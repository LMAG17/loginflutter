import 'package:cakeboss/graph.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://countries.trevorblades.com/");
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
          title: 'Graph&Flutter',
          home: GraphPage(),
        ),
      ),
    );
  }
}
