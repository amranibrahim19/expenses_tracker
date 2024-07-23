import 'dart:io';

import 'package:expenses_tracker/class/expenses.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:expenses_tracker/screen/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Update with your actual import

class ShowExpenseScreen extends StatefulWidget {
  final Expense expense;

  const ShowExpenseScreen({super.key, required this.expense});

  @override
  ShowExpenseScreenState createState() => ShowExpenseScreenState();
}

class ShowExpenseScreenState extends State<ShowExpenseScreen> {
  late Expense _expense;

  @override
  void initState() {
    super.initState();
    _expense = widget.expense;
  }

  Future<void> _deleteExpense() async {
    try {
      await ExpensesRepository.instance.delete(_expense.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully')),
      );
      Navigator.pop(context); // Go back to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting expense: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trash),
            onPressed: () async {
              final shouldDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text(
                      'Are you sure you want to delete this expense? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (shouldDelete) {
                _deleteExpense();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _expense.title,
              style:
                  const TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Amount: RM${_expense.amount.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${formatDate(_expense.expenseDate)}',
              style:
                  const TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
            ),
            const SizedBox(height: 16.0),
            if (_expense.imagePath != null && _expense.imagePath!.isNotEmpty)
              Image.file(
                File(_expense.imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the edit screen (assume EditExpenseScreen exists)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExpenseScreen(expense: _expense),
                  ),
                );
              },
              child: const Text('Edit Expense'),
            ),
          ],
        ),
      ),
    );
  }
}

// Utility function for date formatting (assuming you have a date formatting function)
String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
