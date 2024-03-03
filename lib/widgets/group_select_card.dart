import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';

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
      organizationId: widget.loginProvider.organization?.id ?? 'error',
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
    List<RadioListTile<OrganizationGroupModel?>> groupChildren = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupChildren.add(RadioListTile<OrganizationGroupModel?>(
        title: const Text('グループ未選択'),
        value: null,
        groupValue: widget.homeProvider.currentGroup,
        onChanged: (value) {
          widget.homeProvider.currentGroupChange(value);
          Navigator.pop(context);
        },
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupChildren.add(RadioListTile<OrganizationGroupModel?>(
          title: Text(group.name),
          value: group,
          groupValue: widget.homeProvider.currentGroup,
          onChanged: (value) {
            widget.homeProvider.currentGroupChange(value);
            Navigator.pop(context);
          },
        ));
      }
    }
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupChildren,
        ),
      ),
    );
  }
}
