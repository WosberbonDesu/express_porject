// ignore_for_file: file_names

import 'package:image_picker/image_picker.dart';
import 'package:personal_expenses/models/complaint_model.dart';
import 'package:personal_expenses/models/user_model.dart';

abstract class IAppService {
  Future getCategories();
  Future getUser(String uid);
  Future getTransactions(String uid);
  Future getNotifications(String uid);
  Future setBudgetLimit(String uid, num limit);
  Future deleteSingleNotification(String messageID);
  Future fetchUserNotification(String userID);
  Future removeUserImage(String userId);
  Future addUserImage(UserModel user, XFile image);
  Future sendComplaint(Complaint complaint);
}
