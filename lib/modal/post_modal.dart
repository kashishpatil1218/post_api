class Post {
  int id;
  String title;
  String body;
  List<String> tags;
  Reactions reactions;
  int views;
  int userId;
  String imgUrl;
  bool isLiked;
  bool isDisliked;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
    required this.imgUrl,
    this.isLiked = false,
    this.isDisliked= false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      reactions: Reactions.fromJson(json['reactions']),
      views: json['views'],
      userId: json['userId'],
      imgUrl:
          'https://picsum.photos/id/${json['id'] + 100}/200/200', // dummy image
    );
  }

  void toggleLike() {
    isLiked = !isLiked;
    if (isLiked) {
      reactions.likes++;
    } else {
      reactions.dislikes--;
    }
  }
  void dislike() {
    reactions.dislikes--;
  }
}

class Reactions {
  int likes;
  int dislikes;

  Reactions({required this.likes, required this.dislikes});

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(likes: json['likes'], dislikes: json['dislikes']);
  }
}
