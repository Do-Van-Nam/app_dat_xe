import 'package:demo_app/core/app_export.dart';

import '../topup_widgets.dart';

class InfoNoteSection extends StatelessWidget {
  const InfoNoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InfoNoteCard(text: l10n.infoNote);
  }
}
