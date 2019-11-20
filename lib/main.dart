import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<List<PurchaseDetails>> subscription;
  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;

        // print(purchaseUpdates.first.);
    subscription = purchaseUpdates.listen((purchases) {
      connectToStore(purchases: purchases);
    });
    super.initState();
  }

  void connectToStore({purchases}) async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print(available);
    print(purchases);
    final ProductDetails productDetails = purchases;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    var response = await InAppPurchaseConnection.instance
        .buyNonConsumable(purchaseParam: purchaseParam);
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Hello',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              child: Text('Try'),
              onPressed: connectToStore,
            )
          ],
        ),
      ),
    );
  }
}
