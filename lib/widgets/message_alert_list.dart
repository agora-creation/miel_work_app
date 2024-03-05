import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class MessageAlertList extends StatelessWidget {
  final String label;
  final String subLabel;

  const MessageAlertList({
    required this.label,
    required this.subLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kBlue300Color,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                subLabel,
                style: const TextStyle(fontSize: 12),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
