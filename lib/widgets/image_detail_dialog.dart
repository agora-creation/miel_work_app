import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class ImageDetailDialog extends StatelessWidget {
  final String src;
  final Function()? onPressedDelete;
  final Function()? onPressedClose;

  const ImageDetailDialog(
    this.src, {
    this.onPressedDelete,
    this.onPressedClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Image.network(src),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  onPressedDelete != null
                      ? Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(100),
                          color: kWhiteColor,
                          child: IconButton(
                            onPressed: onPressedDelete,
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: kRedColor,
                              size: 30,
                            ),
                          ),
                        )
                      : Container(),
                  onPressedClose != null
                      ? Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(100),
                          color: kWhiteColor,
                          child: IconButton(
                            onPressed: onPressedClose,
                            icon: const FaIcon(
                              FontAwesomeIcons.xmark,
                              color: kBlackColor,
                              size: 30,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
