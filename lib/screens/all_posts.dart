import 'package:flutter/material.dart';
import 'package:test_app/models/post.dart';
import 'package:test_app/screens/post_comments_screen.dart';

class AllPostsScreen extends StatelessWidget {
  final List<Post> posts;
  const AllPostsScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(post: posts[index]),
                  ),
                ),
                child: Text(
                  "${index + 1})  ${posts[index].title}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                posts[index].body,
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
