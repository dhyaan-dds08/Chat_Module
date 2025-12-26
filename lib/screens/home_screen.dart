import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../core/config/app_config.dart';
import '../core/services/user_service.dart';
import '../core/utils/snackbar_utils.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final ValueNotifier<int> _selectedTab = ValueNotifier(0);
  final ScrollController _usersScrollController = ScrollController();
  final ValueNotifier<bool> _showAppBar = ValueNotifier(true);
  final UserService _userService = UserService();

  late AppConfig config;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _usersScrollController.addListener(_onUsersScroll);
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    config = AppConfig(context);
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void _onUsersScroll() {
    if (_selectedTab.value == 0) {
      if (_usersScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showAppBar.value) {
          _showAppBar.value = false;
        }
      } else if (_usersScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showAppBar.value) {
          _showAppBar.value = true;
        }
      }
    }
  }

  void _showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Enter user name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.mediumRadius),
            ),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _addUser(nameController.text.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                _addUser(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addUser(String name) async {
    await _userService.addUser(name);
    if (mounted) {
      setState(() {});
      SnackBarUtil.showSuccess(context, 'User "$name" added');
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _selectedTab.dispose();
    _usersScrollController.dispose();
    _showAppBar.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedTab,
      builder: (context, selectedTab, child) {
        if (selectedTab == 1 && !_showAppBar.value) {
          _showAppBar.value = true;
        }

        return Scaffold(
          body: Column(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _showAppBar,
                builder: (context, showAppBar, child) {
                  if (selectedTab == 0) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: showAppBar
                          ? AppConfig.appBarHeight +
                                MediaQuery.of(context).padding.top
                          : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: showAppBar ? 1.0 : 0.0,
                        child: AppBar(
                          surfaceTintColor: Colors.transparent,
                          toolbarHeight: AppConfig.appBarHeight,
                          backgroundColor: Theme.of(
                            context,
                          ).scaffoldBackgroundColor,
                          title: _buildTabSwitcher(),
                          centerTitle: true,
                          elevation: 0,
                        ),
                      ),
                    );
                  } else {
                    return AppBar(
                      surfaceTintColor: Colors.transparent,
                      toolbarHeight: AppConfig.appBarHeight,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      title: _buildTabSwitcher(),
                      centerTitle: true,
                      elevation: 0,
                    );
                  }
                },
              ),
              Expanded(
                child: selectedTab == 0
                    ? _buildUsersListTab()
                    : _buildChatHistoryTab(),
              ),
            ],
          ),
          floatingActionButton: selectedTab == 0
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: const CircleBorder(),
                  onPressed: _showAddUserDialog,
                  child: Icon(
                    Icons.add,
                    size: AppConfig.mediumIconSize,
                    color: Colors.white,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: AppConfig.tabSwitcherHeight,
      padding: EdgeInsets.all(AppConfig.smallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConfig.pillRadius),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedTab,
        builder: (context, selectedTab, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabButton('Users', 0, selectedTab),
              _buildTabButton('Chat History', 1, selectedTab),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String label, int index, int selectedTab) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => _selectedTab.value = index,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: config.w(6),
          vertical: AppConfig.largePadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConfig.pillRadius),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: config.bodyMedium?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUsersListTab() {
    final users = _userService.getAllUsers();

    if (users.isEmpty) {
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
            Text(
              'No users yet',
              style: config.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppConfig.smallSpacing),
            Text(
              'Tap the + button to add your first user',
              style: config.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: AppConfig.smallSpacing,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
      ),
      controller: _usersScrollController,
      key: const PageStorageKey<String>('usersListKey'),
      padding: EdgeInsets.only(
        left: AppConfig.screenPadding,
        right: AppConfig.screenPadding,
        bottom: AppConfig.screenPadding,
        top: AppConfig.screenPadding,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConfig.mediumPadding,
            vertical: AppConfig.smallPadding,
          ),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppConfig.avatarSize,
                height: AppConfig.avatarSize,
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
                    style: config.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              if (user.isOnline)
                Positioned(
                  bottom: -AppConfig.smallPadding / 3,
                  right: -AppConfig.smallPadding / 3,
                  child: Container(
                    width: AppConfig.smallIconSize,
                    height: AppConfig.smallIconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            user.name,
            style: config.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            user.isOnline ? 'Online' : user.lastSeenText,
            style: config.bodySmall,
          ),

          onTap: () {
            context.push('/home/chat/${user.id}');
          },
        );
      },
    );
  }

  Widget _buildChatHistoryTab() {
    final chatHistory = _userService.getChatHistory();

    if (chatHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: config.h(8),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppConfig.mediumSpacing),
            Text(
              'No chats yet',
              style: config.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppConfig.smallSpacing),
            Text(
              'Start a conversation with a user',
              style: config.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: AppConfig.smallSpacing,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
      ),
      key: const PageStorageKey<String>('chatHistoryKey'),
      padding: EdgeInsets.all(AppConfig.screenPadding),
      itemCount: chatHistory.length,
      itemBuilder: (context, index) {
        final item = chatHistory[index];
        final user = item.user;
        final lastMessage = item.lastMessage;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConfig.mediumPadding,
            vertical: AppConfig.smallPadding,
          ),
          leading: Container(
            width: AppConfig.avatarSize,
            height: AppConfig.avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.greenAccent, Colors.green],
                stops: [0.0, 1.0],
              ),
            ),
            child: Center(
              child: Text(
                user.initial,
                style: config.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          title: Text(
            user.name,
            style: config.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            lastMessage?.message ?? 'No messages yet',
            style: config.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.timeText,
                style: config.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (item.unreadCount > 0)
                Container(
                  margin: EdgeInsets.only(top: AppConfig.smallPadding),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConfig.smallPadding * 1.5,
                    vertical: AppConfig.smallPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppConfig.pillRadius),
                  ),
                  child: Text(
                    '${item.unreadCount}',
                    style: config.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () async {
            await context.push('/home/chat/${user.id}');
            if (mounted) setState(() {});
          },
        );
      },
    );
  }
}
