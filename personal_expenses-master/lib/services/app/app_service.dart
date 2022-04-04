import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/enums/db_enums.dart';
import '../../models/category_model.dart';
import '../../models/complaint_model.dart';
import '../../models/notification_model.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import 'IAppService.dart';

class AppService extends IAppService {
  final FirebaseFirestore firestore;

  AppService(this.firestore);

  @override
  Future getUser(String uid) async {
    try {
      var user = await firestore
          .collection(DatabaseEnums.users.rawValue)
          .doc(uid)
          .get();
      if (user.exists) {
        var usr = UserModel.fromMap(user.data()!);
        return usr;
      } else {
        return "Kullanıcı bulunamadı.";
      }
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future getCategories() async {
    try {
      List<CategoryModel> categories = [];
      var categoriesDocs =
          await firestore.collection(DatabaseEnums.categories.rawValue).get();
      for (var item in categoriesDocs.docs) {
        var categoryItem = CategoryModel.fromMap(item.data());
        categories.add(categoryItem);
      }
      return categories;
    } catch (e) {
      return "Bir hata oluştu. ${e.toString()}";
    }
  }

  @override
  Future getTransactions(String uid) async {
    try {
      List<TransactionModel> transactions = [];
      var transactionDocs = await firestore
          .collection(DatabaseEnums.users.rawValue)
          .doc(uid)
          .collection(DatabaseEnums.transactions.rawValue)
          .orderBy("date", descending: true)
          .get();
      if (transactionDocs.docs.isNotEmpty) {
        for (var item in transactionDocs.docs) {
          var transaction = TransactionModel.fromMap(item.data());
          transactions.add(transaction);
        }
      }
      return transactions;
    } catch (e) {
      return "Bir hata oluştu. ${e.toString()}";
    }
  }

  @override
  Future getNotifications(String uid) async {
    try {
      List<NotificationModel> notifications = [];
      var notificationDocs = await firestore
          .collection(DatabaseEnums.notifications.rawValue)
          .where("userID", isEqualTo: uid)
          .get();

      if (notificationDocs.docs.isNotEmpty) {
        for (var item in notificationDocs.docs) {
          var notificaiton = NotificationModel.fromMap(item.data());
          notifications.add(notificaiton);
        }
        notifications
            .sort((a, b) => a.notificationTime.compareTo(b.notificationTime));
      }
      return notifications;
    } catch (e) {
      return "Bir hata oluştu. ${e.toString()}";
    }
  }

  @override
  Future setBudgetLimit(String uid, num limit) async {
    try {
      await firestore
          .collection(DatabaseEnums.users.rawValue)
          .doc(uid)
          .update({"notifyBudget": limit});
      return null;
    } catch (e) {
      return "Bir hata oluştu. ${e.toString()}";
    }
  }

  @override
  Future fetchUserNotification(String userID) async {
    try {
      List<NotificationModel> notifications = [];

      var notifcationRef = await firestore
          .collection(DatabaseEnums.notifications.rawValue)
          .where("userID", isEqualTo: userID)
          .get();
      for (var item in notifcationRef.docs) {
        var notification = NotificationModel.fromMap(item.data());
        notifications.add(notification);
      }
      return notifications;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future deleteSingleNotification(String messageID) async {
    try {
      await firestore
          .collection(DatabaseEnums.notifications.rawValue)
          .doc(messageID)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future addUserImage(UserModel user, XFile image) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      var storageRef = storage.ref().child("userImages/${user.uid}");
      if (user.imageURL != null) {
        await storage
            .ref()
            .child("userImages/${user.uid}/${user.uid}.jpg")
            .delete();
      }
      Uint8List byteData = await image.readAsBytes();

      Reference refImage = storageRef.child(user.uid + ".jpg");
      TaskSnapshot uploadTask = await refImage.putData(byteData);
      var imageURL = await uploadTask.ref.getDownloadURL();

      await firestore
          .collection(DatabaseEnums.users.rawValue)
          .doc(user.uid)
          .update({"imageURL": imageURL});
      return imageURL;
    } catch (e) {
      return null;
    }
  }

  @override
  Future removeUserImage(String userId) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      await storage.ref().child("userImages/$userId/$userId.jpg").delete();
      await firestore
          .collection(DatabaseEnums.users.rawValue)
          .doc(userId)
          .update({"imageURL": null});
      return null;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }

  @override
  Future sendComplaint(Complaint complaint) async {
    try {
      await firestore
          .collection(DatabaseEnums.complaints.rawValue)
          .add(complaint.toMap());
      return null;
    } catch (e) {
      return "Bir hata oluştu";
    }
  }
}
