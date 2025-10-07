import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knovator_task/feature/post_detail/bloc/post_detail_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  final int id;

  const PostDetailScreen({super.key, required this.id});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(loadPost);
  }

  loadPost() {
    context.read<PostDetailBloc>().add(GetPostEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailLoaded) {
              return Text(
                state.post.title ?? 'Post Detail',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18.0,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load post: ${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          }

          if (state is PostDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.post.title ?? 'No Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Post ID: ${state.post.id}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  const Divider(
                    height: 40,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  Text(
                    state.post.body ?? 'No content available.',
                    style: TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
