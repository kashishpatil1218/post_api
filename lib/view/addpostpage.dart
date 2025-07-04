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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Create Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageUrlController.text.isEmpty
              ? GestureDetector(
                    onTap: ()
                       {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: TextField(
                                controller: imageUrlController,
                                decoration: InputDecoration(
                                  labelText: 'Image URL',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                              title: Text(
                                'Add Image Url',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        );

                    },
                    child: Icon(Icons.add,size: 35,color: Colors.grey,))

                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrlController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
              ),

              SizedBox(height: 25),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Title',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                      hint: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Add Title',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Post Body',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    controller: bodyController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                      hint: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Add discription',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 180),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 35),
        child: GestureDetector(
          onTap: () => _submitPost(),
          child: Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Post',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
