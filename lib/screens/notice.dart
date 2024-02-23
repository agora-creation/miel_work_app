import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
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
          'お知らせ',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
