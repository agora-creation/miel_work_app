import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_group_radio.dart';

class GroupSelectCard extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupSelectCard({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupSelectCard> createState() => _GroupSelectCardState();
}

class _GroupSelectCardState extends State<GroupSelectCard> {
  @override
  void initState() {
    super.initState();
    widget.homeProvider.setGroups(
      organizationId: widget.loginProvider.organization?.id,
      group: widget.loginProvider.isAdmin() ? null : widget.loginProvider.group,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loginProvider.isAdmin()) return Container();
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
        bottom: 4,
      ),
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => GroupSelectDialog(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
          ),
        ),
        child: Material(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: widget.homeProvider.currentGroup != null
                ? Text(widget.homeProvider.currentGroup?.name ?? '')
                : const Text('グループ未選択'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            tileColor: kWhiteColor,
          ),
        ),
      ),
    );
  }
}

class GroupSelectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupSelectDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupSelectDialog> createState() => _GroupSelectDialogState();
}

class _GroupSelectDialogState extends State<GroupSelectDialog> {
  @override
  Widget build(BuildContext context) {
    List<Widget> groupChildren = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupChildren.add(CustomGroupRadio(
        group: null,
        value: widget.homeProvider.currentGroup,
        onChanged: (value) {
          widget.homeProvider.currentGroupChange(value);
          Navigator.pop(context);
        },
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupChildren.add(CustomGroupRadio(
          group: group,
          value: widget.homeProvider.currentGroup,
          onChanged: (value) {
            widget.homeProvider.currentGroupChange(value);
            Navigator.pop(context);
          },
        ));
      }
    }
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupChildren,
          ),
        ),
      ),
    );
  }
}
