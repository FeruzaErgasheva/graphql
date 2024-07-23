import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lesson82_graphql/core/constants/graphql_mutations.dart';

class EditProductScreen extends StatefulWidget {
  final Map product;

  const EditProductScreen({required this.product, super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product['title']);
    _descriptionController =
        TextEditingController(text: widget.product['description']);
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
  }

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
        title: const Text("Edit Product"),
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
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final client = GraphQLProvider.of(context).value;
                final variables = {
                  'id': widget.product['id'],
                  'changes': {
                    'title': _titleController.text,
                    'price': double.tryParse(_priceController.text),
                    'description': _descriptionController.text,
                    'categoryId': widget.product['category']
                        ['id'], // Assuming category ID
                  },
                };

                final MutationOptions options = MutationOptions(
                  document: gql(updateProduct),
                  variables: variables,
                  onCompleted: (dynamic resultData) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Product updated successfully')),
                    );
                    Navigator.pop(context);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Failed to update product: ${error.toString()}')),
                    );
                  },
                );

                await client.mutate(options);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}