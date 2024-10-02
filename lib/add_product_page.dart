import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _isLoading = false;

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? productsString = prefs.getString('products');
      List<Map<String, dynamic>> products = [];

      if (productsString != null) {
        products = List<Map<String, dynamic>>.from(jsonDecode(productsString));
      }

      // Check for product duplicacy
      if (products.any((product) => product['name'] == _nameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product already exists'),
        ));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      products.add({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
      });

      await prefs.setString('products', jsonEncode(products));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _imageController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addProduct,
                      child: Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
