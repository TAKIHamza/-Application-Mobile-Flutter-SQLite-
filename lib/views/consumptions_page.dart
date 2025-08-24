import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/widgets/consumption_card.dart';

class ConsumptionsPage extends StatefulWidget {
  final int compteurId;

  const ConsumptionsPage({Key? key, required this.compteurId}) : super(key: key);

  @override
  State<ConsumptionsPage> createState() => _ConsumptionsPageState();
}

class _ConsumptionsPageState extends State<ConsumptionsPage> {
  Future<List<Consommation>>? _consommations;
  

  @override
  void initState() {
    super.initState();
    _fetchConsommations();
  }

  Future<void> _fetchConsommations() async {
    final db = DatabaseProvider.db;
    final compteurId = widget.compteurId;
    _consommations = db.getRecordsByForeignKey<Consommation>(
      DatabaseProvider.TABLE_NAME_CONSOMMATION,
      'id_compteur',
      compteurId,
      (e) => Consommation.fromJson(e),
    );
    setState(() {}); // Update UI after fetching consommations
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             
              FutureBuilder<List<Consommation>>(
                future: _consommations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching consummations'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Center(child: Text('No data available')),
                    );
                  } else {
                    final consommations = snapshot.data!;
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:consommations.length,
                      itemBuilder: (context, index) {
                        final consommation =consommations[index];
                        return ConsumptionCard(
                          consumption: consommation,
                          refresh: _fetchConsommations,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
