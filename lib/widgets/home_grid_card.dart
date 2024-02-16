import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class HomeGridCard extends StatelessWidget {
  final String label;
  final Widget child;
  final Function()? onTap;

  const HomeGridCard({
    required this.label,
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: kWhiteColor,
        surfaceTintColor: kWhiteColor,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: kBlackColor),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(color: kBlackColor),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
