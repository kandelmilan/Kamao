import 'dart:async';
import 'package:get/get.dart';
import 'campaign_list_types.dart';

class CampaignListController<T> extends GetxController {
  CampaignListController({
    required this.title,
    required CampaignPageFetcher<T> fetcher,
    this.take = 20,
    this.emptyMessage = 'No campaigns found',
    this.enableSearch = true,
  }) : _fetcher = fetcher;

  final String title;
  final int take;
  final String emptyMessage;
  final bool enableSearch;
  final CampaignPageFetcher<T> _fetcher;

  final campaigns = <T>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = Rxn<String>();
  final hasMore = true.obs;
  final searchQuery = ''.obs;

  int _page = 1;
  Timer? _debounce;
  int _requestId = 0;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> loadFirstPage() async {
    final requestId = ++_requestId;

    _page = 1;
    hasMore.value = true;
    isLoading.value = true;
    error.value = null;

    final result = await _fetcher(
      page: _page,
      take: take,
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
    );

    if (requestId != _requestId) return;

    result.fold((failure) => error.value = failure.message, (data) {
      campaigns.assignAll(data);
      hasMore.value = data.length == take;
    });
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;
    final requestId = _requestId;
    isLoadingMore.value = true;

    final nextPage = _page + 1;
    final result = await _fetcher(
      page: nextPage,
      take: take,
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
    );

    if (requestId != _requestId) {
      isLoadingMore.value = false;
      return;
    }

    result.fold((failure) => Get.snackbar('Error', failure.message), (data) {
      _page = nextPage;
      campaigns.addAll(data);
      hasMore.value = data.length == take;
    });
    isLoadingMore.value = false;
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = value.trim();
      if (trimmed == searchQuery.value) return;
      searchQuery.value = trimmed;
      loadFirstPage();
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    if (searchQuery.value.isEmpty) return;
    searchQuery.value = '';
    loadFirstPage();
  }

  Future<void> refresh() => loadFirstPage();
}
