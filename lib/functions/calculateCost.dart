double calculateCost(double lastReading, 
                     double currentReading, 
                     double rate1, double threshold1, 
                     double rate2, double threshold2, 
                     double rate3, double maxReading, 
                     double fixedPrice) {
  double totalCost = 0.0;

  if (currentReading <= lastReading ) {
    return totalCost;
  }

  double consumed = currentReading - lastReading;

  if (consumed <= threshold1) {
    totalCost = consumed * rate1;
  } else if (consumed <= threshold2) {
    totalCost = threshold1 * rate1 + (consumed - threshold1) * rate2;
  } else {
    totalCost = threshold1 * rate1 + (threshold2 - threshold1) * rate2 + (consumed - threshold2) * rate3;
  }

  return totalCost + fixedPrice;
}
