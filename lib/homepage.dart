import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    getProduct();
  }
  var myBox=Hive.box('MyBox');
  TextEditingController product=TextEditingController();
  TextEditingController price=TextEditingController();
  List myData=[];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Hive DataBase'),
      ),
      floatingActionButton: FloatingActionButton(child : Icon(Icons.add),backgroundColor: Colors.orange, onPressed: (){
      showBottomSheet();
      },
      ),
      body: ListView.builder(
          itemCount:  myData.length,
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.only(left: 8,right: 8,top: 3),
            child: Card(
                elevation: 10,
              shadowColor: Colors.orange,
              child: ListTile(
                title: Text(myData[index]['product']),
                subtitle: Text(myData[index]['price']),
                trailing: SizedBox(width: 100,
                child: Row(children: [
                  IconButton(onPressed: (){
                    product.text=myData[index]['product'];
                    price.text=myData[index]['price'];
                    updateShowBottomSheet(myData[index]['key']);

                  }, icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){
                    deleteProduct(myData[index]['key']);
                  }, icon: Icon(Icons.delete)),
                ],),),
              ),
            ),);

      }),
    );
  }


  void showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context)=>
        Container(
          child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: product,
                decoration: InputDecoration(
                    hintText: 'Enter Product',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: price,
                decoration: InputDecoration(
                    hintText: 'Enter price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                Map newProduct={
                  'product':product.text,
                  'price':price.text,
                };
                addProduct(newProduct);
                getProduct();
                product.clear();
                price.clear();

              },
                  child: Text('Add Product')),
            ],
          ),),
        )
    );
  }
  void addProduct(data)async{
    await myBox.add(data);
    print(myBox.values);
  }
  void getProduct(){
    myData=myBox.keys.map((a){
      var res=myBox.get(a);
     return{
       'key':a,
       'product':res['product'],
       'price':res['price']
     };

    }

    ).toList();
    setState(() {

    });
  }
  void deleteProduct(key)async{
    await  myBox.delete(key);
    getProduct();
  }
  void updateShowBottomSheet(key){
    showModalBottomSheet(context: context, builder: (context)=>
        Container(
          child: Padding(padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: product,
                  decoration: InputDecoration(
                      hintText: 'Enter Product',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: price,
                  decoration: InputDecoration(
                      hintText: 'Enter price',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  Map newProduct={
                    'product':product.text,
                    'price':price.text,
                  };
                  updateProduct(key, newProduct);
                  getProduct();
                  product.clear();
                  price.clear();

                }, child: Text('update Product')),
              ],
            ),),
        )
    );
  }
  void   updateProduct(key ,data)async{
    await myBox.put(key, data);
    getProduct();
  }
}
