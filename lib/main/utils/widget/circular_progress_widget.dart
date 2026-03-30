import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/utils/constant.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:flutter/material.dart';

class CircularProgressCustom extends StatelessWidget {
  final double usedData;
  final double totalData;
  final String unit;

  const CircularProgressCustom({
    super.key,
    required this.usedData,
    required this.totalData, required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double progress = usedData / totalData;

    return SizedBox(
      width: 112,
      height: 112,
      child: CustomPaint(
        painter: _CircularProgressPainter(progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${Constant.formatNumber(usedData)} $unit",
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.color_1818,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.used,
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.color_1818,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = AppColors.color_E11B
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      -sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
