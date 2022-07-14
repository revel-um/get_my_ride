import 'package:flutter/material.dart';
import 'package:quick_bite/components/OrderItem.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab();

  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  TextEditingController controller = TextEditingController();

  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 45,
            child: TextField(
              controller: controller,
              cursorWidth: 2,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                print(text);
              },
              onChanged: (_){
                setState(() {
                  text = _;
                });
              },
              cursorColor: Colors.grey.shade500,
              decoration: InputDecoration(
                hintText: 'Search in orders',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.pink,
                ),
                suffixIcon: text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          controller.text = '';
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.pink,
                        ),
                      ),
                hintStyle: TextStyle(color: Colors.grey.shade500, height: 3),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: OrderItem(),
          ),
          itemCount: 10,
        ),
      ),
    );
  }
}
