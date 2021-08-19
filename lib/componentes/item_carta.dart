//import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/carta.dart';
import '../providers/cartas_providers.dart';
import '../utils/rotas.dart';
import 'package:provider/provider.dart';

class ItemListaCarta extends StatelessWidget {
  final Carta carta;
  File image;

  ItemListaCarta(this.carta);

  void deleteCarta(context, Carta carta) {
    Provider.of<CartaProvider>(context, listen: false).deleteCarta(carta);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(
        File(carta.imagem),
        fit: BoxFit.cover,
      ),
      contentPadding: EdgeInsets.all(15),
      tileColor: Colors.black12,
      title: Container(
        child: Text(
          '${carta.nome}\n${carta.descricao}\n${carta.forca}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Rotas.FORM_CARTAS,
                    arguments: carta,
                  );
                },
                color: Colors.black,
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("ATENÇÃO"),
                      content: Text("Está certo disso?"),
                      actions: [
                        TextButton(
                            child: Text("Não"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: Text("Sim"),
                            onPressed: () {
                              deleteCarta(context, carta);
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
