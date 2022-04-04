import 'package:flutter/material.dart';
import '../../components/main_components.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../constants/styles/themes.dart';
import '../../providers/appstate.dart';
import '../../utilities/routes.dart';
import '../../utilities/snackbar.dart';
import '../../utilities/validators.dart';
import '../../widgets/auth/page_templ.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController mailCtr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
        page: Consumer<AppState>(
      builder: (context, app, child) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Şifremi Unutttum",
              style: PersonalTStyles.w700s24B,
            ),
            const SizedBox(height: 24),
            const Text(
              "Şifre değişim linki için e-posta adresinizi giriniz.",
            ),
            const SizedBox(height: 40),
            buildTextField(
                validator: (v) => validateMail(v),
                controller: mailCtr,
                text: "E-Posta"),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () async => await sendEmail(app, context),
              child: const Text("E-Posta Gönder"),
            ),
            const SizedBox(height: 100),
            TextButton(
                style: secondaryTextButtonTheme,
                onPressed: () => navigatePop(context),
                child: const Text("Geri Dön")),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  Future<void> sendEmail(AppState app, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var returnType =
          await app.authService.forgotPassword(mailCtr.text.trim());
      if (returnType == null) {
        await showSnackBar(context, "E-Posta gönderildi.");
        navigatePop(context);
      } else {
        await showSnackBar(context, returnType,
            backgroundColor: PersonalColors.red);
      }
    }
  }
}
