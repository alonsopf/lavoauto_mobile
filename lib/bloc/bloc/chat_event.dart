part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatEvent extends ChatEvent {
  final int orderId;

  const InitializeChatEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class SendMessageEvent extends ChatEvent {
  final String messageText;

  const SendMessageEvent(this.messageText);

  @override
  List<Object?> get props => [messageText];
}

class LoadMessagesEvent extends ChatEvent {
  final int limit;
  final int offset;

  const LoadMessagesEvent({this.limit = 50, this.offset = 0});

  @override
  List<Object?> get props => [limit, offset];
}

class MarkMessagesAsReadEvent extends ChatEvent {
  final List<int> messageIds;

  const MarkMessagesAsReadEvent(this.messageIds);

  @override
  List<Object?> get props => [messageIds];
}

class RefreshMessagesEvent extends ChatEvent {
  const RefreshMessagesEvent();

  @override
  List<Object?> get props => [];
}
