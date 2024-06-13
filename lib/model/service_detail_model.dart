import 'package:nearby_assist/model/count_per_rating_model.dart';
import 'package:nearby_assist/model/service_image_model.dart';
import 'package:nearby_assist/model/service_info_model.dart';
import 'package:nearby_assist/model/vendor_info_model.dart';

class ServiceDetailModel {
  CountPerRatingModel countPerRating;
  ServiceInfoModel serviceInfo;
  VendorInfoModel vendorInfo;
  List<ServiceImageModel> serviceImages;

  ServiceDetailModel({
    required this.countPerRating,
    required this.serviceInfo,
    required this.vendorInfo,
    required this.serviceImages,
  });
}
