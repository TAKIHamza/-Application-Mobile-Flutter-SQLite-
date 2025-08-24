int getTrimestreFromDate(DateTime date) {
  // Obtenez le mois à partir de la date
  int month = date.month;

  // Déterminez le trimestre en fonction du mois
  if (month >= 1 && month <= 3) {
    return 1; // Premier trimestre
  } else if (month >= 4 && month <= 6) {
    return 2; // Deuxième trimestre
  } else if (month >= 7 && month <= 9) {
    return 3; // Troisième trimestre
  } else {
    return 4; // Quatrième trimestre
  }
}