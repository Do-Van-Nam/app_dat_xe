import 'package:demo_app/core/app_export.dart';
import 'package:equatable/equatable.dart';

part 'service_register_event.dart';
part 'service_register_state.dart';

class ServiceRegisterBloc
    extends Bloc<ServiceRegisterEvent, ServiceRegisterState> {
  ServiceRegisterBloc() : super(const ServiceRegisterState()) {
    on<ServiceRegisterInitialised>(_onInitialised);
    on<ServiceRegisterServiceToggled>(_onServiceToggled);
    on<ServiceRegisterRegisterAllTapped>(_onRegisterAllTapped);
    on<ServiceRegisterConfirmTapped>(_onConfirmTapped);

    add(const ServiceRegisterInitialised());
  }

  void _onInitialised(
    ServiceRegisterInitialised event,
    Emitter<ServiceRegisterState> emit,
  ) {
    emit(state.copyWith(
      services: [
        const ServiceItem(
          id: 'xe_om',
          name: 'Xe ôm',
          subLabel: 'Di chuyển linh hoạt',
          iconPath: AppImages.icMotorbike,
          iconTheme: ServiceIconTheme.blue,
        ),
        const ServiceItem(
          id: 'taxi_4',
          name: 'Taxi 4 chỗ',
          subLabel: 'Tiện nghi cơ bản',
          iconPath: AppImages.icTaxi4,
          iconTheme: ServiceIconTheme.blue,
          isEnabled: true, // pre-selected in design
        ),
        const ServiceItem(
          id: 'taxi_7',
          name: 'Taxi 7 chỗ',
          subLabel: 'Dành cho nhóm lớn',
          iconPath: AppImages.icTaxi7,
          iconTheme: ServiceIconTheme.blue,
        ),
        const ServiceItem(
          id: 'food',
          name: 'Giao đồ ăn',
          subLabel: 'Giao tận cửa',
          iconPath: AppImages.icFood,
          iconTheme: ServiceIconTheme.orange,
          isEnabled: true, // pre-selected in design
        ),
        const ServiceItem(
          id: 'package',
          name: 'Giao hàng',
          subLabel: 'Vận chuyển siêu tốc',
          iconPath: AppImages.icPackage,
          iconTheme: ServiceIconTheme.orange,
        ),
        const ServiceItem(
          id: 'inter_city',
          name: 'Xe đi tỉnh',
          subLabel: 'Hành trình đường dài',
          iconPath: AppImages.icLocationPin,
          iconTheme: ServiceIconTheme.blue,
        ),
        const ServiceItem(
          id: 'airport',
          name: 'Xe sân bay',
          subLabel: 'Đưa đón đúng giờ',
          iconPath: AppImages.icAirplane,
          iconTheme: ServiceIconTheme.blue,
        ),
        const ServiceItem(
          id: 'drive',
          name: 'Lái hộ',
          subLabel: 'An toàn cho khách',
          iconPath: AppImages.icSteering,
          iconTheme: ServiceIconTheme.blue,
        ),
      ],
    ));
  }

  void _onServiceToggled(
    ServiceRegisterServiceToggled event,
    Emitter<ServiceRegisterState> emit,
  ) {
    final updated = state.services.map((s) {
      if (s.id == event.serviceId) {
        return s.copyWith(isEnabled: !s.isEnabled);
      }
      return s;
    }).toList();
    emit(state.copyWith(services: updated));
  }

  void _onRegisterAllTapped(
    ServiceRegisterRegisterAllTapped event,
    Emitter<ServiceRegisterState> emit,
  ) {
    // If all are already enabled, disable all; otherwise enable all.
    final enableAll = !state.allEnabled;
    final updated =
        state.services.map((s) => s.copyWith(isEnabled: enableAll)).toList();
    emit(state.copyWith(services: updated));
  }

  Future<void> _onConfirmTapped(
    ServiceRegisterConfirmTapped event,
    Emitter<ServiceRegisterState> emit,
  ) async {
    if (!state.hasAnyEnabled) return;
    emit(state.copyWith(status: ServiceRegisterStatus.submitting));
    try {
      // TODO: call registration repository with enabled service IDs
      final enabledIds =
          state.services.where((s) => s.isEnabled).map((s) => s.id).toList();
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: ServiceRegisterStatus.submitted));
    } catch (e) {
      emit(state.copyWith(
        status: ServiceRegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
