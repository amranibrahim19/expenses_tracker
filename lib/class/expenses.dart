class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime expenseDate; // Changed to DateTime
  final String? type;
  final String? imagePath;
  final String? category;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.expenseDate, // Changed to DateTime
    this.type,
    this.imagePath,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(), // Convert to string
      'imagePath': imagePath,
      'description': description,
      'category': category,
      'type': type,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      expenseDate: DateTime.parse(map['expense_date']), // Parse string to DateTime
      imagePath: map['imagePath'],
      category: map['category'],
      type: map['type'],
    );
  }

  // factory Expense.fromJson(Map<String, dynamic> json) {
  //   return Expense(
  //     id: json['id'],
  //     title: json['title'],
  //     amount: json['amount'],
  //     expenseDate: DateTime.parse(json['expenseDate']),
  //     imagePath: json['imagePath'],
  //     category: json['category'],
  //   );
  // }
}
