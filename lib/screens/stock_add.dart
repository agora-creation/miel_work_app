import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/stock.dart';
import 'package:miel_work_app/services/stock.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class StockAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final int category;

  const StockAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.category,
    super.key,
  });

  @override
  State<StockAddScreen> createState() => _StockAddScreenState();
}

class _StockAddScreenState extends State<StockAddScreen> {
  StockService stockService = StockService();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '999');

  void _init() async {
    numberController.text = await stockService.getLastNumber(
      organizationId: widget.loginProvider.organization?.id,
    );
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
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
          '在庫品を追加',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FormLabel(
                    '管理No',
                    child: CustomTextField(
                      controller: numberController,
                      textInputType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '品名',
                    child: CustomTextField(
                      controller: nameController,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  widget.category == 0
                      ? FormLabel(
                          '最初の在庫数',
                          child: CustomTextField(
                            controller: quantityController,
                            textInputType: TextInputType.number,
                            maxLines: 1,
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await stockProvider.create(
            organization: widget.loginProvider.organization,
            category: widget.category,
            number: numberController.text,
            name: nameController.text,
            quantity: int.parse(quantityController.text),
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '在庫品が追加されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
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
