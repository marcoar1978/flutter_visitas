import 'package:visitas/screens/cadastro_visita.dart';
import 'package:visitas/screens/consulta_visita.dart';
import 'package:visitas/screens/inclusao_fotos.dart';
import 'package:visitas/screens/lista_clientes.dart';
import 'package:visitas/screens/lista_visitas.dart';
import 'package:visitas/screens/tab_visitas.dart';

class Rotas{
  static final rotas = {
  ListaVisitas.routeName: (context) => ListaVisitas(),
  TabVisitas.routeName: (context) => TabVisitas(),
  CadastroVisita.routeName: (context) => CadastroVisita(),
  ListaClientes.routeName: (context) => ListaClientes(),
  InclusaoFoto.routeName: (context) => InclusaoFoto(),
  };
}