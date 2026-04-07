import 'package:demo_app/core/app_export.dart';
import 'package:flutter/services.dart';

import '../bloc/topup_bloc.dart';
import '../topup_widgets.dart';

class AmountInputSection extends StatefulWidget {
  const AmountInputSection({super.key});

  @override
  State<AmountInputSection> createState() => _AmountInputSectionState();
}

class _AmountInputSectionState extends State<AmountInputSection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final initial = context.read<TopUpBloc>().state.amount;
    _ctrl = TextEditingController(text: _raw(initial));
  }

  String _raw(int amount) => amount == 0 ? '' : amount.toString();

  String _fmt(int amount) {
    if (amount == 0) return '0';
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TopUpBloc>().state;

    // Sync controller when amount changes from chip
    final fmtDisplay = _fmt(state.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          l10n.amountLabel,
          style: AppStyles.inter11SemiBold,
        ),
        const SizedBox(height: 12),

        // Amount display card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.colorF5F7FA,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currency + amount row (tappable for keyboard)
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // đ symbol
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, right: 6),
                      child: Text(
                        'đ',
                        style: AppStyles.inter22SemiBold,
                      ),
                    ),
                    // Hidden TextField for editing
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: AppStyles.inter44ExtraBold,
                        decoration: const InputDecoration.collapsed(
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: AppColors.colorBDBDBD,
                          ),
                        ),
                        onChanged: (v) {
                          context.read<TopUpBloc>().add(AmountChanged(v));
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(
                height: 8,
                color: AppColors.colorInputDivider,
                thickness: 1.5,
              ),

              const SizedBox(height: 14),

              // Quick-amount chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 6,
                  children: [
                    _chip(context, 50000, l10n.amount50k, state),
                    _chip(context, 100000, l10n.amount100k, state),
                    _chip(context, 200000, l10n.amount200k, state),
                    _chip(context, 500000, l10n.amount500k, state),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    int amount,
    String label,
    TopUpState state,
  ) {
    return AmountChip(
      label: label,
      selected: state.amount == amount,
      onTap: () {
        _ctrl.text = amount.toString();
        context.read<TopUpBloc>().add(QuickAmountSelected(amount));
      },
    );
  }
}
