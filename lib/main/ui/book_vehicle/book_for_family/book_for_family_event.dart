part of 'book_for_family_bloc.dart';

abstract class BookForFamilyEvent extends Equatable {
  const BookForFamilyEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the user changes the receiver's name.
class BookForFamilyReceiverNameChanged extends BookForFamilyEvent {
  const BookForFamilyReceiverNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

/// Triggered when the user changes the receiver's phone number.
class BookForFamilyReceiverPhoneChanged extends BookForFamilyEvent {
  const BookForFamilyReceiverPhoneChanged(this.phone);
  final String phone;

  @override
  List<Object?> get props => [phone];
}

/// Triggered when the user selects a service type.
class BookForFamilyServiceSelected extends BookForFamilyEvent {
  const BookForFamilyServiceSelected(this.service);
  final BookForFamilyServiceType service;

  @override
  List<Object?> get props => [service];
}

/// Triggered when the user changes the pickup address.
class BookForFamilyPickupChanged extends BookForFamilyEvent {
  const BookForFamilyPickupChanged(this.pickup);
  final String pickup;

  @override
  List<Object?> get props => [pickup];
}

/// Triggered when the user changes the destination address.
class BookForFamilyDestinationChanged extends BookForFamilyEvent {
  const BookForFamilyDestinationChanged(this.destination);
  final String destination;

  @override
  List<Object?> get props => [destination];
}

/// Triggered when the user changes the driver note.
class BookForFamilyNoteChanged extends BookForFamilyEvent {
  const BookForFamilyNoteChanged(this.note);
  final String note;

  @override
  List<Object?> get props => [note];
}

/// Triggered when a quick-note tag is tapped.
class BookForFamilyQuickTagTapped extends BookForFamilyEvent {
  const BookForFamilyQuickTagTapped(this.tag);
  final String tag;

  @override
  List<Object?> get props => [tag];
}

/// Triggered when the confirm button is tapped.
class BookForFamilyConfirmTapped extends BookForFamilyEvent {
  const BookForFamilyConfirmTapped();
}
