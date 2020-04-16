import 'package:sqflite/sqlite_api.dart';
import 'package:visitas/models/cliente_model.dart';
import '../app_database.dart';

class ClienteDao {
  static String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT )';

  static String _tableName = 'cliente';
  static String _id = 'id';
  static String _nome = 'nome';

  Future<int> incluir(Cliente cliente) async {
    Database db = await getDatabase();
    Map<String, dynamic> clienteMap = Map();
    clienteMap['nome'] = cliente.nome;
    return db.insert(_tableName, clienteMap);
  }

  Future<List<Cliente>> listaTodos() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Cliente> clientes = List();
    for (Map<String, dynamic> map in result) {
      clientes.add(
        Cliente(map[_id], map[_nome]),
      );
    }

    return clientes;
  }
}
