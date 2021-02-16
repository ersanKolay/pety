import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyCJVxsLcCXlPPDHj61olkI1oD0vCR6Vm_Y';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:Y%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<Map<dynamic, dynamic>> getPlaceAddress(
      double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    List<dynamic> addressComponents =
        json.decode(response.body)['results'][0]['address_components'];
    String countries = addressComponents
        .where((entry) => entry['types'].contains('country'))
        .toList()
        .map((entry) => entry['long_name'])
        .toString();
    String city = addressComponents
        .where(
            (entry) => entry['types'].contains('administrative_area_level_1'))
        .toList()
        .map((entry) => entry['long_name'])
        .toString();

    //print(json.decode(response.body));
    String stringCity = city.replaceAll("(", "");
    stringCity = stringCity.replaceAll(")", "");
    String stringCountries = countries.replaceAll("(", "");
    stringCountries = stringCountries.replaceAll(")", "");
    Map<dynamic, dynamic> makeMap = {
      'address': json.decode(response.body)['results'][0]['formatted_address'],
      'country': stringCountries,
      'city': stringCity
    };
    return makeMap;
  }
}
