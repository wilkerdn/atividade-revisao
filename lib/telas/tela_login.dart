import 'package:flutter/material.dart';
import '../componentes/card_login.dart';

class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dimensoesDispositivo = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(106, 90, 205, 1),
              Color.fromRGBO(106, 90, 205, 0.85),
              Color.fromRGBO(106, 90, 205, 0.70),
              Color.fromRGBO(106, 90, 205, 0.5),
              Color.fromRGBO(106, 90, 205, 0.70),
              Color.fromRGBO(106, 90, 205, 0.85),
              Color.fromRGBO(106, 90, 205, 1),
            ])),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: dimensoesDispositivo.width * 0.75,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 70,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.purple,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black38,
                          offset: Offset(0, 2),
                        )
                      ]),
                  child: Text(
                    "MAGIC",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CardLogin()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
