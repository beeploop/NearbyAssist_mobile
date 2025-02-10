class RatingCountModel {
  final int five;
  final int four;
  final int three;
  final int two;
  final int one;

  RatingCountModel({
    required this.five,
    required this.four,
    required this.three,
    required this.two,
    required this.one,
  });

  factory RatingCountModel.fromJson(Map<String, dynamic> json) {
    return RatingCountModel(
      five: json['five'],
      four: json['four'],
      three: json['three'],
      two: json['two'],
      one: json['one'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'five': five,
      'four': four,
      'three': three,
      'two': two,
      'one': one,
    };
  }

  int total() {
    return one + two + three + four + five;
  }
}
