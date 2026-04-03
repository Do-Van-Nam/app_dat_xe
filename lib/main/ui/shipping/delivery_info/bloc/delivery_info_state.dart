part of 'delivery_info_bloc.dart';

enum DeliveryInfoStatus { initial, loading, success, failure }

class DeliveryInfoState extends Equatable {
  const DeliveryInfoState({
    this.status = DeliveryInfoStatus.initial,
    this.selectedWeight = '0-5kg',
    this.selectedGoodsType = 'ĐÓNG GÓI',
    this.receiverName = '',
    this.receiverPhone = '',
    this.deliveryNote = '',
    this.receiverAddress = '28 Võng Thị, P. Bưởi, Q. Tây Hồ',
    this.errorMessage,
  });

  final DeliveryInfoStatus status;
  final String selectedWeight;
  final String selectedGoodsType;
  final String receiverName;
  final String receiverPhone;
  final String deliveryNote;
  final String receiverAddress;
  final String? errorMessage;

  DeliveryInfoState copyWith({
    DeliveryInfoStatus? status,
    String? selectedWeight,
    String? selectedGoodsType,
    String? receiverName,
    String? receiverPhone,
    String? deliveryNote,
    String? receiverAddress,
    String? errorMessage,
  }) {
    return DeliveryInfoState(
      status: status ?? this.status,
      selectedWeight: selectedWeight ?? this.selectedWeight,
      selectedGoodsType: selectedGoodsType ?? this.selectedGoodsType,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      deliveryNote: deliveryNote ?? this.deliveryNote,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isFormValid =>
      receiverName.isNotEmpty && receiverPhone.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        selectedWeight,
        selectedGoodsType,
        receiverName,
        receiverPhone,
        deliveryNote,
        receiverAddress,
        errorMessage,
      ];
}
