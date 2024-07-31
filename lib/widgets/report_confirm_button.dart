import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class ReportConfirmButton extends StatelessWidget {
  final bool confirm;
  final String confirmTime;
  final String confirmLabel;
  final Function()? onPressed;

  const ReportConfirmButton({
    this.confirm = false,
    this.confirmTime = '',
    this.confirmLabel = '',
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const FaIcon(FontAwesomeIcons.check),
            style: IconButton.styleFrom(
              backgroundColor:
                  confirm ? kCheckColor : kGreyColor.withOpacity(0.3),
            ),
            color: kWhiteColor,
          ),
          confirm
              ? Column(
                  children: [
                    Text(confirmTime),
                    Text(confirmLabel),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
