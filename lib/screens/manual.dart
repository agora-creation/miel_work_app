import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/manual.dart';
import 'package:miel_work_app/screens/manual_pdf.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_manual_list.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ManualScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ManualScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  ManualService manualService = ManualService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          '業務マニュアル一覧',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: manualService.streamList(
          organizationId: widget.loginProvider.organization?.id,
        ),
        builder: (context, snapshot) {
          List<ManualModel> manuals = [];
          if (snapshot.hasData) {
            manuals = manualService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
          }
          return ListView.builder(
            itemCount: manuals.length,
            itemBuilder: (context, index) {
              ManualModel manual = manuals[index];
              return CustomManualList(
                manual: manual,
                user: widget.loginProvider.user,
                onTap: () => pushScreen(
                  context,
                  ManualPdfScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    manual: manual,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.loginProvider.isAdmin()
          ? FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AddManualDialog(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
              child: const Icon(Icons.add, color: kWhiteColor),
            )
          : Container(),
    );
  }
}

class AddManualDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const AddManualDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<AddManualDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddManualDialog> {
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.homeProvider.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        '業務マニュアルを追加',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: titleController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'タイトル',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          CustomButtonSm(
            label: 'PDFファイル選択',
            labelColor: kWhiteColor,
            backgroundColor: kGreyColor,
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result == null) return;
              setState(() {
                pickedFile = result.files.first;
              });
            },
          ),
          const SizedBox(height: 8),
          DropdownButton<OrganizationGroupModel?>(
            isExpanded: true,
            value: selectedGroup,
            items: groupItems,
            onChanged: (value) {
              setState(() {
                selectedGroup = value;
              });
            },
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
            String? error = await manualProvider.create(
              organization: widget.loginProvider.organization,
              title: titleController.text,
              pickedFile: pickedFile,
              group: selectedGroup,
              user: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '業務マニュアルを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
