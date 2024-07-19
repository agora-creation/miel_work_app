import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/custom_icon_text_button.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:path/path.dart' as p;

class FilePickerButton extends StatelessWidget {
  final File? value;
  final String defaultValue;
  final Function()? onPressed;

  const FilePickerButton({
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
        CustomIconTextButton(
          label: 'ファイルを選択してください',
          labelColor: kBlackColor,
          backgroundColor: kGrey300Color,
          leftIcon: FontAwesomeIcons.file,
          onPressed: onPressed,
        ),
        value != null ? Text(p.basename(value?.path ?? '')) : Container(),
        value == null && defaultValue != ''
            ? LinkText(
                label: '確認する',
                color: kBlueColor,
                onTap: () {},
              )
            : Container(),
      ],
    );
  }
}
