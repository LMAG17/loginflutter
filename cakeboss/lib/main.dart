import 'package:cakeboss/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "http://rickandmortyapi.com/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: InMemoryCache(),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Graph&Flutter',
          home: LoginPage(),
        ),
      ),
    );
  }
}
