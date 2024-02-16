import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class GroupListTile extends StatelessWidget {
  final Function()? onTap;

  const GroupListTile({
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: kWhiteColor),
        ),
      ),
      child: ListTile(
        title: const Text(
          'インフォメーション',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
        subtitle: const Text(
          'ひろめ市場',
          style: TextStyle(color: kWhiteColor),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: kWhiteColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
