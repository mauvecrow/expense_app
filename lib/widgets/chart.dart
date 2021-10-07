import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      //index := number of days in the week used
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var dayAmount = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        var trx = recentTransactions[i];
        if (trx.date.day == weekDay.day &&
            trx.date.year == weekDay.year &&
            trx.date.month == weekDay.month) {
          dayAmount += trx.amount;
        }
      }
      return {'day': DateFormat.E().format(weekDay), 'amount': dayAmount};
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map((data) => ChartBar(
                  (data['day'] as String),
                  (data['amount'] as double),
                  totalSpending == 0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending))
              .toList(),
        ),
      ),
    );
  }
}
