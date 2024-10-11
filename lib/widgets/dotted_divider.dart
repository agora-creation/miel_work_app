import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double lineWidth = constraints.maxWidth; // Dividerの横幅
        const double dashWidth = 5.0; // 点線の幅
        const double dashSpace = 5.0; // 線と線の間隔

        // 点線の個数を計算
        int dashCount = (lineWidth / (dashWidth + dashSpace)).floor();

        return SizedBox(
          width: lineWidth,
          height: 1.0, // Dividerの高さ
          child: ListView.builder(
            itemCount: dashCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              // 各点線の描画
              return Container(
                width: dashWidth,
                height: 1.0, // 点線の高さ
                color: Colors.black, // 点線の色
                margin: const EdgeInsets.symmetric(horizontal: dashSpace),
              );
            },
          ),
        );
      },
    );
  }
}
