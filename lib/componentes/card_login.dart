import 'package:flutter/material.dart';
import '../providers/login.dart';
import '../utils/rotas.dart';
import 'package:provider/provider.dart';

enum ModoAutenticacao { Cadastro, Login }

class CardLogin extends StatefulWidget {
  @override
  _CardLoginState createState() => _CardLoginState();
}

class _CardLoginState extends State<CardLogin> {
  final controladorSenha = TextEditingController();
  ModoAutenticacao modoAutenticacao = ModoAutenticacao.Login;
  bool loading = false;
  final form = GlobalKey<FormState>();

  final Map<String, String> dadosAutenticacao = {
    'email': '',
    'senha': '',
  };

  get color => null;

  void showError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Erro ao logar!"),
      ),
    );
  }

  Future<void> submit() async {
    if (!form.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    form.currentState.save();

    Login login = Provider.of(context, listen: false);

    if (modoAutenticacao == ModoAutenticacao.Login) {
      try {
        await login.realizaLogin(
          dadosAutenticacao['email'],
          dadosAutenticacao['senha'],
        );
        Navigator.of(context).pushReplacementNamed(Rotas.HOME);
      } catch (e) {
        print(e);
        showError();
      }
    } else {
      await login.registrar(
        dadosAutenticacao['email'],
        dadosAutenticacao['senha'],
        'signUp',
      );
    }
    setState(() {
      loading = false;
    });
  }

  void trocaModo() {
    modoAutenticacao == ModoAutenticacao.Login
        ? setState(() {
            modoAutenticacao = ModoAutenticacao.Cadastro;
          })
        : setState(() {
            modoAutenticacao = ModoAutenticacao.Login;
          });
  }

  @override
  Widget build(BuildContext context) {
    final dimensoesDispositivo = MediaQuery.of(context).size;
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: dimensoesDispositivo.width * 0.75,
        height: modoAutenticacao == ModoAutenticacao.Login ? 330 : 390,
        child: Form(
          key: form,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return "Informe um e-mail válido!";
                    }
                    return null;
                  },
                  onSaved: (value) => dadosAutenticacao['email'] = value,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: "Senha"),
                    controller: controladorSenha,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return "Informe uma senha válida!";
                      }
                      return null;
                    },
                    onSaved: (value) => {dadosAutenticacao['senha'] = value}),
                if (modoAutenticacao == ModoAutenticacao.Cadastro)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Confirmar senha"),
                    obscureText: true,
                    validator: modoAutenticacao == ModoAutenticacao.Cadastro
                        ? (value) {
                            if (value != controladorSenha.text) {
                              return "As senhas são diferentes!";
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(height: 20),
                if (loading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.blue)),
                    color: Colors.amber,
                    child: Text(
                      modoAutenticacao == ModoAutenticacao.Login
                          ? "Entrar"
                          : "Submeter",
                    ),
                    onPressed: () {
                      submit();
                    },
                  ),
                SizedBox(height: 8),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.blue)),
                  color: Colors.cyan,
                  onPressed: trocaModo,
                  child: Text(
                    modoAutenticacao == ModoAutenticacao.Login
                        ? "Cadastrar"
                        : "Login",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
