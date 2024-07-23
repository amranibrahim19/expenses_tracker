import 'package:expenses_tracker/helper/change_indicator.dart';
import 'package:flutter/material.dart';

Widget buildExpenseCard({
  required String title,
  required Future<double> future,
  required Color color,
  double? previousAmount,
  String? previousPeriodLabel,
  String? currentPeriodLabel,
}) {
  return Expanded(
    child: Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<double>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final currentAmount = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RM${currentAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (previousAmount != null && previousPeriodLabel != null && currentPeriodLabel != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ExpenseChangeIndicator(
                              currentAmount: currentAmount,
                              previousAmount: previousAmount,
                              currentPeriodLabel: currentPeriodLabel,
                              previousPeriodLabel: previousPeriodLabel,
                            ),
                          ),
                      ],
                    );
                  } else if (previousAmount != null && previousPeriodLabel != null && currentPeriodLabel != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RM0.00',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ExpenseChangeIndicator(
                            currentAmount: 0.0,
                            previousAmount: previousAmount,
                            currentPeriodLabel: currentPeriodLabel,
                            previousPeriodLabel: previousPeriodLabel,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      'RM0.00',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
