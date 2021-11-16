import 'package:country_directory/model.dart';
import 'package:graphql/client.dart';

const baseURL = "https://countries.trevorblades.com/";

final _httpLink = HttpLink(
  baseURL,
);

final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);

//returns a list of countries names with the country code
Future<List<Country>> getAllCountries() async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getAllCountries),
    ),
  );
  if (result.hasException) {
    throw result.exception!;
  }
  var json = result.data!["countries"];
  List<Country> countries = [];
  for (var res in json) {
    var country = Country.fromJson(res);
    countries.add(country);
  }
  return countries;
}

// returns a country with the given country code
Future<Country> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );

  var json = result.data!["country"];
  print(json);

  var country = Country.fromJson(json);
  return country;
}

const _getAllCountries = r'''
query {
  countries{
    code
    name
    }
  }
''';
const _getCountry = r'''
query getCountry($code:ID!){
  country(code:$code){
    name
    capital
    code
    native
    currency
    phone
    emoji

  }
}

''';
