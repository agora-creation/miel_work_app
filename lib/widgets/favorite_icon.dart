import 'package:flutter/material.dart';
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
          Icon(
            Icons.favorite,
            color: favoriteUserIds.isNotEmpty ? kRedColor : kGreyColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${favoriteUserIds.length}',
            style: TextStyle(
              color: favoriteUserIds.isNotEmpty ? kRedColor : kGreyColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
