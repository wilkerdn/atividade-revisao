import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Foto extends StatefulWidget {
  @override
  _FotoState createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  File imagem;

  fotografar() async {
    final ImagePicker picker = ImagePicker();
    try {
      final arquivoImagem = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        preferredCameraDevice: CameraDevice.front,
      );
      if (arquivoImagem == null) return;

      setState(() {
        imagem = File(arquivoImagem.path);
      });
    } catch (e) {
      print('Catch fotografar:\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.green,
          )),
          alignment: Alignment.center,
          child: imagem != null
              ? Image.file(
                  imagem,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text("Nenhuma imagem!"),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
          icon: Icon(Icons.camera),
          onPressed: fotografar,
        ),
      ],
    );
  }
}
