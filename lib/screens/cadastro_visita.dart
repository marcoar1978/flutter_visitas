import 'package:flutter/material.dart';
import 'package:visitas/database/daos/cliente_dao.dart';
import 'package:visitas/database/daos/contato_dao.dart';
import 'package:visitas/database/daos/visita_dao.dart';
import 'package:visitas/enviroment/TipoVisita.dart';
import 'package:visitas/enviroment/opcao_data.dart';
import 'package:visitas/models/cliente_model.dart';
import 'package:visitas/models/parametros/clientes_parametro.dart';
import 'package:visitas/models/parametros/contatos_parametro.dart';
import 'package:visitas/models/contato_model.dart';
import 'package:visitas/models/parametros/contatos_parametro.dart';
import 'package:visitas/models/visita_model.dart';
import 'package:visitas/screens/lista_visitas.dart';

class CadastroVisita extends StatefulWidget {
  static String routeName = '/cadastroVisita';

  @override
  _CadastroVisitaState createState() => _CadastroVisitaState();
}

class _CadastroVisitaState extends State<CadastroVisita> {
  TextEditingController _campoTitulo = TextEditingController();
  TextEditingController _campoNomeContato = TextEditingController();
  TextEditingController _campoEmailContato = TextEditingController();
  TextEditingController _campoTelefoneContato = TextEditingController();
  TextEditingController _campoNomeCliente = TextEditingController();
  ClienteDao clienteDao = ClienteDao();
  Cliente selectCliente;
  ContatoDao contatoDao = ContatoDao();
  VisitaDao visitaDao = VisitaDao();
  Contato selectContato;
  List<Cliente> clientes = List();
  List<Contato> contatos = List();
  ContatosParametro contatosParametro;
  ClientesParametro clientesParametro;

  TiposVisita _tipoVisita = TiposVisita.RECLAMACAO;
  final _formKey = GlobalKey<FormState>();
  final _formKeyContato = GlobalKey<FormState>();
  final _formKeyCliente = GlobalKey<FormState>();

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
      onChanged: (text) {},
      validator: (text) {
        if (text.isEmpty) {
          return 'Digite o título';
        }
        return null;
      },
    );
  }

  Widget popupCadCliente(BuildContext context) {
    return AlertDialog(
      title: Text('Inclusão de Cliente'),
      content: Form(
        key: this._formKeyCliente,
        child: Container(
          height: 100,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: this._campoNomeCliente,
                decoration: InputDecoration(
                    labelText: 'Nome', icon: Icon(Icons.account_circle)),
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Digite o nome';
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
          child: Text('Incluir'),
          onPressed: () async {
            if (this._formKeyCliente.currentState.validate()) {
              ClientesParametro clientesParametro = ClientesParametro();
              clientesParametro.cliente = await clienteDao.incluir(
                Cliente(0, this._campoNomeCliente.text),
              );
              clientesParametro.clientes = await clienteDao.listaTodos();
              //Navigator.pushNamed(context, CadastroVisita.routeName,
              //    arguments: clientesParametro);
              setState(() {
                this.clientes = clientesParametro.clientes;
                this._campoNomeCliente.text = '';
                Navigator.pop(context);
              });
            }
          },
        )
      ],
    );
  }

  Widget popupCadContato(BuildContext context) {
    return AlertDialog(
      title: Text('Inclusão de Contato'),
      content: Form(
        key: this._formKeyContato,
        child: Container(
          height: 250,
          child: ListView(
            children: <Widget>[
              //Icon(Icons.account_circle),
              TextFormField(
                controller: this._campoNomeContato,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  icon: Icon(Icons.account_circle),
                ),
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Digite o nome';
                  }
                },
              ),
              TextFormField(
                controller: this._campoTelefoneContato,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  icon: Icon(Icons.phone),
                ),
              ),
              TextFormField(
                controller: this._campoEmailContato,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
             Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Incluir'),
          onPressed: () async {
            if (_formKeyContato.currentState.validate()) {
              Contato contato = Contato(
                0,
                this._campoNomeContato.text,
                this._campoTelefoneContato.text,
                this._campoEmailContato.text,
              );
              contato = await contatoDao.incluir(contato);
              ContatosParametro contatosParametro = ContatosParametro();
              contatosParametro.contatos = await contatoDao.listaTodos();
              contatosParametro.contato = contato;
              this._campoNomeContato.text = '';
              this._campoTelefoneContato.text = '';
              this._campoEmailContato.text = '';
              setState(() {
                this.contatos = contatosParametro.contatos;
                Navigator.pop(context);
              });
            }
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
                child: Row(
                  children: <Widget>[
                    Text(c.nome),
                  ],
                ),
              );
            }).toList(),
            onChanged: (c) {
              setState(() {
                this.selectContato = c;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Escolha o contato';
              }
              return null;
            },
          ),
        ),
        Container(
          width: 90,
          child: IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return popupCadCliente(context);
                  });
            },
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
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          Visita visita = Visita(
            id: 0,
            titulo: this._campoTitulo.text,
            cliente: this.selectCliente.id,
            tipoVisita: this._tipoVisita.index,
            data: this.formatadataLabel(opcaoData: "db"),
            obs: '',
            contato: this.selectContato.id,
          );
          await this.visitaDao.incluir(visita);
          Navigator.of(context).pushNamed('/');
        }
      },
    );
  }

  void recepcaoParamContato() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is ContatosParametro) {
      contatosParametro = ModalRoute.of(context).settings.arguments;
      setState(() {
        this.contatos = contatosParametro.contatos;
        //this.selectContato = contatosParametro.contato ?? this.selectContato;
      });
    }
  }

  void recepcaoParamCliente() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is ClientesParametro) {
      clientesParametro = ModalRoute.of(context).settings.arguments;
      setState(() {
        this.clientes = clientesParametro.clientes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this.recepcaoParamContato();
    this.recepcaoParamCliente();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed(ListaVisitas.routeName);
            },
          ),
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
