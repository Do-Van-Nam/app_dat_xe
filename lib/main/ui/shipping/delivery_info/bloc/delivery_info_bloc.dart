import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_info_event.dart';
part 'delivery_info_state.dart';

class DeliveryInfoBloc extends Bloc<DeliveryInfoEvent, DeliveryInfoState> {
  DeliveryInfoBloc() : super(const DeliveryInfoState()) {
    on<WeightSelected>(_onWeightSelected);
    on<GoodsTypeSelected>(_onGoodsTypeSelected);
    on<ReceiverNameChanged>(_onReceiverNameChanged);
    on<ReceiverPhoneChanged>(_onReceiverPhoneChanged);
    on<DeliveryNoteChanged>(_onDeliveryNoteChanged);
    on<ChangeAddressTapped>(_onChangeAddressTapped);
    on<ContinueTapped>(_onContinueTapped);
  }

  void _onWeightSelected(
    WeightSelected event,
    Emitter<DeliveryInfoState> emit,
  ) {
    emit(state.copyWith(selectedWeight: event.weight));
  }

  void _onGoodsTypeSelected(
    GoodsTypeSelected event,
    Emitter<DeliveryInfoState> emit,
  ) {
    emit(state.copyWith(selectedGoodsType: event.goodsType));
  }

  void _onReceiverNameChanged(
    ReceiverNameChanged event,
    Emitter<DeliveryInfoState> emit,
  ) {
    emit(state.copyWith(receiverName: event.name));
  }

  void _onReceiverPhoneChanged(
    ReceiverPhoneChanged event,
    Emitter<DeliveryInfoState> emit,
  ) {
    emit(state.copyWith(receiverPhone: event.phone));
  }

  void _onDeliveryNoteChanged(
    DeliveryNoteChanged event,
    Emitter<DeliveryInfoState> emit,
  ) {
    emit(state.copyWith(deliveryNote: event.note));
  }

  void _onChangeAddressTapped(
    ChangeAddressTapped event,
    Emitter<DeliveryInfoState> emit,
  ) {
    // Navigate to address picker – handled by the page listening to state/status.
  }

  void _onContinueTapped(
    ContinueTapped event,
    Emitter<DeliveryInfoState> emit,
  ) {
    if (!state.isFormValid) {
      emit(state.copyWith(
        status: DeliveryInfoStatus.failure,
        errorMessage: 'Vui lòng điền đầy đủ thông tin người nhận.',
      ));
      return;
    }
    emit(state.copyWith(status: DeliveryInfoStatus.success));
  }
}
