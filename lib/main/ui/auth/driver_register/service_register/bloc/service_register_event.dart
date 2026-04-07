part of 'service_register_bloc.dart';

abstract class ServiceRegisterEvent extends Equatable {
  const ServiceRegisterEvent();

  @override
  List<Object?> get props => [];
}

/// Page initialised – seed service list.
class ServiceRegisterInitialised extends ServiceRegisterEvent {
  const ServiceRegisterInitialised();
}

/// User toggles a single service on/off.
class ServiceRegisterServiceToggled extends ServiceRegisterEvent {
  const ServiceRegisterServiceToggled(this.serviceId);
  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

/// User taps "Đăng ký tất cả" – enables / disables all.
class ServiceRegisterRegisterAllTapped extends ServiceRegisterEvent {
  const ServiceRegisterRegisterAllTapped();
}

/// User taps "Xác nhận đăng ký".
class ServiceRegisterConfirmTapped extends ServiceRegisterEvent {
  const ServiceRegisterConfirmTapped();
}
