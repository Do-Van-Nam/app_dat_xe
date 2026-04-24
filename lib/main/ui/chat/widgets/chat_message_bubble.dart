import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/chat_room.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String userId;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe(userId);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.color1A56DB : AppColors.colorF3F3F6,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: isMe
                  ? AppStyles.inter14Medium.copyWith(color: Colors.white)
                  : AppStyles.inter14Medium,
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: AppStyles.inter10Regular.copyWith(
                color: isMe ? Colors.white70 : AppColors.color999999,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
