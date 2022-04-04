import '../../components/profile_cmp.dart';
import '../styles/text_styles.dart';
import '../../providers/appstate.dart';
import '../../utilities/routes.dart';
import '../../utilities/validators.dart';

import '../../components/main_components.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogEnum { name, phone, password, limit }

extension DialogEnumExt on DialogEnum {
  Future<dynamic> dialogMethod(
      {required BuildContext context, required AppState app}) {
    switch (this) {
      case DialogEnum.name:
        return showCupDioName(context, app);
      case DialogEnum.phone:
        return showCupDioPhone(context, app);
      case DialogEnum.limit:
        return showCupDioLimit(context, app);
      case DialogEnum.password:
        return showCupDioPassword(context, app);
    }
  }
}

Future<dynamic> showCupDioName(BuildContext context, AppState app) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtr = TextEditingController();
  bool isLoading = false;
  return showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => CupertinoAlertDialog(
              title: const Text("Ad Soyad Güncelleme\n "),
              content: Form(
                key: _formKey,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: buildTextField(
                      validator: (v) => validateEmptiness(v),
                      controller: nameCtr,
                      text: "Ad Soyad"),
                ),
              ),
              actions: isLoading
                  ? loadingIndicatorForUpdate
                  : [
                      buildDialogActionButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = !isLoading);
                              await app.updateName(
                                  newName: nameCtr.text.trim(),
                                  context: context);
                              setState(() => isLoading = !isLoading);
                              navigatePop(context);
                            }
                          },
                          title: "Güncelle"),
                      buildDialogActionButton(
                        title: "İptal",
                        onPressed: () {
                          navigatePop(context);
                        },
                      ),
                    ],
            ),
          ));
}

Future<dynamic> showCupDioPhone(BuildContext context, AppState app) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneCtr = TextEditingController();
  bool isLoading = false;
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => CupertinoAlertDialog(
              title: const Text("Telefon Numarası Güncelleme\n "),
              content: Form(
                key: _formKey,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: buildTextField(
                      validator: (v) => validateMobile(v),
                      controller: phoneCtr,
                      text: "Telefon Numarası"),
                ),
              ),
              actions: isLoading
                  ? loadingIndicatorForUpdate
                  : [
                      buildDialogActionButton(
                        title: "Güncelle",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = !isLoading);
                            await app.updatePhoneNumber(
                                newPhone: phoneCtr.text.trim(),
                                context: context);
                            setState(() => isLoading = !isLoading);
                            navigatePop(context);
                          }
                        },
                      ),
                      buildDialogActionButton(
                        title: "İptal",
                        onPressed: () {
                          navigatePop(context);
                        },
                      ),
                    ],
            ),
          ));
}

Future<dynamic> showCupDioPassword(BuildContext context, AppState app) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordCtr = TextEditingController();
  final TextEditingController oldpasswordCtr = TextEditingController();
  final TextEditingController passwordAgainCtr = TextEditingController();
  bool isLoading = false;
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
        title: const Text("Şifre Güncelleme\n "),
        content: Form(
          key: _formKey,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                buildTextField(
                    isObscure: true,
                    validator: (v) => validatePassword(v),
                    controller: oldpasswordCtr,
                    text: "Eski Şifre"),
                const SizedBox(
                  height: 10,
                ),
                buildTextField(
                    isObscure: true,
                    validator: (v) => validatePassword(v),
                    controller: passwordCtr,
                    text: "Yeni Şifre"),
                const SizedBox(
                  height: 10,
                ),
                buildTextField(
                    isObscure: true,
                    validator: (v) => validatePassCheck(v, passwordCtr),
                    controller: passwordAgainCtr,
                    text: "Yeni Şifre Tekrar"),
              ],
            ),
          ),
        ),
        actions: isLoading
            ? loadingIndicatorForUpdate
            : [
                buildDialogActionButton(
                  title: "Güncelle",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = !isLoading);
                      await app.updatePassword(
                          newPassword: passwordCtr.text.trim(),
                          oldPassword: oldpasswordCtr.text.trim(),
                          context: context);
                      setState(() => isLoading = !isLoading);
                      navigatePop(context);
                    }
                  },
                ),
                buildDialogActionButton(
                  title: "İptal",
                  onPressed: () {
                    navigatePop(context);
                  },
                ),
              ],
      ),
    ),
  );
}

Future<dynamic> showCupDioLimit(BuildContext context, AppState app) {
  final TextEditingController limitController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  if (app.user!.notifyBudget != 0) {
    limitController.text = app.user!.notifyBudget.toStringAsFixed(2);
  }
  bool isLoading = false;
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => CupertinoAlertDialog(
              title: const Text("Harcama Limiti\n "),
              content: Form(
                key: _formKey,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bilgilendirilmek istediğiniz harcama limitini giriniz.",
                          textAlign: TextAlign.center,
                          style: PersonalTStyles.w500s14B,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                            validator: (v) => validatePrice(v),
                            controller: limitController,
                            text: "Limit"),
                      ],
                    ),
                  ),
                ),
              ),
              actions: isLoading
                  ? loadingIndicatorForUpdate
                  : [
                      buildDialogActionButton(
                          title: "Güncelle",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              await app.setBudgetLimit(
                                  num.parse(limitController.text.trim()));
                              setState(() => isLoading = false);
                              Navigator.pop(context,
                                  num.parse(limitController.text.trim()));
                            }
                          }),
                      buildDialogActionButton(
                        title: "İptal",
                        onPressed: () {
                          navigatePop(context);
                        },
                      ),
                    ],
            ),
          ));
}

List<Widget> get loadingIndicatorForUpdate => [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildCircularProgress(),
      )
    ];
