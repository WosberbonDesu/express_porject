import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../components/main_components.dart';
import '../../components/notification_cmp.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../models/notification_model.dart';
import '../../providers/appstate.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  dynamic notifications;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  initialize() async {
    changeLoading();
    var app = Provider.of<AppState>(context, listen: false);

    notifications = await app.appService.fetchUserNotification(app.user!.uid);

    if (notifications is List<NotificationModel>) {
      (notifications as List<NotificationModel>)
          .sort((b, a) => a.notificationTime.compareTo(b.notificationTime));
    }

    changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, app, child) => isLoading
            ? SizedBox(height: app.queryHeight, child: buildCircularProgress())
            : (notifications is String)
                ? buildErrorMessage(notifications, app.queryHeight)
                : (notifications as List<NotificationModel>).isEmpty
                    ? buildErrorMessage(
                        "Henüz bir bildiriminiz bulunmuyor.", app.queryHeight)
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                            left: 20, top: 50, right: 20, bottom: 0),
                        shrinkWrap: true,
                        itemCount:
                            (notifications as List<NotificationModel>).length,
                        separatorBuilder: (_, __) => const SizedBox(height: 28),
                        itemBuilder: (BuildContext context, int i) {
                          var notification =
                              (notifications as List<NotificationModel>)[i];

                          return Dismissible(
                            key: Key(notification.messageID),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              var returnBool = await showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text("Uyarı"),
                                  content: const Text("""
Bu bildirimi silmek istediğinizden emin misiniz?"""),
                                  actions: [
                                    RawMaterialButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Evet"),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Hayır"),
                                    ),
                                  ],
                                ),
                              );
                              if (returnBool) {
                                var returnTypeFromService = await app.appService
                                    .deleteSingleNotification(
                                        notification.messageID.toString());
                                if (returnTypeFromService) {
                                  (notifications as List<NotificationModel>)
                                      .removeWhere((element) =>
                                          element.messageID ==
                                          notification.messageID);
                                }
                                setState(() {});
                              }
                            },
                            background: slideLeftBackground(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.network(
                                      notification.iconUrl,
                                      placeholderBuilder: (context) =>
                                          buildCircularProgress(),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.message,
                                            overflow: TextOverflow.fade,
                                            style: PersonalTStyles.w600s15B,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            DateFormat("dd/MM/yyyy - kk:mm")
                                                .format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                notification.notificationTime,
                                              ),
                                            ),
                                            style: PersonalTStyles.w400s14TG,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: PersonalColors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Bildirimi Sil",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
