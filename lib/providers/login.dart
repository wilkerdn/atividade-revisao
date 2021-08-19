import 'dart:async';
import 'dart:convert';
import '../providers/manter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/variaveis.dart';

class Login with ChangeNotifier {
  DateTime dataExpiracao;
  Timer tempo;
  String token;
  String idUsuario;

  bool get logado {
    return token != null;
  }

  String get getIdUsuario {
    return logado ? idUsuario : null;
  }

  String get getToken {
    if (token != null &&
        dataExpiracao != null &&
        dataExpiracao.isAfter(DateTime.now())) {
      return token;
    } else {
      return null;
    }
  }

  Future<void> registrar(String email, String senha, String operacao) async {
    Uri _url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:${operacao}',
      {"key": Variaveis.KEYFIREBASE},
    );
    final response = await http.post(
      _url,
      body: json.encode({
        "email": email,
        "password": senha,
        'returnSecureToken': true,
      }),
    );
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
    } else {
      token = responseBody["idToken"];
      idUsuario = responseBody["localId"];
      dataExpiracao = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );

      Manter.salvarMap('userData', {
        'token': token,
        'userId': idUsuario,
        'expiryDate': dataExpiracao.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> realizaLogin(String email, String senha) async {
    return registrar(email, senha, "signInWithPassword");
  }

  Future<void> signup(String email, String senha) async {
    print('novo usuário');
    return registrar(email, senha, "signUp");
  }

  Future<void> tryAutoLogin() async {
    if (logado) {
      return Future.value();
    }

    final userData = await Manter.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    idUsuario = userData["userId"];
    token = userData["token"];
    dataExpiracao = expiryDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    token = null;
    idUsuario = null;
    dataExpiracao = null;
    if (tempo != null) {
      tempo.cancel();
      tempo = null;
    }
    Manter.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (tempo != null) {
      tempo.cancel();
    }
    final tempoParaLogout = dataExpiracao.difference(DateTime.now()).inSeconds;
    tempo = Timer(Duration(seconds: tempoParaLogout), logout);
  }
}
