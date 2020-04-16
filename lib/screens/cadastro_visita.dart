import 'package:flutter/material.dart';
import 'package:visitas/database/daos/cliente_dao.dart';
import 'package:visitas/enviroment/TipoVisita.dart';
import 'package:visitas/enviroment/opcao_data.dart';
import 'package:visitas/models/cliente_model.dart';

class CadastroVisita extends StatefulWidget {
  static String routeName = '/';

  @override
  _CadastroVisitaState createState() => _CadastroVisitaState();
}

class _CadastroVisitaState extends State<CadastroVisita> {
  TextEditingController _campoTitulo = TextEditingController();
  ClienteDao clienteDao = ClienteDao();
  List<Cliente> clientes = List();
  Cliente selectCliente;
  TiposVisita _tipoVisita = TiposVisita.RECLAMACAO;
  final _formKey = GlobalKey<FormState>();
  DateTime data = DateTime.now();


  @override
  void initState() {
    super.initState();
    clienteDao.listaTodos().then((clientes) {
      this.clientes = clientes;
      print(this.clientes);
    });
  }

  Widget campoTipoAcompanhamento(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
          value: TiposVisita.RECLAMACAO,
          groupValue: this._tipoVisita,
          onChanged: (TiposVisita value) {
            setState(() {
              print(value.index);
              this._tipoVisita = value;
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Text('Reclamação'),
        Radio(
          value: TiposVisita.ACOMPANHAMENTO,
          groupValue: this._tipoVisita,
          onChanged: (TiposVisita value) {
            setState(() {
              print(value.index);
              this._tipoVisita = value;
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Text('Acompanhamento'),
      ],
    );
  }

  Widget campoTitulo() {
    return TextFormField(
      controller: this._campoTitulo,
      decoration: InputDecoration(
        labelText: 'Título',
        //border: OutlineInputBorder(),
      ),
      onChanged: (text) {
        _formKey.currentState.validate();
      },
      validator: (text) {
        if (text.isEmpty) {
          return 'Digite o título';
        }
        return null;
      },
    );
  }

  Widget selCliente() {
    return DropdownButtonFormField<Cliente>(
      hint: Text("Selecione o cliente"),
      itemHeight: 50,
      value: selectCliente,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      //elevation: 16,
      items: this.clientes.map((Cliente c) {
        return DropdownMenuItem<Cliente>(
          value: c,
          child: Text(c.nome),
        );
      }).toList(),
      onChanged: (c) {
        _formKey.currentState.validate();
        setState(() {
          this.selectCliente = c;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Escolha o cliente';
        }
        return null;
      },
      decoration: InputDecoration(
          //border: OutlineInputBorder(),
          ),
    );
  }

  String formatadataLabel({String opcaoData}) {
    String ano = this.data.year.toString();
    String mes = this.data.month.toString();
    String dia = this.data.day.toString();
    if(opcaoData == 'label'){
      return "${dia}/${mes}/${ano}";
    }
    return '${ano}-${mes}-${dia}';
  }

  Widget campoData() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.date_range),
          color: Theme.of(context).primaryColor,
          iconSize: 40,
          onPressed: () async {
            DateTime dataEcolhida = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2040),
            );
            setState(() {
              this.data = dataEcolhida ?? this.data;
            });
          },
        ),
        Text(
          this.formatadataLabel(opcaoData: 'label'),
          style: TextStyle(fontSize: 24),
        )
      ],
    );
  }

  Widget submit() {
    return RaisedButton(
      child: Text('Incluir'),
      onPressed: () {
        if (_formKey.currentState.validate()) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inserir Visita'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding:
                EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0, bottom: 8.0),
            children: <Widget>[
              campoData(),
              campoTipoAcompanhamento(context),
              campoTitulo(),
              selCliente(),
              SizedBox(
                height: 10,
              ),
              submit()
            ],
          ),
        ));
  }
}
