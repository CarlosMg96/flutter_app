import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './global/presentation/witgets/road_list_widget.dart';
import './data/cubit/road_cubit.dart';
import './data/repository/road_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoadCubit(RoadRepository())..fetchRoads(),
      child: MaterialApp(
        title: 'Roads App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RoadListWidget(), // Aquí es donde usas tu widget
      ),
    );
  }
}