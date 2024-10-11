import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class RequestList extends StatelessWidget {
  final String label;
  final bool alert;
  final Function()? onTap;

  const RequestList({
    required this.label,
    this.alert = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(label),
        trailing: alert
            ? const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: kRedColor,
                size: 16,
              )
            : const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledColor,
                size: 16,
              ),
        onTap: onTap,
        tileColor: alert ? kRedColor.withOpacity(0.3) : null,
      ),
    );
  }
}
