import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:intl/intl.dart';

class ChatRoom {
  final ChatRideInfo? ride;
  final ChatActorInfo? actor;
  final ChatContactInfo? contact;
  final bool chatEnabled;
  final List<ChatMessage> messages;

  ChatRoom({
    this.ride,
    this.actor,
    this.contact,
    this.chatEnabled = false,
    this.messages = const [],
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      ride: json['ride'] != null ? ChatRideInfo.fromJson(json['ride']) : null,
      actor:
          json['actor'] != null ? ChatActorInfo.fromJson(json['actor']) : null,
      contact: json['contact'] != null
          ? ChatContactInfo.fromJson(json['contact'])
          : null,
      chatEnabled: json['chat_enabled'] ?? false,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((i) => ChatMessage.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride': ride?.toJson(),
      'actor': actor?.toJson(),
      'contact': contact?.toJson(),
      'chat_enabled': chatEnabled,
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatRideInfo {
  final String id;
  final int status;
  final String statusLabel;

  ChatRideInfo({
    this.id = '',
    this.status = 0,
    this.statusLabel = '',
  });

  factory ChatRideInfo.fromJson(Map<String, dynamic> json) {
    return ChatRideInfo(
      id: json['id']?.toString() ?? '',
      status: json['status'] ?? 0,
      statusLabel: json['status_label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'status_label': statusLabel,
    };
  }
}

class ChatActorInfo {
  final String id;
  final int type;
  final String typeLabel;

  ChatActorInfo({
    this.id = '',
    this.type = 0,
    this.typeLabel = '',
  });

  factory ChatActorInfo.fromJson(Map<String, dynamic> json) {
    return ChatActorInfo(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 0,
      typeLabel: json['type_label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'type_label': typeLabel,
    };
  }
}

class ChatContactInfo {
  final String id;
  final String name;
  final String phone;

  ChatContactInfo({
    this.id = '',
    this.name = '',
    this.phone = '',
  });

  factory ChatContactInfo.fromJson(Map<String, dynamic> json) {
    return ChatContactInfo(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class ChatMessage {
  final String id;
  final String rideId;
  final String senderId;
  final int senderType;
  final String senderTypeLabel;
  final String senderName;
  final String content;
  final int status;
  final String statusLabel;
  final DateTime? createdAt;

  ChatMessage({
    this.id = '',
    this.rideId = '',
    this.senderId = '',
    this.senderType = 0,
    this.senderTypeLabel = '',
    this.senderName = '',
    this.content = '',
    this.status = 0,
    this.statusLabel = '',
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      rideId: json['ride_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderType: json['sender_type'] ?? 0,
      senderTypeLabel: json['sender_type_label'] ?? '',
      senderName: json['sender_name'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 0,
      statusLabel: json['status_label'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'sender_id': senderId,
      'sender_type': senderType,
      'sender_type_label': senderTypeLabel,
      'sender_name': senderName,
      'content': content,
      'status': status,
      'status_label': statusLabel,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Future<bool> get isMe async {
  //   final user = await SharePreferenceUtil.getUser();
  //   final userId = (user?.id ?? "0").toString();
  //   return senderId == userId;
  // }
  bool isMe(String currentUserId) {
    return senderId == currentUserId;
  }

  String get time => DateFormat('HH:mm').format(createdAt ?? DateTime.now());
}
