import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fond blanc pour la carte
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 197, 252, 231), // Couleur de début du dégradé
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
                          
              // Couleur de fin du dégradé
            ],),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Couleur de l'ombrage
              blurRadius: 10, // Flou de l'ombrage
              offset: Offset(0, 4), // Décalage de l'ombrage
            ),
          ],
        ),
        child: Row(
          children: [
             Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Association     ',
                    style: GoogleFonts.getFont(
                      'Nunito',
                      fontSize: 22,
                      color: Color.fromARGB(179, 11, 46, 58), // Couleur du texte
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'ifsane',
                    style: GoogleFonts.getFont(
                      'Nunito',
                      fontSize: 22,
                      color: Color.fromARGB(179, 11, 46, 58),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'de l’eau',
                    style: GoogleFonts.getFont(
                      'Nunito',
                      fontSize: 22,
                      color: Color.fromARGB(179, 11, 46, 58),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'potable',
                    style: GoogleFonts.getFont(
                      'Nunito',
                      fontSize: 22,
                      color: Color.fromARGB(179, 11, 46, 58),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/WaterTap.gif',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
