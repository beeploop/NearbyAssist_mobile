class SearchResultModel {
  String id;
  double score;
  int rank;
  String vendor;
  double latitude;
  double longitude;

  SearchResultModel({
    required this.id,
    required this.score,
    required this.rank,
    required this.vendor,
    required this.latitude,
    required this.longitude,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'],
      score: double.parse(json['score'].toString()),
      rank: json['rank'],
      vendor: json['vendor'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
