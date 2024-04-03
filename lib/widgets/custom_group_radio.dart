import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';

class CustomGroupRadio extends StatelessWidget {
  final OrganizationGroupModel? group;
  final OrganizationGroupModel? value;
  final void Function(OrganizationGroupModel?)? onChanged;

  const CustomGroupRadio({
    required this.group,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      child: RadioListTile<OrganizationGroupModel?>(
        title: group != null
            ? Text(group?.name ?? '')
            : const Text(
                'グループの指定なし',
                style: TextStyle(color: kGreyColor),
              ),
        value: group,
        groupValue: value,
        onChanged: onChanged,
      ),
    );
  }
}
