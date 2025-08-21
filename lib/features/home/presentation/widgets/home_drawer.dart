import 'package:ai_form_builder/features/auth/application/auth_state.dart';
import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:ai_form_builder/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// HomeDrawer for side drawer
class HomeDrawer extends ConsumerWidget {
  /// HomeDrawer container
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Drawer(
      // Explicitly set the background color to ensure it's applied
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: Column(
        children: [
          // Custom DrawerHeader with proper background
          Container(
            height: 200, // Standard drawer header height
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.drawerTheme.backgroundColor,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer(
                  builder: (context, ref, _) {
                    final authState = ref.watch(authControllerProvider);
                    if (authState is Authenticated) {
                      final user = authState.user;
                      return Row(
                        children: [
                          // User avatar
                          CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : null,
                            backgroundColor: Colors.grey[300],
                            child:
                                user.photoURL == null
                                    ? const Icon(Icons.person, size: 36)
                                    : null,
                          ),
                          const SizedBox(width: 16),

                          // User name
                          Expanded(
                            child: Text(
                              user.name ?? 'No Name',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),

          // Menu items with proper background
          Expanded(
            child: Container(
              color: theme.drawerTheme.backgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      'Form Builder Chat',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      context.push('/ai_form_builder_chat');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.aiChat,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      context.push('/aiChat');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      "Friends List",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      context.push('/uToUUserListPage');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.settings,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      context.push('/settings');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.home,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      // ref.read(homeControllerProvider.notifier).changeTab(0);
                      // context.pop(); // Close the drawer
                      context.go('/home'); // go back to home
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(
                        context,
                      )!.logout, // Fixed typo from 'Logot'
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).signOut();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
