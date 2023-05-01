import 'package:flutter/material.dart';

class MyTransactions extends StatelessWidget {
  final String transactionName;
  final String amount;
  final String expenseOrIncome;

  const MyTransactions(
      {Key? key,
      required this.transactionName,
      required this.amount,
      required this.expenseOrIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.grey[100],
            // height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[500]),
                  child: const Center(
                    child: Icon(
                      Icons.currency_rupee,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(transactionName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                ),
                Text(
                  '${expenseOrIncome == 'expense' ? '-' : '+'}₹ $amount',
                  style: TextStyle(
                      fontSize: 16,
                      color: (expenseOrIncome == 'expense'
                          ? Colors.red
                          : Colors.green)),
                )
              ],
            )),
      ),
    );
  }
}
