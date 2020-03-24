class Post {
  final int id;
  final String title;
  final String guid;
  final String selfLink;
  final String mediaLink;
  final String content;
  final DateTime date;
  final String webPageLink;
  String imageUrl;
  get getImageUrl => imageUrl;

  Post({this.id, this.title, this.guid, this.selfLink, this.mediaLink, this.content, this.date, this.webPageLink});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      guid: json['guid']['rendered'],
      selfLink: json['_links']['self'][0]['href'],
      mediaLink: json['_links']['wp:featuredmedia'][0]['href'],
      content: json['content']['rendered'],
      date: DateTime.parse(json['date']),
      webPageLink: json['link'],
    );
  }
  void setImageUrl(String imageUrl) {this.imageUrl = imageUrl;}
}