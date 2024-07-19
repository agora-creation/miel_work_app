import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class CustomIconTextButton extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Function()? onPressed;
  final bool disabled;

  const CustomIconTextButton({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.leftIcon,
    this.rightIcon,
    this.onPressed,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: disabled ? kGreyColor : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leftIcon != null
              ? Row(
                  children: [
                    FaIcon(
                      leftIcon,
                      color: labelColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              : Container(),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceHanSansJP-Bold',
              ),
            ),
          ),
          rightIcon != null
              ? Row(
                  children: [
                    const SizedBox(width: 8),
                    FaIcon(
                      rightIcon,
                      color: labelColor,
                      size: 16,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
