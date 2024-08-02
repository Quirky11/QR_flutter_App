import 'package:flutter/material.dart';
import '../categories.dart';
import '../category.dart';
import '../grocery_item.dart';
import 'grocery_item.dart';

class CategoryListView extends StatelessWidget {
  final List<GroceryItem> originalItems;
  final Function(Categories) filterItems;

  const CategoryListView({
    Key? key,
    required this.originalItems,
    required this.filterItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: Categories.values.length,
      itemBuilder: (ctx, index) {
        final category = Categories.values[index];
        final categoryItems = originalItems
            .where((item) => item.category == categories[category])
            .toList();
        return ListTile(
          title: Text(category.name),
          subtitle: Text('${categoryItems.length} items'),
          onTap: () {
            filterItems(category);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
