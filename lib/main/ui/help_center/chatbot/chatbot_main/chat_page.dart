import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/model/chatbot/button_callback_model.dart';
import 'package:demo_app/main/data/model/chatbot/button_callback_data_item_model.dart';
import 'package:demo_app/main/data/model/chatbot/chatbot_data_model.dart';
import 'package:demo_app/main/utils/utility_fuctions.dart';
import 'package:demo_app/main/utils/widget/image_widget.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'chat_bloc.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/generated/app_localizations.dart';

class ChatBotPage extends StatefulWidget {
  final String? initialMessage;

  const ChatBotPage({super.key, this.initialMessage});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) =>
          ChatBloc()
            ..add(InitChatEvent(widget.initialMessage ?? l10n.chatbotStart)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 550,
          leading: Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(AppImages.icBack, width: 24, height: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(AppImages.imgChatBot5),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.chatbotTitle, style: AppStyles.headerWhite),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        l10n.online,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Overlay mờ khi mở menu

                // Background chat
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImages.chatbotBG, fit: BoxFit.fitWidth),
                ),

                // Nội dung chat chính
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Danh sách tin nhắn + input...
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                state.messages.length +
                                (state.isTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.messages.length &&
                                  state.isTyping) {
                                return _buildBotTyping();
                              }
                              final msg = state.messages[index];
                              return _buildMessageBubble(msg, context);
                            },
                          ),
                        ),

                        _buildInputField(context, state),
                      ],
                    ),
                  ),
                ),
                if (state.isOpenMenu)
                  GestureDetector(
                    onTap: () {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<ChatBloc>().add(ToggleMenuEvent());
                      // });
                    },
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),

                // Menu trắng
                if (state.isOpenMenu)
                  Positioned(
                    bottom: 40, // Khoảng cách từ FAB
                    left: 16,
                    child: Material(
                      // Thêm Material để shadow hoạt động tốt hơn
                      elevation: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(
                              iconPath: AppImages.icMenuRed,
                              label: l10n.mainMenu,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.mainMenu,
                                      "main_menu",
                                      "wsGetMenu",
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                });
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icLogin,
                              label: l10n.changePhoneNumberLogin,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.changePhoneNumberLogin,
                                      "change_phone_number",
                                      "wsGetMenu",
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.changePhoneNumberLogin,
                                      "change_phone_number",
                                      "reset-user",
                                      userMessage: false,
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                });
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icMessage,
                              label: l10n.newChat,
                              onTap: () async {
                                final completer = Completer();
                                context.read<ChatBloc>().add(
                                  ResetChatEvent(completer: completer),
                                );

                                await completer
                                    .future; // Đợi cho đến khi Bloc xử lý xong Reset

                                context.read<ChatBloc>().add(
                                  SendMessageEvent(
                                    l10n.chatbotStart,
                                    "new_chat",
                                    "wsGetMenu",
                                  ),
                                );
                                context.read<ChatBloc>().add(ToggleMenuEvent());

                                if (_controller.text.trim().isNotEmpty) {
                                  _controller.clear();
                                }
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icCall,
                              label: l10n.callTheStaffs,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                  makePhoneCall("1204");
                                });
                                print('Gọi nhân viên');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatbotData msg, BuildContext context) {
    developer.log(msg.buttonCallbackDataList.length.toString());
    List<String> images = [
      AppImages.icKhmer,
      AppImages.icEng,
      AppImages.icChina,
    ];
    return msg.isBot
        // tra loi cua bot
        ? Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // noi dung tra loi cua bot
                  Row(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AppImages.imgChatBot5),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 6,
                              left: -2,
                              child: SvgPicture.asset(AppImages.icBotChatTail),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.color_F7F7,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.answer ?? msg.descriptionButton,
                                      style: AppStyles.poppins12Regular
                                          .copyWith(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Align(
                                      alignment: AlignmentGeometry.centerRight,
                                      child:
                                          // Spacer(),
                                          Text(
                                            '${msg.datetime!.hour}:${msg.datetime!.minute.toString().padLeft(2, '0')}',
                                            style: AppStyles.poppins12Regular
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: AppColors.color_AEAE,
                                                ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // cac nut lua chon
                  msg.buttonCallbackDataList.isNotEmpty
                      ?
                        // chi co 1 nhom nut
                        msg.buttonCallbackDataList.length == 1
                            ?
                              // neu la lua chon ngon ngu
                              msg.id == "11" ||
                                      msg.callbackData == "list_language"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 48.0,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          spacing: 12,
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(3, (index) {
                                            return Container(
                                              width: 100,
                                              child: _buildBotButton(
                                                msg
                                                    .buttonCallbackDataList[0]
                                                    .buttonCallBacks[index],
                                                context,
                                                false,
                                                true,
                                                images[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 48.0,
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double width = constraints.maxWidth;
                                          List<ButtonCallback> buttons = msg
                                              .buttonCallbackDataList[0]
                                              .buttonCallBacks;
                                          int itemCount = buttons.length;

                                          return Column(
                                            spacing: 8,
                                            children: List.generate(itemCount, (
                                              index,
                                            ) {
                                              // Kiểm tra nếu là phần tử cuối cùng và tổng số lượng là số lẻ
                                              bool isLastAndOdd =
                                                  (index == itemCount - 1) &&
                                                  (itemCount % 2 != 0);

                                              return isLastAndOdd
                                                  ? Container(
                                                      width: isLastAndOdd
                                                          ? width
                                                          : width /
                                                                2, // Nếu lẻ thì rộng 100%, ngược lại 50%

                                                      child: _buildBotButton(
                                                        buttons[index],
                                                        context,
                                                      ),
                                                    )
                                                  : index <
                                                        (itemCount + 1) / 2 - 1
                                                  ? IntrinsicHeight(
                                                      child: Row(
                                                        spacing: 8,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                _buildBotButton(
                                                                  buttons[2 *
                                                                      index],
                                                                  context,
                                                                ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                _buildBotButton(
                                                                  buttons[2 *
                                                                          index +
                                                                      1],
                                                                  context,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox();
                                            }),
                                          );
                                        },
                                      ),
                                    )
                            // co nhieu hon 1 nhom nut
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                //height: 250,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    SizedBox(width: 48),
                                    ...List.generate(
                                      msg.buttonCallbackDataList.length,
                                      (index) {
                                        return _buildGroupBotButton(
                                          msg.buttonCallbackDataList[index],
                                          context,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                      : SizedBox(),
                  // cau hoi goi y
                  msg.suggestionQuestion?.isNotEmpty ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(left: 48.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double width = constraints.maxWidth;
                              List<String> buttons = msg.suggestionQuestion!;
                              int itemCount = buttons.length;

                              return Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                alignment: WrapAlignment.start,
                                children: List.generate(itemCount, (index) {
                                  ButtonCallback temp = ButtonCallback(
                                    buttonName: buttons[index],
                                    callbackData: "callbackData",
                                    type: "type",
                                    isCallLinkIfLogin: "isCallLinkIfLogin",
                                  );

                                  return SizedBox(
                                    width: width,
                                    child: _buildBotButton(temp, context, true),
                                  );
                                }),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          )
        :
          // tin nhan cua nguoi dung
          Align(
            alignment: Alignment.centerRight,
            child: Stack(
              children: [
                Positioned(
                  bottom: 6,
                  right: -2,
                  child: SvgPicture.asset(AppImages.icUserChatTail),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        msg.descriptionButton,
                        style: AppStyles.poppins12Regular.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${msg.datetime!.hour}:${msg.datetime!.minute.toString().padLeft(2, '0')}',
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 10,
                              color: AppColors.color_AEAE,
                            ),
                          ),
                          SvgPicture.asset(AppImages.icdoubleCheck),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildBotButton(
    ButtonCallback buttonCallback,
    BuildContext context, [
    bool isQuestion = false,
    bool isLanguageBtn = false,
    String? languageImg,
  ]) {
    bool hasUrl = buttonCallback.iconNameAddress != null;
    return GestureDetector(
      onTap: () {
        isQuestion
            ? context.read<ChatBloc>().add(
                SendMessageFromInputEvent(buttonCallback.buttonName),
              )
            : context.read<ChatBloc>().add(
                SendMessageEvent(
                  buttonCallback.buttonName,
                  buttonCallback.callbackData,
                  "wsGetMenu",
                ),
              );
      },
      child: Container(
        // margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: isLanguageBtn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  CircleAvatar(
                    child:
                        // SafeImage(
                        //   url: buttonCallback.iconNameAddress,
                        //   placeholder: AppImages.imgEntertainmentDefault,
                        //   errorAsset: AppImages.imgEntertainmentDefault,
                        // ),
                        SvgPicture.asset(
                          languageImg ?? " ",
                          width: 36,
                          height: 36,
                        ),
                  ),
                  Text(
                    buttonCallback.buttonName,
                    style: AppStyles.poppins12Regular.copyWith(fontSize: 14),
                  ),
                ],
              )
            : Center(
                child: Text(
                  buttonCallback.buttonName,
                  textAlign: TextAlign.center,
                  style: AppStyles.poppins12Regular.copyWith(fontSize: 14),
                ),
              ),
      ),
    );
  }

  Widget _buildGroupBotButton(
    ButtonCallbackDataItem item,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: 240, // Độ rộng phù hợp (có thể điều chỉnh theo màn hình)
            // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            // padding: const EdgeInsets.all(16),
            height: 350,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.color_FFFD, AppColors.color_FFEE],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.colorMain),
                  child: Center(
                    child: Text(
                      item.title ?? "--",
                      style: AppStyles.poppins14Medium.copyWith(
                        fontSize: 16,
                        color: AppColors.color_5F5F,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ...item.buttonCallBacks.map((btn) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 16,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.read<ChatBloc>().add(
                                  SendMessageEvent(
                                    btn.buttonName,
                                    btn.callbackData,
                                    "wsGetMenu",
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppImages
                                        .icCheck2, // Icon tick đỏ trong hình
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Text(
                                      btn.buttonName,
                                      style: AppStyles.poppins12Regular,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -20,
            left: 60,
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.colorMain,
                borderRadius: BorderRadius.circular(1000),
                border: BoxBorder.all(color: AppColors.color_5F5F, width: 2),
              ),
              child: Image.asset(
                AppImages
                    .imgMetfoneTxt, // Thay bằng đường dẫn asset thật của bạn
                // height: 40,
                width: 40,
                fit: BoxFit.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotTyping() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.imgChatBot5),
          Container(
            // width: 50,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Container(
                  margin: EdgeInsets.only(right: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context, ChatState state) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // Nút menu: hình tròn xám mờ
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.color_F7F7, // xám mờ
            ),
            child: IconButton(
              icon: SvgPicture.asset(AppImages.icMenu, width: 24, height: 24),
              onPressed: () {
                context.read<ChatBloc>().add(ToggleMenuEvent());
              },
              padding: const EdgeInsets.all(12), // Tăng padding để nút to hơn
              constraints: const BoxConstraints(),
            ),
          ),

          const SizedBox(width: 12),

          // Container bo góc chứa TextField + nút gửi
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.color_F7F7, // Nền xám nhạt/mờ
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.only(
                top: 4,
                right: 4,
                bottom: 4,
                left: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Write your message',
                        border: InputBorder.none, // Bỏ viền mặc định
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty && !state.isTyping) {
                          developer.log("nhap input va gui");
                          print("nhap input va gui");
                          context.read<ChatBloc>().add(
                            SendMessageFromInputEvent(value.trim()),
                          );
                          _controller.clear();
                        }
                      },
                    ),
                  ),

                  // Nút gửi nằm trong cùng Container
                  FloatingActionButton(
                    mini: true, // Kích thước nhỏ hơn
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    elevation: 0, // Bỏ bóng để hòa hợp với nền mờ
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty &&
                          !state.isTyping) {
                        context.read<ChatBloc>().add(
                          SendMessageFromInputEvent(_controller.text.trim()),
                        );
                        _controller.clear();
                      }
                    },
                    child: SvgPicture.asset(
                      AppImages.icSend,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
