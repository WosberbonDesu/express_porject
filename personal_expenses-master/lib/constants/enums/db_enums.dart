enum DatabaseEnums {
  users,
  transactions,
  categories,
  notifications,
  complaints,
}

extension DatabaseEnumsExt on DatabaseEnums {
  String get rawValue {
    switch (this) {
      case DatabaseEnums.users:
        return "users";
      case DatabaseEnums.transactions:
        return "transactions";
      case DatabaseEnums.categories:
        return "categories";
      case DatabaseEnums.notifications:
        return "notifications";
      case DatabaseEnums.complaints:
        return "complaints";
    }
  }
}
