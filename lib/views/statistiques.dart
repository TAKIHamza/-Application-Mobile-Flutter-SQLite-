import 'package:flutter/material.dart';
import 'package:ifsan/controllers/SyncService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatistiquesPage extends StatefulWidget {
  @override
  _StatistiquesPageState createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
  final SyncService _controller = SyncService();

  @override
  void initState() {
    super.initState();

   
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          SizedBox(width: 10),
          Text(
           '> Les consommation dans  backend',
            style: TextStyle(
              color:Color.fromARGB(223, 42, 43, 43),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(width: 10),
          Icon(
            Icons.cloud_done_outlined,
            size: 30, // You can replace this with any suitable greeting icon
            color: Color.fromARGB(255, 21, 130, 125),
          ),
        ],
      ),
        
                      ),
      body: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/HORS-LIGNE.jpg'), // Assurez-vous d'avoir une image dans le dossier assets
                  SizedBox(height: 20),
                  Text('No token available. Please login.'),
                ],
              ),
            );
          } else {
            return FutureBuilder<List<List<dynamic>>>(
              future: _controller.fetchStatistics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load statistics'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No statistics available'));
                } else {
                  List<List<dynamic>> statistics = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      itemCount: statistics.length,
                      itemBuilder: (context, index) {
                        var stat = statistics[index];
                        return  Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              child: ListTile(
                                title: Text('Annee/trimestre :: ${stat[0]}'),
                                subtitle: Text('Consommations: ${stat[1]}'),
                              ),
                            
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
