enum SocialType {
  twitter(name: 'Twitter'),
  instagram(name: 'Instagram'),
  facebook(name: 'Facebook'),
  messenger(name: 'Messenger'),
  linkedin(name: 'LinkedIn'),
  other(name: 'Other');

  const SocialType({required this.name});
  final String name;
}

class SocialModel {
  final String id;
  final SocialType site;
  final String title;
  final String url;

  SocialModel({
    required this.id,
    required this.site,
    required this.title,
    required this.url,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['id'],
      site: () {
        switch (json['site'] as String) {
          case 'Twitter':
            return SocialType.twitter;
          case 'Instagram':
            return SocialType.instagram;
          case 'Facebook':
            return SocialType.facebook;
          case 'Messenger':
            return SocialType.messenger;
          case 'LinkedIn':
            return SocialType.linkedin;
          default:
            return SocialType.other;
        }
      }(),
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'site': site.name,
      'title': title,
      'url': url,
    };
  }
}

class NewSocial {
  final SocialType site;
  final String title;
  final String url;

  NewSocial({
    required this.site,
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'site': site.name,
      'title': title,
      'url': url,
    };
  }
}
