import 'package:flutter/material.dart';

class CustomAlertBanner extends StatelessWidget {
  final String msg;
  final bool success;

  const CustomAlertBanner({
    required this.msg,
    required this.success,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        color: success ? Colors.blueAccent : Colors.redAccent,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
