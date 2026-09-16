/// Multipart fields for `POST /creator/submissions/form`.
///
/// [receiptPath] is omitted from the request when null — use that when the
/// campaign does not require a receipt or the user has not picked one.
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

  /// Local file path for the receipt image. Null = do not send `receipt`.
  final String? receiptPath;
}
