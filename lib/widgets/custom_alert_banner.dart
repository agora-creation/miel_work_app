import 'package:flutter/material.dart';

class CustomAlertBanner extends StatelessWidget {
  const CustomAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Text(
            "This is an example notification. It looks awesome!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
