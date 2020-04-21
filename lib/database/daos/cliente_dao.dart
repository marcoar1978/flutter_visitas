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

  Future<Cliente> incluir(Cliente cliente) async {
    Database db = await getDatabase();
    Map<String, dynamic> clienteMap = Map();
    clienteMap['nome'] = cliente.nome;
    int clienteId = await db.insert(_tableName, clienteMap);
    cliente.id = clienteId;
    return cliente;
  }

  Future<List<Cliente>> listaTodos() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROm $_tableName ORDER BY $_nome');

    List<Cliente> clientes = List();
    for (Map<String, dynamic> map in result) {
      clientes.add(
        Cliente(map[_id], map[_nome]),
      );
    }

    return clientes;
  }

  Future<Cliente> buscaPorId(int clienteId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> clientes = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [clienteId],
    );
    return Cliente.fromMap(clientes.first);
  }
}
