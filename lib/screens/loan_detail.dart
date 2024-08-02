import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/loan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/loan.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/loan_mod.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoanDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const LoanDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
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
          '貸出情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelLoanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                loan: widget.loan,
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
                  child: LoanModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    loan: widget.loan,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(
                '貸出日',
                child: FormValue(
                  dateText('yyyy/MM/dd HH:mm', widget.loan.loanAt),
                ),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '貸出先',
                child: FormValue(widget.loan.loanUser),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '貸出先(会社)',
                child: FormValue(widget.loan.loanCompany),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '対応スタッフ',
                child: FormValue(widget.loan.loanStaff),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '返却予定日',
                child: FormValue(
                  dateText('yyyy/MM/dd HH:mm', widget.loan.returnPlanAt),
                ),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '品名',
                child: FormValue(widget.loan.itemName),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '添付写真',
                child: Container(),
              ),
              const SizedBox(height: 80),
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

class DelLoanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const DelLoanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<DelLoanDialog> createState() => _DelLoanDialogState();
}

class _DelLoanDialogState extends State<DelLoanDialog> {
  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
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
            String? error = await loanProvider.delete(
              loan: widget.loan,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '貸出情報が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
