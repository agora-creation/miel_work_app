import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/home.dart';
import 'package:miel_work_app/widgets/animation_background.dart';
import 'package:miel_work_app/widgets/custom_button_lg.dart';
import 'package:miel_work_app/widgets/custom_login_card.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            const AnimationBackground(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Text(
                      'ひろめWORK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                Text(
                                  'スタッフログイン',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SourceHanSansJP-Bold',
                                  ),
                                ),
                                Text('管理者からメールアドレスとパスワードを貰い、ログインしてください。'),
                              ],
                            ),
                          ),
                          CustomLoginCard(
                            children: [
                              CustomTextFormField(
                                controller: emailController,
                                textInputType: TextInputType.emailAddress,
                                maxLines: 1,
                                label: 'メールアドレス',
                                color: kBlackColor,
                                prefix: Icons.email,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                controller: passwordController,
                                obscureText: true,
                                textInputType: TextInputType.visiblePassword,
                                maxLines: 1,
                                label: 'パスワード',
                                color: kBlackColor,
                                prefix: Icons.password,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButtonLg(
                                  label: 'ログイン',
                                  labelColor: kWhiteColor,
                                  backgroundColor: kBlueColor,
                                  onPressed: () async {
                                    String? error = await loginProvider.login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    if (error != null) {
                                      if (!mounted) return;
                                      showMessage(context, error, false);
                                      return;
                                    }
                                    if (!mounted) return;
                                    showMessage(context, 'ログインに成功しました', true);
                                    pushReplacementScreen(
                                      context,
                                      const HomeScreen(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
