import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoMarqueeText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const AutoMarqueeText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính chiều rộng chữ
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.width;
        final availableWidth = constraints.maxWidth;

        if (textWidth > availableWidth) {
          // Chạy marquee nếu chữ dài hơn container
          return SizedBox(
            height: style.fontSize! * 1.2, // chiều cao cho chữ
            child: Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              blankSpace: 20,
              velocity: 30,
              startAfter: Duration(seconds: 1),
              pauseAfterRound: Duration(seconds: 1),
            ),
          );
        } else {
          // Nếu không dài thì hiển thị Text bình thường
          return Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        }
      },
    );
  }
}