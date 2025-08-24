
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/Tcompteur.dart';
import 'package:ifsan/models/compteur.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/services/ApiService.dart';

class SyncService {
  
  final ApiService apiService = new ApiService();
  final DatabaseProvider databaseProvider=DatabaseProvider.db ;


  Future<void> syncPersonnes() async {
    try {
      
      List<Tcompteur> personnes = await apiService.fetchPersonnes();
      for (Tcompteur consommateur in personnes) {

        await databaseProvider.insertRecord(DatabaseProvider.TABLE_NAME_CONSOMMATEUR, consommateur.personne.toJson());
         await databaseProvider.insertRecord(DatabaseProvider.TABLE_NAME_COMPTEUR, new Compteur(
          id: consommateur.id,
          numeroSerie: consommateur.numeroSerie,
          dernierReleve: consommateur.dernierReleve ,
          dateInstallation: consommateur.dateInstallation,
          zone: consommateur.zone.name,
          localisationID: 1 ,
          consommateurID: consommateur.personne.id ).toJson());
      }
    } catch (e) {
      throw Exception('Failed to sync data: $e');
    }
  }

   Future<void> syncParametres() async {
    try {
      List<Parametre> parametres = await apiService.fetchParametres();
      for (Parametre parametre in parametres) {
        await databaseProvider.insertRecord(DatabaseProvider.TABLE_NAME_PARAMETRE, parametre.toJson());
      }
    } catch (e) {
      throw Exception('Failed to sync parametres: $e');
    }
  }

    Future<void> syncConsommations(List<Consommation> consommations) async {
    try {
      await apiService.syncConsommations(consommations);
    } catch (e) {
      throw Exception('Failed to sync consommations: $e');
    }
  }

  Future<List<List<dynamic>>> fetchStatistics() async {
  try {
    List<List<dynamic>> statistics = await apiService.fetchStatistics();
    return statistics;
  } catch (e) {
    throw Exception('Failed to sync statistics: $e');
  }
}
}

