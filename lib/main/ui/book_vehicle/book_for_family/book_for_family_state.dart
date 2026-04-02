part of 'book_for_family_bloc.dart';

enum BookForFamilyServiceType { car, food }

enum BookForFamilyStatus { initial, loading, success, failure }

class BookForFamilyState extends Equatable {
  const BookForFamilyState({
    this.receiverName = '',
    this.receiverPhone = '',
    this.selectedService = BookForFamilyServiceType.car,
    this.pickup = '',
    this.destination = '',
    this.note = '',
    this.status = BookForFamilyStatus.initial,
    this.errorMessage,
  });

  final String receiverName;
  final String receiverPhone;
  final BookForFamilyServiceType selectedService;
  final String pickup;
  final String destination;
  final String note;
  final BookForFamilyStatus status;
  final String? errorMessage;

  bool get isFormValid =>
      receiverName.trim().isNotEmpty &&
      receiverPhone.trim().isNotEmpty &&
      pickup.trim().isNotEmpty &&
      destination.trim().isNotEmpty;

  BookForFamilyState copyWith({
    String? receiverName,
    String? receiverPhone,
    BookForFamilyServiceType? selectedService,
    String? pickup,
    String? destination,
    String? note,
    BookForFamilyStatus? status,
    String? errorMessage,
  }) {
    return BookForFamilyState(
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      selectedService: selectedService ?? this.selectedService,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        receiverName,
        receiverPhone,
        selectedService,
        pickup,
        destination,
        note,
        status,
        errorMessage,
      ];
}
