import 'package:expenses_tracker/class/category.dart';
import 'package:expenses_tracker/components/card.dart';
import 'package:expenses_tracker/components/snackbar.dart';
import 'package:expenses_tracker/helper/calculation.dart';
import 'package:expenses_tracker/screen/add_screen.dart';
import 'package:expenses_tracker/screen/setting_screen.dart';
import 'package:expenses_tracker/screen/show_screen.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/class/expenses.dart';
import 'package:expenses_tracker/helper/helper.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Expense>> _expenses;
  late Future<double> _totalAmount;
  late Future<double> _weeklyExpense;
  late Future<double> _lastWeekExpense;
  late Future<double> _dailyExpense;
  late Future<double> _yesterdayExpense;

  @override
  void initState() {
    super.initState();
    _refreshExpenses();
  }

  void _refreshExpenses() {
    setState(() {
      _expenses = ExpensesRepository.instance.readAllExpenses();
      _totalAmount = calculateByMonth(_expenses);
      _weeklyExpense = calculateByWeek(_expenses);
      _lastWeekExpense = calculateByLastWeek(_expenses);
      _dailyExpense = calculateByDay(_expenses);
      _yesterdayExpense = calculateByYesterday(_expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // F6F5F5 - Light Yellow
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()));
            },
          ),
          // You can add more actions here if needed
        ],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Expense>>(
        future: _expenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final expenses = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Expenses Card
                FutureBuilder<double>(
                  future: _totalAmount,
                  builder: (context, totalSnapshot) {
                    if (totalSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (totalSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${totalSnapshot.error}'));
                    } else if (totalSnapshot.hasData) {
                      final totalAmount = totalSnapshot.data!;
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 150,
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 5,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: ListTile(
                              title: const Text(
                                'Total Expenses this month',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'RM${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text('No total amount available'));
                    }
                  },
                ),

                // Expenses Summary Row
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Daily Expenses Card
                      FutureBuilder<List<double>>(
                        future: Future.wait([_dailyExpense, _yesterdayExpense]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            if (snapshot.data != null &&
                                snapshot.data!.length == 2) {
                              final yesterdayExpense = snapshot.data![1];
                              return buildExpenseCard(
                                title: 'Daily',
                                future:
                                    _weeklyExpense, // Future for the current week expense
                                color: const Color(0xfff5f5f5),
                                previousAmount: yesterdayExpense,
                                previousPeriodLabel: 'Yesterday',
                                currentPeriodLabel: 'Today',
                              );
                            } else {
                              return const Center(child: Text('Invalid data'));
                            }
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),

                      const SizedBox(width: 8.0),
                      // Weekly Expenses Card with comparison to last week
                      FutureBuilder<List<double>>(
                        future: Future.wait([_weeklyExpense, _lastWeekExpense]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            if (snapshot.data != null &&
                                snapshot.data!.length == 2) {
                              final lastWeekExpense = snapshot.data![1];
                              return buildExpenseCard(
                                title: 'Weekly',
                                future:
                                    _weeklyExpense, // Future for the current week expense
                                color: const Color(0xfff5f5f5),
                                previousAmount: lastWeekExpense,
                                previousPeriodLabel: 'Last Week',
                                currentPeriodLabel: 'This Week',
                              );
                            } else {
                              return const Center(child: Text('Invalid data'));
                            }
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Transactions Title
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      final category = categories.firstWhere(
                        (cat) => cat.name == expense.category,
                        orElse: () => Category('Others', Icons.category),
                      );

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            category.icon,
                            color: categoryColors[category.name],
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            'RM${expense.amount.toStringAsFixed(2)} - ${formatDate(expense.expenseDate)}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                      'Are you sure you want to delete this expense?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldDelete ?? false) {
                                try {
                                  await ExpensesRepository.instance
                                      .delete(expense.id);
                                  if (context.mounted) {
                                    showSuccessSnackbar(context, Colors.green,
                                        'Expense deleted successfully');
                                  }

                                  setState(() {
                                    _refreshExpenses();
                                  });
                                } catch (e) {
                                  if (context.mounted) {
                                    showErrorSnackbar(context, Colors.red,
                                        'Error deleting expense: $e');
                                  }
                                }
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowExpenseScreen(expense: expense),
                              ),
                            ).then((_) {
                              _refreshExpenses();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No expenses found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
