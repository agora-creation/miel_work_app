import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_square.dart';

class RequestSquareList extends StatelessWidget {
  final RequestSquareModel square;
  final Function()? onTap;

  const RequestSquareList({
    required this.square,
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
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    square.companyName,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '申込担当者名: ${square.companyUserName}',
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', square.createdAt)}',
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  square.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', square.approvedAt)}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 14,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: kDisabledColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
