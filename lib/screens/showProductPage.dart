import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/apis/AllApis.dart';
import 'package:quick_bite/components/carouselImage.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/models/productModel.dart';
import 'package:quick_bite/screens/showStorePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../components/ratingWidget.dart';

class ShowProductPage extends StatefulWidget {
  final ProductModel productModel;

  const ShowProductPage({required this.productModel});

  @override
  _ShowProductPageState createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage> {
  double animationValue = 1;

  PanelController panelController = PanelController();

  Map<String, Icon> vehicleTypes = {
    'Car': Icon(IconData(0xf2c1,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage)),
    'Bike': Icon(Icons.motorcycle_sharp),
    'Scooter': Icon(Icons.electric_scooter),
    'Bicycle': Icon(Icons.directions_bike_outlined)
  };

  String priceCategory = 'Days';

  String productState = 'No State';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: height - (animationValue * 140),
                child: widget.productModel.productImages.length > 0
                    ? Center(
                  child: CarouselImage(
                    imageData: widget.productModel.productImages,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),
                )
                    : Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 30 + ((1 - animationValue) * 10),
                  ),
                ),
              ),
              Positioned(
                bottom: 60 - 30 * animationValue,
                width: width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getBox(
                          icon: vehicleTypes[
                          manageCriteria(widget.productModel.criteria)],
                          title: manageCriteria(widget.productModel.criteria)),
                      getBox(
                          icon: Icon(Icons.store),
                          title: 'Visit Store',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowStorePage(),
                              ),
                            );
                          }),
                      getBox(
                        icon: Icon(Icons.arrow_back),
                        title: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlidingUpPanel(
              controller: panelController,
              onPanelSlide: (value) {
                setState(() {
                  animationValue = value;
                });
              },
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              maxHeight: 160,
              minHeight: 50,
              panel: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel.model,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Store: ' + widget.productModel.storeName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingWidget(
                                initialRating: widget.productModel.ratings),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '(${widget.productModel.ratedBy} Reviews)',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          priceCategory == 'Days'
                              ? '\u20B9' + widget.productModel.rentPerDay
                              : '\u20B9' + widget.productModel.rentPerHour,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    value: priceCategory,
                                    items: <String>['Days', 'Hours']
                                        .map((String e) {
                                      return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        priceCategory = val.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: productState == 'loading'
                              ? null
                              : () {
                            String state = 'Cart';
                            if (productState == 'No State') {
                              state = 'Cart';
                            } else {
                              state = 'Delete';
                            }
                            setState(() {
                              productState = 'loading';
                            });
                            SharedPreferences.getInstance().then(
                                  (value) {
                                AllApis()
                                    .changeProductState(
                                  token: value.getString('token'),
                                  productId:
                                  widget.productModel.productId,
                                  storeId: widget.productModel.storeId,
                                  state: state,
                                )
                                    .then(
                                      (value) {
                                    setState(() {
                                      if (state == 'Cart') {
                                        productState = 'Cart';
                                        AllData.orderModel.cartItems.add(
                                            widget.productModel);
                                      } else {
                                        productState = 'No State';
                                        final cartItems = AllData.orderModel
                                            .cartItems;
                                        for (int i = 0; i <
                                            cartItems.length; i++) {
                                          if (cartItems[i].productId ==
                                              widget.productModel.productId){
                                            AllData.orderModel.cartItems.removeAt(i);
                                          }
                                        }
                                      }
                                      widget.productModel.state =
                                          productState;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          productState == 'Cart'
                                              ? 'Added to cart'
                                              : 'Removed from cart',
                                          style: TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Material(
                            elevation: 5,
                            shadowColor: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: productState == 'loading'
                                    ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : productState == 'Cart'
                                    ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Cart',
                                  style:
                                  TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productState = widget.productModel.state;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      panelController.open();
    });
  }

  String manageCriteria(criteria) {
    final cr = widget.productModel.criteria
        .toString()
        .toLowerCase()
        .characters
        .first
        .toUpperCase() +
        widget.productModel.criteria.toString().toLowerCase().substring(1);
    return cr;
  }

  Widget getBox({@required icon, @required title, onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 70 - 10 * animationValue,
            width: 70 - 10 * animationValue,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: icon,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
