import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/stock.dart';

class StockList extends StatelessWidget {
  final StockModel stock;
  final Function()? onTap;

  const StockList({
    required this.stock,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
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
                    '在庫No: ${stock.number}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    stock.name,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Text('在庫数: ${stock.quantity}'),
          ],
        ),
      ),
    );
  }
}
