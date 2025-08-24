import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/functions/trimestre.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/widgets/count_Card.dart';

class StatistiqueCard extends StatefulWidget {
  @override
  _StatistiqueCardState createState() => _StatistiqueCardState();
}

class _StatistiqueCardState extends State<StatistiqueCard> {
  late int consommateursValue = 0;
  late int compteursValue = 0;
  late int zonesValue = 0;
  late int consommationsInserer = 0;
  late int consommationsNonInserer = 0;
  late int consommationsValue = 0;
  late int facturesPayeesValue = 0;
  late int facturesNonPayeesValue = 0;
  late int facturesValue = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
  try {
    DatabaseProvider databaseProvider = DatabaseProvider.db;
    DateTime now =DateTime.now();
     Parametre trimestreParam = (await  databaseProvider.getParameterByName('trimestre')) ?? Parametre(name: 'trimestre', value: getTrimestreFromDate(now).toString() );
     Parametre anneeParam = (await  databaseProvider.getParameterByName('annee')) ??Parametre(name: 'annee', value: DateTime.now().year.toString() );
    consommateursValue = await databaseProvider.getCount(DatabaseProvider.TABLE_NAME_CONSOMMATEUR);
    compteursValue = await databaseProvider.getCount(DatabaseProvider.TABLE_NAME_COMPTEUR);
    zonesValue = await databaseProvider.getCount(DatabaseProvider.TABLE_NAME_ZONE);
    consommationsInserer = await databaseProvider.getConsommationsCountForYearAndTrimester(int.parse(anneeParam.value) ,  int.parse(trimestreParam.value));
    consommationsValue = await databaseProvider.getCount(DatabaseProvider.TABLE_NAME_CONSOMMATION);
    consommationsNonInserer = compteursValue-consommationsInserer;
    
    setState(() {}); // Rafraîchir l'interface utilisateur pour afficher les nouvelles valeurs
  } catch (e) {
    // Gérer les erreurs ici
    print('Erreur lors de initialisation des données : $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fond blanc pour la carte
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 0.1),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 238, 254, 249), // Couleur de début du dégradé
              Color.fromARGB(255, 253, 254, 254),
              Color.fromARGB(255, 255, 255, 255),
                          
              // Couleur de fin du dégradé
            ],),
         
        ),
       

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CountCard(
                    icon: Icons.people_outline,
                    text: 'Consommateurs',
                    value: consommateursValue,
                  ),
                  CountCard(
                    icon: Icons.av_timer_sharp,
                    text: 'Compteurs d\'eau',
                    value: compteursValue,
                  ),
                  
                   CountCard(
                    icon: Icons.check_circle_outlined,
                    text: 'Consommations inserer ',
                    value: consommationsInserer,
                  ),
                  CountCard(
                    icon: Icons.warning_rounded,
                    text: 'Consommations à inserer',
                    value: consommationsNonInserer,
                  ),
                  CountCard(
                    icon: Icons.date_range_rounded,
                    text: 'consommations dans la base ',
                    value: consommationsValue,
                  ),
                ],
              ),
            ),
            
           
          ],
        ),
      ),
    );
  }
}
