// ignore_for_file: file_names

import 'package:image_picker/image_picker.dart';
import 'package:personal_expenses/models/user_model.dart';

abstract class IAuthService {
  Future<dynamic> login(String mail, String password);
  Future<dynamic> signUp(
      String mail, String password, UserModel user, XFile? image);
  Future<dynamic> forgotPassword(String mail);
  Future<dynamic> signOut(String uid, UserModel user);
  Future<dynamic> updateName(String name);
  Future<dynamic> updatePhoneNumber(String phoneNumber);
  Future<dynamic> updatePassword(
      String newPassword, String oldPassword, String email);
}
