import 'package:flutter/material.dart';
import '../providers/cartas_providers.dart';
import '../componentes/drawer_personalizado.dart';
import '../componentes/item_carta.dart';
import '../providers/cartas_providers.dart';
import '../utils/rotas.dart';
import 'package:provider/provider.dart';

class TelaCartas extends StatefulWidget {
  @override
  _TelaCartasState createState() => _TelaCartasState();
}

class _TelaCartasState extends State<TelaCartas> {
  bool _isLoading = false;
  Future<void> _atualizarLista(BuildContext context) {
    return Provider.of<CartaProvider>(context, listen: false).buscaCarta();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CartaProvider>(context, listen: false).buscaCarta().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final carta = Provider.of<CartaProvider>(context).getCarta;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cartas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(Rotas.FORM_CARTAS);
            },
          )
        ],
      ),
      drawer: DrawerPersonalisado(),
      body: RefreshIndicator(
        onRefresh: () => _atualizarLista(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: carta.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                ItemListaCarta(carta[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
