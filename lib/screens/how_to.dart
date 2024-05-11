import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          automaticallyImplyLeading: false,
          title: const Text(
            '使い方',
            style: TextStyle(color: kBlackColor),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: kBlackColor,
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        ),
        body: SfPdfViewer.network('https://agora-c.com/miel-work/manual.pdf'),
      ),
    );
  }
}
