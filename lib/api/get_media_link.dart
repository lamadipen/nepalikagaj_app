import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> fetchMedia(mediaUrl) async {
  final response = await http.get(mediaUrl);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decode = json.decode(response.body);
    var test = decode['media_details']['sizes']['medium_large']['source_url'];
    return test;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print("Error return empty list");

    return new Future.value("");
  }
}
