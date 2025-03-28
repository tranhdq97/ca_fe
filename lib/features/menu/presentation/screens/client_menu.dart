import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../helpers/category_helper.dart';
import '../controllers/menu_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuItemController>(
      builder: (context, menuController, child) {
        // Remove fetching logic here, as data is already fetched at app start
        if (menuController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (menuController.errorMessage != null) {
          return Center(child: Text(menuController.errorMessage!));
        }

        return Row(
          children: [
            // Categories (Vertical Style)
            Container(
              width: 48.0,
              color: Colors.grey[100],
              child: ListView(
                children: menuController.categories.map((category) {
                  final isActive =
                      category['id'] == menuController.activeCategoryId;
                  return GestureDetector(
                    onTap: () {
                      menuController.setActiveCategory(category['id']);
                    },
                    child: Container(
                      color: isActive
                          ? AppColors.secondaryOrange
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CategoryHelper.getIconByName(category['name']) ??
                                Icons.category,
                            color: isActive ? Colors.white : Colors.black,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Search Box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppTextField(
                      controller: _searchController,
                      hintText: AppStrings.search,
                      prefixIcon: Icons.search,
                      onChanged: (value) {
                        menuController.filterItemsBySearch(value);
                      },
                    ),
                  ),

                  // Items List
                  Expanded(
                    child: ListView.separated(
                      itemCount: menuController.filteredItems.length,
                      separatorBuilder: (context, index) => const Divider(
                          height: 0.0, // Reduce space between items
                          thickness: 0.5),
                      itemBuilder: (context, index) {
                        final item = menuController.filteredItems[index];
                        final formattedPrice =
                            NumberFormat('#,###').format(item['price']);
                        return ListTile(
                          title: Text(item['name']),
                          trailing: Text(
                            '$formattedPrice VND',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
