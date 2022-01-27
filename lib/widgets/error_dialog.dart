import 'package:flutter/material.dart';


class ErrorDialog extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ErrorDialog({ this.message }) ;
    final String? message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          child: const Center(
            child: Text('OK'),

          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          ),
      ],
    
    );
  }
}