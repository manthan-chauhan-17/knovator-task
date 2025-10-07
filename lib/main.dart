import 'package:flutter/material.dart';
import 'package:knovator_task/service/storage_service/hive_helper.dart';
import 'package:knovator_task/feature/post_detail/bloc/post_detail_bloc.dart';
import 'package:knovator_task/feature/posts/bloc/posts_bloc.dart';
import 'package:knovator_task/feature/posts/view/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostsBloc()),
        BlocProvider(create: (context) => PostDetailBloc()),
      ],
      child: MaterialApp(title: 'Knovator Task', home: const HomePage()),
    );
  }
}
