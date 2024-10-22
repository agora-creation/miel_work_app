import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan_guardsman.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_guardsman.dart';
import 'package:miel_work_app/screens/plan_guardsman.dart';
import 'package:miel_work_app/services/plan_guardsman.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/plan_guardsman_list.dart';
import 'package:provider/provider.dart';

class PlanGuardsmanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const PlanGuardsmanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<PlanGuardsmanTimelineScreen> createState() =>
      _PlanGuardsmanTimelineScreenState();
}

class _PlanGuardsmanTimelineScreenState
    extends State<PlanGuardsmanTimelineScreen> {
  PlanGuardsmanService guardsmanService = PlanGuardsmanService();

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
          '${dateText('yyyy/MM/dd', widget.day)}：警備員予定表',
          style: const TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: guardsmanService.streamList(
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
            List<PlanGuardsmanModel> guardsMans = [];
            if (snapshot.hasData) {
              guardsMans = guardsmanService.generateList(
                data: snapshot.data,
              );
            }
            if (guardsMans.isEmpty) {
              return const Center(child: Text('この日の予定はありません'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: guardsMans.length,
              itemBuilder: (context, index) {
                PlanGuardsmanModel guardsman = guardsMans[index];
                return PlanGuardsmanList(
                  guardsman: guardsman,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ModGuardsmanDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      guardsman: guardsman,
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
          builder: (context) => AddGuardsmanDialog(
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

class ModGuardsmanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanGuardsmanModel guardsman;

  const ModGuardsmanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.guardsman,
    super.key,
  });

  @override
  State<ModGuardsmanDialog> createState() => _ModGuardsmanDialogState();
}

class _ModGuardsmanDialogState extends State<ModGuardsmanDialog> {
  TextEditingController contentController = TextEditingController();
  DateTime eventAt = DateTime.now();

  @override
  void initState() {
    contentController.text = widget.guardsman.content;
    eventAt = widget.guardsman.eventAt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final guardsmanProvider = Provider.of<PlanGuardsmanProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormLabel(
              '内容',
              child: CustomTextField(
                controller: contentController,
                textInputType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            FormLabel(
              '予定日',
              child: FormValue(
                dateText('yyyy/MM/dd', eventAt),
                onTap: () async {
                  picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: kFirstDate,
                    maxTime: kLastDate,
                    theme: kDatePickerTheme,
                    onConfirm: (value) {
                      setState(() {
                        eventAt = value;
                      });
                    },
                    currentTime: eventAt,
                    locale: picker.LocaleType.jp,
                  );
                },
              ),
            ),
          ],
        ),
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
            String? error = await guardsmanProvider.delete(
              guardsman: widget.guardsman,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '警備員予定が削除されました', true);
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await guardsmanProvider.update(
              guardsman: widget.guardsman,
              organization: widget.loginProvider.organization,
              content: contentController.text,
              eventAt: eventAt,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '警備員予定が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
