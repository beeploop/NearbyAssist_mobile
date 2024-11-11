class KeyModel {
  final String public;
  final String private;

  KeyModel({required this.public, required this.private});

  Map<String, dynamic> toJson() {
    return {
      'publicPem': public,
      'privatePem': private,
    };
  }
}
