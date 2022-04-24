import 'package:flutter/material.dart';
import 'package:quick_bite/components/cartListItem.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'CART',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            backgroundColor: Colors.white,
            toolbarHeight: 0.0,
            floating: true,
            forceElevated: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getRow('TOTAL ITEMS', AllData.orderModel.cartItems.length),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              'Proceed To Checkout',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              getChildren(),
            ),
          ),
        ],
      ),
    );
  }

  getChildren() {
    bool showHint = true;
    List<CartListItem> items = [];
    AllData.orderModel.cartItems.forEach((element) {
      items.add(CartListItem(
        showHint: showHint,
        productModel: element,
        setState: (){
          setState(() {
          });
        },
      ));
      showHint = false;
    });
    return items;
  }

  getRow(title, subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '$title : $subtitle',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
