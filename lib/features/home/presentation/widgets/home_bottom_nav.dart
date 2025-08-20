import 'package:ai_chat/features/home/provider/home_provider.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// HomeBottomNav widget class
class HomeBottomNav extends ConsumerWidget {
  /// HomeBottomNav widget constructor
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(homeControllerProvider.notifier).changeTab(index);
        // Navigate using GoRouter
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/uToUUserListPage');
            break;
          case 2:
            context.go('/aiChat');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),

        // BottomNavigationBarItem(
        //   icon: const Icon(Icons.search),
        //   label: AppLocalizations.of(context)!.search,
        // ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat),
          label: AppLocalizations.of(context)!.aiChat,
        ),
      ],
    );
  }
}
