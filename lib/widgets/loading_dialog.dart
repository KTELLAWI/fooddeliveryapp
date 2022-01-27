import 'package:flutter/material.dart';
import 'package:sellerapp/widgets/progress_bar.dart';


class LoadingDialog extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const LoadingDialog({ this.message }) ;
    final String? message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 10,),
          Text(message! + ", Please  Wait "),
        ],
        ),
      
    );
  }
}
