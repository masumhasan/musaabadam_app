import 'package:get/get.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';

class CategoriesController extends GetxController {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedSortIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await CategoryService.instance.getTopLevelCategories();
      categories.assignAll(result);
      _sort();
    } catch (_) {
      // silent — screen shows empty state
    } finally {
      isLoading.value = false;
    }
  }

  void setSortIndex(int index) {
    selectedSortIndex.value = index;
    _sort();
  }

  void _sort() {
    switch (selectedSortIndex.value) {
      case 1: // Popular — use sortOrder descending as a proxy
        categories.sort((a, b) => b.sortOrder.compareTo(a.sortOrder));
      case 2: // A-Z
        categories.sort((a, b) => a.name.compareTo(b.name));
      default: // Recommended — server order (sortOrder asc)
        categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
  }
}
