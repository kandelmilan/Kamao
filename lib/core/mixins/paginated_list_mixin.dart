import 'package:get/get.dart';
import 'package:kamao/core/core.dart';

mixin PaginatedListMixin<T> on GetxController {
  static const int defaultPageSize = 20;

  final items = <T>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasNextPage = true.obs;
  final hasError = false.obs;
  final totalCount = 0.obs;

  // Reactive now (was a private int) so Obx() in the view can rebuild the
  // pager label ("Page 2 of 6") when it changes.
  final currentPageRx = 1.obs;
  int get currentPage => currentPageRx.value;

  bool get hasPreviousPage => currentPageRx.value > 1;

  Future<PaginatedResponse<T>?> fetchPage(int page);

  Future<void> loadFirstPage() async {
    await _loadPageReplacing(1);
  }

  /// Appends the next page onto `items` — infinite-scroll style.
  /// Kept for compatibility with anything still using scroll-triggered
  /// loading; the DPR list no longer calls this.
  Future<void> loadNextPage() async {
    if (isLoadingMore.value || isLoading.value || !hasNextPage.value) return;

    isLoadingMore.value = true;
    final nextPage = currentPageRx.value + 1;
    final response = await fetchPage(nextPage);
    isLoadingMore.value = false;

    if (response == null) return;

    items.addAll(response.items);
    currentPageRx.value = nextPage;
    hasNextPage.value = response.hasNextPage;
    totalCount.value = response.totalCount;
  }

  /// Replaces `items` with the requested page — classic Previous/Next
  /// pager style (page 2 of size 20 = records 21-40).
  Future<void> goToPage(int page) async {
    if (page < 1 || page == currentPageRx.value && items.isNotEmpty) return;
    await _loadPageReplacing(page);
  }

  Future<void> goToNextPage() async {
    if (hasNextPage.value) await goToPage(currentPageRx.value + 1);
  }

  Future<void> goToPreviousPage() async {
    if (hasPreviousPage) await goToPage(currentPageRx.value - 1);
  }

  Future<void> _loadPageReplacing(int page) async {
    if (isLoading.value) return;
    isLoading.value = true;
    hasError.value = false;

    final response = await fetchPage(page);

    isLoading.value = false;

    if (response == null) {
      hasError.value = true;
      return;
    }

    items.assignAll(response.items);
    currentPageRx.value = page;
    hasNextPage.value = response.hasNextPage;
    totalCount.value = response.totalCount;
  }

  // Future<void> refresh() => loadFirstPage();
}
