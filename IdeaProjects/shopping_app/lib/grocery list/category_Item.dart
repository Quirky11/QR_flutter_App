import 'package:flutter/material.dart';
import '../category.dart';
import '../grocery_item.dart';

class CategoryItemWidget extends StatelessWidget {
  final Categories category;
  final List<GroceryItem> items;
  final VoidCallback onTap;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      subtitle: Text('${items.length} items'),
      onTap: onTap,
    );
  }
}
