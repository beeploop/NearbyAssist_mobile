class SearchResultModel {
  String id;
  String vendorName;
  double suggestionScore;
  double rate;
  double rating;
  double latitude;
  double longitude;
  int completedBookings;
  double distance;

  SearchResultModel({
    required this.id,
    required this.vendorName,
    required this.suggestionScore,
    required this.rate,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.completedBookings,
    required this.distance,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'],
      vendorName: json['vendorName'],
      suggestionScore: double.parse(json['suggestionScore'].toString()),
      rate: double.parse(json['rate'].toString()),
      rating: double.parse(json['rating'].toString()),
      latitude: json['latitude'],
      longitude: json['longitude'],
      completedBookings: int.parse(json['completedBookings'].toString()),
      distance: double.parse(json['distance'].toString()),
    );
  }
}
