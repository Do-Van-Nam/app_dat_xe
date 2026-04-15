class UniqueError {
  final String message;
  final Object _id = Object(); // mỗi instance là unique

  UniqueError(this.message);

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => _id.hashCode;
}
