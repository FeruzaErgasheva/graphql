import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lesson82_graphql/config/graphql_config.dart';
import 'package:lesson82_graphql/ui/screens/home_screen.dart';

void main() {
  final client = GraphqlConfig.initializeClient();
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
          child: MaterialApp(
        home: HomeScreen(),
      )),
    );
  }
}
