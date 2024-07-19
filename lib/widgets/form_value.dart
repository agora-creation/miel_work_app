import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class FormValue extends StatelessWidget {
  final String value;
  final Function()? onTap;

  const FormValue(
    this.value, {
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kGrey300Color,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 18,
                ),
              ),
            ),
            onTap != null
                ? const FaIcon(
                    FontAwesomeIcons.pen,
                    size: 16,
                    color: kGrey600Color,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
