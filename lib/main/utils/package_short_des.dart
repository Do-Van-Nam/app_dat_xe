class PackageShortDes {
  final String? data;
  final String? time;
  final String? sms;
  final bool isParsed;

  const PackageShortDes({
    this.data,
    this.time,
    this.sms,
    required this.isParsed,
  });
}

PackageShortDes parseShortDes(String? shortDes) {
  if (shortDes == null || shortDes.isEmpty) {
    return const PackageShortDes(isParsed: false);
  }

  final dataRegex = RegExp(r'(\d+\s?(GB|MB))', caseSensitive: false);
  final timeRegex = RegExp(r'(\d+\s?Mins?)', caseSensitive: false);
  final smsRegex  = RegExp(r'(\d+\s?SMS)', caseSensitive: false);

  final data = dataRegex.firstMatch(shortDes)?.group(0);
  final time = timeRegex.firstMatch(shortDes)?.group(0);
  final sms  = smsRegex.firstMatch(shortDes)?.group(0);

  final isParsed = data != null || time != null || sms != null;

  return PackageShortDes(
    data: data ?? shortDes,
    time: time ?? shortDes,
    sms: sms ?? shortDes,
    isParsed: isParsed,
  );
}
