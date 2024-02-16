import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/user.dart';

class GroupScreen extends StatefulWidget {
  final UserProvider userProvider;

  const GroupScreen({
    required this.userProvider,
    super.key,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
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
          '団体／グループの設定',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: kGrey600Color),
              ),
            ),
            child: RadioListTile(
              value: '1',
              groupValue: '1',
              title: const Text('ひろめ市場 インフォメーション'),
              onChanged: (value) {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: kGrey600Color),
              ),
            ),
            child: RadioListTile(
              value: '2',
              groupValue: '1',
              title: const Text('ひろめ市場 食器センター'),
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
