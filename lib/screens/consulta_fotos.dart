import 'package:flutter/material.dart';
import 'package:visitas/models/visita_model.dart';

class ConsultaFotos extends StatefulWidget {

  Visita visita;
  ConsultaFotos({this.visita});

  @override
  _ConsultaFotosState createState() => _ConsultaFotosState();
}

class _ConsultaFotosState extends State<ConsultaFotos> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Consulta de Fotos'),
    );
  }
}
