import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/top_rated_series_model.dart';
import 'package:netflix_clone/models/upcoming_movie_model.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/services/api_services.dart';
import 'package:netflix_clone/widgets/now_playing_widget.dart';
import 'package:netflix_clone/widgets/upcoming_movie_card_widget.dart';

import '../models/now_playing_model.dart';
import '../widgets/custom_corousal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();
  late Future<UpcomingMovieModel> upcomingFuture;
  late Future<NowPlayingModel> nowPlayingFuture;
  late Future<TopRatedMoviesModel> topRatedSeries;

  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>SearchScreen()));
              },
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(future: topRatedSeries, builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,  // Ensure full height
                    width: MediaQuery.of(context).size.width,    // Ensure full width
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.red,),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if(snapshot.hasData) {
                  return CustomCorousalSlider(data: snapshot.data!);
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 220,
                child: NowPlayingWidget(future: nowPlayingFuture, headLineText: "Now Playing",)
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 220,
                child: UpcomingMovieCardWidget(future: upcomingFuture, headLineText: "Upcoming Movies",),
              ),
            ],
          ),
        ));
  }
}
