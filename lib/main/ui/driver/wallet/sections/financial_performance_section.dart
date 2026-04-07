import 'package:demo_app/core/app_export.dart';

import '../bloc/wallet_bloc.dart';
import '../wallet_widgets.dart';

class FinancialPerformanceSection extends StatelessWidget {
  const FinancialPerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = context.select((WalletBloc b) => b.state.performancePercent);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorPerfBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left: text + bar chart
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.financialPerformanceTitle,
                  style: AppStyles.inter16Bold,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.financialPerformanceSub,
                  style: AppStyles.inter13Regular,
                ),
                const SizedBox(height: 16),
                const SimpleBarChart(),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: circle stock chart
          const CircleChartImage(),
        ],
      ),
    );
  }
}
