import 'package:sqflite/sqlite_api.dart';
import 'package:visitas/database/app_database.dart';
import 'package:visitas/models/contato_model.dart';

class ContatoDao {
  static String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_telefone TEXT, '
      '$_email TEXT )';

  static String _tableName = 'contatos';
  static String _id = 'id';
  static String _nome = 'nome';
  static String _telefone = 'telefone';
  static String _email = 'email';

  Future<int> incluir(Contato contato) async {
    Database db = await getDatabase();

    Map<String, dynamic> contatoMap = Map();
    contatoMap[_nome] = contato.nome;
    contatoMap[_telefone] = contato.telefone;
    contatoMap[_email] = contato.email;
    return db.insert(_tableName, contatoMap);
  }

  Future<List<Contato>> listaTodos() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> contatosMap =
        await db.rawQuery("SELECT * FROM $_tableName");

    List<Contato> contatos = List();
    for (Map<String, dynamic> contatoMap in contatosMap) {
      Contato contato = Contato.fromMap(contatoMap);
      contatos.add(contato);
    }
    return contatos;
  }
}
