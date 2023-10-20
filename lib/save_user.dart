import 'dart:io';

import 'package:contact_list/components/text_field_widget.dart';
import 'package:contact_list/helper/database_helper.dart';
import 'package:contact_list/home_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SaveUser extends StatefulWidget {
  const SaveUser({super.key});

  @override
  State<SaveUser> createState() => _SaveUserState();
}

class _SaveUserState extends State<SaveUser> {
  final nameEC = TextEditingController();
  final numberEC = TextEditingController();
  final emailEC = TextEditingController();

  XFile? image;

  Future<void> _saveContacts(BuildContext context) async {
    final db = await DatabaseHelper().db;
    final user = {
      'name': nameEC.text,
      'number': numberEC.text,
      'email': emailEC.text,
      'photoUrl': image!.path,
    };

    await db!.insert('User', user);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
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
        title: const Text('Cadastro de contatos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
                    onPressed: () => _saveContacts(context),
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
