import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/chat/bloc/chat_bloc.dart';
import 'package:demo_app/main/ui/chat/widgets/chat_appbar.dart';
import 'package:demo_app/main/ui/chat/widgets/chat_input.dart';
import 'package:demo_app/main/ui/chat/widgets/chat_message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.rideId});
  final String rideId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(rideId: widget.rideId)..add(LoadMessages()),
      child: _ChatView(controller: _messageController), // 👈 truyền xuống
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const ChatAppBar(),
      body: Column(
        children: [
          /// MESSAGE LIST
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      "Chưa có tin nhắn", // 👈 fix lỗi string
                      style: AppStyles.inter14Medium
                          .copyWith(color: AppColors.color999999),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        state.messages[state.messages.length - 1 - index];

                    return ChatMessageBubble(
                      message: message,
                      userId: state.userId ?? "0",
                    );
                  },
                );
              },
            ),
          ),

          /// INPUT
          ChatInputField(
            controller: controller,
            onSend: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              context.read<ChatBloc>().add(SendMessage(text));
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
