
import 'package:flutter_test/flutter_test.dart';
import 'package:nepalikagaj/api/get_media_link.dart';

void main(){
  test('can get media for the resource link', (){
    var fetchMedia2 = fetchMedia("https://nepalikagaj.com/wp-json/wp/v2/media/6401");
    var expected = "https://nepalikagaj.com/wp-content/uploads/2020/03/punam12-768x496.jpg";
    fetchMedia2.then((actual) => expect(actual,expected));
  });
}