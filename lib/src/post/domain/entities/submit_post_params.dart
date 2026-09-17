/// Fields for creating a creator submission.
///
/// When [receiptPath] is null/empty the client posts JSON to
/// `POST /creator/submissions`. When a local receipt file is present it
/// posts multipart to `POST /creator/submissions/form`.
class SubmitPostParams {
  const SubmitPostParams({
    required this.campaignId,
    required this.platform,
    this.contentUrl = '',
    this.externalPostId = '',
    this.caption = '',
    this.thumbnailUrl = '',
    this.receiptPath,
  });

  final String campaignId;
  final String platform;
  final String contentUrl;
  final String externalPostId;
  final String caption;
  final String thumbnailUrl;

  /// Local file path for the receipt image. Null/empty → JSON endpoint.
  final String? receiptPath;

  bool get hasReceipt =>
      receiptPath != null && receiptPath!.trim().isNotEmpty;
}
