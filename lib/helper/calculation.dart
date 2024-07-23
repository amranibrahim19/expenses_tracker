import 'package:expenses_tracker/class/expenses.dart';

Future<double> calculateTotalAmount(
    Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final totalAmount =
      expenses.fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}

Future<double> calculateByMonth(Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  final totalAmount = expenses
      .where((expense) =>
          expense.expenseDate
              .isAfter(currentMonth.subtract(const Duration(days: 1))) &&
          expense.expenseDate
              .isBefore(currentMonth.add(const Duration(days: 31))))
      .fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}

Future<double> calculateByWeek(Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final now = DateTime.now();
  final currentWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: DateTime.now().weekday - 1));
  final totalAmount = expenses
      .where((expense) =>
          expense.expenseDate
              .isAfter(currentWeek.subtract(const Duration(days: 1))) &&
          expense.expenseDate
              .isBefore(currentWeek.add(const Duration(days: 7))))
      .fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}

// calculate the total amount of expenses  last week
Future<double> calculateByLastWeek(Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final now = DateTime.now();
  final lastWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: DateTime.now().weekday + 6));
  final totalAmount = expenses
      .where((expense) =>
          expense.expenseDate
              .isAfter(lastWeek.subtract(const Duration(days: 1))) &&
          expense.expenseDate.isBefore(lastWeek.add(const Duration(days: 7))))
      .fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}

Future<double> calculateByDay(Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final totalAmount = expenses
      .where((expense) =>
          expense.expenseDate
              .isAfter(today.subtract(const Duration(days: 1))) &&
          expense.expenseDate.isBefore(today.add(const Duration(days: 1))))
      .fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}

// yesterday
Future<double> calculateByYesterday(Future<List<Expense>> expensesFuture) async {
  final expenses = await expensesFuture;
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
  final totalAmount = expenses
      .where((expense) =>
          expense.expenseDate
              .isAfter(yesterday.subtract(const Duration(days: 1))) &&
          expense.expenseDate.isBefore(yesterday.add(const Duration(days: 1))))
      .fold(0.0, (total, expense) => total + expense.amount);
  return totalAmount;
}
