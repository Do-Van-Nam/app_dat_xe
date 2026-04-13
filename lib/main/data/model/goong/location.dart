// location.dart — Goong Autocomplete Result Model

class GoongLocation {
  /// Địa điểm đầy đủ (vd: "91 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội")
  final String description;

  /// Các phần chuỗi tìm kiếm khớp với kết quả
  final List<MatchedSubstring> matchedSubstrings;

  /// Mã định danh duy nhất — dùng để gọi Place Detail / Geocode API
  final String placeId;

  /// Chuỗi đại diện cho địa điểm duy nhất trên bản đồ
  final String reference;

  /// Thông tin định dạng chính/phụ của địa điểm
  final StructuredFormatting structuredFormatting;

  /// Các từ khóa mô tả địa điểm kèm offset
  final List<Term> terms;

  /// true nếu địa điểm có địa điểm con (dùng Child ID API)
  final bool hasChildren;

  /// Loại hiển thị (vd: "expand0")
  final String displayType;

  /// Điểm liên quan / độ chính xác so với truy vấn
  final double score;

  /// Mã Plus Code (local + global)
  final PlusCode? plusCode;

  const GoongLocation({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.hasChildren,
    required this.displayType,
    required this.score,
    this.plusCode,
  });

  factory GoongLocation.fromJson(Map<String, dynamic> json) {
    return GoongLocation(
      description: json['description'] as String? ?? '',
      matchedSubstrings: (json['matched_substrings'] as List<dynamic>?)
              ?.map((e) =>
                  MatchedSubstring.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      placeId: json['place_id'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      structuredFormatting: StructuredFormatting.fromJson(
        json['structured_formatting'] as Map<String, dynamic>? ?? {},
      ),
      terms: (json['terms'] as List<dynamic>?)
              ?.map((e) => Term.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hasChildren: json['has_children'] as bool? ?? false,
      displayType: json['display_type'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      plusCode: json['plus_code'] != null
          ? PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'matched_substrings': matchedSubstrings.map((e) => e.toJson()).toList(),
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting.toJson(),
      'terms': terms.map((e) => e.toJson()).toList(),
      'has_children': hasChildren,
      'display_type': displayType,
      'score': score,
      'plus_code': plusCode?.toJson(),
    };
  }

  @override
  String toString() =>
      'GoongLocation(placeId: $placeId, description: $description)';
}

// ============================================================
// StructuredFormatting
// ============================================================

class StructuredFormatting {
  /// Tên chính của địa điểm (vd: "91 Trung Kính")
  final String mainText;

  /// Thông tin phụ / vùng khu vực (vd: "Trung Hòa, Cầu Giấy, Hà Nội")
  final String secondaryText;

  const StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String? ?? '',
      secondaryText: json['secondary_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'secondary_text': secondaryText,
      };
}

// ============================================================
// MatchedSubstring
// ============================================================

class MatchedSubstring {
  /// Độ dài phần khớp
  final int length;

  /// Vị trí bắt đầu trong chuỗi tìm kiếm
  final int offset;

  const MatchedSubstring({
    required this.length,
    required this.offset,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

// ============================================================
// Term
// ============================================================

class Term {
  /// Vị trí của từ trong chuỗi
  final int offset;

  /// Từ khóa mô tả địa điểm (vd: "Phường Trung Hòa")
  final String value;

  const Term({
    required this.offset,
    required this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'] as int? ?? 0,
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}

// ============================================================
// PlusCode
// ============================================================

class PlusCode {
  /// Mã địa phương kèm khu vực (vd: "+6DW1G Trung Hòa, Cầu Giấy, Hà Nội")
  final String compoundCode;

  /// Mã toàn cầu xác định vị trí chính xác (vd: "LOC1+6DW1G")
  final String globalCode;

  const PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'] as String? ?? '',
      globalCode: json['global_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'compound_code': compoundCode,
        'global_code': globalCode,
      };
}
