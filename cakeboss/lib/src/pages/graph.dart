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
            documentNode: gql(r"""query {
                    characters{
                      info{
                        pages
                      }
                      results{
                        id
                        name
                        species
                        gender
                        origin{name}
                        location{name}
                        image
                      }
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        result.data['characters']['results'][index]['image']),
                  ),
                  title:
                      Text(result.data['characters']['results'][index]['name']),
                  subtitle: Text(result.data['characters']['results'][index]
                          ['species'] +
                      '=>' +
                      result.data['characters']['results'][index]['gender']),
                  trailing: Text(
                      result.data['characters']['results'][index]['origin']['name']),
                );
              },
              itemCount: result.data['characters']['results'].length,
            );
          },
        ));
  }
}
