import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_facility.dart';

class RequestFacilityList extends StatelessWidget {
  final RequestFacilityModel facility;
  final Function()? onTap;

  const RequestFacilityList({
    required this.facility,
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
                    facility.companyUserName,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '店舗責任者名: ${facility.companyUserName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', facility.createdAt)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  facility.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', facility.approvedAt)}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
