import 'package:flutter/material.dart';
import 'categories.dart';
import 'category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.timestamp, // New field
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
  final DateTime timestamp; // New field
}
