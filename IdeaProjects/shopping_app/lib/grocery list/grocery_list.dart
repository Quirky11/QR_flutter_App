import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../categories.dart';
import '../category.dart';
import '../firestore_helper.dart';
import '../grocery_item.dart';
import '../new_item.dart';
import 'category_filter.dart';
import 'category_list.dart';
import 'grocery_file.dart';
import 'grocery_item.dart';
import 'history_list.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  List<GroceryItem> _originalItems = [];
  List<Map<String, dynamic>> _history = [];
  late Future<List<GroceryItem>> _loadedItems;
  String? _error;
  Categories? _selectedCategory;
  int _selectedIndex = 0;

  final FirestoreHelper _firestoreHelper = FirestoreHelper(); // Firestore helper instance

  @override
  void initState() {
    super.initState();
    _loadItems(); // Directly load items without using FutureBuilder
    _loadHistory(); // Load history on initialization
  }

  Future<void> _loadItems() async {
    try {
      final url = Uri.https(
          'shopping-app-b6a5e-default-rtdb.firebaseio.com', 'shopping_list.json');
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode >= 400) {
        throw Exception('Failed to fetch data');
      }

      // If no data was found, return an empty list
      if (response.body == 'null') {
        setState(() {
          _groceryItems = [];
          _originalItems = [];
        });
        return;
      }

      // Decode the JSON data
      final Map<String, dynamic> listData = json.decode(response.body) ?? {};

      final List<GroceryItem> loadedItems = [];

      // Loop through each entry in the data and create GroceryItem objects
      for (final item in listData.entries) {
        final category = categories.entries.firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
          orElse: () => MapEntry(Categories.other, categories[Categories.other]!),
        ).value;

        loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
          timestamp: DateTime.parse(item.value['timestamp']),
        ));
      }

      // Update the state with the loaded items
      setState(() {
        _groceryItems = loadedItems;
        _originalItems = loadedItems;
      });
    } catch (e) {
      // Handle errors and update the state with the error message
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _loadHistory() async {
    try {
      final historyData = await _firestoreHelper.getHistory();
      setState(() {
        _history = historyData;
      });
    } catch (e) {
      print('Failed to load history: $e');
      _showErrorDialog('Failed to load history');
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

    // Add the new item to the local state
    setState(() {
      _groceryItems.add(newItem);
      _originalItems.add(newItem);
      _history.add({
        'action': 'added',
        'item': newItem.name,
        'timestamp': newItem.timestamp,
      });
    });

    // Save the new item to Firebase
    final url = Uri.https(
        'shopping-app-b6a5e-default-rtdb.firebaseio.com', 'shopping_list/${newItem.id}.json');
    await http.put(
      url,
      body: json.encode({
        'name': newItem.name,
        'quantity': newItem.quantity,
        'category': newItem.category.title,
        'timestamp': newItem.timestamp.toIso8601String(),
      }),
    );

    // Add the action to the Firestore history
    await _firestoreHelper.addHistory('added', newItem.name, newItem.timestamp);
  }

  Future<void> _removeItem(GroceryItem item) async {
    final url = Uri.https('shopping-app-b6a5e-default-rtdb.firebaseio.com',
        'shopping_list/${item.id}.json');
    final existingItemIndex = _groceryItems.indexOf(item);

    // Remove the item from the local state
    setState(() {
      _groceryItems.removeAt(existingItemIndex);
      _history.add({
        'action': 'removed',
        'item': item.name,
        'timestamp': DateTime.now(),
      });
    });

    // Delete the item from Firebase
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // If the deletion fails, add the item back to the local state
      setState(() {
        _groceryItems.insert(existingItemIndex, item);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to delete item.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _groceryItems.insert(existingItemIndex, item);
              });
            },
          ),
        ),
      );
    }

    // Add the action to the Firestore history
    await _firestoreHelper.addHistory('removed', item.name, DateTime.now());
  }

  void _sortItems() {
    setState(() {
      _groceryItems.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _filterItems(Categories category) {
    setState(() {
      if (category == Categories.other) {
        _groceryItems = _originalItems;
      } else {
        _groceryItems = _originalItems
            .where((item) => item.category == categories[category])
            .toList();
      }
      _selectedCategory = category;
    });
  }

  void _clearFilter() {
    setState(() {
      _groceryItems = _originalItems;
      _selectedCategory = null;
    });
  }

  void _handleBottomNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _views = [
      GroceryListView(
        groceryItems: _groceryItems,
        removeItem: _removeItem,
      ),
      CategoryListView(
        originalItems: _originalItems,
        filterItems: _filterItems,
      ),
      HistoryListView(
        history: _history,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Text('Filter by Category'),
              ),
              if (_selectedCategory != null)
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear Filter'),
                ),
            ],
            onSelected: (value) {
              if (value == 'sort') {
                _sortItems();
              } else if (value == 'filter') {
                showDialog(
                  context: context,
                  builder: (ctx) => CategoryFilterDialog(
                    filterItems: _filterItems,
                  ),
                );
              } else if (value == 'clear') {
                _clearFilter();
              }
            },
          ),
        ],
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handleBottomNavBarTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
