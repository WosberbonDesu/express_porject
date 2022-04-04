enum SortEnums { all, thisWeek, thisMonth, lastThreeMonths, thisYear }

extension SortExtension on SortEnums {
  String get rawValue {
    switch (this) {
      case SortEnums.all:
        return "Hepsi";
      case SortEnums.thisWeek:
        return "Bu Hafta";
      case SortEnums.thisMonth:
        return "Bu Ay";
      case SortEnums.lastThreeMonths:
        return "Son 3 Ay";
      case SortEnums.thisYear:
        return "Bu Yıl";
    }
  }
}
