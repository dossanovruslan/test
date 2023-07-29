import 'package:flutter/material.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/screens/details_screen.dart';

class UserCard extends StatelessWidget {
  final User user;
  final int index;
  const UserCard({
    super.key,
    required this.user,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailsScreen(user: user),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Text('${index + 1}) ${user.username} ${user.name}'),
      ),
    );
  }
}
