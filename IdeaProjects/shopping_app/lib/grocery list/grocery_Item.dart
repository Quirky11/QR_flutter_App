import 'package:flutter/material.dart';
import '../grocery_item.dart';


class GroceryItemWidget extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onRemove;

  const GroceryItemWidget({
    Key? key,
    required this.item,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        onRemove();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      key: ValueKey(item.id),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: CircleAvatar(
            backgroundColor: item.category.color,
            child: const Icon(Icons.local_grocery_store, color: Colors.white),
          ),
          trailing: Text(
            item.quantity.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
