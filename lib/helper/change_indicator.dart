import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseChangeIndicator extends StatelessWidget {
  final double currentAmount;
  final double previousAmount;
  final String currentPeriodLabel;
  final String previousPeriodLabel;

  const ExpenseChangeIndicator({
    super.key,
    required this.currentAmount,
    required this.previousAmount,
    this.currentPeriodLabel = 'Current Period',
    this.previousPeriodLabel = 'Previous Period',
  });

  @override
  Widget build(BuildContext context) {
    // Calculate change percentage
    final double changePercentage = previousAmount == 0
        ? 0
        : ((currentAmount - previousAmount) / previousAmount) * 100;

    // Determine if there is an increase
    final bool isIncrease = changePercentage > 0;

    // Hide if there is no change
    final bool showIndicator = changePercentage != 0;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Visibility(
        visible: showIndicator,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FaIcon(
                  isIncrease
                      ? FontAwesomeIcons.arrowTrendUp
                      : FontAwesomeIcons.arrowTrendDown,
                  color: isIncrease ? Colors.green : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 5.0),
                Text(
                  '${isIncrease ? '+' : ''}${changePercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isIncrease ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
