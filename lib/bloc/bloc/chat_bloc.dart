import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavoauto/data/models/chat_message_model.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  String? _currentHashId;
  List<ChatMessage> _cachedMessages = [];

  ChatBloc({required this.chatRepository}) : super(const ChatInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesAsReadEvent>(_onMarkMessagesAsRead);
    on<RefreshMessagesEvent>(_onRefreshMessages);
  }

  // Initialize chat for an order
  Future<void> _onInitializeChat(
    InitializeChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoadingState());

    try {
      final response = await chatRepository.getOrCreateChatHash(event.orderId);
      _currentHashId = response.hashId;
      _cachedMessages = [];

      emit(ChatInitializedState(
        hashId: response.hashId,
        orderId: response.orderId,
      ));

      // Load initial messages
      add(const LoadMessagesEvent());
    } on Exception catch (e) {
      emit(ChatErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Load messages from chat
  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentHashId == null) {
      emit(const ChatErrorState('Chat not initialized'));
      return;
    }

    try {
      final response = await chatRepository.getMessages(
        _currentHashId!,
        limit: event.limit,
        offset: event.offset,
      );

      _cachedMessages = response.messages;

      emit(ChatMessagesLoadedState(
        messages: response.messages,
        total: response.total,
        hashId: _currentHashId!,
      ));
    } on Exception catch (e) {
      emit(ChatErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Send a message
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentHashId == null) {
      emit(const ChatErrorState('Chat not initialized'));
      return;
    }

    try {
      final response = await chatRepository.sendMessage(
        _currentHashId!,
        event.messageText,
      );

      // Create ChatMessage from response
      final newMessage = ChatMessage(
        messageId: response.messageId,
        chatId: 0, // Will be fetched when loading messages
        senderId: 0, // Will be fetched when loading messages
        senderType: 'client', // Current user type will be determined by context
        messageText: event.messageText,
        createdAt: response.createdAt,
        isRead: response.isRead,
      );

      emit(ChatMessageSentState(newMessage));

      // Refresh messages to get latest state
      add(const RefreshMessagesEvent());
    } on Exception catch (e) {
      emit(ChatErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Mark messages as read
  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentHashId == null) {
      return;
    }

    try {
      final response = await chatRepository.markMessagesAsRead(
        _currentHashId!,
        event.messageIds,
      );

      emit(ChatMessageReadState(response.updated));
    } on Exception catch (e) {
      // Don't emit error, just log it
      print('Error marking messages as read: $e');
    }
  }

  // Refresh messages
  Future<void> _onRefreshMessages(
    RefreshMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentHashId == null) {
      return;
    }

    try {
      final response = await chatRepository.getMessages(
        _currentHashId!,
        limit: 50,
        offset: 0,
      );

      _cachedMessages = response.messages;

      emit(ChatMessagesLoadedState(
        messages: response.messages,
        total: response.total,
        hashId: _currentHashId!,
      ));
    } on Exception catch (e) {
      print('Error refreshing messages: $e');
    }
  }

  String? get currentHashId => _currentHashId;
  List<ChatMessage> get cachedMessages => _cachedMessages;
}
