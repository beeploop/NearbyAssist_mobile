class ServicePhoto {
  String serviceId;
  String vendorId;
  String url;

  ServicePhoto({
    required this.serviceId,
    required this.vendorId,
    required this.url,
  });

  factory ServicePhoto.fromJson(Map<String, dynamic> json) {
    return ServicePhoto(
      serviceId: json['ServiceId'],
      vendorId: json['VendorId'],
      url: json['Url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'vendorId': vendorId,
      'url': url,
    };
  }
}
