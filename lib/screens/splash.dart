import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/animation_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          AnimationBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'ひろめWORK',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                    letterSpacing: 2,
                  ),
                ),
                SpinKitCubeGrid(color: kBlackColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
