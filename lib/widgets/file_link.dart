import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/link_text.dart';

class FileLink extends StatelessWidget {
  final String file;
  final String fileExt;
  final Function()? onTap;

  const FileLink({
    required this.file,
    this.fileExt = '.jpg',
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (imageExtensions.contains(fileExt)) {
      return GestureDetector(
        onTap: onTap,
        child: Image.network(
          File(file).path,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    if (pdfExtensions.contains(fileExt)) {
      return LinkText(
        label: 'ファイルを開く',
        color: kBlueColor,
        onTap: onTap,
      );
    }
    return Container();
  }
}
