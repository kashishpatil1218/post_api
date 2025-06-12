import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/home_provider.dart';
import '../modal/post_modal.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final imageUrlController = TextEditingController();

  void _submitPost() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final imgUrl = imageUrlController.text.trim();

    if (title.isEmpty || body.isEmpty || imgUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      imgUrl: imgUrl,
      tags: [],
      views: 0,
      userId: 1,
      reactions: Reactions(likes: 0, dislikes: 0),
      isLiked: false,
      isDisliked: false,
    );

    try {
      await Provider.of<PostProvider>(context, listen: false).addPost(newPost);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to post. Try again.')));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Post Title'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Post Body'),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitPost, child: Text('Post')),
            ],
          ),
        ),
      ),
    );
  }
}
