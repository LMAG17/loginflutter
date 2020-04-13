import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GraphlQL Client"),
        ),
        body: Query(
          options: QueryOptions(
            documentNode: gql(r"""
                    query GetContinents{
                        countries{
                          name
                      }
                    }
              """),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading) {
              return Text('Loading');
            }
            if (result.data == null) {
              return Text('No data Found');
            }
            print(result.data);
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(result.data['countries'][index]['name']),
                );
              },
              itemCount: result.data['countries'].length,
            );
          },
        ));
  }
}
