import 'package:flutter/material.dart';
import 'package:visitas/database/daos/cliente_dao.dart';
import 'package:visitas/database/daos/contato_dao.dart';
import 'package:visitas/database/daos/visita_dao.dart';
import 'package:visitas/enviroment/TipoVisita.dart';
import 'package:visitas/enviroment/opcao_data.dart';
import 'package:visitas/models/cliente_model.dart';
import 'package:visitas/models/contato_model.dart';
import 'package:visitas/models/visita_model.dart';

class CadastroVisita extends StatefulWidget {
  static String routeName = '/';

  @override
  _CadastroVisitaState createState() => _CadastroVisitaState();
}

class _CadastroVisitaState extends State<CadastroVisita> {
  TextEditingController _campoTitulo = TextEditingController();
  ClienteDao clienteDao = ClienteDao();
  Cliente selectCliente;
  ContatoDao contatoDao = ContatoDao();
  Contato selectContato;
  List<Cliente> clientes = List();
  List<Contato> contatos = List();

  TiposVisita _tipoVisita = TiposVisita.RECLAMACAO;
  final _formKey = GlobalKey<FormState>();
  DateTime data = DateTime.now();

  @override
  void initState() {
    super.initState();
    clienteDao.listaTodos().then((clientes) {
      this.clientes = clientes;
    });
    contatoDao.listaTodos().then((contatos) {
      this.contatos = contatos;
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

  Widget popupCadContato(BuildContext context){
    return AlertDialog(
      title: Text('Inclusão de contato'),
      content: Text('----'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Incluir'),
          onPressed: () {
            setState(() {

              this.selectContato = this.contatos[0];
            });
            Navigator.pop(context);

          },
        )

      ],

    );
  }

  Widget selContato() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 120,
          child: DropdownButtonFormField<Contato>(
            hint: Text('Selecione o contato'),
            itemHeight: 50,
            value: selectContato,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            items: this.contatos.map((Contato c) {
              return DropdownMenuItem<Contato>(
                value: c,
                child: Text(c.nome),
              );
            }).toList(),
            onChanged: (c) {
              _formKey.currentState.validate();
              setState(() {
                this.selectContato = c;
              });
            },
          ),
        ),
        Container(
          width: 90,
          child: IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              showDialog(context: context, builder: (context){
                return popupCadContato(context);
              });
            },
          ),
        )
      ],
    );
  }

  Widget selCliente() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 120,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<Cliente>(
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
            ),
          ),
          //IconButton(icon: Icon(Icons.assignment), onPressed: () {} ,)
        ),
        Container(
          width: 90,
          child: IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {},
          ),
        )

        //
      ],
    );
  }

  String formatadataLabel({String opcaoData}) {
    String ano = this.data.year.toString();
    String mes = this.data.month.toString();
    String dia = this.data.day.toString();
    if (opcaoData == 'label') {
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
          title: Text('Incluir Visita'),
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
              selContato(),
              SizedBox(
                height: 30,
              ),
              submit()
            ],
          ),
        ));
  }
}
