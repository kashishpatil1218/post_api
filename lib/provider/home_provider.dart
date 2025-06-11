import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modal/post_modal.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async   {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/posts'));

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

  void likePost(int index)
  {
    _posts[index].toggleLike();
    notifyListeners();
  }
  void dislikePost(int index) {
    _posts[index].dislike();
    notifyListeners();
  }
}

