import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:visitas/models/visita_model.dart';
import 'package:image_picker/image_picker.dart';

class InclusaoFoto extends StatefulWidget {
  static String routeName = '/inclusaoFoto';

  @override
  _InclusaoFotoState createState() => _InclusaoFotoState();
}

class _InclusaoFotoState extends State<InclusaoFoto> {
  Visita visita;
  File imagem;

  void _getImgGaleria() async {
    File imagemTemporaria =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.imagem = imagemTemporaria;
    });
  }

  void _recebeParamVisita() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is Visita) {
      this.visita = ModalRoute.of(context).settings.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    this._recebeParamVisita();
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.visita.titulo),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: (this.imagem != null)
                  ? Image.file(this.imagem)
                  : Center(
                      child: Text('Selecione uma imagem'),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.blue),
                bottom: BorderSide(color: Colors.blue),
              )),
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Text('Foto 1', style: TextStyle(fontSize: 36.0)),
                  SizedBox(width: 20),
                  Text('Foto 2', style: TextStyle(fontSize: 36.0)),
                  SizedBox(width: 20),
                  Text('Foto 3', style: TextStyle(fontSize: 36.0)),
                  SizedBox(width: 20),
                  Text('Foto 4', style: TextStyle(fontSize: 36.0)),
                  SizedBox(width: 20),
                  Text('Foto 5', style: TextStyle(fontSize: 36.0)),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.image, size: 48.0, color: Colors.amber),
                    onPressed: () {
                      print('teste de evento');
                      this._getImgGaleria();
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
