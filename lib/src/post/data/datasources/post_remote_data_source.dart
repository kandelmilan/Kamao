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
    final map = <String, dynamic>{
      'campaignId': campaignId,
      'platform': platform,
      'contentUrl': contentUrl,
      'externalPostId': externalPostId,
      'caption': caption,
      'thumbnailUrl': thumbnailUrl,
    };

    if (receiptPath != null && receiptPath.isNotEmpty) {
      final name = receiptPath.split('/').last;
      map['receipt'] = await MultipartFile.fromFile(
        receiptPath,
        filename: name.isNotEmpty ? name : 'receipt.jpg',
      );
    }

    final response = await _apiService.uploadFile(
      ApiEndpoints.submissionsForm,
      formData: FormData.fromMap(map),
    );

    final data = response.data is Map ? response.data['data'] : null;
    if (data is String) return data;
    return data?.toString() ?? '';
  }
}
