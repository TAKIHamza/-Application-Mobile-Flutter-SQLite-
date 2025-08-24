import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/compteur.dart';
import 'package:ifsan/models/consommateur.dart';
import 'package:ifsan/views/addCounter_page.dart';
import 'package:ifsan/widgets/counter_card.dart';
import 'package:url_launcher/url_launcher.dart';
class ConsumerPage extends StatefulWidget {
  final Consommateur consommateur;

  const ConsumerPage({Key? key, required this.consommateur}) : super(key: key);

  @override
  _ConsumerPageState createState() => _ConsumerPageState();
}

class _ConsumerPageState extends State<ConsumerPage> {
  List<Compteur> compteurs = []; 
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _getCompteurs();
  }

void _makePhoneCall() async {
  final String phoneNumber = widget.consommateur.telephone;
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible de lancer $url';
  }
}

  Future<void> _getCompteurs() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    final db = DatabaseProvider.db;
    final consommateurId = widget.consommateur.id;
    compteurs = await db.getRecordsByForeignKey<Compteur>(
            DatabaseProvider.TABLE_NAME_COMPTEUR,  
            'consommateurID',       
            consommateurId,         
            (e) => Compteur.fromJson(e),  
);
    setState(() {
      _isLoading = false; // Set loading state to false after fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 147, 145),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [IconButton(
  onPressed: _makePhoneCall,
  icon: Icon(Icons.call)
)
],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... consumer information section with background color and bottom radius (unchanged)
  Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 147, 145),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  // Avatar icon of the person with Hero animation
                  Hero(
                    tag: 'avatar-${widget.consommateur.id}',
                    child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60, // Adjust the size as needed
                          color: Color.fromARGB(255, 17, 180, 159), // Change the color if necessary
                        ),
                      ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.consommateur.nom.toUpperCase()} ${widget.consommateur.prenom}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    ' ${widget.consommateur.adresse}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),

            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        ' Compteurs d\' Eau : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 108, 107, 107),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddCounterPage(consommateurID: widget.consommateur.id,)),).then((_) {
                  
                            _getCompteurs();
                           });
                        },
                        icon: Icon(Icons.add_box_rounded),
                        iconSize: 40,
                        color: Color.fromARGB(255, 14, 157, 170),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Display loading indicator or list of compteurs
                  _isLoading
                      ? Center(child: CircularProgressIndicator()) // Loading indicator
                      : ListView.builder(
                          shrinkWrap: true, // Prevent list from expanding excessively
                          physics: NeverScrollableScrollPhysics(), // Disable scrolling
                          itemCount: compteurs.length,
                          itemBuilder: (context, index) {
                            return CounterCard(compteur: compteurs[index],refresh: _getCompteurs,);
                          },
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
