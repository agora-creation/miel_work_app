import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class MessageFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? galleryPressed;
  final Function()? sendPressed;
  final bool enabled;

  const MessageFormField({
    required this.controller,
    required this.galleryPressed,
    required this.sendPressed,
    this.enabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kGreyColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: IconButton(
              onPressed: enabled ? galleryPressed : null,
              icon: Icon(Icons.photo, color: enabled ? kBlueColor : kGreyColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'メッセージを入力...',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                enabled: enabled,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: IconButton(
              onPressed: enabled ? sendPressed : null,
              icon: Icon(Icons.send, color: enabled ? kBlueColor : kGreyColor),
            ),
          ),
        ],
      ),
    );
  }
}
