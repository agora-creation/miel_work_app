import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:path/path.dart' as p;

class PdfField extends StatelessWidget {
  final File? value;
  final String defaultValue;
  final Function()? onTap;

  const PdfField({
    required this.value,
    required this.defaultValue,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kRed400Color,
        width: double.infinity,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'PDFファイル選択',
                style: TextStyle(
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value != null
                  ? Text(
                      p.basename(value?.path ?? ''),
                      style: const TextStyle(color: kWhiteColor),
                    )
                  : Container(),
              value == null && defaultValue != ''
                  ? Text(
                      defaultValue,
                      style: const TextStyle(color: kWhiteColor),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
