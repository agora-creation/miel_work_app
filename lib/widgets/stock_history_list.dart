import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/stock_history.dart';
import 'package:miel_work_app/widgets/link_text.dart';

class StockHistoryList extends StatelessWidget {
  final StockHistoryModel stockHistory;
  final Function()? onTap;

  const StockHistoryList({
    required this.stockHistory,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: stockHistory.typeColor(),
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stockHistory.typeText()}日時: ${dateText('yyyy/MM/dd HH:mm', stockHistory.createdAt)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '${stockHistory.typeSign()} ${stockHistory.quantity}',
                  style: const TextStyle(fontSize: 18),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          LinkText(
            label: '削除',
            color: kRedColor,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
