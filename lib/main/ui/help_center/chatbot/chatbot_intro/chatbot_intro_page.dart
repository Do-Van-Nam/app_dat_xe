import 'package:demo_app/app.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/main/utils/widget/common_widgets.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'chatbot_intro_bloc.dart';

class ChatbotIntroPage extends StatelessWidget {
  const ChatbotIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ChatbotIntroBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(AppImages.icBack, width: 24, height: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.chatbotTitle, // "CamID ChatBot"
            style: AppStyles.headerWhite,
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ChatbotIntroBloc, ChatbotIntroState>(
          listener: (context, state) {
            if (state is ChatbotIntroSuccess) {
              String extra = state.startNew ? l10n.chatbotStart : "continue";
              print("extra: ${extra}");
              context.push(
                PATH_CHATBOT,
                extra: state.startNew ? l10n.chatbotStart : "continue",
              );
            }
            if (state is ChatbotIntroError) {
              AppToast.show(context, state.message);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    AppImages.chatbotBG, // Ảnh nền của bạn
                    fit: BoxFit
                        .fitWidth, // Giữ tỷ lệ, chỉ rộng full, cao theo tỷ lệ gốc
                    // Hoặc dùng BoxFit.none để giữ nguyên kích thước pixel gốc 100%
                    // fit: BoxFit.none,
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Mascot Robot (thay bằng ảnh asset thật sau)
                      Image.asset(
                        AppImages.chatbot, // Bạn thêm ảnh robot vào assets
                        height: 500,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 40),

                      // Bubble chào mừng
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.chatbotGreeting, // "How may I help you today!"
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.chatbotDescription, // "This AI chatbot is for customer service, wishing to support customers in the best way!"
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),

                            // Nút Start (đỏ)
                            commonButton(
                              text: l10n.chatbotStart,
                              color: Colors.red,
                              textColor: Colors.white,
                              isLoading: state is ChatbotIntroLoading,
                              onPressed: () => context
                                  .read<ChatbotIntroBloc>()
                                  .add(StartChatEvent()),
                            ),
                            const SizedBox(height: 16),
                            commonButton(
                              text: l10n.chatbotContinue,
                              color: Colors.black,
                              textColor: Colors.white,
                              isLoading: state is ChatbotIntroLoading,
                              onPressed: state is ChatbotIntroLoading
                                  ? null
                                  : () => context.read<ChatbotIntroBloc>().add(
                                      ContinueChatEvent(),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
