import 'package:demo_app/core/app_export.dart';

import '../bloc/upload_records_bloc.dart';

/// Single document row card with status-aware UI.
class DocumentItemCard extends StatelessWidget {
  const DocumentItemCard({
    super.key,
    required this.item,
    required this.uploadLabel,
    required this.cameraLabel,
    required this.onUpload,
    required this.onCamera,
  });

  final UploadRecordsDocItem item;
  final String uploadLabel;
  final String cameraLabel;
  final VoidCallback onUpload;
  final VoidCallback onCamera;

  @override
  Widget build(BuildContext context) {
    final isVerified = item.isVerified;
    final isUploading = item.isUploading;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isVerified
              ? AppColors.colorDocVerifiedBg
              : AppColors.colorDocCardBg,
          // borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color:
                  isVerified ? AppColors.colorVerifiedBar : Colors.transparent,
              width: 3,
            ),
            // top: BorderSide(color: AppColors.colorDocCardBorder),
            // right: BorderSide(color: AppColors.colorDocCardBorder),
            // bottom: BorderSide(color: AppColors.colorDocCardBorder),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.colorShadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isVerified
                    ? AppColors.colorDocVerifiedIconBg
                    : AppColors.colorDocIconBg,
              ),
              alignment: Alignment.center,
              child: isVerified
                  ? SvgPicture.asset(
                      AppImages.icCheckCircleFill,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.colorDocVerifiedIcon,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      item.iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.colorDocIconFg,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Name + sub label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppStyles.inter15SemiBold),
                  const SizedBox(height: 3),
                  Text(
                    item.subLabel,
                    style: AppStyles.inter11SemiBold.copyWith(
                      color: isVerified
                          ? AppColors.colorDocVerifiedLabel
                          : AppColors.colorDocSubLabel,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action: uploading spinner / verified badge / action button
            if (isUploading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.colorPrimary,
                ),
              )
            // else if (isVerified)
            //   SvgPicture.asset(
            //     AppImages.icCheckCircleGreen,
            //     width: 26,
            //     height: 26,
            //     colorFilter: const ColorFilter.mode(
            //       AppColors.colorGreen,
            //       BlendMode.srcIn,
            //     ),
            //   )
            else
              _ActionButton(
                item: item,
                uploadLabel: uploadLabel,
                cameraLabel: cameraLabel,
                onUpload: onUpload,
                onCamera: onCamera,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.item,
    required this.uploadLabel,
    required this.cameraLabel,
    required this.onUpload,
    required this.onCamera,
  });

  final UploadRecordsDocItem item;
  final String uploadLabel;
  final String cameraLabel;
  final VoidCallback onUpload;
  final VoidCallback onCamera;

  @override
  Widget build(BuildContext context) {
    final isCamera = item.actionType == UploadRecordsDocActionType.camera;

    return GestureDetector(
      onTap: isCamera ? onCamera : onUpload,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCamera
              ? AppColors.colorBtnCameraBg
              : AppColors.colorBtnUploadBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isCamera ? AppImages.icCamera : AppImages.icUpload,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                isCamera
                    ? AppColors.colorBtnCameraText
                    : AppColors.colorBtnUploadText,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              isCamera ? cameraLabel : uploadLabel,
              style: AppStyles.inter12SemiBold.copyWith(
                color: isCamera
                    ? AppColors.colorBtnCameraText
                    : AppColors.colorBtnUploadText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
