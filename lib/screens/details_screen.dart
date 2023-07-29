// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/album_card.dart';
import 'package:test_app/components/post_card.dart';

import 'package:test_app/models/post.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/screens/all_posts.dart';

class DetailsScreen extends StatelessWidget {
  final User user;
  const DetailsScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              Text(user.email),
              Text(user.phone),
              Text(user.website),
              Text(user.company.name),
              Text(user.company.bs),
              Text(user.company.catchPhrase),
              Text(
                  '${user.address.city} ${user.address.street}${user.address.suite}'),
              const SizedBox(height: 12),
              PostCard(user: user),
              const SizedBox(height: 12),
              AlbumCard(user: user)
            ],
          ),
        ),
      ),
    );
  }
}
