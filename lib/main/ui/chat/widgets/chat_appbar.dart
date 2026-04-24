import 'package:demo_app/core/app_export.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 1,
      title: Text(
        !Constant.isUserApp ? "Trao đổi với khách hàng" : "Trao đổi với tài xế",
        style: AppStyles.inter16SemiBold,
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
