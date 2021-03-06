import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nepalikagaj/modal/Post.dart';

Future<List<Post>> fetchPosts() async {
  var postsUrl = 'https://nepalikagaj.com/wp-json/wp/v2/posts';
  final response = await http.get(postsUrl);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body) as List)
        .map((post) => Post.fromJson(post))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print("Error return empty list");

    return new Future.value([]);
  }
}
