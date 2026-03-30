import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingWidget extends StatelessWidget {
  final LoadingWidgetState state;
  final Widget child;
  final String? emptyMessage;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const LoadingWidget({
    super.key,
    required this.state,
    required this.child,
    this.emptyMessage,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case LoadingWidgetState.loading:
        return const _LoadingView();

      case LoadingWidgetState.success:
        return child;

      case LoadingWidgetState.empty:
        return _StateContent(
          icon: AppImages.icEmpty,
          message: emptyMessage ?? AppLocalizations.of(context)!.no_data,
        );
      case LoadingWidgetState.emptyNotification:
        return _StateContent(
          icon: AppImages.icEmptyNotification,
          message: emptyMessage ?? AppLocalizations.of(context)!.no_data,
        );
      case LoadingWidgetState.emptyShowroom:
        return _StateContent(
          icon: AppImages.icEmptyShowroom,
          message: emptyMessage ?? AppLocalizations.of(context)!.no_data,
        );

      case LoadingWidgetState.error:
        return _StateContent(
          icon: AppImages.icError,
          message: errorMessage ?? AppLocalizations.of(context)!.error_occurred,
          onRetry: onRetry,
        );
    }
  }
}

enum LoadingWidgetState { loading, success, empty, emptyNotification, emptyShowroom, error }

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.color_E11B,
        ),
      ),
    );
  }
}

class _StateContent extends StatelessWidget {
  final String icon;
  final String message;
  final VoidCallback? onRetry;

  const _StateContent({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // if (onRetry != null) ...[
            //   const SizedBox(height: 16),
            //   ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
            // ],
          ],
        ),
      ),
    );
  }
}
