import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nepalikagaj/modal/Post.dart';

import 'get_media_link.dart';

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

Future<List<Post>> fetchPostsAndImageLinks() async {
  List<Post> list = await fetchPosts();
  List<Post> posts = new List();

//    await Future.wait(list.map((input) async {
//      await setImageUrl(input);
//      posts.add(input);
//    }));
  await Future.forEach(list, (elem) async {
    await setImageUrl(elem);
    posts.add(elem);
  });

  return posts;
}

setImageUrl(Post post) async {
  var imageUrl = await fetchMedia(post.mediaLink);
  post.setImageUrl(imageUrl);
}
