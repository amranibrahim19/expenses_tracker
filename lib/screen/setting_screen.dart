import 'package:expenses_tracker/components/bottom_menu.dart';
import 'package:expenses_tracker/components/snackbar.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:expenses_tracker/screen/add_screen.dart';
import 'package:expenses_tracker/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  int _currentIndex = 1;
  void _refreshExpenses() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  showSuccessSnackbar(context, Colors.black, "Success");
                },
                child: Card(
                  margin:
                      const EdgeInsets.all(0.0), // Remove the default margin
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.grey, width: 1.0), // Grey border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0), // Padding all around
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show Profile',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.black,
                          size: 16.0, // Adjust the size as needed
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  showSuccessSnackbar(context, Colors.black, "Success");
                },
                child: Card(
                  margin:
                      const EdgeInsets.all(0.0), // Remove the default margin
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.grey, width: 1.0), // Grey border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0), // Padding all around
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Backup Data',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.black,
                          size: 16.0, // Adjust the size as needed
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  bool confirmed = await _showConfirmationDialog();
                  if (confirmed) {
                    _resetDatabase();
                  }
                },
                child: Card(
                  margin:
                      const EdgeInsets.all(0.0), // Remove the default margin
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.grey, width: 1.0), // Grey border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0), // Padding all around
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reset Database',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.black,
                          size: 16.0, // Adjust the size as needed
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FloatingActionButton(
          tooltip: 'Increment',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddExpenseScreen(),
              ),
            ).then((_) {
              // Refresh the expenses list after returning from AddExpenseScreen
              _refreshExpenses();
            });
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
