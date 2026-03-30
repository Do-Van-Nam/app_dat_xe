import 'package:flutter_bloc/flutter_bloc.dart';

import 'mini_app_event.dart';
import 'mini_app_state.dart';
import 'mini_app_webview_controller.dart';

class MiniAppBloc extends Bloc<MiniAppEvent, MiniAppState> {
  MiniAppBloc() : super(const MiniAppState()) {
    on<MiniAppOpen>((_, emit) {
      emit(state.copyWith(opened: true, minimized: false));
    });

    on<MiniAppMinimize>((_, emit) {
      emit(
        state.copyWith(
          opened: true, // Đảm bảo opened vẫn là true khi minimize
          minimized: true,
          nearClose: false,
        ),
      );
    });

    on<MiniAppClose>((_, emit) {
      emit(const MiniAppState());
    });

    on<MiniAppUpdatePosition>((e, emit) {
      emit(state.copyWith(position: e.position));
    });

    on<MiniAppNearCloseChanged>((e, emit) {
      emit(state.copyWith(nearClose: e.value));
    });

    on<MiniAppLoadUrl>((e, emit) {
      MiniAppWebViewController().loadUrl(e.url);
      emit(state.copyWith(opened: true, minimized: false));
    });
  }
}
