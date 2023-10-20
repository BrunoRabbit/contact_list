import 'dart:io';

import 'package:contact_list/components/text_field_widget.dart';
import 'package:contact_list/helper/database_helper.dart';
import 'package:contact_list/home_view.dart';
import 'package:contact_list/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  static const String tableUser = 'User';

  final nameEC = TextEditingController();
  final numberEC = TextEditingController();
  final emailEC = TextEditingController();

  XFile? image;

  Future<void> _editContacts(BuildContext context) async {
    final userToEdit = ModalRoute.of(context)!.settings.arguments;

    if (userToEdit is Map<String, UserModel>) {
      final user = userToEdit['user'] as UserModel;
      final db = await DatabaseHelper().db;

      UserModel userModelUpdated = UserModel(
        id: user.id,
        name: nameEC.text.isEmpty ? user.name : nameEC.text,
        email: emailEC.text.isEmpty ? user.email : emailEC.text,
        number: numberEC.text.isEmpty ? user.number : numberEC.text,
        photoUrl: image?.path ?? user.photoUrl,
      );

      await db!.update(
        tableUser,
        userModelUpdated.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  deleteUser() async {
    final userToEdit = ModalRoute.of(context)!.settings.arguments;

    if (userToEdit is Map<String, UserModel>) {
      final user = userToEdit['user'] as UserModel;
      final db = await DatabaseHelper().db;

      await db!.delete(
        tableUser,
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();

    image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: [
          InkWell(
            onTap: () {
              deleteUser();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.delete,
              ),
            ),
          )
        ],
        title: const Text('Editar contatos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFieldWidget(nameEC, 'Nome'),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(numberEC, 'Telefone'),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(emailEC, 'Email'),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: image?.path != null
                        ? FileImage(File(image!.path))
                        : const AssetImage('assets/default.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(width: 20),
                const Text('Insira uma imagem'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                    onPressed: () => _editContacts(context),
                    child: const Text('Salvar Pessoa'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
