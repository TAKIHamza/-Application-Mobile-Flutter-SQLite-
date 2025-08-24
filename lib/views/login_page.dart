import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifsan/views/navigation_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

 Future<void> _login() async {
  setState(() {
    _errorMessage = '';
    _isLoading = true; // Show loader
  });

  try {
    // Extracting username and password from text fields
    String username = _usernameController.text;
    String password = _passwordController.text;
    if(username.isEmpty || password.isEmpty){
      setState(() {
        _errorMessage = 'Please enter username and password';
      });
      return;
    }
 print('Username: $username');
      print('Password: $password');
    // Your API endpoint for authentication
    String apiUrl = 'http://192.168.234.163:8080/api/utilisateurs/login';

    // Making a POST request to authenticate the user
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json', 
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['jwtToken'];
      String email = responseData['email'];
      String zone = responseData['zone'];
      Parametre parameter = Parametre(name: 'username', value: responseData['nom']);
      print(token);
      print(responseData['nom']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
       await prefs.setString('email', email);
        await prefs.setString('zone', zone);
    await DatabaseProvider.db.insertRecord(DatabaseProvider.TABLE_NAME_PARAMETRE, parameter.toJson());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } else {
      // If authentication failed, show error message
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  } catch (error) {
    // Handle any exceptions that occur during login
    setState(() {
      _errorMessage = 'An error occurred during login';
    });
  } finally {
    setState(() {
      _isLoading = false; // Hide loader
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 85),
            Image.asset(
              'assets/logoWithName.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isLoading) CircularProgressIndicator(), // Show loader if loading
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.person, color: Color.fromARGB(255, 38, 111, 121)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 38, 111, 121)),
                    ),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 180,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _login, // Call the login method
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 180,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => NavigationPage()),
                          );
                      },
                      child: const Text(
                        'HORS-LIGNE',
                        style: TextStyle(color: Color.fromARGB(255, 102, 116, 119)),
                      ),
                    ),
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
