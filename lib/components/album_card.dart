import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/album.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/screens/all_albums.dart';

class AlbumCard extends StatefulWidget {
  final User user;
  const AlbumCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  late final Future<List<Album>> _future;
  @override
  void initState() {
    _future = getPosts();
    super.initState();
  }

  final dio = Dio();

  Future<List<Album>> getPosts() async {
    final response = await dio.get(
        'https://jsonplaceholder.typicode.com/albums/?userId=${widget.user.id}');
    final posts = response.data as List;
    return posts.map((e) => Album.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Album>>(
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
                    'Альбомы',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data![index].title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AllAlbumsScreen(albums: snapshot.data ?? []),
                      ),
                    ),
                    child: const Text(
                      'Посмотреть все альбомы',
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
