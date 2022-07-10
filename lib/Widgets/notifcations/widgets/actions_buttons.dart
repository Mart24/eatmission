import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key key,
    this.onCreate,
    this.onCancel,
  }) : super(key: key);
  final VoidCallback onCreate;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Colors.grey[200],
          ),
          child: Text(
            "Annuleer",
            style: TextStyle(color: Colors.black87),
          ),
        ),
        SizedBox(width: 12.0),
        ElevatedButton(
          onPressed: onCreate,
          child: Text("Maak aan"),
        ),
      ],
    );
  }
}
