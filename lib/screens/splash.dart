import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/animation_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimationBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: kBlackColor)),
                    ),
                    child: const Text(
                      'ひろめWORK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceHanSansJP-Bold',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SpinKitCubeGrid(
                    color: kBlackColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
