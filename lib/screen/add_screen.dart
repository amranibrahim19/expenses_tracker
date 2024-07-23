import 'dart:io';
import 'package:expenses_tracker/class/category.dart';
import 'package:expenses_tracker/components/pick_file.dart';
import 'package:expenses_tracker/components/save_button.dart';
import 'package:expenses_tracker/components/snackbar.dart';
import 'package:expenses_tracker/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expenses_tracker/class/expenses.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _title = '';
  String _description = '';
  double _amount = 0;
  Category? _selectedCategory;
  DateTime? _date;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
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
        _dateController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Format date as needed
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
      if (mounted) {
        showErrorSnackbar(context, Colors.red, 'Error picking image: $e');
      }
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      var uuid = const Uuid();

      final newExpense = Expense(
        id: uuid.v1(),
        title: _title,
        description: _description,
        amount: _amount,
        expenseDate: _date ?? DateTime.now(), // Default to now if date is null
        imagePath: _image?.path,
        category: _selectedCategory?.name,
      );

      try {
        await ExpensesRepository.instance.create(newExpense);

        if (mounted) {
          showSuccessSnackbar(
              context, Colors.green, 'Expense saved successfully');

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } catch (e) {
        if (mounted) {
          showErrorSnackbar(context, Colors.red, 'Error saving expense: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
        title: const Text(
          'Expenses Tracker',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black, // Notification icon color
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification icon tapped')),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                TextFormField(
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
                    _amount = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Expense Date',
                    hintText: 'Select a date',
                  ),
                  readOnly:
                      true, // Make the field read-only to prevent manual input
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _date = DateTime.tryParse(value ?? '') ?? DateTime.now();
                  },
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
                UploadButton(onPressed: _pickImage, text: 'Upload Receipt'),
                const SizedBox(height: 20),
                SaveButton(
                  onPressed: _saveExpense,
                  text: 'Save Expense',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
