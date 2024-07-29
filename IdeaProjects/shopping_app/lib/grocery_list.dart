import 'dart:convert';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'grocery_item.dart';
import 'new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading=true;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Future<void> _loadItems() async {
    final url = Uri.https('shopping-app-b6a5e-default-rtdb.firebaseio.com', 'shopping_list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception('Failed to load items');
      }
      final Map<String, dynamic> listData = json.decode(response.body) ?? {};
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']);
        loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category.value,
        ));
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading=false;
      });
    } catch (error) {
      print('Error loading items: $error');
    }
  }

  Future<void> _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });

    // Optionally, add code here to sync the new item with the server
  }

  Future<void> _removeItem(GroceryItem item) async {
    final url = Uri.https('shopping-app-b6a5e-default-rtdb.firebaseio.com', 'shopping_list/${item.id}.json');
    final existingItemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.removeAt(existingItemIndex);
    });

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(existingItemIndex, item);
      });
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));
    if(_isLoading ){
      content=const Center(child: CircularProgressIndicator(),);
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
