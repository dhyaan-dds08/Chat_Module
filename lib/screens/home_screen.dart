import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import '../core/config/app_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedTab = ValueNotifier(0);
  final ScrollController _usersScrollController = ScrollController();
  final ValueNotifier<bool> _showAppBar = ValueNotifier(true);

  late AppConfig config;

  @override
  void initState() {
    super.initState();
    _usersScrollController.addListener(_onUsersScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    config = AppConfig(context);
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

  @override
  void dispose() {
    _selectedTab.dispose();
    _usersScrollController.dispose();
    _showAppBar.dispose();
    super.dispose();
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
                  backgroundColor: Color(0xff005acf),
                  shape: CircleBorder(),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add User tapped')),
                    );
                  },
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
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: AppConfig.smallSpacing,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
      ),
      controller: _usersScrollController,
      key: const PageStorageKey<String>('usersListKey'),
      padding: EdgeInsets.all(AppConfig.screenPadding),
      itemCount: 20,
      itemBuilder: (context, index) {
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
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
                    'U${index + 1}',
                    style: config.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
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
          title: Text('User ${index + 1}', style: config.titleMedium),
          subtitle: Text('Online', style: config.bodySmall),
          trailing: Icon(
            Icons.chevron_right,
            size: AppConfig.mediumIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            context.push('/home/chat/$index');
          },
        );
      },
    );
  }

  Widget _buildChatHistoryTab() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: AppConfig.smallSpacing,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
      ),
      key: const PageStorageKey<String>('chatHistoryKey'),
      padding: EdgeInsets.all(AppConfig.screenPadding),
      itemCount: 15,
      itemBuilder: (context, index) {
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
              color: Colors.greenAccent,
            ),
            child: Center(
              child: Text(
                'C${index + 1}',
                style: config.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
          title: Text('Chat ${index + 1}', style: config.titleMedium),
          subtitle: Text('Last message here...', style: config.bodySmall),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${index + 1}h ago',
                style: config.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (index % 3 == 0)
                Container(
                  margin: EdgeInsets.only(top: AppConfig.smallPadding),
                  padding: EdgeInsets.all(AppConfig.smallPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '2',
                    style: config.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped Chat ${index + 1}')));
          },
        );
      },
    );
  }
}
