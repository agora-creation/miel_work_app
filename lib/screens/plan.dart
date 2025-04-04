import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/category.dart';
import 'package:miel_work_app/screens/plan_add.dart';
import 'package:miel_work_app/screens/plan_detail.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/day_list.dart';
import 'package:miel_work_app/widgets/month_picker_button.dart';
import 'package:miel_work_app/widgets/plan_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  AutoScrollController controller = AutoScrollController();
  PlanService planService = PlanService();
  List<String> searchCategories = [];
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _init() async {
    await ConfigService().checkReview();
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
    controller.scrollToIndex(
      DateTime.now().day,
      preferPosition: AutoScrollPosition.begin,
    );
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
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
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
                  monthPickerDialogSettings: const MonthPickerDialogSettings(
                    dialogSettings: PickerDialogSettings(
                      locale: Locale('ja'),
                    ),
                  ),
                );
                if (selected == null) return;
                _changeMonth(selected);
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: planService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchCategories: searchCategories,
                ),
                builder: (context, snapshot) {
                  List<PlanModel> plans = [];
                  if (snapshot.hasData) {
                    plans = planService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                      searchStart: DateTime(
                        days.first.year,
                        days.first.month,
                        days.first.day,
                        0,
                        0,
                        0,
                      ),
                      searchEnd: DateTime(
                        days.last.year,
                        days.last.month,
                        days.last.day,
                        23,
                        59,
                        59,
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: controller,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      DateTime day = days[index];
                      DateTime dayStart = DateTime(
                        day.year,
                        day.month,
                        day.day,
                        0,
                        0,
                        0,
                      );
                      DateTime dayEnd = DateTime(
                        day.year,
                        day.month,
                        day.day,
                        23,
                        59,
                        59,
                      );
                      List<PlanModel> dayPlans = [];
                      if (plans.isNotEmpty) {
                        for (PlanModel plan in plans) {
                          bool listIn = false;
                          if (plan.startedAt.millisecondsSinceEpoch <=
                                  dayStart.millisecondsSinceEpoch &&
                              dayStart.millisecondsSinceEpoch <=
                                  plan.endedAt.millisecondsSinceEpoch) {
                            listIn = true;
                          } else if (dayStart.millisecondsSinceEpoch <=
                                  plan.startedAt.millisecondsSinceEpoch &&
                              plan.endedAt.millisecondsSinceEpoch <=
                                  dayEnd.millisecondsSinceEpoch) {
                            listIn = true;
                          }
                          if (listIn) {
                            dayPlans.add(plan);
                          }
                        }
                      }
                      return AutoScrollTag(
                        key: ValueKey(day.day),
                        controller: controller,
                        index: day.day,
                        child: DayList(
                          day,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: dayPlans.map((dayPlan) {
                                return PlanList(
                                  plan: dayPlan,
                                  groups: widget.homeProvider.groups,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: PlanDetailScreen(
                                          loginProvider: widget.loginProvider,
                                          homeProvider: widget.homeProvider,
                                          plan: dayPlan,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: PlanAddScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                date: DateTime.now(),
              ),
            ),
          );
        },
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
        decoration: BoxDecoration(border: Border.all(color: kBorderColor)),
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
                child: Container(),
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
          backgroundColor: kSearchColor,
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
