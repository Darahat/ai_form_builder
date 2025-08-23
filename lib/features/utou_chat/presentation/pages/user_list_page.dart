import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:ai_form_builder/features/utou_chat/provider/utou_chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// All User Account registered will show
class UserListPage extends ConsumerWidget {
  /// User List Constructor
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersProvider);
    final currentUser = ref.watch(authControllerProvider).uid;
    final logger = ref.watch(appLoggerProvider);
    logger.info(usersAsyncValue.toString());
    logger.info(currentUser.toString());

    return usersAsyncValue.when(
      data: (users) {
        final otherUsers =
            users.where((user) => user.uid != currentUser).toList();
        logger.info('Current Firebase User: ${users.length}');

        return ListView.builder(
          itemCount: otherUsers.length,
          itemBuilder: (context, index) {
            final user = otherUsers[index];
            final displayName = user.name ?? 'No Name';
            // logger.info('Current Firebase User: ${otherUsers.length}');
            logger.info('Is user authenticated: $user');
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child:
                    user.photoURL == null
                        ? Text(displayName.isNotEmpty ? displayName[0] : '')
                        : null,
              ),
              title: Text(displayName),
              onTap: () {
                //  context.push('/uToUChat');
                context.push(
                  '/uToUChat/${user.uid}?name=${Uri.encodeComponent(displayName)}',
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
