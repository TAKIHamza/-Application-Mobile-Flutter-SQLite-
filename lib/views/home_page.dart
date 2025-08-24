import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/functions/trimestre.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/widgets/consumptionInfo_widget.dart';
import 'package:ifsan/widgets/greeting_card.dart';
import 'package:ifsan/widgets/home_card.dart';
import 'package:ifsan/widgets/statistique_card.dart';

class HomePage extends StatefulWidget {
 
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
   late Parametre _trimestreParam;
   late Parametre _anneeParam ;
   late Parametre _username ;
   late bool completed ;
   late DateTime now ;
 
  @override
  void initState() {
    super.initState();
     now = DateTime.now();
    _trimestreParam = Parametre(name: 'trimestre', value: getTrimestreFromDate(now).toString());
    _anneeParam = Parametre(name: 'annee', value: now.year.toString());
    _username = Parametre(name: 'username', value: 'User');
    completed = false;
    loadParameters();
  }


  void loadParameters() async {
    DatabaseProvider  databaseProvider = DatabaseProvider.db;
      _trimestreParam = (await  databaseProvider.getParameterByName('trimestre')) ?? _trimestreParam;
      _anneeParam = (await  databaseProvider.getParameterByName('annee')) ?? _anneeParam;
       _username = (await  databaseProvider.getParameterByName('username')) ?? _username;
      int nbcompteurs =  await databaseProvider.getCount(DatabaseProvider.TABLE_NAME_COMPTEUR);
      int nbconsomationsInserted = await  databaseProvider.getConsommationsCountForYearAndTrimester(
        int.parse( _anneeParam.value),int.parse( _trimestreParam.value));
        completed = nbconsomationsInserted == nbcompteurs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
          children: <Widget>[
             
              GreetingWidget(name: _username.value),
             SizedBox(height: 2),
            HomeCard(),
            
            SizedBox(height: 15),
         
               const Padding(
          padding: EdgeInsets.only(left: 16), // Adjust the left padding as needed
          child: Text(
            '> Consommaion actual :',
            style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
            ),
          ),
        ),
            ConsumptionInfoWidget(
            year:  int.parse( _anneeParam.value),
            quarter: int.parse( _trimestreParam.value),
            allConsumptionsInserted : completed 
          ),
            SizedBox(height: 4),
           const Padding(
          padding: EdgeInsets.only(left: 16), // Adjust the left padding as needed
          child: Text(
            '> Statistiques : ',
            style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
            ),
          ),
        ), 
        SizedBox(height: 10),
       
            
            StatistiqueCard(),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 253, 253),
    );
  }
}
