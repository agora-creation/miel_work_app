import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/stock.dart';
import 'package:miel_work_app/models/stock_history.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/stock.dart';
import 'package:miel_work_app/providers/stock_history.dart';
import 'package:miel_work_app/screens/stock_mod.dart';
import 'package:miel_work_app/services/stock_history.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/stock_history_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class StockDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const StockDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  StockHistoryService stockHistoryService = StockHistoryService();

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
        title: const Text(
          '在庫品の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelStockDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                stock: widget.stock,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: StockModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    stock: widget.stock,
                  ),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.pen,
              color: kBlueColor,
            ),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '登録日時：${dateText('yyyy/MM/dd HH:mm', widget.stock.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
              ),
              FormLabel(
                '管理No',
                child: FormValue(widget.stock.number),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '品名',
                child: FormValue(widget.stock.name),
              ),
              const SizedBox(height: 8),
              widget.stock.category == 0
                  ? FormLabel(
                      '現在の在庫数',
                      child: FormValue(widget.stock.quantity.toString()),
                    )
                  : Container(),
              widget.stock.category == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          type: ButtonSizeType.sm,
                          label: '(−)出庫',
                          labelColor: kWhiteColor,
                          backgroundColor: kRedColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AddStockType0Dialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              stock: widget.stock,
                            ),
                          ),
                          disabled: widget.stock.quantity == 0,
                        ),
                        CustomButton(
                          type: ButtonSizeType.sm,
                          label: '(+)入庫',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AddStockType1Dialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              stock: widget.stock,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              widget.stock.category == 0 ? const Text('在庫変動履歴一覧') : Container(),
              widget.stock.category == 0
                  ? Expanded(
                      child: SingleChildScrollView(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: stockHistoryService.streamList(
                            stockId: widget.stock.id,
                            searchStart: null,
                            searchEnd: null,
                          ),
                          builder: (context, snapshot) {
                            List<StockHistoryModel> stockHistories = [];
                            if (snapshot.hasData) {
                              stockHistories = stockHistoryService.generateList(
                                data: snapshot.data,
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: stockHistories.length,
                              itemBuilder: (context, index) {
                                StockHistoryModel stockHistory =
                                    stockHistories[index];
                                return StockHistoryList(
                                  stockHistory: stockHistory,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => DelStockHistoryDialog(
                                      loginProvider: widget.loginProvider,
                                      homeProvider: widget.homeProvider,
                                      stock: widget.stock,
                                      stockHistory: stockHistory,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class DelStockDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const DelStockDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<DelStockDialog> createState() => _DelStockDialogState();
}

class _DelStockDialogState extends State<DelStockDialog> {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
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
            String? error = await stockProvider.delete(
              stock: widget.stock,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫品を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelStockHistoryDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;
  final StockHistoryModel stockHistory;

  const DelStockHistoryDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    required this.stockHistory,
    super.key,
  });

  @override
  State<DelStockHistoryDialog> createState() => _DelStockHistoryDialogState();
}

class _DelStockHistoryDialogState extends State<DelStockHistoryDialog> {
  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
            Text(
              '※在庫数は元に戻ります。',
              style: TextStyle(color: kRedColor),
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
            String? error = await stockHistoryProvider.delete(
              stock: widget.stock,
              stockHistory: widget.stockHistory,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddStockType0Dialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const AddStockType0Dialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<AddStockType0Dialog> createState() => _AddStockType0DialogState();
}

class _AddStockType0DialogState extends State<AddStockType0Dialog> {
  TextEditingController quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            '在庫品名',
            child: FormValue(widget.stock.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '出庫する数',
            child: CustomTextField(
              controller: quantityController,
              textInputType: TextInputType.number,
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
          label: '出庫する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await stockHistoryProvider.create(
              stock: widget.stock,
              type: 0,
              quantity: int.parse(quantityController.text),
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddStockType1Dialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const AddStockType1Dialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<AddStockType1Dialog> createState() => _AddStockType1DialogState();
}

class _AddStockType1DialogState extends State<AddStockType1Dialog> {
  TextEditingController quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            '在庫品名',
            child: FormValue(widget.stock.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '入庫する数',
            child: CustomTextField(
              controller: quantityController,
              textInputType: TextInputType.number,
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
          label: '入庫する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await stockHistoryProvider.create(
              stock: widget.stock,
              type: 1,
              quantity: int.parse(quantityController.text),
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
