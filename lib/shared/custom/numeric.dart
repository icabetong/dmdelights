import 'package:flutter/material.dart';

class NumericStepper extends StatelessWidget {
  const NumericStepper({
    Key? key,
    required this.value,
    required this.onChanged,
    this.max = 10,
    this.min = 1,
  }) : super(key: key);

  final int value;
  final int max;
  final int min;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: value - 1 >= min
              ? () {
                  onChanged(value - 1);
                }
              : null,
        ),
        Expanded(
            child: Text(
          value.toString(),
          textAlign: TextAlign.center,
        )),
        IconButton(
          icon: const Icon(Icons.expand_less),
          onPressed: value + 1 <= max
              ? () {
                  onChanged(value + 1);
                }
              : null,
        )
      ],
    );
  }
}
