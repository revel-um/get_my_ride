import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quick_bite/components/networkAndFileImage.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/AllApis.dart';
import '../models/productModel.dart';

class CartListItem extends StatefulWidget {
  final showHint;
  final ProductModel productModel;
  final setState;

  const CartListItem(
      {this.showHint = false,
      required this.productModel,
      @required this.setState});

  @override
  _CartListItemState createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  // static const IconData cancel = IconData(0xf71e,
  //     fontFamily: CupertinoIcons.iconFont,
  //     fontPackage: CupertinoIcons.iconFontPackage);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 5.0,
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  final cartItems = AllData.orderModel.cartItems;
                  for (int i = 0; i < cartItems.length; i++) {
                    if (cartItems[i].productId ==
                        widget.productModel.productId) {
                      SharedPreferences.getInstance().then(
                        (value) {
                          AllApis()
                              .changeProductState(
                            token: value.getString('token'),
                            productId: widget.productModel.productId,
                            storeId: widget.productModel.storeId,
                            state: 'Delete',
                          )
                              .then(
                            (value) {
                              AllData.orderModel.cartItems.removeAt(i);
                              AllData.reload = true;
                              widget.setState();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Removed from cart',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                      break;
                    }
                  }
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: NetworkAndFileImage(
                    height: 70,
                    borderRadius: BorderRadius.circular(0),
                    fit: BoxFit.fitWidth,
                    iconColor: Colors.black,
                    imageData: widget.productModel.productImages.length == 0
                        ? null
                        : widget.productModel.productImages[0],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: Color(0x12000000),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: RichText(
                    text: TextSpan(
                      text: widget.productModel.model + '\n',
                      style: TextStyle(color: Colors.black, height: 1.5),
                      children: [
                        TextSpan(text: widget.productModel.storeName + '\n'),
                        TextSpan(text: widget.productModel.rentPerDay)
                      ],
                    ),
                  ),
                ),
                Spacer(),
                if (widget.showHint)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '<-- Slide to delete',
                      style: TextStyle(
                        color: Color(0x24000000),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
