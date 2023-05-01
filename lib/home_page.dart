import 'dart:async';
import 'package:expense_tracker_flutter/google_sheets_api.dart';
import 'package:expense_tracker_flutter/plus_button.dart';
import 'package:expense_tracker_flutter/top_card.dart';
import 'package:expense_tracker_flutter/transaction.dart';
import 'package:flutter/material.dart';
import 'loading_circle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool timeHasStarted = false;
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void startLoading() {
    timeHasStarted = true;
    Timer.periodic(
        const Duration(seconds: 1), (timer) {
          if (GoogleSheetsApi.loading == false) {
            setState(() {});
            timer.cancel();
          }
    });
  }

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textControllerItem.text,
      _textControllerAmount.text,
      _isIncome,
    );
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textControllerAmount,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textControllerItem,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timeHasStarted == false) {
      startLoading();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          TopCard(
            balance: (GoogleSheetsApi.calculateIncome() - GoogleSheetsApi.calculateExpense()).toString(),
            income: GoogleSheetsApi.calculateIncome().toString(),
            expense: GoogleSheetsApi.calculateExpense().toString(),
          ),
          Expanded(
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: GoogleSheetsApi.loading == true
                          ? const LoadingCircle()
                          : ListView.builder(
                              itemCount:
                                  GoogleSheetsApi.currentTransactions.length,
                              itemBuilder: (context, index) {
                                return MyTransactions(
                                    amount: GoogleSheetsApi
                                        .currentTransactions[index][0],
                                    transactionName: GoogleSheetsApi
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsApi
                                        .currentTransactions[index][2]);
                              }))
                ],
              ))),
           PlusButton(
            function: _newTransaction,
          )
        ],
      ),
    );
  }
}
