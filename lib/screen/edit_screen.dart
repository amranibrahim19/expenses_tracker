import 'dart:io';

import 'package:expenses_tracker/class/category.dart';
import 'package:expenses_tracker/class/expenses.dart';
import 'package:expenses_tracker/components/pick_file.dart';
import 'package:expenses_tracker/components/save_button.dart';
import 'package:expenses_tracker/components/snackbar.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  EditExpenseScreenState createState() => EditExpenseScreenState();
}

class EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? _date;
  double? _amount;
  String? _title;
  File? _image;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController.text = expense.title;
    _descriptionController.text = expense.description;
    _amountController.text = expense.amount.toString();
    _date = expense.expenseDate;
    _dateController.text = formatDate(expense.expenseDate);
    if (expense.imagePath != null) {
      _image = File(expense.imagePath!);
    }
    _selectedCategory = categories.firstWhere(
        (category) => category.name == expense.category,
        orElse: () => categories.first);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _date ?? DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
        _dateController.text = formatDate(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      var uuid = const Uuid();
      final updatedExpense = Expense(
        id: uuid.v1(),
        title: _title!,
        description: _descriptionController.text,
        amount: _amount!,
        expenseDate: _date ?? DateTime.now(), // Default to now if date is null
        imagePath: _image?.path,
        category: _selectedCategory?.name,
      );

      try {
        await ExpensesRepository.instance.update(updatedExpense);

        if (mounted) {
          showSuccessSnackbar(
              context, Colors.green, 'Expense updated successfully');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          showErrorSnackbar(context, Colors.red, 'Error updating expense: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = double.tryParse(value ?? '');
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Expense Date',
                    hintText: 'Select a date',
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map<DropdownMenuItem<Category>>((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon,
                              color: categoryColors[category.name]),
                          const SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Receipt'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveExpense,
                  child: const Text('Save Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Utility function for date formatting
String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
