import 'package:flutter/material.dart';

/// Side Navigation bar UserProfile Header class
class UserProfileHeader extends StatelessWidget {
  /// Side Navigation bar UserProfile Constructor
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
        SizedBox(height: 10),
        Text(
          'Welcome User',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
        ),
        Text('user@example.com', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withAlpha(178))),
      ],
    );
  }
}
