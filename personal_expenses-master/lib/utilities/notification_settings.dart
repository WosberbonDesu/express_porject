import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums/db_enums.dart';
import '../models/user_model.dart';
import 'helpers.dart';

updateUserForLastLogin(String userID) async {
  var lastLogin = Timestamp.fromDate(DateTime.now());

  var loggedUserDoc = FirebaseFirestore.instance
      .collection(DatabaseEnums.users.rawValue)
      .doc(userID);
  await loggedUserDoc.update({"lastLogin": lastLogin});
  var loggedUser = await loggedUserDoc.get();
  var user = UserModel.fromMap(loggedUser.data()!);
  dynamic deviceID;
  deviceID = await getDeviceInfo();
  if (!(user.deviceList.contains(deviceID))) {
    await subscribeNotificationChannels(user);
  }

  loggedUserDoc.update({
    "deviceList": FieldValue.arrayUnion(
      [deviceID],
    )
  });
  user.deviceList.add(deviceID);

  return !(user.deviceList.contains(deviceID))
      ? [lastLogin, deviceID]
      : [lastLogin];
}
