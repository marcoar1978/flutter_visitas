import 'package:flutter/material.dart';
import 'package:visitas/models/visita_model.dart';

class ConsultaVisita extends StatefulWidget {
  Visita visita;

  ConsultaVisita({this.visita});

  @override
  _ConsultaVisitaState createState() => _ConsultaVisitaState();
}

Widget _campoConsulta(String label, String valor) {
  return Row(
    children: <Widget>[
      Container(
        width: 70,
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Text(valor, style: TextStyle(fontSize: 16))
    ],
  );
}

class _ConsultaVisitaState extends State<ConsultaVisita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            _campoConsulta(
              'Data',
              widget.visita.data.toString(),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Título',
              widget.visita.titulo,
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Cliente',
              widget.visita.cliente.toString(),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Tipo',
              widget.visita.tipoVisita.toString(),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Obs',
              widget.visita.obs.toString(),
            ),
            Divider(
              height: 32.0,
            ),
            _campoConsulta(
              'Contato',
              widget.visita.contato.toString(),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Telefone',
              '',
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Email',
              '',
            ),

          ],
        ),
      ),
    );
  }
}
