import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendtrove/models/cart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trendtrove/pages/mappage.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  const PurchaseDetailsScreen({Key? key}) : super(key: key);

  @override
  _PurchaseDetailsScreenState createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Details'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Shoes Purchased:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.getUserCart().length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cart.getUserCart()[index].name),
                      subtitle: Text('\Rs${cart.getUserCart()[index].price}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Amount: \Rs${cart.getTotalAmount().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  LatLng? location = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSample(),
                    ),
                  );
                  setState(() {
                    selectedLocation = location;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    selectedLocation != null
                        ? 'Selected Location: $selectedLocation'
                        : 'Select Location',
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () async {
                      List<Map<String, dynamic>> shoeDetailsList = [];
                      for (var shoe in cart.getUserCart()) {
                        shoeDetailsList.add({
                          'name': shoe.name,
                          'price': shoe.price,
                        });
                      }
                      await FirebaseFirestore.instance
                          .collection('purchases')
                          .add({
                        'shoes': shoeDetailsList,
                        'totalAmount': cart.getTotalAmount(),
                        //'location': selectedLocation?.toJson(), // assuming LatLng has a toJson() method
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'CheckOut',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
