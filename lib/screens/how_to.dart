import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '使い方',
          style: TextStyle(color: kBlackColor),
        ),
      ),
      body: SfPdfViewer.network('https://agora-c.com/miel-work/manual.pdf'),
    );
  }
}
