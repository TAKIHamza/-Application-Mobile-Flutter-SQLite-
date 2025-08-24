import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/facture.dart';

class FacturePage extends StatefulWidget {
  final int idCompteur;

  const FacturePage({Key? key, required this.idCompteur}) : super(key: key);

  @override
  _FacturePageState createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  late Future<List<Facture>> _facturesFuture;
  @override
  void initState() {
    super.initState();
    _loadFactures();
     
  }

  Future<void> _loadFactures() async {
    setState(() {
      _facturesFuture = DatabaseProvider.db.getFacturesByCompteurId(widget.idCompteur);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Facture>>(
          future: _facturesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erreur: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Aucune facture trouvée.'),
              );
            } else {
              return ListView.builder(
                 shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Facture facture = snapshot.data![index];
                
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                          elevation: 3,
                          
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                    Expanded(

                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 86, 89, 88),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                     IconButton(
                      onPressed: null,
                      icon: Icon(Icons.invert_colors_on_outlined),
                    
                    ),
                    
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              ListTile(
                                title: Text("Montant:  ${facture.montant}"),
                                
                              ),
                              ListTile(
                                title: Text("Date de création:   ${facture.dateEmission.substring(0, 10)}"),
                              
                              ),
                              ListTile(
                                title: Text("Date limite de paiement:   ${facture.dateLimitePaiement.substring(0, 10)}"),
                              ),
                              ListTile(
                                title: Text("Date  de paiement:   ${facture.datePaiement!.isEmpty? '':facture.datePaiement!.substring(0, 10)}"),
                              ),
                              SizedBox(height: 30,)
                     ],
                          ),
                        ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
