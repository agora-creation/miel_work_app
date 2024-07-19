import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';

class CategoryList extends StatelessWidget {
  final CategoryModel category;
  final Function()? onTap;

  const CategoryList({
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
        trailing: const FaIcon(
          FontAwesomeIcons.chevronRight,
          color: kWhiteColor,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
