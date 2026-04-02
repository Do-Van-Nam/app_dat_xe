import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'book_for_family_event.dart';
part 'book_for_family_state.dart';

class BookForFamilyBloc extends Bloc<BookForFamilyEvent, BookForFamilyState> {
  BookForFamilyBloc() : super(const BookForFamilyState()) {
    on<BookForFamilyReceiverNameChanged>(_onReceiverNameChanged);
    on<BookForFamilyReceiverPhoneChanged>(_onReceiverPhoneChanged);
    on<BookForFamilyServiceSelected>(_onServiceSelected);
    on<BookForFamilyPickupChanged>(_onPickupChanged);
    on<BookForFamilyDestinationChanged>(_onDestinationChanged);
    on<BookForFamilyNoteChanged>(_onNoteChanged);
    on<BookForFamilyQuickTagTapped>(_onQuickTagTapped);
    on<BookForFamilyConfirmTapped>(_onConfirmTapped);
  }

  void _onReceiverNameChanged(
    BookForFamilyReceiverNameChanged event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(receiverName: event.name));
  }

  void _onReceiverPhoneChanged(
    BookForFamilyReceiverPhoneChanged event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(receiverPhone: event.phone));
  }

  void _onServiceSelected(
    BookForFamilyServiceSelected event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(selectedService: event.service));
  }

  void _onPickupChanged(
    BookForFamilyPickupChanged event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(pickup: event.pickup));
  }

  void _onDestinationChanged(
    BookForFamilyDestinationChanged event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(destination: event.destination));
  }

  void _onNoteChanged(
    BookForFamilyNoteChanged event,
    Emitter<BookForFamilyState> emit,
  ) {
    emit(state.copyWith(note: event.note));
  }

  void _onQuickTagTapped(
    BookForFamilyQuickTagTapped event,
    Emitter<BookForFamilyState> emit,
  ) {
    final current = state.note;
    final tag = event.tag;
    final updated = current.isEmpty ? tag : '$current $tag';
    emit(state.copyWith(note: updated));
  }

  Future<void> _onConfirmTapped(
    BookForFamilyConfirmTapped event,
    Emitter<BookForFamilyState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        status: BookForFamilyStatus.failure,
        errorMessage: 'Vui lòng điền đầy đủ thông tin.',
      ));
      return;
    }
    emit(state.copyWith(status: BookForFamilyStatus.loading));
    try {
      // TODO: Call booking repository here
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: BookForFamilyStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: BookForFamilyStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
