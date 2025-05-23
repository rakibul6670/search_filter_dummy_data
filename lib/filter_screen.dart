import 'package:flutter/material.dart';
import 'package:search_and_filter_dummy_data/products.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // List to store filtered products (based on search or filter)
  List<Map<String, dynamic>> filterProducts = [];

  // Initialize filterProducts with all products on widget load
  @override
  void initState() {
    super.initState();
    filterProducts = products;
  }

  // Search input value
  String? query;

  // Search function: Filters products by name or category
  void searchProduct(String searchText) {
    setState(() {
      query = searchText;

      // Convert input and fields to lowercase for case-insensitive search
      filterProducts = products.where((product) {
        final title = product["name"].toLowerCase();
        final category = product["category"].toLowerCase();
        final input = searchText.toLowerCase();
        return title.contains(input) || category.contains(input);
      }).toList();
    });
  }

  // List of categories for dropdown filter
  List<String> productCategory = [
    "Electronics",
    "Furniture",
    "Clothing",
  ];

  String? selectCategory;

  // Flags for price sorting
  var isLowToHigh = false;
  var isHighToLow = false;

  // Apply category and price filters
  void applyFilter() {
    setState(() {
      // Filter by selected category
      filterProducts = products.where((product) {
        return selectCategory == null || product["category"] == selectCategory;
      }).toList();

      // Sort by price if any sort option selected
      if (isLowToHigh || isHighToLow) {
        filterProducts.sort((a, b) {
          if (isLowToHigh) {
            return a["price"].compareTo(b["price"]);
          } else {
            return b["price"].compareTo(a['price']);
          }
        });
      }

      // Close bottom sheet after applying filter
      Navigator.pop(context);
    });
  }

  // Bottom sheet UI for selecting category and price sorting
  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown to choose category
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Select your filter category",
                    ),
                    value: selectCategory,
                    items: productCategory.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectCategory = value as String;
                    },
                  ),

                  SizedBox(height: 15),

                  // Price sorting buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Price"),
                      // Low to High button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isLowToHigh ? Colors.green : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isLowToHigh = !isLowToHigh;
                            if(isHighToLow){isHighToLow = false;};
                          });
                        },
                        child: Text("Low to High"),
                      ),
                      // High to Low button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isHighToLow ? Colors.green : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            if(isLowToHigh){isLowToHigh = false;};
                            isHighToLow = !isHighToLow;
                          });
                        },
                        child: Text("High to Low"),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Apply filter button
                  ElevatedButton(
                    onPressed: applyFilter,
                    child: Text("Apply to Filter"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter price, categories"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15),

              // Search bar
              TextFormField(
                onChanged: searchProduct,
                decoration: InputDecoration(
                  hintText: "Search your product by title,author,category",
                  suffix: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Filter heading and filter icon button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Products", style: TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: showBottomSheet,
                    icon: Icon(Icons.filter_alt),
                  ),
                ],
              ),

              // List of filtered products
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filterProducts.length,
                itemBuilder: (context, index) {
                  final product = filterProducts[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(product["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Category: ${product["category"]}"),
                          Text("Price: \$${product["price"]}"),
                          Text("Available: ${product["available"]}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
