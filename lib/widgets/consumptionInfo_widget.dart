import 'package:flutter/material.dart';

class ConsumptionInfoWidget extends StatelessWidget {
  final int year;
  final int quarter;
  final bool allConsumptionsInserted; // Nouveau nom de paramètre

  ConsumptionInfoWidget({
    required this.year,
    required this.quarter,
    required this.allConsumptionsInserted,
  });

  @override
  Widget build(BuildContext context) {
    String status = allConsumptionsInserted ? "Complet" : "Incomplet";
    IconData statusIcon = allConsumptionsInserted ? Icons.check_circle : Icons.error;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
         
          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   CircleAvatar(
                    radius: 41.5,
            backgroundColor:Color.fromRGBO(24, 160, 124, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  '$year',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Annee',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
          
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Color.fromRGBO(24, 160, 124, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_note,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          '$quarter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          'Trimestre',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 42,
                    backgroundColor:Color.fromRGBO(24, 160, 124, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          statusIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                         Text(
                          '$status',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Etat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                        
                       
                      ],
                    ),
                  ),
                ],
              ),
            ),
         
      ),
    );
  }
}
