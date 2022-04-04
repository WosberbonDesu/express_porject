import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/main_components.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../models/user_model.dart';
import '../../providers/appstate.dart';
import '../tabs/main_tab.dart';
import '../../utilities/helpers.dart';
import '../../utilities/routes.dart';
import '../../utilities/snackbar.dart';
import '../../utilities/validators.dart';
import '../../widgets/auth/page_templ.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController mailCtr = TextEditingController();
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController phoneCtr = TextEditingController();
  final TextEditingController passCtr = TextEditingController();
  final TextEditingController passAgainCtr = TextEditingController();
  XFile? image;

  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
        profilePicWidget: SizedBox(
            height: 120,
            width: 120,
            child: GestureDetector(
              onTap: () async => await profilePicture(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: PersonalColors.blue, width: 3),
                  color: PersonalColors.blue,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        FeatherIcons.users,
                        color: Colors.white,
                      ),
              ),
            )),
        page: Consumer<AppState>(
          builder: (context, app, child) => Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Kayıt Ol",
                  style: PersonalTStyles.w700s24B,
                ),
                const SizedBox(height: 24),
                buildTextField(
                    validator: (v) => validateEmptiness(v),
                    controller: nameCtr,
                    text: "İsim Soyisim"),
                const SizedBox(height: 20),
                buildTextField(
                    validator: (v) => validateMobile(v),
                    controller: phoneCtr,
                    text: "Telefon Numarası",
                    isPhoneNumber: true),
                const SizedBox(height: 20),
                buildTextField(
                    validator: (v) => validateMail(v),
                    controller: mailCtr,
                    text: "E-Posta"),
                const SizedBox(height: 20),
                buildTextField(
                    validator: (v) => validatePassword(v),
                    controller: passCtr,
                    isObscure: true,
                    text: "Şifre"),
                const SizedBox(height: 20),
                buildTextField(
                    validator: (v) => validatePassCheck(v, passCtr),
                    isObscure: true,
                    controller: passAgainCtr,
                    text: "Tekrar Şifre"),
                const SizedBox(height: 24),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () async => await signup(app, context),
                        child: const Text("Kayıt Ol"),
                      ),
                const SizedBox(height: 100),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Zaten bir hesabınız var mı? ",
                    style: PersonalTStyles.w400s14G2,
                    children: [
                      TextSpan(
                        text: "Giriş Yap",
                        style: PersonalTStyles.w600s14Or,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => navigatePop(context),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  profilePicture(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () async {
                      image = await loadImage(ImageSource.gallery);
                      setState(() {});
                      navigatePop(context);
                    },
                    child: const Text("Galeriden Ekle")),
                const Divider(),
                GestureDetector(
                    onTap: () async {
                      image = await loadImage(ImageSource.camera);
                      setState(() {});
                      navigatePop(context);
                    },
                    child: const Text("Fotoğraf Çek")),
                const Divider(),
                if (image != null)
                  GestureDetector(
                      onTap: () {
                        setState(() => image = null);
                        navigatePop(context);
                      },
                      child: const Text("Fotoğrafı Sil")),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> signup(AppState app, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      changeLoading();
      var returnType = await app.authService.signUp(
          mailCtr.text.trim(),
          passCtr.text.trim(),
          UserModel(
            monthlyIncome: 0,
            monthlyOutcome: 0,
            uid: "",
            phoneNumber: num.parse(phoneCtr.text.trim()),
            email: mailCtr.text.trim(),
            name: nameCtr.text.trim(),
            createdAt: Timestamp.fromDate(DateTime.now()),
            lastLogin: Timestamp.fromDate(DateTime.now()),
            deviceList: [],
            notifyBudget: 0,
            currentBudget: 0,
          ),
          image);

      if (returnType is UserModel) {
        await app.setUser(returnType);
        navigatePushAndRemove(context, TabsScreen(userID: returnType.uid));
      } else {
        await showSnackBar(context, returnType,
            backgroundColor: PersonalColors.red);
      }
      changeLoading();
    }
  }
}
