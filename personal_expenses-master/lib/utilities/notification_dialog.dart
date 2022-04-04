import 'package:flutter/material.dart';
import 'routes.dart';

showNotificationDialog(
    BuildContext context, Map<String, dynamic> notificationContent) {
  return showDialog(
    context: context,
    builder: (context) => NotificationDialog(
      notificationContent: notificationContent,
    ),
  );
}

class NotificationDialog extends StatelessWidget {
  final Map<String, dynamic> notificationContent;

  const NotificationDialog({Key? key, required this.notificationContent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "E-Cüzdan",
            textAlign: TextAlign.center,
            // style: EdupubsTextStyles.w500s18TB,
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
            padding: const EdgeInsets.all(12.5),
            child: Text(
              notificationContent["body"],
              textAlign: TextAlign.center,
              // style: EdupubsTextStyles.w400s15B,
            )),
      ),
      actionsPadding: const EdgeInsets.only(right: 10),
      actions: [
        RawMaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onPressed: () => navigatePop(context),
            child: const Text(
              "Tamam",
              // style: EdupubsTextStyles.w400s14MC,
            )),
      ],
    );
  }
}
