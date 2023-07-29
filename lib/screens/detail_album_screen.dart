import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/album.dart';
import 'package:test_app/models/photo.dart';

class DetailAlbumScreen extends StatefulWidget {
  final Album album;
  const DetailAlbumScreen({super.key, required this.album});

  @override
  State<DetailAlbumScreen> createState() => _DetailAlbumScreenState();
}

class _DetailAlbumScreenState extends State<DetailAlbumScreen> {
  late final Future<List<Photo>> _future;
  @override
  void initState() {
    _future = getPhoto();
    super.initState();
  }

  final dio = Dio();

  Future<List<Photo>> getPhoto() async {
    final response = await dio.get(
        'https://jsonplaceholder.typicode.com/photos/?albumId=${widget.album.id}');
    final listUser = response.data as List;
    return listUser.map((e) => Photo.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.album.title)),
      body: FutureBuilder<List<Photo>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data![index].url,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Text(snapshot.data![index].title)
                    ],
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
