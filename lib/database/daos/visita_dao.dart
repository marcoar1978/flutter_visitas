import 'package:sqflite/sqlite_api.dart';
import 'package:visitas/database/app_database.dart';
import 'package:visitas/models/visita_model.dart';

class VisitaDao {
  static String tableSql = 'CREATE TABLE $tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_titulo TEXT , '
      '$_cliente INTEGER ,'
      '$_tipoVisita INTEGER , '
      '$_data TEXT , '
      '$_obs TEXT , '
      '$_contato INTEGER)';

  static String tableName = 'visitas';
  static String _id = 'id';
  static String _titulo = 'titulo';
  static String _cliente = 'cliente';
  static String _tipoVisita = 'tipoVisita';
  static String _data = 'data';
  static String _obs = 'obs';
  static String _contato = 'contato';

  Future<int> incluir(Visita visita) async {
    Database db = await getDatabase();
    return await db.insert(
      tableName,
      visita.toMap(),
    );
  }

  Future<List<Visita>> consultaPorTitulo(String titulo) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result;
    if(titulo != null){
      print('if');
      result = await db.rawQuery("SELECT * FROM $tableName WHERE titulo LIKE '%$titulo%'");
    }
    else{
      print('else');
      result = await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id DESC LIMIT 10");
    }

    List<Visita> visitas = List();
    for (Map<String, dynamic> map in result) {
      visitas.add(
        Visita(
            id: map[_id],
            titulo: map[_titulo],
            cliente: map[_cliente],
            tipoVisita: map[_tipoVisita],
            data: map[_data],
            obs: map[_obs],
            contato: map[_contato]),
      );
    }
    return visitas;
  }

  Future<List<Visita>> listaTodos() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(tableName);
    List<Visita> visitas = List();

    for (Map<String, dynamic> map in result) {
      visitas.add(
        Visita(
            id: map[_id],
            titulo: map[_titulo],
            cliente: map[_cliente],
            tipoVisita: map[_tipoVisita],
            data: map[_data],
            obs: map[_obs],
            contato: map[_contato]),
      );
    }
    return visitas;
  }
}
