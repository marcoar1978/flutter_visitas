import 'package:flutter/material.dart';
import 'package:visitas/screens/menu_drawer.dart';

class ListaClientes extends StatefulWidget {
  static String routeName = '/listaClientes';

  @override
  _ListaClientesState createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: Text('Lista de Clientes'),
      ),
    );
  }
}
