import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/enums/db_enums.dart';
import '../../models/user_model.dart';
import 'IAuthService.dart';
import '../../utilities/helpers.dart';

class AuthService extends IAuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firebase;

  AuthService(this.auth, this.firebase);

  @override
  Future forgotPassword(String mail) async {
    try {
      await auth.sendPasswordResetEmail(email: mail);
      return null;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future login(String mail, String password) async {
    try {
      var user = await auth.signInWithEmailAndPassword(
        email: mail.trim(),
        password: password.trim(),
      );
      if (user.user != null) {
        try {
          var loggedUsr = await firebase
              .collection(DatabaseEnums.users.rawValue)
              .doc(user.user!.uid)
              .get();
          var loggedUser = UserModel.fromMap(loggedUsr.data()!);
          var deviceID = await getDeviceInfo();
          if (!(loggedUser.deviceList.contains(deviceID))) {
            await subscribeNotificationChannels(loggedUser);
            await firebase
                .collection(DatabaseEnums.users.rawValue)
                .doc(user.user!.uid)
                .update({
              "deviceList": FieldValue.arrayUnion(
                [deviceID],
              )
            });
            loggedUser.deviceList.add(deviceID);
          }
          return loggedUser;
        } on Exception catch (_) {
          return "Bir hata oluştu.";
        }
      } else {
        return "Kullanıcı bulunamadı.";
      }
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future signOut(String uid, UserModel user) async {
    try {
      var deviceID = await getDeviceInfo();
      if (user.deviceList.contains(deviceID)) {
        await unsubscribeNotificationChannels(user);
        var loggedUserDoc =
            firebase.collection(DatabaseEnums.users.rawValue).doc(user.uid);

        loggedUserDoc.update({
          "deviceList": FieldValue.arrayRemove(
            [deviceID],
          )
        });
      }

      await auth.signOut();
      return null;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future signUp(
    String mail,
    String password,
    UserModel user,
    XFile? image,
  ) async {
    try {
      var deviceID = await getDeviceInfo();
      var createdUser = await auth.createUserWithEmailAndPassword(
          email: mail, password: password);
      user.uid = createdUser.user!.uid;
      if (image != null) {
        Reference ref =
            FirebaseStorage.instance.ref().child("userImages/${user.uid}/");

        Uint8List byteData = await image.readAsBytes();

        Reference refImage = ref.child(user.uid + ".jpg");
        TaskSnapshot uploadTask = await refImage.putData(byteData);
        var imageURL = await uploadTask.ref.getDownloadURL();
        user.imageURL = imageURL;
      }

      user.deviceList = [deviceID];
      await subscribeNotificationChannels(user);
      await firebase
          .collection(DatabaseEnums.users.rawValue)
          .doc(user.uid)
          .set(user.toMap());
      return user;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future updateName(String name) async {
    try {
      var usrDoc = firebase
          .collection(DatabaseEnums.users.rawValue)
          .doc(auth.currentUser!.uid);
      await usrDoc.update({"name": name});
      return null;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future updatePhoneNumber(String phoneNumber) async {
    try {
      var usrDoc = firebase
          .collection(DatabaseEnums.users.rawValue)
          .doc(auth.currentUser!.uid);
      await usrDoc.update({"phoneNumber": num.parse(phoneNumber)});
      return null;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future updatePassword(
      String newPassword, String oldPassword, String email) async {
    try {
      await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: oldPassword));
      await auth.currentUser!.updatePassword(newPassword);
      return null;
    } catch (e) {
      return "Lütfen bilgilerinizi kontrol ediniz.";
    }
  }
}
