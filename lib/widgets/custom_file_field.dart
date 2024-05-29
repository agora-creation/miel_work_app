import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:path/path.dart' as p;

class CustomFileField extends StatelessWidget {
  final File? value;
  final String defaultValue;
  final Function()? onPressed;

  const CustomFileField({
    required this.value,
    required this.defaultValue,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomButtonSm(
          label: 'ファイル選択',
          labelColor: kBlackColor,
          backgroundColor: kGrey300Color,
          onPressed: onPressed,
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
    );
  }
}
