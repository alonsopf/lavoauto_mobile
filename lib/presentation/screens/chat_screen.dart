import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/chat_bloc.dart';
import 'package:lavoauto/data/models/chat_message_model.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int orderId;
  final String otherUserName;
  final String? otherUserPhotoUrl;
  final String currentUserType; // "client" or "lavador"

  const ChatScreen({
    Key? key,
    required this.orderId,
    required this.otherUserName,
    this.otherUserPhotoUrl,
    required this.currentUserType,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  final List<int> _unreadMessageIds = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    // Initialize chat
    context.read<ChatBloc>().add(InitializeChatEvent(widget.orderId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(SendMessageEvent(text));
    _messageController.clear();
  }

  void _markMessagesAsRead(List<ChatMessage> messages) {
    if (_unreadMessageIds.isEmpty) return;

    context.read<ChatBloc>().add(
          MarkMessagesAsReadEvent(_unreadMessageIds),
        );

    _unreadMessageIds.clear();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherUserName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'En línea',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatMessageSentState) {
            _scrollToBottom();
          } else if (state is ChatMessagesLoadedState) {
            _scrollToBottom();
          } else if (state is ChatErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatMessagesLoadedState) {
                    final messages = state.messages;

                    // Mark unread messages as read
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _markMessagesAsRead(messages);
                    });

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text('Inicia la conversación'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isCurrentUser =
                            message.senderType == widget.currentUserType;

                        return _MessageBubble(
                          message: message,
                          isCurrentUser: isCurrentUser,
                          otherUserPhotoUrl: widget.otherUserPhotoUrl,
                        );
                      },
                    );
                  } else if (state is ChatErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ChatBloc>()
                                  .add(InitializeChatEvent(widget.orderId));
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            // Input area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribe tu mensaje...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
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
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final String? otherUserPhotoUrl;

  const _MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.otherUserPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.createdAtDateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            if (otherUserPhotoUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    otherUserPhotoUrl!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 16),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    message.messageText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (isCurrentUser && message.isRead)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.done_all,
                            size: 14,
                            color: Colors.blue.shade300,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
