import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ifsan/models/Tcompteur.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  final String baseUrl='http://192.168.234.163:8080';

 Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String?> getZone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('zone');
  }


  Future<List<Tcompteur>> fetchPersonnes() async {
    String? token = await getToken();
    String? zone= await getZone();
      if (token == null) {
        throw Exception('Token is not available');
      }
       final response = await http.get(
      Uri.parse('$baseUrl/api/compteurs/zone/$zone'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Tcompteur.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load personnes');
    }
  }

  
   Future<List<Parametre>> fetchParametres() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token is not available');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/parametres'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Parametre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load parametres');
    }
  }

  
  Future<void> syncConsommations(List<Consommation> consommations) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('Token is not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/consommations/batch'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(consommations.map((consommation) => consommation.toBackendJson()).toList()),
      );

      if (response.statusCode == 200) {
        // Insérer le code de gestion de la réponse réussie ici
      } else {
        throw Exception('Failed to sync consommations');
      }
    } catch (e) {
      throw Exception('Failed to sync consommations: $e');
    }
  }

  Future<List<List<dynamic>>> fetchStatistics() async {
    String? token = await getToken();
    String? zone = await getZone();
    if (token == null) {
      throw Exception('Token is not available');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/consommations/statistics/$zone'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => item as List<dynamic>).toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }
}
