import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/input_text_field.dart';
import 'package:test_app/models/comment.dart';
import 'package:test_app/models/post.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final TextEditingController commentController;
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  late final Future<List<Comment>> _future;
  @override
  void initState() {
    commentController = TextEditingController();
    emailController = TextEditingController();
    nameController = TextEditingController();

    _future = getComments();
    super.initState();
  }

  final dio = Dio();

  Future<List<Comment>> getComments() async {
    final response = await dio.get(
        'https://jsonplaceholder.typicode.com/comments?postId=${widget.post.id}');
    final listUser = response.data as List;
    return listUser.map((e) => Comment.fromJson(e)).toList();
  }

  Future addComment() async {
    final res = await dio.post(
      'https://jsonplaceholder.typicode.com/comments?postId=${widget.post.id}',
      data: Comment(
        postId: widget.post.id,
        id: widget.post.id,
        name: nameController.text,
        email: emailController.text,
        body: commentController.text,
      ).toJson(),
    );
    print(res);
  }

  @override
  void dispose() {
    commentController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Comment>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].body,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                snapshot.data![index].name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                snapshot.data![index].email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () => showModalBottomSheetSendComment(),
                        child: const Text('Добавить комментарий'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }

  showModalBottomSheetSendComment() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputFieldWidget(
                hintText: 'Comment',
                controller: commentController,
              ),
              const SizedBox(height: 10),
              InputFieldWidget(
                hintText: 'name',
                controller: nameController,
              ),
              const SizedBox(height: 10),
              InputFieldWidget(
                hintText: 'email',
                controller: emailController,
              ),
              ElevatedButton(
                  onPressed: () {
                    addComment();
                    commentController.clear();
                    emailController.clear();
                    nameController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Send'))
            ],
          ),
        );
      },
    );
  }
}
