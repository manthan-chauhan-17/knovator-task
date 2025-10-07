import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knovator_task/feature/post_detail/view/post_detail_page.dart';
import 'package:knovator_task/feature/posts/bloc/posts_bloc.dart';
import 'package:knovator_task/feature/posts/widget/post_card.dart';
import 'package:knovator_task/service/storage_service/hive_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(GetPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Posts', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load posts: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          }

          if (state is PostsLoaded) {
            final filteredPosts = state.posts.where((post) {
              final isRead = HiveHelper.isPostRead(post.id ?? -1);
              if (state.activeFilter == 'Unread') return !isRead;
              if (state.activeFilter == 'Read') return isRead;
              return true;
            }).toList();

            return Column(
              children: [
                _buildFilter(state.activeFilter),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<PostsBloc>().add(GetPostsEvent());
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredPosts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final post = filteredPosts[index];
                        final isRead = HiveHelper.isPostRead(post.id ?? -1);
                        return PostCard(
                          post: post,
                          isRead: isRead,
                          onTap: () {
                            context.read<PostsBloc>().add(
                              MarkPostAsReadEvent(post.id ?? -1),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(id: post.id ?? -1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilter(String activeFilter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: ['All', 'Unread', 'Read'].map((filter) {
          final isSelected = activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<PostsBloc>().add(FilterPostsEvent(filter));
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.amber[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? Colors.amber : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
