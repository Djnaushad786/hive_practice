import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List myData = [];
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var myBox = Hive.box('MyBox');

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() {
    myData = myBox.keys.map((key) {
      final res = myBox.get(key);
      if (res is Map) {
        return {
          'key': key,
          'product': res['product'],
          'price': res['price']
        };
      } else {
        return {
          'key': key,
          'product': 'Invalid Data',
          'price': 'Invalid Data'
        };
      }
    }).toList();
    setState(() {});
  }

  void addProduct() {
    final newProduct = {
      'product': productController.text,
      'price': priceController.text,
    };
    myBox.add(newProduct);
    productController.clear();
    priceController.clear();
    getProduct();
  }

  void deleteProduct(key) async {
    await myBox.delete(key);
    getProduct();
  }

  void updateProduct(key, data) async {
    await myBox.put(key, data);
    getProduct();
  }

  void showBottomSheet({String? key}) {
    if (key != null) {
      final existingProduct = myBox.get(key);
      if (existingProduct is Map) {
        productController.text = existingProduct['product'] ?? '';
        priceController.text = existingProduct['price'] ?? '';
      }
    } else {
      productController.clear();
      priceController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productController,
              decoration: InputDecoration(labelText: 'Product'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (key != null) {
                  updateProduct(key, {
                    'product': productController.text,
                    'price': priceController.text,
                  });
                } else {
                  addProduct();
                }
                Navigator.pop(context);
              },
              child: Text(key != null ? 'Update Product' : 'Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive Database')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showBottomSheet(),
      ),
      body: myData.isEmpty
          ? Center(child: Text('No Products Available'))
          : ListView.builder(
        itemCount: myData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(myData[index]['product']),
              subtitle: Text(myData[index]['price']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showBottomSheet(key: myData[index]['key']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteProduct(myData[index]['key']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
