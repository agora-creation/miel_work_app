import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/providers/category.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_category_list.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final OrganizationModel? organization;

  const CategoryScreen({
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
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'カテゴリ管理',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
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
              return CustomCategoryList(
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
        icon: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
          style: TextStyle(color: kWhiteColor),
        ),
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
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'カテゴリを追加',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'カテゴリ名',
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
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
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
            showMessage(context, 'カテゴリを追加しました', true);
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
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'カテゴリを削除',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: widget.category.color,
            title: Text(
              widget.category.name,
              style: const TextStyle(color: kWhiteColor),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
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
            showMessage(context, 'カテゴリを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
