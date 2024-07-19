import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

enum ButtonSizeType { sm, lg }

class CustomButton extends StatelessWidget {
  final ButtonSizeType type;
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;
  final bool disabled;

  const CustomButton({
    required this.type,
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ButtonSizeType.lg) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: disabled ? kGreyColor : backgroundColor,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: disabled ? kWhiteColor : labelColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceHanSansJP-Bold',
            ),
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: disabled ? kGreyColor : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: disabled ? kWhiteColor : labelColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
      );
    }
  }
}
