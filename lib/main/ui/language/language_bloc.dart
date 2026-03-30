import 'dart:ui';

import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/ui/language/language_event.dart';
import 'package:demo_app/main/ui/language/languge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('en','US'))) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadLanguageEvent>(_onLoadLanguage);
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event,
      Emitter<LanguageState> emit,
      ) async {
    await SharePreferenceUtil.saveLanguage(
      event.locale.languageCode,
    );
    emit(LanguageState(event.locale));
  }

  Future<void> _onLoadLanguage(
      LoadLanguageEvent event,
      Emitter<LanguageState> emit,
      ) async {
    final code = await SharePreferenceUtil.getLanguageCode();
    emit(LanguageState(Locale(code)));
  }
}
