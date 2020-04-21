import 'package:flutter/material.dart';
import 'package:visitas/components/progress.dart';
import 'package:visitas/database/daos/visita_dao.dart';
import 'package:visitas/models/visita_model.dart';
import 'package:visitas/screens/cadastro_visita.dart';
import 'package:visitas/screens/consulta_visita.dart';
import 'package:visitas/screens/inclusao_fotos.dart';
import 'package:visitas/screens/menu_drawer.dart';
import 'package:visitas/screens/tab_visitas.dart';

class ListaVisitas extends StatefulWidget {
  static String routeName = '/';

  @override
  _ListaVisitasState createState() => _ListaVisitasState();
}

class _ListaVisitasState extends State<ListaVisitas> {
  TextEditingController pesquisaController = TextEditingController();
  String pesquisa = null;
  VisitaDao visitaDao = VisitaDao();
  List<Visita> visitas = List();

  Widget _listaVisitas(BuildContext context) {
    return FutureBuilder(
      future: visitaDao.consultaPorTitulo(this.pesquisa),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            this.visitas = snapshot.data;
            return ListView.builder(
              itemCount: this.visitas.length,
              itemBuilder: (context, index) {
                this.visitas.sort((a, b) {
                  var dataA = _converteData(a.data);
                  var dataB = _converteData(b.data);
                  if (dataA.isAfter(dataB))
                    return -1;
                  else if (dataA.isBefore(dataB))
                    return 1;
                  else
                    return 0;
                });
                Visita visita = this.visitas[index];
                return this._cardLista(context, visita);
              },
            );
            break;
        }
        return Text('Erro desconhecido');
      },
    );
  }

  DateTime _converteData(String data) {
    var dataSplit = data.split('-');
    DateTime dataConvert = DateTime(
      int.tryParse(dataSplit[2]),
      int.tryParse(dataSplit[1]),
      int.tryParse(dataSplit[2]),
    );
    return dataConvert;
  }

  Widget _cardLista(BuildContext context, Visita visita) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          visita.titulo,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _formataData(visita.data),
          style: TextStyle(fontSize: 12.0),
        ),
        onTap: () {
          this._menuBottom(context, visita);
        },
      ),
    );
  }

  String _formataData(String data) {
    var dataSplit = data.split('-');
    //return '$dataSplit[2].$dataSplit[1].$dataSplit[0]';
    return dataSplit[2] + '.' + dataSplit[1] + '.' + dataSplit[0];
  }

  void _menuBottom(BuildContext context, Visita visita) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                width: double.maxFinite,
                height: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 3.0,
                      // has the effect of softening the shadow
                      spreadRadius: 3.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        5.0, // horizontal, move right 10
                        5.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          visita.titulo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                TabVisitas.routeName,
                                arguments: visita);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.zoom_in),
                              SizedBox(width: 10),
                              Text('Visualizar',
                                  style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            //Navigator.of(context).pushNamed(
                            //  InclusaoFoto.routeName,
                            // arguments: visita,
                            //);
                          },
                          child: Center(
                              child: Row(
                            children: <Widget>[
                              Icon(Icons.edit),
                              SizedBox(width: 10),
                              Text('Editar', style: TextStyle(fontSize: 16.0)),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              InclusaoFoto.routeName,
                              arguments: visita,
                            );
                          },
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_alt),
                                SizedBox(width: 10),
                                Text('Incluir Fotos',
                                    style: TextStyle(fontSize: 16.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.close),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Fechar',
                                    style: TextStyle(fontSize: 16.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  Widget _alertSearch() {
    return AlertDialog(
      title: Text('Busca de Visitas'),
      content: TextField(
        controller: this.pesquisaController,
        decoration: InputDecoration(
          labelText: 'Pesquisar',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (text) async {
          setState(() {
            this.pesquisa = this.pesquisaController.text;
            Navigator.pop(context);
          });
        },
      ),
      actions: <Widget>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Visitas'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return this._alertSearch();
                    });
              },
              child: Icon(
                Icons.search,
                size: 32.0,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: this._listaVisitas(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CadastroVisita.routeName);
        },
      ),
    );
  }
}
