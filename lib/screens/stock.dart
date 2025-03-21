import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/stock.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/stock_add.dart';
import 'package:miel_work_app/screens/stock_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/stock.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/stock_list.dart';
import 'package:page_transition/page_transition.dart';

class StockScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const StockScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  StockService stockService = StockService();
  TabController? _tabController;

  void _init() async {
    await ConfigService().checkReview();
  }

  @override
  void initState() {
    _init();
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhiteColor,
          title: const Text(
            '在庫品一覧',
            style: TextStyle(color: kBlackColor),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                color: kBlackColor,
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('一般在庫', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('資産', style: TextStyle(fontSize: 18)),
              ),
            ],
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 5, color: kBlueColor),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          shape: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stockService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  category: 0,
                ),
                builder: (context, snapshot) {
                  List<StockModel> stocks = [];
                  if (snapshot.hasData) {
                    stocks = stockService.generateList(data: snapshot.data);
                  }
                  if (stocks.isEmpty) {
                    return const Center(child: Text('一般在庫品はありません'));
                  }
                  return ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      StockModel stock = stocks[index];
                      return StockList(
                        stock: stock,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: StockDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                stock: stock,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stockService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  category: 1,
                ),
                builder: (context, snapshot) {
                  List<StockModel> stocks = [];
                  if (snapshot.hasData) {
                    stocks = stockService.generateList(data: snapshot.data);
                  }
                  if (stocks.isEmpty) {
                    return const Center(child: Text('資産品はありません'));
                  }
                  return ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      StockModel stock = stocks[index];
                      return StockList(
                        stock: stock,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: StockDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                stock: stock,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
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
                child: StockAddScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  category: _tabController!.index,
                ),
              ),
            );
          },
          icon: const FaIcon(
            FontAwesomeIcons.plus,
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
      ),
    );
  }
}
