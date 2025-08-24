import 'dart:async';
import 'dart:io';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/models/facture.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseProvider {
  static const String TABLE_NAME_CONSOMMATEUR = "consommateurs";
  static const String TABLE_NAME_CONSOMMATION = "consommations";
  static const String TABLE_NAME_COMPTEUR = "compteurs";
  static const String TABLE_NAME_FACTURE = "factures";
  static const String TABLE_NAME_ZONE = "zones";
  static const String TABLE_NAME_LOCALISATION = "localisations";
  static const String TABLE_NAME_PARAMETRE = "parametres";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String path = join(await getDatabasesPath(), 'consommation.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $TABLE_NAME_CONSOMMATEUR (
            id INTEGER PRIMARY KEY,
            cni TEXT,
            nom TEXT,
            prenom TEXT,
            adresse TEXT,
            telephone TEXT
            
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_COMPTEUR (
            id INTEGER PRIMARY KEY,
            numero_serie TEXT,
            date_installation TEXT,
            dernierReleve TEXT,
            zone TEXT,
            localisationID INTEGER,
            consommateurID INTEGER,
            FOREIGN KEY (consommateurID) REFERENCES $TABLE_NAME_CONSOMMATEUR(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_CONSOMMATION (
            id INTEGER PRIMARY KEY ,
            trimestre INTEGER,
            annee INTEGER,
            quantite INTEGER,
            valeur_compteur INTEGER,
            id_compteur INTEGER,
            imagePath TEXT,
            FOREIGN KEY (id_compteur) REFERENCES $TABLE_NAME_COMPTEUR(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_FACTURE (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            montant REAL,
            date_emission TEXT,
            date_limite_paiement TEXT,
            date_paiement TEXT,
            est_payee INTEGER,
            id_consommation INTEGER,
            FOREIGN KEY (id_consommation) REFERENCES $TABLE_NAME_CONSOMMATION(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_ZONE (
            name TEXT PRIMARY KEY,
            description TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_LOCALISATION (
            id INTEGER PRIMARY KEY ,
            latitude TEXT,
            longitude TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $TABLE_NAME_PARAMETRE (
            name TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
  }
  
////////////////// insert

 Future<int> insertRecord(String tableName, Map<String, dynamic> data) async {
  final db = await database;
  var raw = await db.insert(
    tableName,
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return raw;
}
////////////////////update
///updateRecord(TABLE_NAME_CONSOMMATEUR, consommateur.toJson(), 'id = ?', [consommateur.id]);
 Future<int> updateRecord(String tableName, Map<String, dynamic> data, String whereClause, List<dynamic> whereArgs) async {
  final db = await database;
  var res = await db.update(
    tableName,
    data,
    where: whereClause,
    whereArgs: whereArgs,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return res;
}
///////////////////////// get all $x

  
Future<List<T>> getAllRecords<T>(String tableName, T Function(Map<String, dynamic>) fromJson) async {
  final db = await database;
  var res = await db.query(tableName);
  List<T> records = res.isNotEmpty ? res.map((e) => fromJson(e)).toList() : [];
  return records;
}
// nombre des linges 

Future<int> getCount(String tableName) async {
  final db = await database;
  var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  return count!;
}

Future<List<Consommation>> getConsommationsByCNI(String cni) async {
  final db = await database;

  final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT c.id, c.trimestre, c.annee, c.quantite, c.valeur_compteur, c.id_compteur, c.imagePath
    FROM $TABLE_NAME_CONSOMMATEUR cons
    JOIN $TABLE_NAME_COMPTEUR cp ON cons.id = cp.consommateurID
    JOIN $TABLE_NAME_CONSOMMATION c ON cp.id = c.id_compteur
    WHERE cons.cni != ?
  ''', [cni]);

  return results.map((json) => Consommation.fromJson(json)).toList();
}

//nombres
Future<int> getFacturesPayeesCount() async {
  final db = await database;
  var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_FACTURE WHERE est_payee = 1'));
  return count ?? 0;
}
Future<int> getFacturesNonPayeesCount() async {
  final db = await database;
  var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_FACTURE WHERE est_payee = 0'));
  return count ?? 0;
}

Future<int> getConsommationsCountForYearAndTrimester(int year, int trimester) async {
  final db = await database;
  var count = Sqflite.firstIntValue(await db.rawQuery('''
    SELECT COUNT(*) FROM $TABLE_NAME_CONSOMMATION 
    WHERE annee = ? AND trimestre = ?
  ''', [year, trimester]));
  return count ?? 0;
}


Future<int> getConsommationsForIdConsumerAndYearAndTrimester(int id ,int year, int trimester) async {
  final db = await database;
  var count = Sqflite.firstIntValue(await db.rawQuery('''
    SELECT COUNT(*) FROM $TABLE_NAME_CONSOMMATION 
    WHERE id_compteur = ? AND annee = ? AND trimestre = ?
  ''', [id,year, trimester]));
  return count ?? 0;
}


// max id

Future<int> getMaxId(String tableName, String idColumnName) async {
  final db = await database;
  var result = await db.rawQuery('SELECT MAX($idColumnName) FROM $tableName');
  var maxId = result[0]['MAX($idColumnName)'] as int?;
  return maxId != null ? maxId + 1 : 1;
}
  // get by 
 Future<List<Map<String, Object?>>> getInfoForQuarterYear(int quarter, int year) async {
  final db = await database;
  final result = await db.rawQuery('''
    SELECT
      $TABLE_NAME_CONSOMMATEUR.nom as nomConsommateur,
      $TABLE_NAME_CONSOMMATEUR.prenom as prenomConsommateur,
      $TABLE_NAME_COMPTEUR.zone as zoneCompteur,
      $TABLE_NAME_COMPTEUR.numero_serie as numeroSerieCompteur,
      $TABLE_NAME_COMPTEUR.dernierReleve as dernierReleveCompteur,
      $TABLE_NAME_CONSOMMATION.quantite as quantiteConsommation,
      $TABLE_NAME_FACTURE.montant as montantFacture
    FROM $TABLE_NAME_FACTURE
    INNER JOIN $TABLE_NAME_CONSOMMATION
      ON $TABLE_NAME_FACTURE.id_consommation = $TABLE_NAME_CONSOMMATION.id
    INNER JOIN $TABLE_NAME_COMPTEUR
      ON $TABLE_NAME_CONSOMMATION.id_compteur = $TABLE_NAME_COMPTEUR.id
    INNER JOIN $TABLE_NAME_CONSOMMATEUR
      ON $TABLE_NAME_COMPTEUR.consommateurID = $TABLE_NAME_CONSOMMATEUR.id
    WHERE $TABLE_NAME_CONSOMMATION.trimestre = $quarter
      AND $TABLE_NAME_CONSOMMATION.annee = $year
    
  ''');
  if (result.isNotEmpty) {
    print(result);
    return result;
  } else {
    return [];
  }
}


Future<List<T>> getRecordsByForeignKey<T>(
  String tableName,
  String foreignKeyName,
  int foreignKeyValue,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final db = await database;
  var res = await db.query(
    tableName,
    where: '$foreignKeyName = ?',
    whereArgs: [foreignKeyValue],
    orderBy: 'id DESC',
  );
  List<T> records = res.isNotEmpty
      ? res.map((e) => fromJson(e)).toList()
      : [];
  return records;
}

Future<Parametre?> getParameterByName(String name) async {
  final db = await database;
  var res = await db.query(
    TABLE_NAME_PARAMETRE,
    where: 'name = ?',
    whereArgs: [name],
  );

  List<Parametre> parameters = res.isNotEmpty
      ? res.map((e) => Parametre.fromJson(e)).toList()
      : [];
  return parameters.isNotEmpty ? parameters[0] : null;
}

Future<List<Facture>> getFacturesByCompteurId(int compteurId) async {
  print(compteurId);
  final db = await database;
  var res = await db.query(
    TABLE_NAME_FACTURE,
    where: 'id_consommation IN (SELECT id FROM $TABLE_NAME_CONSOMMATION WHERE id_compteur = ?)',
    whereArgs: [compteurId],
    orderBy: 'id_consommation DESC',
  );
  List<Facture> factures = res.isNotEmpty
      ? res.map((e) => Facture.fromJson(e)).toList()
      : [];
  return factures;
}



  // delete 
  
  Future<int> deleteConsommateur(int consommateurId) async {
  final db = await database;
  
  // Get the counters associated with the consumer
  List<Map<String, dynamic>> counters = await db.query(
    TABLE_NAME_COMPTEUR,
    where: 'consommateurID = ?',
    whereArgs: [consommateurId],
  );
  
  // Iterate through each counter
  for (var counter in counters) {
    // Get the consumptions associated with the counter
    List<Map<String, dynamic>> consumptions = await db.query(
      TABLE_NAME_CONSOMMATION,
      where: 'id_compteur = ?',
      whereArgs: [counter['id']],
    );
    
    // Iterate through each consumption
    for (var consumption in consumptions) {
      // Delete the images and invoices associated with the consumption
       if (consumption['imagePath'] != null) {
      final imageFile = File(consumption['imagePath']);
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
      await db.delete(
        TABLE_NAME_FACTURE,
        where: 'id_consommation = ?',
        whereArgs: [consumption['id']],
      );
    }
    
    // Delete the consumptions associated with the counter
    await db.delete(
      TABLE_NAME_CONSOMMATION,
      where: 'id_compteur = ?',
      whereArgs: [counter['id']],
    );
  }

  // Delete the counters associated with the consumer
  await db.delete(
    TABLE_NAME_COMPTEUR,
    where: 'consommateurID = ?',
    whereArgs: [consommateurId],
  );

  // Finally, delete the consumer
  return await db.delete(
    TABLE_NAME_CONSOMMATEUR,
    where: 'id = ?',
    whereArgs: [consommateurId],
  );
}
Future<int> deleteConsommation(int consommationId) async {
  final db = await database;

  // Delete the invoices associated with the consumption

  await db.delete(
    TABLE_NAME_FACTURE,
    where: 'id_consommation = ?',
    whereArgs: [consommationId],
  );

  // Finally, delete the consumption
  return await db.delete(
    TABLE_NAME_CONSOMMATION,
    where: 'id = ?',
    whereArgs: [consommationId],
  );
}
Future<int> deleteCompteur(int compteurId) async {
  final db = await database;
  
  // Get the consumptions associated with the counter
  List<Map<String, dynamic>> consumptions = await db.query(
    TABLE_NAME_CONSOMMATION,
    where: 'id_compteur = ?',
    whereArgs: [compteurId],
  );
  
  // Iterate through each consumption
  for (var consumption in consumptions) {
    // Delete the invoices associated with the consumption
     if (consumption['imagePath'] != null) {
      final imageFile = File(consumption['imagePath']);
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
    await db.delete(
      TABLE_NAME_FACTURE,
      where: 'id_consommation = ?',
      whereArgs: [consumption['id']],
    );
  }

  // Delete the consumptions associated with the counter
  await db.delete(
    TABLE_NAME_CONSOMMATION,
    where: 'id_compteur = ?',
    whereArgs: [compteurId],
  );

  // Finally, delete the counter
  return await db.delete(
    TABLE_NAME_COMPTEUR,
    where: 'id = ?',
    whereArgs: [compteurId],
  );
}



}
