import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';

Future<String> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? deviceId;
  if (Platform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    deviceId = build.androidId; //UUID for Android
  } else if (Platform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    deviceId = data.identifierForVendor; //UUID for iOS
  }
  return deviceId ?? "unknown";
}

Future<XFile?> loadImage(ImageSource source) async {
  var imagePicker = ImagePicker();
  var image = await imagePicker.pickImage(source: source);
  return image;
}

Future<void> subscribeNotificationChannels(UserModel loggedUser) async {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  await fcm.subscribeToTopic("users");
  await fcm.subscribeToTopic(loggedUser.uid);
}

Future<void> unsubscribeNotificationChannels(UserModel user) async {
  var fcm = FirebaseMessaging.instance;

  await fcm.unsubscribeFromTopic("users");
  await fcm.unsubscribeFromTopic(user.uid);
}

// Future<dynamic> buildLimitDialog(BuildContext context, AppState app) {
//   final TextEditingController limitController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   return showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setState) {
//         return AlertDialog(
//           actionsAlignment: MainAxisAlignment.spaceEvenly,
//           title: const Text(
//             "Harcama Limiti Belirle",
//             textAlign: TextAlign.center,
//             style: PersonalTStyles.w600s20B,
//           ),
//           content: SizedBox(
//             height: 150,
//             child: isLoading
//                 ? Center(child: buildCircularProgress())
//                 : Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Bilgilendirilmek istediğiniz harcama limitini giriniz.",
//                           style: PersonalTStyles.w500s14B,
//                         ),
//                         const SizedBox(height: 20),
//                         buildTextField(
//                             validator: (v) => validatePrice(v),
//                             controller: limitController,
//                             text: "Limit"),
//                       ],
//                     ),
//                   ),
//           ),
//           actions: [
//             TextButton(
//                 style: greyTextButtonTheme,
//                 onPressed: () => navigatePop(context),
//                 child: const Text("İptal")),
//             TextButton(
//                 style: secondaryTextButtonTheme,
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     setState(() => isLoading = true);
//                     await app
//                         .setBudgetLimit(num.parse(limitController.text.trim()));
//                     setState(() => isLoading = false);
//                     Navigator.pop(
//                         context, num.parse(limitController.text.trim()));
//                   }
//                 },
//                 child: const Text("Limit Belirle"))
//           ],
//         );
//       },
//     ),
//   );
// }
