import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modal/post_modal.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;

  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/posts/add'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Post> loadedPosts = (data['posts'] as List).map((item) {
          return Post.fromJson(item);
        }).toList();

        _posts = loadedPosts;
      } else {
        print("Failed to load posts. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void likePost(int index) {
    final post = _posts[index];

    if (post.isLiked) {
      post.isLiked = false;
      post.reactions.likes--;
    } else {
      if (post.isDisliked) {
        post.isDisliked = false;
        post.reactions.dislikes--;
      }
      post.isLiked = true;
      post.reactions.likes++;
      post.showLikeAnimation = true;

      post.showLikeAnimation = true;

      Future.delayed(Duration(milliseconds: 1200), () {
        post.showLikeAnimation = false;
        notifyListeners();
      });
    }

    notifyListeners();
  }

  void hideLikeAnimation(int index) {
    _posts[index].showLikeAnimation = false;
    notifyListeners();
  }

  void disLikePost(int index) {
    final post = _posts[index];

    if (post.isDisliked) {
      // Remove dislike
      post.isDisliked = false;
      post.reactions.dislikes--;
    } else {
      // Switch from like to dislike
      if (post.isLiked) {
        post.isLiked = false;
        post.reactions.likes--;
      }
      post.isDisliked = true;
      post.reactions.dislikes++;
    }
    notifyListeners();
  }

  //new  post
  Future<void> addPost(Post post) async {
    final url = Uri.parse("https://dummyjson.com/posts/add");

    final body = {
      "title": post.title,
      "body": post.body,
      "userId": post.userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newPost = Post(
          id: data["id"],
          title: data["title"],
          body: data["body"],
          imgUrl: post.imgUrl,
          userId: data["userId"],
          views: 0,
          tags: [],
          reactions: Reactions(likes: 0, dislikes: 0),
          isLiked: false,
          isDisliked: false,
        );

        _posts.insert(0, newPost);
        notifyListeners();
      } else {
        throw Exception(
          "Failed to add post. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error adding post: $e");
      rethrow;
    }
  }
}
