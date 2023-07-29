import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/post.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/screens/all_posts.dart';

class PostCard extends StatefulWidget {
  final User user;
  const PostCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final Future<List<Post>> _future;
  @override
  void initState() {
    _future = getPosts();
    super.initState();
  }

  final dio = Dio();

  Future<List<Post>> getPosts() async {
    final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts/?userId=${widget.user.id}');
    final posts = response.data as List;
    return posts.map((e) => Post.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Посты',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    itemCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index + 1})  ${snapshot.data![index].title}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            snapshot.data![index].body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPostsScreen(posts: snapshot.data ?? []),
                      ),
                    ),
                    child: const Text(
                      'Посмотреть все посты',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }
}
