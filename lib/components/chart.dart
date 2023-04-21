// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/components/chart_bar.dart';

import 'package:personal_expenses_app/model/transaction.dart';

class Chart extends StatelessWidget {
  Chart(this.recentTransactions);

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTxValues {
    return List.generate(7, (index) {
      DateTime weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get weekSum {
    return groupedTxValues.fold(0.0, (sum, item) {
      return sum += item['amount'] as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...(groupedTxValues).map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      label: data['day'] as String,
                      spending: data['amount'] as double,
                      spot: (weekSum == 0.0
                          ? 0.0
                          : (data['amount'] as double) / weekSum)),
                );
              }).toList(),
            ],
          ),
        ));
  }
}
