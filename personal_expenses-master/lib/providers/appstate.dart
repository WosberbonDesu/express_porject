import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/styles/colors.dart';
import '../models/category_model.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../screens/auth/login.dart';
import '../services/app/IAppService.dart';
import '../services/auth/IAuthService.dart';
import '../services/functions/ICallableService.dart';
import '../services/global_context.dart';
import '../utilities/notification_settings.dart';
import '../utilities/routes.dart';
import '../utilities/snackbar.dart';

class AppState with ChangeNotifier {
  final IAppService appService;
  final IAuthService authService;
  final ICallableService callableService;
  AppState({
    required this.appService,
    required this.authService,
    required this.callableService,
  }) {
    getCategories();
  }
  double queryWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;

  double queryHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.height;

  UserModel? user;
  List<CategoryModel>? categories;
  dynamic notifications;

  getCategories() async {
    var returnType = await appService.getCategories();
    if (returnType is List<CategoryModel>) {
      categories = returnType;
    }
    notifyListeners();
  }

  setUser(UserModel loggedUser) async {
    if (loggedUser == user) return;
    user = loggedUser;
    notifyListeners();
  }

  setBudgetLimit(num limit) async {
    try {
      var returnType = await appService.setBudgetLimit(user!.uid, limit);
      if (returnType == null) {
        user!.notifyBudget = limit;
        showSnackBar(
          NavigationService.navigatorKey.currentContext!,
          "Harcama limiti başarıyla güncellendi.",
        );
      } else {
        showSnackBar(
            NavigationService.navigatorKey.currentContext!, "Bir hata oluştu.",
            backgroundColor: PersonalColors.red);
      }
    } catch (e) {
      showSnackBar(
          NavigationService.navigatorKey.currentContext!, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }
    notifyListeners();
  }

  getTransactions() async {
    try {
      var returnType = await appService.getTransactions(user!.uid);
      if (returnType is List<TransactionModel>) {
        user!.transactions = returnType;
      }
    } catch (e) {
      showSnackBar(NavigationService.navigatorKey.currentContext!,
          "Harcamalar alınamadı.",
          backgroundColor: PersonalColors.red);
    }
    notifyListeners();
  }

  getNotifications() async {
    try {
      var returnType = await appService.getNotifications(user!.uid);
      notifications = returnType;
    } catch (e) {
      showSnackBar(NavigationService.navigatorKey.currentContext!,
          "Harcamalar alınamadı.",
          backgroundColor: PersonalColors.red);
    }
    notifyListeners();
  }

  addTransaction(num price, int type, DateTime date) async {
    try {
      var returnType = await callableService.addTransaction(
          price: price, type: type, date: date);
      if (returnType is! String) {
        returnType = returnType.data;
        if (returnType["message"] != null) {
          showSnackBar(
            NavigationService.navigatorKey.currentContext!,
            returnType["message"],
            backgroundColor: PersonalColors.red,
          );

          return;
        } else if (returnType["success"]) {
          var transaction = TransactionModel.fromMap(
              Map<String, dynamic>.from(returnType["transaction"]));
          user!.monthlyIncome = returnType["monthlyIncome"];
          user!.monthlyOutcome = returnType["monthlyOutcome"];
          if (transaction.isExpense) {
            user!.currentBudget -= transaction.price;
          } else {
            user!.currentBudget += transaction.price;
          }
          if (user!.transactions != null) {
            user!.transactions!.add(transaction);
          } else {
            user!.transactions = [transaction];
          }
        }
        showSnackBar(NavigationService.navigatorKey.currentContext!,
            "Başarıyla eklendi.");
      }
    } catch (e) {
      showSnackBar(
          NavigationService.navigatorKey.currentContext!, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);

      return;
    }

    notifyListeners();
  }

  updateUserLogin() async {
    var returnType = await updateUserForLastLogin(user!.uid);
    if (returnType.length == 2) {
      user!.lastLogin = returnType[0];
      user!.deviceList.add(returnType[1]);
    } else {
      user!.lastLogin = returnType[0];
    }
    notifyListeners();
  }

  addUserImage({
    required UserModel comuser,
    required XFile image,
    required BuildContext context,
  }) async {
    try {
      var returnType = await appService.addUserImage(comuser, image);
      if (returnType == null) {
        showSnackBar(context, "Bir hata oluştu.",
            backgroundColor: PersonalColors.red);
      } else {
        if (user != null) user!.imageURL = returnType;
        showSnackBar(context, "Profil fotoğrafınız başarıyla değiştirildi.");
      }
    } catch (e) {
      showSnackBar(context, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }

    notifyListeners();
  }

  removeUserImage({
    required String userID,
    required BuildContext context,
  }) async {
    try {
      var returnType = await appService.removeUserImage(userID);
      if (returnType != null) {
        showSnackBar(context, "Bir hata oluştu.",
            backgroundColor: PersonalColors.red);
      } else {
        if (user != null) user!.imageURL = null;
        showSnackBar(context, "Profil fotoğrafınız başarıyla kaldırıldı.");
      }
    } catch (e) {
      showSnackBar(context, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }

    notifyListeners();
  }

  signOut() async {
    try {
      var returnType = await authService.signOut(user!.uid, user!);

      if (returnType == null) {
        user = notifications = null;

        showSnackBar(NavigationService.navigatorKey.currentContext!,
            "Başarıyla Çıkış Yapıldı.");
        navigatePushAndRemove(
            NavigationService.navigatorKey.currentContext!, const Login());
        notifyListeners();
      } else {
        showSnackBar(NavigationService.navigatorKey.currentContext!, returnType,
            backgroundColor: PersonalColors.red);
      }
    } catch (e) {
      showSnackBar(
          NavigationService.navigatorKey.currentContext!, "Çıkış Yapılamadı.",
          backgroundColor: PersonalColors.red);
    }
  }

  updateName({
    required String newName,
    required BuildContext context,
  }) async {
    try {
      var returnType = await authService.updateName(newName);
      if (returnType != null) {
        showSnackBar(context, "Bir hata oluştu.",
            backgroundColor: PersonalColors.red);
      } else {
        if (user != null) user!.name = newName;
        showSnackBar(context, "Ad Soyad başarıyla güncellendi.");
      }
    } catch (e) {
      showSnackBar(context, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }
    notifyListeners();
  }

  updatePhoneNumber({
    required String newPhone,
    required BuildContext context,
  }) async {
    try {
      var returnType = await authService.updatePhoneNumber(newPhone);
      if (returnType != null) {
        showSnackBar(context, "Bir hata oluştu.",
            backgroundColor: PersonalColors.red);
      } else {
        if (user != null) user!.phoneNumber = num.parse(newPhone);
        showSnackBar(context, "Telefon numarası başarıyla güncellendi.");
      }
    } catch (e) {
      showSnackBar(context, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }
    notifyListeners();
  }

  updatePassword({
    required String newPassword,
    required String oldPassword,
    required BuildContext context,
  }) async {
    try {
      var returnType = await authService.updatePassword(
          newPassword, oldPassword, user!.email);
      if (returnType != null) {
        showSnackBar(context, "Lütfen bilgilerinizi kontrol ediniz.",
            backgroundColor: PersonalColors.red);
      } else {
        showSnackBar(context, "Şifre başarıyla güncellendi.");
      }
    } catch (e) {
      showSnackBar(context, "Bir hata oluştu.",
          backgroundColor: PersonalColors.red);
    }
  }
}
