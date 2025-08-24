import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/compteur.dart';
import 'package:ifsan/models/consommateur.dart';
import 'package:ifsan/views/addConsumptions_page.dart';
import 'package:ifsan/views/consumer_page.dart';

class CardCounter extends StatelessWidget {
  final Compteur counter;

  const CardCounter({
    Key? key,
    required this.counter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<Consommateur> consommateur = await DatabaseProvider.db.getRecordsByForeignKey<Consommateur>(
            DatabaseProvider.TABLE_NAME_CONSOMMATEUR,  
            'id',       
            counter.consommateurID,         
            (e) => Consommateur.fromJson(e),  
);   

Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsumerPage(consommateur: consommateur[0],),
        ));
      },
      child: Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: Row(
          children: [
            Image.asset(
              'assets/compteurIcon2.png',
              height: 75,
              width: 75,
            ),
            SizedBox(width: 16.0), // Ajoutez un espacement entre l'image et le texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counter.numeroSerie,
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    counter.zone,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.add,size: 30,color: Color.fromARGB(255, 35, 102, 58)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddConsumptionsPage(idCompteur: counter.id ,value: int.parse(counter.dernierReleve.trim())  )),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
