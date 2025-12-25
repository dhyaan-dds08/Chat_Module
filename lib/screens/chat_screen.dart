import 'dart:async';

import 'package:chat_module/data/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/config/app_config.dart';
import '../core/services/user_service.dart';
import '../features/chat/bloc/chat_bloc.dart';
import '../features/chat/bloc/chat_event.dart';
import '../features/chat/bloc/chat_state.dart';
import '../widgets/word_defination_bottomsheet.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final UserService _userService = UserService();
  late AppConfig config;
  Timer? _timestampTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    config = AppConfig(context);
  }

  @override
  void initState() {
    super.initState();

    _updateUserLastOnline();
    _timestampTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        _updateUserLastOnline();
      }
    });
  }

  Future<void> _updateUserLastOnline() async {
    try {
      await _userService.updateLastOnline(widget.userId);
      if (mounted) setState(() {});
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update last online: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessage(userId: widget.userId, message: message),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userService.getUserById(widget.userId);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: config.h(8), color: Colors.red),
              SizedBox(height: AppConfig.mediumSpacing),
              Text('User not found', style: config.titleMedium),
              SizedBox(height: AppConfig.smallSpacing),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: AppConfig.avatarSize * 0.8,
              height: AppConfig.avatarSize * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff03FCFE),
                    Color(0xff599BEF),
                    Color.fromARGB(255, 111, 85, 189),
                    Color(0xffB33ADF),
                    Color(0xffE300DD),
                  ],
                  stops: [0.0, 0.05, 0.5, 0.9, 1.0],
                ),
              ),
              child: Center(
                child: Text(
                  user.initial,
                  style: config.titleSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: AppConfig.mediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: config.titleMedium),
                  Text(
                    'Online',
                    style: config.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: config.h(8),
                          color: Colors.red,
                        ),
                        SizedBox(height: AppConfig.mediumSpacing),
                        Text(state.message, style: config.bodyMedium),
                      ],
                    ),
                  );
                }

                if (state is ChatEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/home_icon.svg',
                          width: config.h(8),
                          height: config.h(8),
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: AppConfig.mediumSpacing),
                        Text('No messages yet', style: config.titleMedium),
                        SizedBox(height: AppConfig.smallSpacing),
                        Text(
                          'Say hi to ${user.name}!',
                          style: config.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = state is ChatLoaded
                    ? state.messages
                    : state is MessageSending
                    ? state.messages
                    : <MessageModel>[];

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppConfig.screenPadding),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isSender = message.isSender;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: AppConfig.mediumPadding,
          left: isSender ? config.w(20) : 0,
          right: isSender ? 0 : config.w(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSender) ...[
              Container(
                width: AppConfig.avatarSize * 0.7,
                height: AppConfig.avatarSize * 0.7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff03FCFE),
                      Color(0xff599BEF),
                      Color.fromARGB(255, 111, 85, 189),
                      Color(0xffB33ADF),
                      Color(0xffE300DD),
                    ],
                    stops: [0.0, 0.05, 0.5, 0.9, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    _userService.getUserById(widget.userId)?.initial ?? 'U',
                    style: config.bodySmall?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: AppConfig.smallPadding),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConfig.mediumPadding,
                      vertical: AppConfig.mediumPadding,
                    ),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppConfig.largeRadius),
                        bottomRight: Radius.circular(AppConfig.largeRadius),
                        topLeft: isSender
                            ? Radius.circular(AppConfig.largeRadius)
                            : Radius.circular(AppConfig.smallRadius),
                        topRight: isSender
                            ? Radius.circular(AppConfig.smallRadius)
                            : Radius.circular(AppConfig.largeRadius),
                      ),
                    ),

                    child: SelectableText(
                      message.message,
                      style: config.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSender
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),

                      contextMenuBuilder: (context, editableTextState) {
                        final TextEditingValue value =
                            editableTextState.textEditingValue;
                        final String selectedText = value.selection.textInside(
                          value.text,
                        );

                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: editableTextState.contextMenuAnchors,
                          buttonItems: [
                            if (selectedText.trim().isNotEmpty)
                              ContextMenuButtonItem(
                                label: 'Look up',
                                onPressed: () {
                                  ContextMenuController.removeAny();
                                  _showWordDefinition(
                                    context,
                                    selectedText.trim(),
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppConfig.smallPadding / 2),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: config.labelSmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSender) ...[
              SizedBox(width: AppConfig.smallPadding),
              Container(
                width: AppConfig.avatarSize * 0.7,
                height: AppConfig.avatarSize * 0.7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 111, 85, 189),
                      Color(0xffB33ADF),
                      Color(0xffE300DD),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Y',
                    style: config.bodySmall?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showWordDefinition(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConfig.largeRadius),
        ),
      ),
      builder: (context) => WordDefinitionSheet(word: word),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConfig.mediumPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: config.h(30)),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConfig.pillRadius),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppConfig.mediumPadding,
                      vertical: AppConfig.mediumPadding,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (_) => _sendMessage(context),
                ),
              ),
            ),
            SizedBox(width: AppConfig.mediumPadding),
            SizedBox(
              height: AppConfig.buttonHeight,
              width: AppConfig.buttonHeight,
              child: FloatingActionButton(
                elevation: 0,
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () => _sendMessage(context),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: AppConfig.mediumIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays < 1) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE h:mm a').format(timestamp);
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }
}
