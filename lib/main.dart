// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/chart.dart';
import 'components/txList.dart';
import 'components/tx_form.dart';
import 'model/transaction.dart';

void main() {
  //this is to lock the app in Portrait Mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTx {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTx(String txTitle, double txAmount, DateTime newDate) {
    setState(() {
      _userTransactions.add(Transaction(
          id: newDate.toString(),
          amount: txAmount,
          date: newDate,
          title: txTitle));
    });
  }

  void _deleteTx(String txId) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == txId);
    });
  }

  void _startAddNewTX(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: TransactionInput(_addTx),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    //this is the appBar now because i want to use it for dynamic size
    final appBar = AppBar(
      title: const Text('Expense Planner'),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () => _startAddNewTX(context), icon: Icon(Icons.add))
      ],
    );

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          .7,
      child: TxList(_userTransactions, _deleteTx),
    );

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (_isLandscape)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.1,
                  child: Row(
                    children: <Widget>[
                      Text('Show Chart'),
                      Switch(
                        value: _showChart,
                        onChanged: (value) {
                          setState(() {
                            _showChart = value;
                            print(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),

              //if we are not in Landscape mode, show both
              if (!_isLandscape)
                Column(
                  children: <Widget>[
                    Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          .3,
                      child: Chart(_recentTx),
                    ),
                    //this variable shows the txList Widget
                    txListWidget,
                  ],
                ),

              //if we are in landscape mode, either show the chart or the list depending on _showChart Switch
              if (_isLandscape)
                _showChart
                    ? Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.9,
                        child: Chart(_recentTx),
                      )
                    : txListWidget
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _startAddNewTX(context),
          child: Icon(Icons.add),
        ));
  }
}
