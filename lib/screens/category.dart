import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/providers/category.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/widgets/category_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const CategoryScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryService categoryService = CategoryService();

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
          'カテゴリ管理',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: categoryService.streamList(
          organizationId: widget.organization?.id,
        ),
        builder: (context, snapshot) {
          List<CategoryModel> categories = [];
          if (snapshot.hasData) {
            categories = categoryService.generateList(
              data: snapshot.data,
            );
          }
          if (categories.isEmpty) {
            return const Center(child: Text('カテゴリはありません'));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              CategoryModel category = categories[index];
              return CategoryList(
                category: category,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => DelCategoryDialog(category: category),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddCategoryDialog(
            organization: widget.organization,
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.plus,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
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

class AddCategoryDialog extends StatefulWidget {
  final OrganizationModel? organization;

  const AddCategoryDialog({
    required this.organization,
    super.key,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController nameController = TextEditingController();
  Color color = kBlueColor;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(
            'カテゴリ名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          BlockPicker(
            pickerColor: color,
            onColorChanged: (value) {
              setState(() {
                color = value;
              });
            },
          ),
        ],
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
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await categoryProvider.create(
              organization: widget.organization,
              name: nameController.text,
              color: color,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'カテゴリが追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelCategoryDialog extends StatefulWidget {
  final CategoryModel category;

  const DelCategoryDialog({
    required this.category,
    super.key,
  });

  @override
  State<DelCategoryDialog> createState() => _DelCategoryDialogState();
}

class _DelCategoryDialogState extends State<DelCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(
            'カテゴリ名',
            child: FormValue(widget.category.name),
          ),
        ],
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await categoryProvider.delete(
              category: widget.category,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'カテゴリが削除されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
