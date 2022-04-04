import 'dart:convert';

class CategoryModel {
  String iconURl;
  String title;
  int type;
  bool isExpense;
  CategoryModel({
    required this.iconURl,
    required this.title,
    required this.type,
    required this.isExpense,
  });

  CategoryModel copyWith({
    String? iconURl,
    String? title,
    int? type,
    bool? isExpense,
  }) {
    return CategoryModel(
      iconURl: iconURl ?? this.iconURl,
      title: title ?? this.title,
      type: type ?? this.type,
      isExpense: isExpense ?? this.isExpense,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconURl': iconURl,
      'title': title,
      'type': type,
      'isExpense': isExpense,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      iconURl: map['iconURl'] ?? '',
      title: map['title'] ?? '',
      type: map['type']?.toInt() ?? 0,
      isExpense: map['isExpense'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(iconURl: $iconURl, title: $title, type: $type, isExpense: $isExpense)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.iconURl == iconURl &&
        other.title == title &&
        other.type == type &&
        other.isExpense == isExpense;
  }

  @override
  int get hashCode {
    return iconURl.hashCode ^
        title.hashCode ^
        type.hashCode ^
        isExpense.hashCode;
  }
}
