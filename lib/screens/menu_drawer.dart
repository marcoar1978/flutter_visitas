import 'package:flutter/material.dart';
import 'package:visitas/screens/lista_clientes.dart';
import 'package:visitas/screens/lista_visitas.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
            decoration: BoxDecoration(
             image: DecorationImage(image: AssetImage('assets/images/projeto-engenharia-civil.jpg'))
            ),
          ),
          ListTile(
            title: Text('Visitas'),
            onTap: () async {
              await Navigator.pop(context);
              Navigator.pushNamed(context, ListaVisitas.routeName);
            },
          ),
          ListTile(
            title: Text('Clientes'),
            onTap: () async {
              await Navigator.pop(context);
              Navigator.pushNamed(context, ListaClientes.routeName);
            },
          ),

        ],

      ),
    );
  }
}
