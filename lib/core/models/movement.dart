class Movement {
  String type;
  String symbol;
  double volume;
  double price;
  DateTime time;

  Movement({
    required this.type,
    required this.symbol,
    required this.volume,
    required this.price,
    required this.time,
  });
}
