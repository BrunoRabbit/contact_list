import 'dart:io';

import 'package:contact_list/edit_contacts.dart';
import 'package:contact_list/helper/database_helper.dart';
import 'package:contact_list/models/user_model.dart';
import 'package:contact_list/save_user.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<UserModel> users = [];

  Future<void> _loadUsers() async {
    final db = await DatabaseHelper().db;
    final queryResult = await db!.query('User');
    final listUsers = queryResult.map((row) {
      return UserModel(
        id: row['id'] as int? ?? 0,
        name: row['name'] as String? ?? '',
        number: row['number'] as String? ?? '',
        email: row['email'] as String? ?? '',
        photoUrl: row['photoUrl'] as String? ?? '',
      );
    }).toList();

    setState(() {
      users = listUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: const Text('Página inicial'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = users[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: FileImage(
                              File(item.photoUrl),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nome: ${item.name}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Email: ${item.email}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Telefone: ${item.number}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EditUser(),
                                  settings: RouteSettings(arguments: {
                                    "user": users[index],
                                  }),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.edit_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SaveUser(),
            ),
          );
        },
      ),
    );
  }
}
