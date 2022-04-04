// ignore_for_file: file_names

abstract class ICallableService {
  Future addTransaction(
      {required num price, required int type, required DateTime date});
}
