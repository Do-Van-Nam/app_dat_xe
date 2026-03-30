import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:flutter/material.dart';

class DemoDialog {

  static Future<void> show(
    BuildContext context, {
    required String title,
    required bool isOn,
    required VoidCallback onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColors.color_FFFF,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextFonts.poppinsSemiBold.copyWith(
                    fontSize: 18,
                    color: AppColors.color_1618,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isOn == true ? l10n.confirm_off_service_title : l10n.confirm_on_service_title,
                  textAlign: TextAlign.center,
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.color_464B,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: AppColors.color_E11B,
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                      onContinue();
                    },
                    child: Text(
                      l10n.confirm,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        fontSize: 16,
                        color: AppColors.color_FFFF,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: AppColors.color_5F5F,
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                    },
                    child: Text(
                      l10n.back,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        fontSize: 16,
                        color: AppColors.color_1618,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
