import 'package:flutter/material.dart';
import '../grocery_item.dart';
import 'grocery_item.dart';

class GroceryListView extends StatelessWidget {
  final List<GroceryItem> groceryItems;
  final Function(GroceryItem) removeItem;

  const GroceryListView({
    Key? key,
    required this.groceryItems,
    required this.removeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) {
          removeItem(groceryItems[index]);
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
        key: ValueKey(groceryItems[index].id),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              groceryItems[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: CircleAvatar(
              backgroundColor: groceryItems[index].category.color,
              child: const Icon(Icons.local_grocery_store, color: Colors.white),
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
