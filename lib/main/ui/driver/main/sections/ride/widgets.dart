import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/main/bloc/driver_bloc.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isLoading,
  });
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.colorBtnCancelBorder),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.colorBtnCancelText))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.icXCircle,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                          AppColors.colorBtnCancelText, BlendMode.srcIn)),
                  const SizedBox(width: 6),
                  Text(label,
                      style: AppStyles.inter14SemiBold
                          .copyWith(color: AppColors.colorBtnCancelText)),
                ],
              ),
      ),
    );
  }
}

void confirmCancel(
  BuildContext context,
  AppLocalizations l10n,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.chuyenDiCancelConfirmTitle,
        style: AppStyles.inter16SemiBold,
      ),
      content: Text(
        l10n.chuyenDiCancelConfirmBody,
        style: AppStyles.inter14Regular,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.chuyenDiConfirmNo,
            style: AppStyles.inter14SemiBold
                .copyWith(color: AppColors.colorTextSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            context.read<DriverBloc>().add(DriverCancelAfterAccept());
          },
          child: Text(
            l10n.chuyenDiConfirmYes,
            style: AppStyles.inter14SemiBold
                .copyWith(color: AppColors.colorTextRed),
          ),
        ),
      ],
    ),
  );
}
