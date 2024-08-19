import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/lost.dart';

class LostCard extends StatelessWidget {
  final LostModel lost;
  final Function()? onTap;

  const LostCard({
    required this.lost,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: kWhiteColor,
          elevation: 8,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(color: kBorderColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('落とし物No'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            lost.itemNumber,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('品名'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            lost.itemName,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('発見日'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            dateText('yyyy/MM/dd', lost.discoveryAt),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('発見場所'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            lost.discoveryPlace,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('発見者'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            lost.discoveryUser,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('備考'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            lost.remarks,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
