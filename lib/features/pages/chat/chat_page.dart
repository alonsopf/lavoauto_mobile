import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/chat_bloc.dart';
import 'package:lavoauto/data/models/chat_message_model.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final int orderId;
  final String otherUserName;
  final String? otherUserPhotoUrl;
  final String currentUserType; // "client" or "lavador"

  const ChatPage({
    super.key,
    required this.orderId,
    required this.otherUserName,
    this.otherUserPhotoUrl,
    required this.currentUserType,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  final List<int> _unreadMessageIds = [];
  Timer? _refreshTimer;

  // Quick reply options
  final List<String> quickReplies = [
    "Voy en camino",
    "He llegado",
    "¿Podemos",
  ];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    context.read<ChatBloc>().add(InitializeChatEvent(widget.orderId));

    // Auto-refresh messages every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Only refresh if the widget is still mounted
      if (mounted) {
        context.read<ChatBloc>().add(RefreshMessagesEvent());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
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

  void _sendQuickReply(String text) {
    context.read<ChatBloc>().add(SendMessageEvent(text));
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
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            // Profile photo
            if (widget.otherUserPhotoUrl != null && widget.otherUserPhotoUrl!.isNotEmpty)
              ClipOval(
                child: Image.network(
                  widget.otherUserPhotoUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.borderGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    );
                  },
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
            const SizedBox(height: 4),
            Text(
              widget.currentUserType == 'lavador' ? 'Cliente' : 'Lavador',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
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
                backgroundColor: AppColors.error,
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
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNew),
                      ),
                    );
                  } else if (state is ChatMessagesLoadedState) {
                    final messages = state.messages;

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'Inicia la conversación',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isCurrentUser = message.senderType == widget.currentUserType;
                        return _MessageBubble(
                          message: message,
                          isCurrentUser: isCurrentUser,
                        );
                      },
                    );
                  } else if (state is ChatErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(InitializeChatEvent(widget.orderId));
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

            // Quick replies
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: quickReplies.map((reply) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.borderGrey, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: () => _sendQuickReply(reply),
                        child: Text(
                          reply,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Input area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.borderGrey.withOpacity(0.3)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje',
                          hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.bgColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 22,
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

  const _MessageBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(message.createdAtDateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primaryNew.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrentUser
                    ? AppColors.primaryNew.withOpacity(0.3)
                    : AppColors.borderGrey.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message.messageText,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCurrentUser && message.isRead) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    size: 14,
                    color: AppColors.primaryNew,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
