import 'package:flutter/material.dart';

class Carta {
  final String id;
  final String nome;
  final String descricao;
  final String forca;
  final String imagem;
  final String idUsuario;

  const Carta({
    @required this.id,
    @required this.nome,
    @required this.descricao,
    @required this.forca,
    @required this.imagem,
    this.idUsuario,
  });
}
