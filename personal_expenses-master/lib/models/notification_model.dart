import 'dart:convert';

class NotificationModel {
  String userID;
  String message;
  int notificationTime;
  String iconUrl;
  String messageID;
  NotificationModel({
    required this.userID,
    required this.message,
    required this.notificationTime,
    required this.iconUrl,
    required this.messageID,
  });

  NotificationModel copyWith({
    String? userID,
    String? message,
    int? notificationTime,
    String? iconUrl,
    String? messageID,
  }) {
    return NotificationModel(
      userID: userID ?? this.userID,
      message: message ?? this.message,
      notificationTime: notificationTime ?? this.notificationTime,
      iconUrl: iconUrl ?? this.iconUrl,
      messageID: messageID ?? this.messageID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'message': message,
      'notificationTime': notificationTime,
      'iconUrl': iconUrl,
      'messageID': messageID,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      userID: map['userID'] ?? '',
      message: map['message'] ?? '',
      notificationTime: map['notificationTime']?.toInt() ?? 0,
      iconUrl: map['iconUrl'] ?? '',
      messageID: map['messageID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(userID: $userID, message: $message, notificationTime: $notificationTime, iconUrl: $iconUrl, messageID: $messageID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.userID == userID &&
        other.message == message &&
        other.notificationTime == notificationTime &&
        other.iconUrl == iconUrl &&
        other.messageID == messageID;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        message.hashCode ^
        notificationTime.hashCode ^
        iconUrl.hashCode ^
        messageID.hashCode;
  }
}
