import 'package:flutter/material.dart';
import '../telas/tela_cartas.dart';
import '../providers/login.dart';
import '../telas/tela_login.dart';
import 'package:provider/provider.dart';

class TelaEscolheHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Login login = Provider.of(context, listen: false);
    return login.logado ? TelaCartas() : TelaLogin();
  }
}
