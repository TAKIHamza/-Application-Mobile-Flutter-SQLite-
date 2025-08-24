// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/controllers/SyncService.dart';
import 'package:ifsan/views/addConsumer_page.dart';
import 'package:ifsan/widgets/member_card.dart';
import 'package:ifsan/models/consommateur.dart'; // Import the Consommateur class

class ConsumersPage extends StatefulWidget {
  ConsumersPage({Key? key}) : super(key: key);

  @override
  _ConsumersPageState createState() => _ConsumersPageState();
}
class _ConsumersPageState extends State<ConsumersPage> {
  late Future<List<Consommateur>> _consumersFuture;
  List<Consommateur> _consumers = [];
  List<Consommateur> _filteredConsumers = [];
  final SyncService syncService = new SyncService();
   bool _isLoading = false;
   
  @override
  void initState() {
    super.initState();
    _refreshConsumers();
  }

  // Function to refresh consumers data
  void _refreshConsumers() {
    _consumersFuture = DatabaseProvider.db.getAllRecords(DatabaseProvider.TABLE_NAME_CONSOMMATEUR, (e) => Consommateur.fromJson(e));
    _consumersFuture.then((consumers) {
      setState(() {
        _consumers = consumers;
        _filteredConsumers = consumers;
      });
    });
  }

  // Function to filter consumers based on search term
  void _filterConsumers(String searchTerm) {
    setState(() {
      _filteredConsumers = _consumers.where((consumer) {
        final fullName = '${consumer.nom} ${consumer.prenom}';
        return fullName.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ajouter un consommateur'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddConsumerPage()),
                ).then((_) {
                  _refreshConsumers();
                });
              },
            ),
            const SizedBox(height: 6),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('Importer des consommateur'),
              onTap: () {
                Navigator.pop(context);  // Close the bottom sheet
                _importConsumers();
                
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _importConsumers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await syncService.syncPersonnes();
      await syncService.syncParametres();
      setState(() {
        _isLoading = false;
      });
      _refreshConsumers();
      _showResultDialog('Import successful', 'success');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showResultDialog('Import failed', e.toString());
    }
  }

  void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content=="success"? Icon(Icons.check_circle ,size: 80, color: Color.fromARGB(255, 20, 149, 108),):Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10.0), 
                  
                Expanded(
                  child: TextField(
                    onChanged: _filterConsumers,
                    decoration: InputDecoration(
                      hintText: 'Search ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredConsumers.length,
              itemBuilder: (context, index) {
                final consumer = _filteredConsumers[index];
                return MemberCard(consommateur: consumer, refreshConsumers: _refreshConsumers,);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showOptions,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 49, 214, 206),
      ),
    );
  }

}
