import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/reply_source.dart';
import 'package:miel_work_app/widgets/reply_source_list.dart';

class MessageFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? filePressed;
  final Function()? galleryPressed;
  final Function()? sendPressed;
  final bool enabled;
  final ReplySourceModel? replySource;
  final Function()? replyClosed;

  const MessageFormField({
    required this.controller,
    required this.filePressed,
    required this.galleryPressed,
    required this.sendPressed,
    this.enabled = false,
    this.replySource,
    this.replyClosed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kGreyColor)),
      ),
      child: Column(
        children: [
          replySource != null
              ? ReplySourceList(
                  replySource: replySource,
                  onTap: replyClosed,
                )
              : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              replySource == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: enabled ? filePressed : null,
                            icon: Icon(
                              Icons.upload_file_sharp,
                              color: enabled ? kBlueColor : kGreyColor,
                              size: 32,
                            ),
                          ),
                          IconButton(
                            onPressed: enabled ? galleryPressed : null,
                            icon: Icon(
                              Icons.add_photo_alternate,
                              color: enabled ? kBlueColor : kGreyColor,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kGrey200Color),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration.collapsed(
                          hintText: replySource == null
                              ? 'メッセージを入力...'
                              : 'リプライを入力...',
                          hintStyle: const TextStyle(fontSize: 20),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        enabled: enabled,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: IconButton(
                  onPressed: enabled ? sendPressed : null,
                  icon: Icon(
                    Icons.send,
                    color: enabled ? kBlueColor : kGreyColor,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
