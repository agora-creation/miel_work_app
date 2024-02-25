import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManualPdfScreen extends StatefulWidget {
  final ManualModel manual;

  const ManualPdfScreen({
    required this.manual,
    super.key,
  });

  @override
  State<ManualPdfScreen> createState() => _ManualPdfScreenState();
}

class _ManualPdfScreenState extends State<ManualPdfScreen> {
  @override
  Widget build(BuildContext context) {
    File file = File(widget.manual.file);
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
          'PDFファイル詳細',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      body: SfPdfViewer.network(file.path),
    );
  }
}
