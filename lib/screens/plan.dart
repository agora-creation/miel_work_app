import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/category.dart';
import 'package:miel_work_app/screens/plan_timeline.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_calendar.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];
  sfc.CalendarController calendarController = sfc.CalendarController();

  void _init() async {
    await ConfigService().checkReview();
  }

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarLongPressDetails details) {
    showBottomUpScreen(
      context,
      PlanTimelineScreen(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
        date: details.date ?? DateTime.now(),
      ),
    );
  }

  @override
  void initState() {
    calendarController.selectedDate = DateTime.now();
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
          'スケジュール',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: kBlackColor,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SearchCategoryDialog(
                loginProvider: widget.loginProvider,
                searchCategoriesChange: _searchCategoriesChange,
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.tag,
              color: kBlackColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: CategoryScreen(
                    organization: widget.loginProvider.organization,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.loginProvider.organization?.id,
            categories: searchCategories,
          ),
          builder: (context, snapshot) {
            List<sfc.Appointment> appointments = [];
            if (snapshot.hasData) {
              appointments = planService.generateListAppointment(
                data: snapshot.data,
                currentGroup: widget.homeProvider.currentGroup,
              );
            }
            return CustomCalendar(
              dataSource: _DataSource(appointments),
              onLongPress: _calendarTap,
              controller: calendarController,
            );
          },
        ),
      ),
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}

class SearchCategoryDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final Function() searchCategoriesChange;

  const SearchCategoryDialog({
    required this.loginProvider,
    required this.searchCategoriesChange,
    super.key,
  });

  @override
  State<SearchCategoryDialog> createState() => _SearchCategoryDialogState();
}

class _SearchCategoryDialogState extends State<SearchCategoryDialog> {
  CategoryService categoryService = CategoryService();
  List<CategoryModel> categories = [];
  List<String> searchCategories = [];

  void _init() async {
    categories = await categoryService.selectList(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
    );
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((category) {
              return CustomCheckbox(
                label: category.name,
                labelColor: kWhiteColor,
                backgroundColor: category.color,
                value: searchCategories.contains(category.name),
                onChanged: (value) {
                  if (searchCategories.contains(category.name)) {
                    searchCategories.remove(category.name);
                  } else {
                    searchCategories.add(category.name);
                  }
                  setState(() {});
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kLightBlueColor,
          onPressed: () async {
            await setPrefsList('categories', searchCategories);
            widget.searchCategoriesChange();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
