import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/styles/colors.dart';
import '../models/complaint_model.dart';
import '../providers/appstate.dart';
import '../utilities/routes.dart';
import '../utilities/snackbar.dart';
import '../utilities/validators.dart';

RawMaterialButton buildDialogActionButton(
    {required VoidCallback onPressed, required String title}) {
  return RawMaterialButton(
    child: Text(
      title,
      style: const TextStyle(fontSize: 15, color: PersonalColors.blue),
    ),
    onPressed: onPressed,
  );
}

GestureDetector profileRowButtons(
    {required BuildContext context,
    required String label,
    required VoidCallback route,
    String? optionalData}) {
  return GestureDetector(
    onTap: route,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1),
        Row(
          children: [
            const SizedBox(height: 54),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(label),
              ),
            ),
            if (optionalData != null) Text(optionalData),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    ),
  );
}

dynamic suggestionPage(
    {required BuildContext context,
    required String label,
    required AppState app,
    String? optionalData}) {
  final TextEditingController complaintCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> sendComplaint(AppState app, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var complaint = Complaint(
        complaint: complaintCtr.text.trim(),
        complaintDate: Timestamp.fromDate(DateTime.now()),
        userName: app.user!.name,
        userId: app.user!.uid,
      );
      var returnType = await app.appService.sendComplaint(complaint);
      if (returnType == null) {
        await showSnackBar(
          context,
          """
Şikayetiniz iletildi. Geri bildiriminiz için teşekkür ederiz.""",
        );
      } else {
        await showSnackBar(context, returnType,
            backgroundColor: PersonalColors.red);
      }

      navigatePop(context);
    }
  }

  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("İstek, Şikayet ve Talep Formu\n "),
      content: Form(
        key: _formKey,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            validator: (v) => validateEmptiness(v),
            controller: complaintCtr,
            maxLines: 4,
            minLines: 2,
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("Gönder"),
          onPressed: () async => await sendComplaint(app, context),
        ),
        CupertinoDialogAction(
          child: const Text("İptal"),
          onPressed: () => navigatePop(context),
        ),
      ],
    ),
  );
}
