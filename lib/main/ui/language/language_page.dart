import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/ui/language/language_bloc.dart';
import 'package:demo_app/main/ui/language/language_event.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});
  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await SharePreferenceUtil.getString(
      ShareKey.KEY_CHANGE_LANGUAGE,
      defaultValue: 'en',
    );
    if (!mounted) return;
    AppLogger().logInfo("Language: $lang");
    setState(() {
      currentLang = lang;
    });
  }

  void _changeLanguage(String langCode) {
    context.read<LanguageBloc>().add(ChangeLanguageEvent(Locale(langCode)));

    setState(() {
      currentLang = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.color_F7F7,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.color_FFFF,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.color_1618,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: AppStyles.headerBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    LanguageItemButton(
                      title: AppLocalizations.of(context)!.english,
                      assetFlag: AppImages.imgEn,
                      isSelected: currentLang == 'en',
                      onTap: () => _changeLanguage('en'),
                    ),
                    const SizedBox(height: 12),
                    LanguageItemButton(
                      title: AppLocalizations.of(context)!.vietnamese,
                      assetFlag: AppImages.imgVn,
                      isSelected: currentLang == 'vi',
                      onTap: () => _changeLanguage('vi'),
                    ),
                    const SizedBox(height: 12),
                    LanguageItemButton(
                      title: AppLocalizations.of(context)!.khmer,
                      assetFlag: AppImages.imgKm,
                      isSelected: currentLang == 'km',
                      onTap: () => _changeLanguage('km'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageItemButton extends StatelessWidget {
  final String title;
  final String assetFlag;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageItemButton({
    super.key,
    required this.title,
    required this.assetFlag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.red.withOpacity(0.1) // bg đỏ nhạt
              : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(assetFlag, width: 32, height: 22, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SvgPicture.asset(
              isSelected
                  ? AppImages.icCheckSelected
                  : AppImages.icCheckUnselected,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
