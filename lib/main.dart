import 'package:flutter/material.dart';
import 'telas/tela_form_cartas.dart';
import 'telas/tela_auth_ou_home.dart';
import 'telas/tela_login.dart';
import 'providers/login.dart';
import 'providers/cartas_providers.dart';
import 'telas/tela_cartas.dart';
import 'utils/rotas.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Login(),
        ),
        ChangeNotifierProxyProvider<Login, CartaProvider>(
          create: (ctx) => CartaProvider('', '', []),
          update: (ctx, login, carta) =>
              CartaProvider(login.token, login.idUsuario, carta.getCarta),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple),
        routes: {
          Rotas.AUTH: (ctx) => TelaEscolheHome(),
          Rotas.HOME: (ctx) => TelaCartas(),
          Rotas.FORM_CARTAS: (ctx) => TelaFormCartas(),
        },
        onGenerateRoute: (settings) {
          print(settings.name);
          return null;
        },
        onUnknownRoute: (settings) {
          print("Rota não encontrada");
          return null;
        },
      ),
    );
  }
}
