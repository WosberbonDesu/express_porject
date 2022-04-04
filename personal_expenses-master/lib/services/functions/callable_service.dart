import 'package:cloud_functions/cloud_functions.dart';

import 'ICallableService.dart';

class CallableService extends ICallableService {
  final FirebaseFunctions functions;

  CallableService(this.functions);

  @override
  Future addTransaction(
      {required num price, required int type, required DateTime date}) async {
    try {
      HttpsCallable addTransaction =
          functions.httpsCallable(("addTransaction"));
      var now = DateTime.now();
      var returnValue = await addTransaction.call(<String, dynamic>{
        "isSameMonth": ((now.month == date.month) && (now.year == date.year)),
        "price": price,
        "type": type,
        "date": date.millisecondsSinceEpoch
      });

      return returnValue;
    } catch (e) {
      return "Bir hata oluştu.";
    }
  }
}
