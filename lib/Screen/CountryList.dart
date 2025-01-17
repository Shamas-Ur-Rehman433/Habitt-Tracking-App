import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchCountries() async {
  try {
    final response = await http.get(Uri.parse('https://api.sampleapis.com/countries/countries'));

    if (response.statusCode == 200) {
      // Decode the response body as a list of maps
      List<dynamic> data = json.decode(response.body);  // Decoding the list of countries

      // Extract country names from the list of maps
      List<String> countries = data.map<String>((country) => country['name'] as String).toList();

      countries.sort();  // Sort alphabetically
      return countries;  // Return the list of country names
    } else {
      throw Exception('Failed to load countries');
    }
  } catch (e) {
    print('Error fetching countries: $e');
    return [];  // Return an empty list if there's an error
  }
}
