import 'package:expenses_tracker/class/expenses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExpensesRepository {
  static final ExpensesRepository instance = ExpensesRepository._init();

  ExpensesRepository._init();

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> create(Expense expense) async {
    final prefs = await _prefs;
    final expenses = await readAllExpenses();
    expenses.add(expense);
    await prefs.setString('expenses', jsonEncode(expenses.map((e) => e.toMap()).toList()));
  }

  Future<List<Expense>> readAllExpenses() async {
    final prefs = await _prefs;
    final expensesString = prefs.getString('expenses');
    if (expensesString == null) return [];
    final List<dynamic> expensesJson = jsonDecode(expensesString);
    return expensesJson.map((json) => Expense.fromMap(json)).toList();
  }

  Future<void> update(Expense expense) async {
    final prefs = await _prefs;
    final expenses = await readAllExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense;
      await prefs.setString('expenses', jsonEncode(expenses.map((e) => e.toMap()).toList()));
    }
  }

  Future<void> delete(String id) async {
    final prefs = await _prefs;
    final expenses = await readAllExpenses();
    final updatedExpenses = expenses.where((e) => e.id != id).toList();
    await prefs.setString('expenses', jsonEncode(updatedExpenses.map((e) => e.toMap()).toList()));
  }

  // export to json
  Future<String> exportToJson() async {
    final expenses = await readAllExpenses();
    return jsonEncode(expenses.map((e) => e.toMap()).toList());
  }

  Future<void> reset() async {
    final prefs = await _prefs;
    await prefs.remove('expenses');
  }
}
