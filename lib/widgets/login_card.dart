import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class LoginCard extends StatelessWidget {
  final List<Widget> children;

  const LoginCard({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
