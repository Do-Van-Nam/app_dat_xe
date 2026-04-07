part of 'service_register_bloc.dart';

enum ServiceIconTheme { blue, orange }

class ServiceItem extends Equatable {
  const ServiceItem({
    required this.id,
    required this.name,
    required this.subLabel,
    required this.iconPath,
    this.iconTheme = ServiceIconTheme.blue,
    this.isEnabled = false,
  });

  final String id;
  final String name;
  final String subLabel;
  final String iconPath;
  final ServiceIconTheme iconTheme;
  final bool isEnabled;

  ServiceItem copyWith({bool? isEnabled}) {
    return ServiceItem(
      id: id,
      name: name,
      subLabel: subLabel,
      iconPath: iconPath,
      iconTheme: iconTheme,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, subLabel, iconPath, iconTheme, isEnabled];
}

enum ServiceRegisterStatus { initial, submitting, submitted, error }

class ServiceRegisterState extends Equatable {
  const ServiceRegisterState({
    this.status = ServiceRegisterStatus.initial,
    this.services = const [],
    this.errorMessage,
  });

  final ServiceRegisterStatus status;
  final List<ServiceItem> services;
  final String? errorMessage;

  bool get hasAnyEnabled => services.any((s) => s.isEnabled);
  bool get allEnabled =>
      services.isNotEmpty && services.every((s) => s.isEnabled);
  int get enabledCount => services.where((s) => s.isEnabled).length;

  ServiceRegisterState copyWith({
    ServiceRegisterStatus? status,
    List<ServiceItem>? services,
    String? errorMessage,
  }) {
    return ServiceRegisterState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, services, errorMessage];
}
