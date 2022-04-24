import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/models/productModel.dart';

class OrderModel {
  List<ProductModel> cartItems = [];
  List<ProductModel> inProcessItems = [];
  List<ProductModel> completedItems = [];
  List<ProductModel> favouritesItems = [];

  final stateConverter = {
    0: 'Cart',
    1: 'Order Confirmed',
    2: 'Order Complete',
    3: 'Favourites'
  };

  void setOrderModel(List items) {
    items.forEach((element) {
      final product = element['product'];
      ProductModel model = ProductModel();
      model.productId = product['_id'].toString();
      model.model = product['model'].toString();
      model.licencePlate = product['licencePlate'].toString();
      model.rentPerHour = product['rentPerHour'].toString();
      model.rentPerDay = product['rentPerDay'].toString();
      model.productImages = product['productImages'] ?? [];
      model.criteria = product['criteria'].toString();
      model.details = product['details'].toString();
      model.bullets = product['bullets'].toString();
      model.discount = product['discount'] ?? 0;
      model.ratings = product['ratings'] ?? 0;
      model.ratedBy = product['ratedBy'] ?? 0;
      model.isDiscountPercent = product['isDiscountPercent'] ?? false;
      model.booked = product['booked'] ?? false;
      model.state = stateConverter[element['state']] ?? 'No State';
      model.storeId = product['store'];

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
      if (model.state == 'Cart') {
        cartItems.add(model);
      } else if (model.state == 'Order Confirmed') {
        inProcessItems.add(model);
      } else if (model.state == 'Order Complete') {
        completedItems.add(model);
      } else if (model.state == 'Favourites') {
        favouritesItems.add(model);
      }
    });
    AllData.orderModel = this;
  }
}
