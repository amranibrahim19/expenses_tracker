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
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
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
                    return Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RM${currentAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        if (previousAmount != null && previousPeriodLabel != null && currentPeriodLabel != null)
                          ExpenseChangeIndicator(
                            currentAmount: currentAmount,
                            previousAmount: previousAmount,
                            currentPeriodLabel: currentPeriodLabel,
                            previousPeriodLabel: previousPeriodLabel,
                          ),
                      ],
                    );
                  } else if (previousAmount != null && previousPeriodLabel != null && currentPeriodLabel != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RM0.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        ExpenseChangeIndicator(
                          currentAmount: 0.0,
                          previousAmount: previousAmount,
                          currentPeriodLabel: currentPeriodLabel,
                          previousPeriodLabel: previousPeriodLabel,
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      'RM0.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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

