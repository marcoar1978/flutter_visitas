import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:visitas/database/daos/cliente_dao.dart';
import 'package:visitas/database/daos/contato_dao.dart';

import 'daos/visita_dao.dart';

Future<Database> getDatabase() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'visitas.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(VisitaDao.tableSql);
    db.execute(ClienteDao.tableSql);
    db.execute(ContatoDao.tableSql);
    }, version: 11,
    onDowngrade: onDatabaseDowngradeDelete,
  );
}
