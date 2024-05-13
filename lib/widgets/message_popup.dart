import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:miel_work_app/common/style.dart';

class MessagePopup extends StatelessWidget {
  final Function()? copyAction;
  final Function()? deleteAction;
  final Widget child;

  const MessagePopup({
    this.copyAction,
    this.deleteAction,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      contentPadding: const EdgeInsets.all(16),
      content: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: copyAction,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kGrey300Color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copy),
                  Text('コピー'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: deleteAction,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kGrey300Color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete),
                  Text('削除'),
                ],
              ),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
