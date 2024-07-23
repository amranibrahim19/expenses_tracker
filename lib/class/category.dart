import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Category {
  final String name;
  final IconData icon;
  Category(this.name, this.icon);
}

final List<Category> categories = [
  Category('Food', FontAwesomeIcons.pizzaSlice),
  Category('Transport', FontAwesomeIcons.train),
  Category('Shopping', FontAwesomeIcons.cartShopping),
  Category('Entertainment', FontAwesomeIcons.ticketSimple),
  Category('Health', FontAwesomeIcons.heartPulse),
  Category('Travel', FontAwesomeIcons.plane),
  Category('Education', FontAwesomeIcons.graduationCap),
  Category('Others', FontAwesomeIcons.list),
];

final Map<String, Color> categoryColors = {
  'Food': Colors.red,
  'Transport': Colors.blue,
  'Shopping': Colors.green,
  'Entertainment': Colors.purple,
  'Health': Colors.orange,
  'Travel': Colors.teal,
  'Education': Colors.pink,
  'Others': Colors.grey,
};

final Map<String, String> categoryIcons = {
  'Food': 'fastfood',
  'Transport': 'directions_bus',
  'Shopping': 'shopping_cart',
  'Entertainment': 'movie',
  'Health': 'local_hospital',
  'Travel': 'flight',
  'Education': 'school',
  'Others': 'category',
};
