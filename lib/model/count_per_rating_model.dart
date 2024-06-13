class CountPerRatingModel {
  int five;
  int four;
  int three;
  int two;
  int one;

  CountPerRatingModel({
    required this.five,
    required this.four,
    required this.three,
    required this.two,
    required this.one,
  });

  factory CountPerRatingModel.fromJson(Map<String, dynamic> json) {
    return CountPerRatingModel(
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
}
