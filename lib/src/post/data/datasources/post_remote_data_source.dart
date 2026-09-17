import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import '../models/social_media_model.dart';
import '../models/submission_model.dart';

abstract class PostRemoteDataSource {
  Future<SocialMediaModel> getSocialMedia({
    required String platform,
    int take = 24,
  });

  Future<List<SubmissionModel>> getPendingSubmissions();

  Future<List<SubmissionModel>> getApprovedSubmissions();

  /// Returns the new submission id from `data`.
  ///
  /// Uses JSON `POST /creator/submissions` when [receiptPath] is empty,
  /// otherwise multipart `POST /creator/submissions/form`.
  Future<String> submitPost({
    required String campaignId,
    required String platform,
    String contentUrl = '',
    String externalPostId = '',
    String caption = '',
    String thumbnailUrl = '',
    String? receiptPath,
  });
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  @override
  Future<SocialMediaModel> getSocialMedia({
    required String platform,
    int take = 24,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.socialMedia,
      queryParameters: {
        'platform': platform.toLowerCase(),
        'take': take,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return SocialMediaModel.fromJson(data);
  }

  @override
  Future<List<SubmissionModel>> getPendingSubmissions() {
    return _getSubmissions(ApiEndpoints.submissionsPending);
  }

  @override
  Future<List<SubmissionModel>> getApprovedSubmissions() {
    return _getSubmissions(ApiEndpoints.submissionsApproved);
  }

  Future<List<SubmissionModel>> _getSubmissions(String path) async {
    final response = await _apiService.get(path);
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .whereType<Map>()
        .map((e) => SubmissionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<String> submitPost({
    required String campaignId,
    required String platform,
    String contentUrl = '',
    String externalPostId = '',
    String caption = '',
    String thumbnailUrl = '',
    String? receiptPath,
  }) async {
    final hasReceipt = receiptPath != null && receiptPath.trim().isNotEmpty;

    final Response<dynamic> response;
    if (hasReceipt) {
      response = await _submitWithReceipt(
        campaignId: campaignId,
        platform: platform,
        contentUrl: contentUrl,
        externalPostId: externalPostId,
        caption: caption,
        thumbnailUrl: thumbnailUrl,
        receiptPath: receiptPath.trim(),
      );
    } else {
      response = await _submitWithoutReceipt(
        campaignId: campaignId,
        platform: platform,
        contentUrl: contentUrl,
        externalPostId: externalPostId,
        caption: caption,
        thumbnailUrl: thumbnailUrl,
      );
    }

    return _parseSubmissionId(response);
  }

  Future<Response<dynamic>> _submitWithoutReceipt({
    required String campaignId,
    required String platform,
    required String contentUrl,
    required String externalPostId,
    required String caption,
    required String thumbnailUrl,
  }) {
    return _apiService.post(
      ApiEndpoints.submissions,
      data: {
        'campaignId': campaignId,
        'platform': platform,
        'contentUrl': contentUrl,
        'externalPostId': externalPostId,
        'caption': caption,
        'thumbnailUrl': thumbnailUrl,
        'receiptBase64': null,
        'receiptFileName': null,
      },
    );
  }

  Future<Response<dynamic>> _submitWithReceipt({
    required String campaignId,
    required String platform,
    required String contentUrl,
    required String externalPostId,
    required String caption,
    required String thumbnailUrl,
    required String receiptPath,
  }) async {
    final name = receiptPath.split('/').last;
    final formData = FormData.fromMap({
      'campaignId': campaignId,
      'platform': platform,
      'contentUrl': contentUrl,
      'externalPostId': externalPostId,
      'caption': caption,
      'thumbnailUrl': thumbnailUrl,
      'receipt': await MultipartFile.fromFile(
        receiptPath,
        filename: name.isNotEmpty ? name : 'receipt.jpg',
      ),
    });

    return _apiService.uploadFile(
      ApiEndpoints.submissionsForm,
      formData: formData,
    );
  }

  String _parseSubmissionId(Response<dynamic> response) {
    final data = response.data is Map ? response.data['data'] : null;
    if (data is String) return data;
    return data?.toString() ?? '';
  }
}
