import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsString = prefs.getString('products');
    if (productsString != null) {
      setState(() {
        _products = List<Map<String, dynamic>>.from(jsonDecode(productsString));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int index) async {
    setState(() {
      _products.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('products', jsonEncode(_products));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _filteredProducts = _products
        .where((product) => product['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi-Fi Shop & Service'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Products',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                _filteredProducts.isEmpty
                    ? Center(child: Text('No Product Found'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.network(
                                  _filteredProducts[index]['image']),
                              title: Text(_filteredProducts[index]['name']),
                              subtitle: Text(
                                  "\$${_filteredProducts[index]['price']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteProduct(index),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addProduct'),
        child: Icon(Icons.add),
      ),
    );
  }
}
