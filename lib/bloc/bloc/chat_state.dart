part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

class ChatInitializedState extends ChatState {
  final String hashId;
  final int orderId;

  const ChatInitializedState({
    required this.hashId,
    required this.orderId,
  });

  @override
  List<Object?> get props => [hashId, orderId];
}

class ChatMessagesLoadedState extends ChatState {
  final List<ChatMessage> messages;
  final int total;
  final String hashId;

  const ChatMessagesLoadedState({
    required this.messages,
    required this.total,
    required this.hashId,
  });

  @override
  List<Object?> get props => [messages, total, hashId];
}

class ChatMessageSentState extends ChatState {
  final ChatMessage message;

  const ChatMessageSentState(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageReadState extends ChatState {
  final int updatedCount;

  const ChatMessageReadState(this.updatedCount);

  @override
  List<Object?> get props => [updatedCount];
}

class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatErrorWithRetryState extends ChatState {
  final String message;
  final Function onRetry;

  const ChatErrorWithRetryState({
    required this.message,
    required this.onRetry,
  });

  @override
  List<Object?> get props => [message];
}
