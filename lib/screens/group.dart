import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/group_mod.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';

class GroupScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<OrganizationGroupModel> groups = [];

  void _getGroups() {
    groups.clear();
    if (widget.homeProvider.groups.isNotEmpty) {
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groups.add(group);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'グループ管理',
            style: TextStyle(color: kBlackColor),
          ),
          shape: const Border(bottom: BorderSide(color: kGrey600Color)),
        ),
        body: groups.isNotEmpty
            ? ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  OrganizationGroupModel group = groups[index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: kGrey600Color)),
                    ),
                    child: ListTile(
                      title: Text(group.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => pushScreen(
                        context,
                        GroupModScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          group: group,
                          getGroups: _getGroups,
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text('グループはありません')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddGroupDialog(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              getGroups: _getGroups,
            ),
          ),
          icon: const Icon(
            Icons.add,
            color: kWhiteColor,
          ),
          label: const Text(
            '新規追加',
            style: TextStyle(color: kWhiteColor),
          ),
        ),
      ),
    );
  }
}

class AddGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function() getGroups;

  const AddGroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.getGroups,
    super.key,
  });

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'グループを追加',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'グループ名',
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.homeProvider.groupCreate(
              organization: widget.loginProvider.organization,
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getGroups();
            if (!mounted) return;
            showMessage(context, 'グループを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
