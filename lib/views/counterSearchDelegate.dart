import 'package:flutter/material.dart';
import 'package:ifsan/models/compteur.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/widgets/counter_search_card.dart';

class CounterSearchDelegate extends SearchDelegate<Compteur?> {
  List<Compteur> _filteredCounters = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Return null when the delegate is closed
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: _filteredCounters.length,
        itemBuilder: (BuildContext context, int index) {
          return CardCounter(counter: _filteredCounters[index]);
        },
      ),
    );
  }

  @override
Widget buildSuggestions(BuildContext context) {
  return FutureBuilder<List<Compteur>>(
    future: DatabaseProvider.db.getAllRecords(DatabaseProvider.TABLE_NAME_COMPTEUR, (e) => Compteur.fromJson(e)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final List<Compteur> allCounters = snapshot.data ?? [];
        final List<Compteur> filteredCounters = allCounters
            .where((counter) =>
                counter.numeroSerie.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return ListView.builder(
          itemCount: filteredCounters.length,
          itemBuilder: (BuildContext context, int index) {
            final counter = filteredCounters[index];
            return 
             
             CardCounter(counter: counter);
            
          },
        );
      }
    },
  );
}

}
