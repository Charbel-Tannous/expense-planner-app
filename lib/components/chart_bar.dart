import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(
      {required this.label, required this.spending, required this.spot});

  final String label;
  final double spending;
  final double spot; //Spending_Percentage_Of_Total

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, contraints) {
      return Column(
        children: <Widget>[
          Container(
            height: contraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spending.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: contraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: contraints.maxHeight * 0.6,
            width: 10,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spot,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: contraints.maxHeight * 0.05,
          ),
          SizedBox(
              height: contraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label))),
        ],
      );
    });
  }
}
