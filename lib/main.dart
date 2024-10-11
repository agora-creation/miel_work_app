import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/category.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/loan.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/lost.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/providers/plan.dart';
import 'package:miel_work_app/providers/problem.dart';
import 'package:miel_work_app/providers/report.dart';
import 'package:miel_work_app/providers/request_cycle.dart';
import 'package:miel_work_app/providers/request_facility.dart';
import 'package:miel_work_app/providers/request_interview.dart';
import 'package:miel_work_app/providers/request_square.dart';
import 'package:miel_work_app/providers/user.dart';
import 'package:miel_work_app/screens/home.dart';
import 'package:miel_work_app/screens/login.dart';
import 'package:miel_work_app/screens/splash.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyBDaAh4qXyu73GIkKmbHxgFirqmJfkcfe0',
            appId: '1:66212259980:android:0c87140f712c46b83933a9',
            messagingSenderId: '66212259980',
            projectId: 'miel-work-project',
            storageBucket: 'miel-work-project.appspot.com',
          ),
        )
      : await Firebase.initializeApp();
  await FmService().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginProvider.initialize()),
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: NoticeProvider()),
        ChangeNotifierProvider.value(value: ChatMessageProvider()),
        ChangeNotifierProvider.value(value: CategoryProvider()),
        ChangeNotifierProvider.value(value: PlanProvider()),
        ChangeNotifierProvider.value(value: ApplyProvider()),
        ChangeNotifierProvider.value(value: ProblemProvider()),
        ChangeNotifierProvider.value(value: ReportProvider()),
        ChangeNotifierProvider.value(value: LostProvider()),
        ChangeNotifierProvider.value(value: LoanProvider()),
        ChangeNotifierProvider.value(value: RequestInterviewProvider()),
        ChangeNotifierProvider.value(value: RequestSquareProvider()),
        ChangeNotifierProvider.value(value: RequestFacilityProvider()),
        ChangeNotifierProvider.value(value: RequestCycleProvider()),
      ],
      child: MediaQuery.withNoTextScaling(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          locale: const Locale('ja'),
          title: 'ひろめWORK',
          theme: customTheme(),
          home: const SplashController(),
        ),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    switch (loginProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return const HomeScreen();
      default:
        return const LoginScreen();
    }
  }
}
