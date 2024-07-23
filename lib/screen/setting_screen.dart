import 'package:expenses_tracker/components/snackbar.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:expenses_tracker/screen/home.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  void _refreshExpenses() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshExpenses();
  }

  void _resetDatabase() async {
    try {
      await ExpensesRepository.instance.reset(); // Updated method call
      // Refresh the UI
      _refreshExpenses();

      if (mounted) {
        showSuccessSnackbar(
            context, Colors.green, 'Database reset successfully');

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        showErrorSnackbar(context, Colors.red, 'Error resetting database: $e');
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Reset'),
              content: const Text(
                  'Are you sure you want to reset the database? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Confirm
                  child: const Text('Reset Database'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> showProgressDialog(
      BuildContext context, ValueNotifier<double> progressNotifier) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Exporting data...'),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                value: progressNotifier.value,
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, value, child) {
                  return Text('${(value * 100).toStringAsFixed(0)}%');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                bool confirmed = await _showConfirmationDialog();
                if (confirmed) {
                  _resetDatabase();
                }
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 10),
                      Text('Reset'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
