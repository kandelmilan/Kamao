enum SocialPlatformType {
  facebook('facebook'),
  instagram('instagram'),
  tiktok('tiktok'),
  youtube('youtube');

  const SocialPlatformType(this.apiId);
  final String apiId; 
}
