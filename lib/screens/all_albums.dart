import 'package:flutter/material.dart';
import 'package:test_app/models/album.dart';
import 'package:test_app/screens/detail_album_screen.dart';

class AllAlbumsScreen extends StatelessWidget {
  final List<Album> albums;
  const AllAlbumsScreen({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: albums.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailAlbumScreen(
                      album: albums[index],
                    ),
                  ),
                ),
                child: Text(
                  "${index + 1}) ${albums[index].title}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
