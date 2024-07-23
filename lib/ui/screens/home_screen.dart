import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lesson82_graphql/core/constants/graphql_mutations.dart';
import 'package:lesson82_graphql/core/constants/graphql_queries.dart';
import 'package:lesson82_graphql/ui/widgets/add_product.dart';
import 'package:lesson82_graphql/ui/widgets/update_product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL Products"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchProducts),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List products = result.data!['products'];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      product['title'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['description']),
                        SizedBox(height: 5),
                        Text('\$${product['price'].toString()}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('Category: ${product['category']['name']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final client = GraphQLProvider.of(context).value;
                            final res = await client.mutate(
                              MutationOptions(
                                document: gql(deleteProduct),
                                variables: {'id': product['id']},
                                onCompleted: (data) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Product deleted"),
                                    ),
                                  );
                                  refetch!();
                                },
                              ),
                            );
                            print(res);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(product: product),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final client = GraphQLProvider.of(context).value;
          //         client.mutate(
          //           MutationOptions(
          //             document: gql(createProduct),
          //             variables: {
          //               "title": "something",
          //               "price": 123,
          //               "description": "123",
          //               'categoryId': 2,
          //               'images': [
          //                 "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp"
          //               ],
          //             },
          //             onCompleted: (data) {
          //               print(data);
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 const SnackBar(
          //                   content: Text("Product added"),
          //                 ),
          //               );
          //               // Navigator.of(context).pop();
          //             },
          //           ),
          //         );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddProductScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
