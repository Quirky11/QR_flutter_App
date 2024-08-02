import 'package:flutter/material.dart';
import '../category.dart';

class CategoryFilterDialog extends StatelessWidget {
  final Function(Categories) filterItems;

  const CategoryFilterDialog({
    Key? key,
    required this.filterItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Categories.values.map((category) {
          return ListTile(
            title: Text(category.name),
            onTap: () {
              filterItems(category);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
