class ReverseGeocodingModel {
  final int placeId;
  final String osmType;
  final int osmId;
  final String latitude;
  final String longitude;
  final String type;
  final int placeRank;
  final double importance;
  final String addresstype;
  final String name;
  final String displayName;

  ReverseGeocodingModel({
    required this.placeId,
    required this.osmType,
    required this.osmId,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addresstype,
    required this.name,
    required this.displayName,
  });

  factory ReverseGeocodingModel.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodingModel(
      placeId: json['place_id'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      latitude: json['lat'],
      longitude: json['lon'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: json['importance'],
      addresstype: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
    );
  }
}
