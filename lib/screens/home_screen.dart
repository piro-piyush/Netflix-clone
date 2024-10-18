import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/upcoming_movie_model.dart';
import 'package:netflix_clone/services/api_services.dart';
import 'package:netflix_clone/widgets/movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();

  late Future<UpcomingMovieModal> upcomingFuture;
  late Future<UpcomingMovieModal> nowPlayingFuture;

  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Image.asset(
            "assets/logo.png",
            height: 50,
            width: 120,
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: Colors.blue,
                height: 27,
                width: 27,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
          // centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 220,
              child: MovieCardWidget(future: upcomingFuture, headLineText: 'Now Playing',)
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(future: upcomingFuture, headLineText: 'Upcoming Movies',),
            ),
          ],
        ));
  }
}
