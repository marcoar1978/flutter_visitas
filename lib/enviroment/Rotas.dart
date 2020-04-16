import 'package:visitas/screens/cadastro_visita.dart';
import 'package:visitas/screens/lista_clientes.dart';
import 'package:visitas/screens/lista_visitas.dart';

class Rotas{
  static final rotas = {
  ListaVisitas.routeName: (context) => ListaVisitas(),
  CadastroVisita.routeName: (context) => CadastroVisita(),
  ListaClientes.routeName: (context) => ListaClientes(),
  };
}