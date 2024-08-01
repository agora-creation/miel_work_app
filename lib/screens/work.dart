import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/day_list.dart';
import 'package:miel_work_app/widgets/month_picker_button.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class WorkScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const WorkScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() {
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
          '勤怠打刻',
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
      body: Column(
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
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                DateTime day = days[index];
                return DayList(
                  day,
                  child: Container(),
                );
              },
            ),
          ),
        ],
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
