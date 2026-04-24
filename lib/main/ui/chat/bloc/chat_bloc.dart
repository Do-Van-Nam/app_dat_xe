import 'dart:async';

import 'package:demo_app/main/data/model/ride/chat_room.dart';
// chat_bloc.dart
import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String rideId;
  late StreamSubscription _sub;
  final DriverSocketService _driverSocketService = DriverSocketService();
  ChatBloc({required this.rideId}) : super(ChatState()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessageReceived);

    _driverSocketService.joinRide(rideId);
    _sub = _driverSocketService.onRideEvent.listen((data) {
      if (data['event'] == 'communication.chat.message.sent') {
        final dataMap = data["data"]["message"] as Map<String, dynamic>? ?? {};
        final message = ChatMessage.fromJson(dataMap);
        add(NewMessageReceived(message));
      }
    });
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await SharePreferenceUtil.getUser();
      final userId = (user?.id ?? "0").toString();
      final (isSuccess, chatRoom) = await RideRepository().getChatRoom(rideId);

      if (isSuccess) {
        print("emit load messages success");
        emit(state.copyWith(
            messages: chatRoom?.messages ?? [],
            isLoading: false,
            userId: userId));
      } else {
        print("emit load messages fail");
        emit(state.copyWith(messages: [], isLoading: false, userId: userId));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: UniqueError("Không tải được tin nhắn")));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    if (event.content.trim().isEmpty) return;

    try {
      final (isSuccess, message) =
          await RideRepository().sendMessage(rideId, event.content);

      if (isSuccess && message != null) {
        print("emit send message success");
        emit(state.copyWith(messages: [...state.messages, message]));
      } else {
        print("emit send message fail");
        emit(state.copyWith(
            isLoading: false, error: UniqueError("Không gửi được tin nhắn")));
      }
    } catch (e) {
      print("emit send message fail: $e");
      emit(state.copyWith(
          isLoading: false, error: UniqueError("Không gửi được tin nhắn")));
    }

    // // TODO: Gọi API gửi tin nhắn
    // await Future.delayed(const Duration(milliseconds: 500));

    // // Giả lập tin nhắn trả lời
    // final reply = ChatMessage(
    //   id: DateTime.now().millisecondsSinceEpoch + 1,
    //   content: "Cảm ơn bạn đã nhắn tin!",
    //   isMe: false,
    //   time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
    // );
    // emit(state.copyWith(messages: [...state.messages, reply]));
  }

  void _onNewMessageReceived(
      NewMessageReceived event, Emitter<ChatState> emit) {
    print("senderid: ${event.message.senderId}");
    print("userid: ${state.userId}");
    print("isMe: ${event.message.isMe(state.userId ?? "")}");
    if (event.message.isMe(state.userId ?? "") ||
        (Constant.isUserApp && event.message.senderType == 1) ||
        (!Constant.isUserApp && event.message.senderType == 2)) {
      print("skip new message received");
      return;
    }
    print("emit new message received");
    emit(state.copyWith(messages: [...state.messages, event.message]));
  }

  @override
  Future<void> close() {
    _sub.cancel(); // ⚠️ bắt buộc
    return super.close();
  }
}
