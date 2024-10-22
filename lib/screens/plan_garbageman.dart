import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan_garbageman.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/plan_garbageman.dart';
import 'package:miel_work_app/widgets/custom_calendar.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/month_picker_button.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PlanGarbagemanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanGarbagemanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanGarbagemanScreen> createState() => _PlanGarbagemanScreenState();
}

class _PlanGarbagemanScreenState extends State<PlanGarbagemanScreen> {
  EventController controller = EventController();
  PlanGarbagemanService garbagemanService = PlanGarbagemanService();
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() async {
    days = generateDays(searchMonth);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '清掃員予定表',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MonthPickerButton(
              value: searchMonth,
              onTap: () async {
                DateTime? selected = await showMonthPicker(
                  context: context,
                  initialDate: searchMonth,
                  locale: const Locale('ja'),
                );
                if (selected == null) return;
                _changeMonth(selected);
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: garbagemanService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: days.first,
                  searchEnd: days.last,
                ),
                builder: (context, snapshot) {
                  List<PlanGarbagemanModel> garbageMans = [];
                  if (snapshot.hasData) {
                    garbageMans = garbagemanService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (garbageMans.isNotEmpty) {
                    for (final garbageman in garbageMans) {
                      controller.add(CalendarEventData(
                        title: garbageman.content,
                        date: garbageman.eventAt,
                      ));
                    }
                  }
                  return CustomCalendar(
                    controller: controller,
                    initialMonth: searchMonth,
                    onPageChange: (month, page) {
                      _changeMonth(month);
                    },
                    onCellTap: (events, day) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const FaIcon(
          FontAwesomeIcons.pen,
          color: kWhiteColor,
        ),
        label: const Text(
          '追加する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
