import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan_dish_center.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_dish_center.dart';
import 'package:miel_work_app/screens/plan_dish_center.dart';
import 'package:miel_work_app/services/organization_group.dart';
import 'package:miel_work_app/services/plan_dish_center.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/plan_dish_center_list.dart';
import 'package:provider/provider.dart';

class PlanDishCenterTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const PlanDishCenterTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<PlanDishCenterTimelineScreen> createState() =>
      _PlanDishCenterTimelineScreenState();
}

class _PlanDishCenterTimelineScreenState
    extends State<PlanDishCenterTimelineScreen> {
  PlanDishCenterService dishCenterService = PlanDishCenterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${dateText('yyyy/MM/dd', widget.day)}：食器センター勤務表',
          style: const TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: dishCenterService.streamList(
            organizationId: widget.loginProvider.organization?.id,
            searchStart: widget.day,
            searchEnd: DateTime(
              widget.day.year,
              widget.day.month,
              widget.day.day,
              23,
              59,
              59,
            ),
          ),
          builder: (context, snapshot) {
            List<PlanDishCenterModel> dishCenters = [];
            if (snapshot.hasData) {
              dishCenters = dishCenterService.generateList(
                data: snapshot.data,
              );
            }
            if (dishCenters.isEmpty) {
              return const Center(child: Text('この日の勤務予定はありません'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dishCenters.length,
              itemBuilder: (context, index) {
                PlanDishCenterModel dishCenter = dishCenters[index];
                return PlanDishCenterList(
                  dishCenter: dishCenter,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ModDishCenterDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      dishCenter: dishCenter,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddDishCenterDialog(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            day: DateTime.now(),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.pen,
          color: kWhiteColor,
        ),
        label: const Text(
          '追加する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
    );
  }
}

class ModDishCenterDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanDishCenterModel dishCenter;

  const ModDishCenterDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.dishCenter,
    super.key,
  });

  @override
  State<ModDishCenterDialog> createState() => _ModDishCenterDialogState();
}

class _ModDishCenterDialogState extends State<ModDishCenterDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  TextEditingController remarksController = TextEditingController();

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '食器センター',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    selectedUser = users.singleWhere((e) => e.id == widget.dishCenter.userId);
    startedAt = widget.dishCenter.startedAt;
    endedAt = widget.dishCenter.endedAt;
    remarksController.text = widget.dishCenter.remarks;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dishCenterProvider = Provider.of<PlanDishCenterProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            'スタッフ選択',
            child: DropdownButton<UserModel?>(
              isExpanded: true,
              value: selectedUser,
              items: users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '予定日時',
            child: DatetimeRangeForm(
              startedAt: startedAt,
              startedOnTap: () => picker.DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: kFirstDate,
                maxTime: kLastDate,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    startedAt = value;
                    endedAt = startedAt.add(const Duration(hours: 1));
                  });
                },
                currentTime: startedAt,
                locale: picker.LocaleType.jp,
              ),
              endedAt: endedAt,
              endedOnTap: () => picker.DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: kFirstDate,
                maxTime: kLastDate,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    endedAt = value;
                  });
                },
                currentTime: endedAt,
                locale: picker.LocaleType.jp,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '備考',
            child: CustomTextField(
              controller: remarksController,
              textInputType: TextInputType.name,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await dishCenterProvider.delete(
              dishCenter: widget.dishCenter,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '勤務予定が削除されました', true);
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await dishCenterProvider.update(
              dishCenter: widget.dishCenter,
              organization: widget.loginProvider.organization,
              user: selectedUser,
              startedAt: startedAt,
              endedAt: endedAt,
              remarks: remarksController.text,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '勤務予定が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
