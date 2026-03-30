class PaperResponse {
  final int id;
  final String type;
  final String name;

  PaperResponse({
    required this.id,
    required this.type,
    required this.name,
  });

  factory PaperResponse.fromJson(Map<String, dynamic> json) {
    return PaperResponse(
      id: json['id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
    };
  }
}