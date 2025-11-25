import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/category_service.dart';
import '../models/category_model.dart';

// Category Service Provider
final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService());

// All Categories Provider
final allCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  try {
    final categoryService = ref.watch(categoryServiceProvider);
    final categories = await categoryService.getAllCategories();
    print('📂 Loaded ${categories.length} categories');
    return categories;
  } catch (e) {
    print('❌ allCategoriesProvider error: $e');
    return [];
  }
});

// Active Categories Provider
final activeCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  try {
    final categoryService = ref.watch(categoryServiceProvider);
    final categories = await categoryService.getActiveCategories();
    print('📂 Loaded ${categories.length} active categories');
    return categories;
  } catch (e) {
    print('❌ activeCategoriesProvider error: $e');
    return [];
  }
});

// Category By ID Provider
final categoryByIdProvider = FutureProvider.family<CategoryModel?, int>((ref, id) async {
  try {
    final categoryService = ref.watch(categoryServiceProvider);
    return await categoryService.getCategoryById(id);
  } catch (e) {
    print('❌ categoryByIdProvider error: $e');
    return null;
  }
});
