import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class AttachedFileList extends StatelessWidget {
  final String fileName;
  final Function()? onTap;
  final bool isClose;

  const AttachedFileList({
    required this.fileName,
    this.onTap,
    this.isClose = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(
          fileName,
          style: const TextStyle(color: kBlueColor),
        ),
        trailing: isClose
            ? const Icon(
                FontAwesomeIcons.xmark,
                color: kRedColor,
                size: 18,
              )
            : const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.transparent,
                size: 18,
              ),
        onTap: onTap,
      ),
    );
  }
}
