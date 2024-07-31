import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class FavoriteIcon extends StatelessWidget {
  final List<String> favoriteUserIds;

  const FavoriteIcon(
    this.favoriteUserIds, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.heart,
            color: favoriteUserIds.isNotEmpty ? kRedColor : kDisabledColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${favoriteUserIds.length}',
            style: TextStyle(
              color: favoriteUserIds.isNotEmpty ? kRedColor : kDisabledColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
