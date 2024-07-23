

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lesson82_graphql/core/constants/graphql_mutations.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int? _selectedCategoryId;
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Category 1'},
    {'id': 2, 'name': 'Category 2'},
    {'id': 3, 'name': 'Category 3'},
    // Add more categories as needed
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration:const  InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: InputDecoration(labelText: 'Category'),
              items: _categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  // final client = GraphQLProvider.of(context).value;
                  // client.mutate(
                  //   MutationOptions(
                  //     document: gql(createProduct),
                  //     variables: {
                  //       "title": _titleController.text,
                  //       "price": _priceController.text,
                  //       "description": _descriptionController.text,
                  //       'categoryId': value,
                  //       'images': [
                  //         "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp"
                  //       ],
                  //     },
                  //     onCompleted: (data) {
                  //       print(data);
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text("Product added"),
                  //         ),
                  //       );
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // );
                   final client = GraphQLProvider.of(context).value;
                  client.mutate(
                    MutationOptions(
                      document: gql(createProduct),
                      variables:  {
                        "title": _titleController.text,
                        "price": double.parse(_priceController.text),
                        "description": _descriptionController.text,
                        'categoryId': _selectedCategoryId,
                        'images': const [
                          "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp"
                        ],
                      },
                      onCompleted: (data) {
                        print(data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product added"),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
