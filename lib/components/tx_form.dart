// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/components/adaptive/adaptive_text_button.dart';

class TransactionInput extends StatefulWidget {
  TransactionInput(this.submitTx);

  final Function submitTx;

  @override
  State<TransactionInput> createState() => _TransactionInputState();
}

class _TransactionInputState extends State<TransactionInput> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime?  _selectedDate;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate==null) {
      return;
    }

    widget.submitTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now()
    ).then((selectedDate) {
      if(selectedDate==null){
        return;
      }
      setState(() {
        _selectedDate=selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: Text(
                      _selectedDate == null ? 'No date chosen' : 'Selected date : ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  AdaptiveTextButton(text: 'Choose date', handler: presentDatePicker)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Transaction'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
