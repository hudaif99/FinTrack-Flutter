import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;
  const PlusButton({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration:
            BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
        height: 75,
        width: 75,
        child: const Center(
            child: Text(
          '+',
          style: TextStyle(color: Colors.white, fontSize: 25),
        )),
      ),
    );
  }
}
