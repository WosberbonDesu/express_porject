import 'dart:convert';

class TransactionModel {
  String iconUrl;
  String title;
  int date;
  bool isExpense;
  num price;
  int type;
  TransactionModel({
    required this.iconUrl,
    required this.title,
    required this.date,
    required this.isExpense,
    required this.price,
    required this.type,
  });

  TransactionModel copyWith({
    String? iconUrl,
    String? title,
    int? date,
    bool? isExpense,
    num? price,
    int? type,
  }) {
    return TransactionModel(
      iconUrl: iconUrl ?? this.iconUrl,
      title: title ?? this.title,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
      price: price ?? this.price,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconUrl': iconUrl,
      'title': title,
      'date': date,
      'isExpense': isExpense,
      'price': price,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      iconUrl: map['iconUrl'] ?? '',
      title: map['title'] ?? '',
      date: map['date']?.toInt() ?? 0,
      isExpense: map['isExpense'] ?? false,
      price: map['price'] ?? 0,
      type: map['type']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionModel(iconUrl: $iconUrl, title: $title, date: $date, isExpense: $isExpense, price: $price, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.iconUrl == iconUrl &&
        other.title == title &&
        other.date == date &&
        other.isExpense == isExpense &&
        other.price == price &&
        other.type == type;
  }

  @override
  int get hashCode {
    return iconUrl.hashCode ^
        title.hashCode ^
        date.hashCode ^
        isExpense.hashCode ^
        price.hashCode ^
        type.hashCode;
  }
}
