import 'package:flutter/material.dart';
import '../../data/repositories/menu_repository.dart';

class MenuItemController with ChangeNotifier {
  final MenuRepository _menuRepository;

  MenuItemController({MenuRepository? menuRepository})
      : _menuRepository = menuRepository ?? MenuRepository() {
    fetchMenuItems(); // Fetch menu items when the controller is created
  }

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _categories = [];
  List<dynamic> _filteredItems = [];
  int _activeCategoryId = 1;
  bool _isLoading = true;
  String? _errorMessage;
  bool _disposed = false; // Add this flag

  List<dynamic> get items => _items;
  List<Map<String, dynamic>> get categories => _categories;
  List<dynamic> get filteredItems => _filteredItems;
  int get activeCategoryId => _activeCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // // Override the dispose method
  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }

  // Create a safe notify method
  void _safeNotifyListeners() {
    if (!_disposed && hasListeners) {
      notifyListeners();
    }
  }

  Future<void> fetchMenuItems() async {
    _setLoading(true);
    try {
      _items = await _menuRepository.fetchMenuItems();
      _errorMessage = null;
      final categorySet = <int>{};
      _categories = _items
          .where((item) => categorySet.add(item['category_id']))
          .map((item) => {
                'id': item['category_id'],
                'name': item['category_name'],
              })
          .toList();

      // Set the default active category to the first category
      if (_categories.isNotEmpty) {
        _activeCategoryId = _categories.first['id'];
      }

      // Initialize filtered items
      _filterItemsByCategory();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (_disposed) return; // Check if disposed
      _setLoading(false);
    }
  }

  void setActiveCategory(int categoryId) {
    if (_disposed) return; // Check if disposed
    _activeCategoryId = categoryId;
    _filterItemsByCategory();
    _safeNotifyListeners();
  }

  void filterItemsBySearch(String query) {
    if (_disposed) return;

    if (query.isEmpty) {
      _filterItemsByCategory();
      _safeNotifyListeners();
      return;
    }

    try {
      final normalizedQuery = _removeAccents(query.toLowerCase());

      // Debug prints
      print('Search query: $normalizedQuery');
      print('Items count before filter: ${_items.length}');

      _filteredItems = _items.where((item) {
        if (item['name'] == null) return false;

        final itemName = _removeAccents(item['name'].toString().toLowerCase());
        final matchesQuery = itemName.contains(normalizedQuery);
        final matchesCategory = item['category_id'] == _activeCategoryId;

        // Option 1: Search within active category only (current behavior)
        return matchesQuery && matchesCategory;

        // Option 2: Search across all categories
        // return matchesQuery;
      }).toList();

      print('Filtered items count: ${_filteredItems.length}');
    } catch (e) {
      print('Error in search: $e');
      _filterItemsByCategory(); // Fallback to category filter on error
    }

    _safeNotifyListeners();
  }

  void _filterItemsByCategory() {
    _filteredItems = _items
        .where((item) => item['category_id'] == _activeCategoryId)
        .toList();
  }

  String _removeAccents(String input) {
    if (input.isEmpty) return '';

    // Simple implementation - replace with your own if needed
    final withDiacritics =
        'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    final withoutDiacritics =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

    String result = input;
    for (int i = 0; i < withDiacritics.length; i++) {
      result = result.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }

    return result;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Notify listeners to rebuild the UI
    });
  }
}
