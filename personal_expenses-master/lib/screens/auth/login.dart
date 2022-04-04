import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../components/main_components.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../models/user_model.dart';
import '../../providers/appstate.dart';
import 'forgot_password.dart';
import 'signup.dart';
import '../tabs/main_tab.dart';
import '../../utilities/routes.dart';
import '../../utilities/snackbar.dart';
import '../../utilities/validators.dart';
import '../../widgets/auth/page_templ.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController mailCtr = TextEditingController();
  final TextEditingController passCtr = TextEditingController();
  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
      page: buildLoginPage(context),
    );
  }

  buildLoginPage(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, child) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Giriş Yap",
              style: PersonalTStyles.w700s24B,
            ),
            const SizedBox(height: 24),
            buildTextField(
                validator: (v) => validateMail(v),
                controller: mailCtr,
                text: "E-Posta"),
            const SizedBox(height: 20),
            buildTextField(
                validator: (v) => validatePassword(v),
                isObscure: true,
                controller: passCtr,
                text: "Şifre"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => navigateToPage(context, const ForgotPassword()),
              child: const Text(
                "Şifremi Unuttum",
                textAlign: TextAlign.end,
                style: PersonalTStyles.w600s14Or,
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? buildCircularProgress()
                : TextButton(
                    onPressed: () async => await login(app, context),
                    child: const Text("Giriş Yap"),
                  ),
            const SizedBox(height: 100),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Hesabınız yok mu? ",
                style: PersonalTStyles.w400s14G2,
                children: [
                  TextSpan(
                      text: "Kayıt Ol",
                      style: PersonalTStyles.w600s14Or,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => navigateToPage(context, const Signup()))
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> login(AppState app, BuildContext context) async {
    changeLoading();
    if (formKey.currentState!.validate()) {
      var returnType = await app.authService.login(
        mailCtr.text.trim(),
        passCtr.text.trim(),
      );
      if (returnType is UserModel) {
        await app.setUser(returnType);
        if (mounted) {
          navigatePushAndRemove(context, TabsScreen(userID: returnType.uid));
        }
      } else {
        await showSnackBar(context, returnType,
            backgroundColor: PersonalColors.red);
      }
    }
    changeLoading();
  }
}
