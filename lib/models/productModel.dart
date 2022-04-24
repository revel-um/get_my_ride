import 'package:quick_bite/models/orderModel.dart';

import '../globalsAndConstants/allConstants.dart';

class ProductModel {
  late String productId;
  late String model;
  late String licencePlate;
  late String rentPerHour;
  late String rentPerDay;
  late List productImages;
  late String criteria;
  late String details;
  late String bullets;
  late String state = 'No State';
  var discount;
  var ratings;
  var ratedBy;
  late bool isDiscountPercent;
  late bool booked;

  late String storeId;
  late String storeName;
  late String storeImage;
  late int pinCode;
  late String phoneNumber;
  late String city;
  late double latitude;
  late double longitude;
  late String address;
  late String creationDate;
  late bool subscriptionExpired;
  late List openHours;
  late List closeHours;

  final stateConverter = {
    0: 'Cart',
    1: 'Order Confirmed',
    2: 'Order Complete',
    3: 'Favourites'
  };

  void setProductModelsFromJsonBody(body) {
    List data = body['data'];
    List items = [];
    if (body['order'] != null) {
      items = body['order']['items'];
      final user = body['order']['user'];
      if (user != null) {
        AllData.userModel.setUserModelFromJsonBody(user);
      }
    }

    final productIdVsState = {};

    items.forEach((element) {
      if (element['product'] != null) {
        productIdVsState[element['product']['_id']] =
            stateConverter[element['state']];
      }
    });
    OrderModel().setOrderModel(items);
    List<ProductModel> productModels = getProductList(data, productIdVsState);
    AllData.productModelList = productModels;
  }

  List<ProductModel> getProductList(data, productIdVsState) {
    List<ProductModel> products = [];
    data.forEach((element) {
      ProductModel model = ProductModel();
      model.productId = element['_id'].toString();
      model.model = element['model'].toString();
      model.licencePlate = element['licencePlate'].toString();
      model.rentPerHour = element['rentPerHour'].toString();
      model.rentPerDay = element['rentPerDay'].toString();
      model.productImages = element['productImages'] ?? [];
      model.criteria = element['criteria'].toString();
      model.details = element['details'].toString();
      model.bullets = element['bullets'].toString();
      model.discount = element['discount'] ?? 0;
      model.ratings = element['ratings'] ?? 0;
      model.ratedBy = element['ratedBy'] ?? 0;
      model.isDiscountPercent = element['isDiscountPercent'] ?? false;
      model.booked = element['booked'] ?? false;

      model.state = productIdVsState[element['_id']] ?? 'No State';

      final store = element['store'];
      model.storeId = store['_id'].toString();
      model.storeName = store['storeName'].toString();
      model.pinCode = store['pinCode'] ?? -1;
      model.phoneNumber = store['phoneNumber'].toString();
      model.city = store['city'].toString();
      model.latitude = store['latitude'] ?? -1;
      model.longitude = store['longitude'] ?? -1;
      model.address = store['address'].toString();
      model.creationDate = store['creationDate'];
      model.subscriptionExpired = store['subscriptionExpired'] ?? false;
      model.openHours = store['openHours'];
      model.closeHours = store['closeHours'];
      products.add(model);
    });
    return products;
  }
}
