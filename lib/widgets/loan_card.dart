import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/loan.dart';

class LoanCard extends StatelessWidget {
  final LoanModel loan;
  final Function()? onTap;

  const LoanCard({
    required this.loan,
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
                          child: Text('品名'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            loan.itemName,
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
                          child: Text('貸出日'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            dateText('yyyy/MM/dd', loan.loanAt),
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
                          child: Text('貸出先'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            loan.loanUser,
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
                          child: Text('貸出先(会社)'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            loan.loanCompany,
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
                          child: Text('対応スタッフ'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            loan.loanStaff,
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
                          child: Text('返却予定日'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            dateText('yyyy/MM/dd', loan.returnPlanAt),
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
