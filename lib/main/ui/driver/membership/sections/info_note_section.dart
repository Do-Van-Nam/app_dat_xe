import 'package:demo_app/core/app_export.dart';

import '../membership_widgets.dart';

class InfoNoteSection extends StatelessWidget {
  const InfoNoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InfoNoteCard(
      prefix: l10n.infoNote,
      boldPart: l10n.infoNoteBold,
      suffix: l10n.infoNoteEnd,
    );
  }
}
