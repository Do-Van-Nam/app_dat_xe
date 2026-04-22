import 'package:demo_app/core/app_export.dart';
import '../../driver_register/upload_records/widgets/dropdown.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';

import 'bloc/upload_records_bloc.dart';
import 'widgets/document_item_card.dart';
import 'widgets/hint_card.dart';
import 'widgets/sample_image_grid.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class UploadRecordsPage extends StatelessWidget {
  const UploadRecordsPage(
      {super.key, required this.phone, required this.fullName});
  final String phone;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadRecordsBloc(
        phone: phone,
        fullName: fullName,
      ),
      child: const _UploadRecordsView(),
    );
  }
}

class _UploadRecordsView extends StatefulWidget {
  const _UploadRecordsView();

  @override
  State<_UploadRecordsView> createState() => _UploadRecordsViewState();
}

class _UploadRecordsViewState extends State<_UploadRecordsView> {
  final _cccdController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _plateController = TextEditingController();
  final _yearController = TextEditingController();

  int? _selectedVehicleType;
  int? _selectedColor;

  @override
  void dispose() {
    _cccdController.dispose();
    _vehicleNameController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UploadRecordsBloc, UploadRecordsState>(
      listenWhen: (p, c) =>
          p.pageStatus != c.pageStatus || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.pageStatus == UploadRecordsPageStatus.error &&
            state.errorMessage != null) {
          AppToast.show(context, state.errorMessage!);
        }
        if (state.pageStatus == UploadRecordsPageStatus.submitted) {
          context.push(PATH_DRIVER_SERVICE_REGISTER);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _UploadRecordsAppBar(title: l10n.xacThucAppBarTitle),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroBannerSection(),
                    const _HintSection(),
                    _DocumentListSection(
                      cccdController: _cccdController,
                      vehicleNameController: _vehicleNameController,
                      plateController: _plateController,
                      yearController: _yearController,
                      selectedVehicleType: _selectedVehicleType,
                      selectedColor: _selectedColor,
                      onVehicleTypeChanged: (val) =>
                          setState(() => _selectedVehicleType = val),
                      onColorChanged: (val) =>
                          setState(() => _selectedColor = val),
                    ),
                    _SampleSection(l10n: l10n),
                  ],
                ),
              ),
            ),
            _BottomSection(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _UploadRecordsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _UploadRecordsAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorAppBarBg,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.colorAppBarDivider),
      ),
      // leading: GestureDetector(
      //   onTap: () => Navigator.of(context).pop(),
      //   child: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: SvgPicture.asset(
      //       AppImages.icArrowBack,
      //       width: 24,
      //       height: 24,
      //       colorFilter: const ColorFilter.mode(
      //         AppColors.colorAppBarTitle,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //   ),
      // ),
      title: Text(
        title,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.colorAppBarTitle,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – HERO BANNER
// ═══════════════════════════════════════════════════════════════

class _HeroBannerSection extends StatelessWidget {
  const _HeroBannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colorHeroBannerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Shield icon watermark (right side)
          Positioned(
            right: -10,
            bottom: -10,
            child: SvgPicture.asset(
              AppImages.icShieldCheck,
              width: 90,
              height: 90,
              colorFilter: const ColorFilter.mode(
                AppColors.colorHeroBannerIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.xacThucHeroBannerTitle,
                style: AppStyles.inter22Bold.copyWith(
                  color: AppColors.colorHeroBannerTitle,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.xacThucHeroBannerBody,
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.colorHeroBannerBody,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – HINT CARD
// ═══════════════════════════════════════════════════════════════

class _HintSection extends StatelessWidget {
  const _HintSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return HintCard(text: l10n.xacThucHintText);
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – DOCUMENT LIST
// ═══════════════════════════════════════════════════════════════

class _DocumentListSection extends StatelessWidget {
  const _DocumentListSection({
    required this.cccdController,
    required this.vehicleNameController,
    required this.plateController,
    required this.yearController,
    this.selectedVehicleType,
    this.selectedColor,
    required this.onVehicleTypeChanged,
    required this.onColorChanged,
  });

  final TextEditingController cccdController;
  final TextEditingController vehicleNameController;
  final TextEditingController plateController;
  final TextEditingController yearController;
  final int? selectedVehicleType;
  final int? selectedColor;
  final ValueChanged<int?> onVehicleTypeChanged;
  final ValueChanged<int?> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UploadRecordsBloc, UploadRecordsState>(
      buildWhen: (p, c) => p.documents != c.documents,
      builder: (context, state) {
        return Column(
          spacing: 12,
          children: [
            buildTextField(
              controller: cccdController,
              label: 'Số CCCD',
              hint: 'Nhập số CCCD',
              icon: Icons.person_outline,
              keyboardType: TextInputType.number,
              onChanged: (val) => context
                  .read<UploadRecordsBloc>()
                  .add(UploadRecordsInfoChanged(type: 'cccd', value: val)),
            ),
            dropdownField<int>(
              label: 'Loại xe',
              value: selectedVehicleType,
              icon: Icons.directions_car,
              items: {
                1: 'Bike',
                2: 'Car 4 seats',
                3: 'Car 7 seats',
                4: 'Car 9 seats',
              },
              onChanged: (val) {
                onVehicleTypeChanged(val);
                if (val != null) {
                  context.read<UploadRecordsBloc>().add(
                      UploadRecordsInfoChanged(
                          type: 'vehicleType', value: val.toString()));
                }
              },
            ),
            buildTextField(
              controller: vehicleNameController,
              label: 'Tên xe',
              hint: 'Nhập tên xe',
              icon: Icons.car_rental,
              keyboardType: TextInputType.text,
              onChanged: (val) => context.read<UploadRecordsBloc>().add(
                  UploadRecordsInfoChanged(type: 'vehicleName', value: val)),
            ),
            dropdownField<int>(
              label: 'Màu xe',
              value: selectedColor,
              icon: Icons.palette_outlined,
              items: {
                0: 'Khác',
                1: 'Đỏ',
                2: 'Xanh lá',
                3: 'Xanh dương',
                4: 'Vàng',
                5: 'Cam',
                6: 'Tím',
                7: 'Nâu',
                8: 'Đen',
                9: 'Trắng',
              },
              onChanged: (val) {
                onColorChanged(val);
                if (val != null) {
                  context.read<UploadRecordsBloc>().add(
                      UploadRecordsInfoChanged(
                          type: 'vehicleColor', value: val.toString()));
                }
              },
            ),
            buildTextField(
              controller: plateController,
              label: 'Biển số xe',
              hint: 'Nhập biển số xe',
              icon: Icons.confirmation_number_outlined,
              keyboardType: TextInputType.text,
              onChanged: (val) => context.read<UploadRecordsBloc>().add(
                  UploadRecordsInfoChanged(type: 'vehicleNumber', value: val)),
            ),
            buildTextField(
              controller: yearController,
              label: 'Năm sản xuất',
              hint: 'Nhập năm sản xuất',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
              onChanged: (val) => context.read<UploadRecordsBloc>().add(
                  UploadRecordsInfoChanged(type: 'vehicleYear', value: val)),
            ),
            const SizedBox(height: 12),
            ...state.documents.asMap().entries.map((entry) {
              final doc = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DocumentItemCard(
                  item: doc,
                  uploadLabel: l10n.xacThucBtnUpload,
                  cameraLabel: l10n.xacThucBtnCamera,
                  onUpload: () => context
                      .read<UploadRecordsBloc>()
                      .add(UploadRecordsUploadTapped(doc.id)),
                  onCamera: () => context
                      .read<UploadRecordsBloc>()
                      .add(UploadRecordsCameraTapped(doc.id)),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – SAMPLE IMAGES
// ═══════════════════════════════════════════════════════════════

class _SampleSection extends StatelessWidget {
  const _SampleSection({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SampleImageGrid(
      title: l10n.xacThucSampleTitle,
      imagePaths: [
        'assets/images/img_sample_id_card.png',
        'assets/images/img_sample_portrait.png',
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM SECTION – NEXT BUTTON + HINT
// ═══════════════════════════════════════════════════════════════

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadowMd,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BlocBuilder<UploadRecordsBloc, UploadRecordsState>(
        buildWhen: (p, c) =>
            p.canProceed != c.canProceed ||
            p.completedCount != c.completedCount ||
            p.pageStatus != c.pageStatus,
        builder: (context, state) {
          final isDocsUploaded = state.canProceed;
          final isSubmitting =
              state.pageStatus == UploadRecordsPageStatus.submitting;

          // Enable button if docs are ready AND vehicle info is selected
          final canGo = isDocsUploaded &&
              state.info?.vehicleType != 0 &&
              state.info?.vehicleColor != 0 &&
              (state.info?.vehicleName ?? "").isNotEmpty &&
              (state.info?.vehicleNumber ?? "").isNotEmpty &&
              (state.info?.vehicleYear ?? 0) != 0 &&
              (state.info?.cccd ?? "").isNotEmpty;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Next button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (canGo && !isSubmitting)
                      ? () => context.read<UploadRecordsBloc>().add(
                            UploadRecordsNextTapped(),
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canGo
                        ? AppColors.colorNextBtnBgActive
                        : AppColors.colorNextBtnBg,
                    disabledBackgroundColor: AppColors.colorNextBtnBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.colorNextBtnTextActive,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.icSend,
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                canGo
                                    ? AppColors.colorNextBtnTextActive
                                    : AppColors.colorNextBtnText,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.xacThucNextButton,
                              style: AppStyles.inter16SemiBold.copyWith(
                                color: canGo
                                    ? AppColors.colorNextBtnTextActive
                                    : AppColors.colorNextBtnText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 10),

              // Progress hint
              Text(
                'VUI LÒNG HOÀN TẤT ${state.completedCount}/${state.totalRequired} YÊU CẦU ĐỂ TIẾP TỤC',
                style: AppStyles.inter11Regular.copyWith(
                  color: AppColors.colorNextHintText,
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
