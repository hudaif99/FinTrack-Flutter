import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  const TopCard(
      {super.key,
      required this.balance,
      required this.income,
      required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(4.0, 4.0),
                blurRadius: 15,
                spreadRadius: 1),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                blurRadius: 15,
                spreadRadius: 1)
          ]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'B A L A N C E',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            Text(
              '₹ $balance',
              style: TextStyle(color: Colors.grey[800], fontSize: 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200], shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '₹ $income',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200], shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '₹ $expense',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
