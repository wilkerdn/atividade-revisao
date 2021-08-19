import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/carta.dart';
import 'package:http/http.dart' as http;
import '../utils/variaveis.dart';

class CartaProvider with ChangeNotifier {
  List<Carta> _carta = [];
  String token;
  String idUsuario;

  CartaProvider(this.token, this.idUsuario, this._carta);

  List<Carta> get getCarta => [..._carta];

  void adicionarCarta(Carta carta) {
    _carta.add(carta);
    notifyListeners();
  }

  Future<void> postCarta(Carta carta) async {
    var url = Uri.https(Variaveis.BACKURL, '/cartas.json');
    http
        .post(url,
            body: jsonEncode(
              {
                'nome': carta.nome,
                'descricao': carta.descricao,
                'forca': carta.forca,
                'imagem': carta.imagem,
                'idUsuario': '$idUsuario',
              },
            ))
        .then((value) {
      adicionarCarta(carta);
    });
  }

  //MÉTODO PARA ATUALIZAR MONTADORAS
  Future<void> patchCarta(Carta carta) async {
    var url = Uri.https(Variaveis.BACKURL, '/cartas/${carta.id}.json');
    http
        .patch(url,
            body: jsonEncode(
              {
                'nome': carta.nome,
                'descricao': carta.descricao,
                'forca': carta.forca,
                'imagem': carta.imagem,
                'idUsuario': '$idUsuario',
              },
            ))
        .then((value) {
      buscaCarta();
      notifyListeners();
    });
  }

  Future<void> deleteCarta(Carta carta) async {
    var url = Uri.https(Variaveis.BACKURL, '/cartas/${carta.id}.json');
    http.delete((url)).then((value) {
      buscaCarta();
      notifyListeners();
    });
  }

  //PARA FAZER REQUISIÇÕSE SINCRONAS DEVEMOS RETORNAR O FUTURE
  Future<void> buscaCarta() async {
    var url = Uri.https(Variaveis.BACKURL, '/cartas.json', {'auth': token});
    var resposta = await http.get(url);
    Map<String, dynamic> data = json.decode(resposta.body);
    _carta.clear();
    data.forEach((idCarta, dadosCarta) {
      if (dadosCarta['idUsuario'].toString() == '$idUsuario') {
        adicionarCarta(Carta(
          id: idCarta,
          nome: dadosCarta['nome'],
          descricao: dadosCarta['descricao'],
          forca: dadosCarta['forca'],
          imagem: dadosCarta['imagem'],
          idUsuario: dadosCarta['idUsuario'],
        ));
      }
    });
    notifyListeners();
  }
}
