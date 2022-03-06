import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function func;
  final String text;
  final Color color;

  const FollowButton(
      {Key? key, required this.func, required this.text, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          onPressed: () => func(),
          child: Text(text),
        ),
      ),
    );
  }
}
