import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/user_card.dart';
import 'package:test_app/models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<User>> _future;
  @override
  void initState() {
    _future = getUsers();
    super.initState();
  }

  final dio = Dio();

  Future<List<User>> getUsers() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/users');
    final listUser = response.data as List;
    return listUser.map((e) => User.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<User>>(
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
                  return UserCard(
                    user: snapshot.data![index],
                    index: index,
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
