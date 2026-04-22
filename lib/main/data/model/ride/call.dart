class Call {
  final num? id;
  final String? rideId;
  final String? callerId;
  final String? calleeId;

  final int? callerType;
  final String? callerTypeLabel;

  final int? status;
  final String? statusLabel;

  final String? calleeName;
  final String? calleePhone;

  final String? failureReason;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Call({
    this.id,
    this.rideId,
    this.callerId,
    this.calleeId,
    this.callerType,
    this.callerTypeLabel,
    this.status,
    this.statusLabel,
    this.calleeName,
    this.calleePhone,
    this.failureReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['id'],
      rideId: json['ride_id'],
      callerId: json['caller_id'],
      calleeId: json['callee_id'],
      callerType: json['caller_type'],
      callerTypeLabel: json['caller_type_label'],
      status: json['status'],
      statusLabel: json['status_label'],
      calleeName: json['callee_name'],
      calleePhone: json['callee_phone'],
      failureReason: json['failure_reason'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'caller_id': callerId,
      'callee_id': calleeId,
      'caller_type': callerType,
      'caller_type_label': callerTypeLabel,
      'status': status,
      'status_label': statusLabel,
      'callee_name': calleeName,
      'callee_phone': calleePhone,
      'failure_reason': failureReason,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
