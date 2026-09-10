// // lib/src/campaign/presentation/widgets/campaign_navigation.dart
// // (or wherever the campaign feature's "shared" file lives)

// import 'package:get/get.dart';
// import '../bindings/campaign_detail_binding.dart';
// import '../views/campaign_detail_view.dart';

// /// Navigation helper — call this from wherever a campaign gets tapped
// /// (Popular Campaigns tile, recent campaigns, favourites, marketplace)
// /// instead of duplicating the Get.to/binding pair at each call site.
// ///
// /// TODO: if the app already uses named routes (Get.toNamed with a
// /// Routes/AppPages table) rather than direct Get.to, register
// /// CampaignDetailView + CampaignDetailBinding there instead and
// /// replace this with a Get.toNamed call, so back-button/deep-link
// /// behavior stays consistent with the rest of the app — same note
// /// as openBrandDetail.
// void openCampaignDetail(String campaignId) {
//   Get.to(
//     () => CampaignDetailView(campaignId: campaignId),
//     binding: CampaignDetailBinding(campaignId: campaignId),
//   );
// }
