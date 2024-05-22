import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';

class CustomCategoryList extends StatelessWidget {
  final CategoryModel category;
  final Function()? onTap;

  const CustomCategoryList({
    required this.category,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: category.color,
        border: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      child: ListTile(
        title: Text(
          category.name,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: kWhiteColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
