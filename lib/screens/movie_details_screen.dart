import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_detail_model.dart';
import 'package:netflix_clone/services/api_services.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  ApiServices apiServices = ApiServices();
  late Future<MovieDetailModel> movieDetail;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }
  void fetchMovieDetails(){
    movieDetail = apiServices.getMovieDetailModel(widget.movieId);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    log("Hey, movie id is: ${widget.movieId}");

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(
                "$imageUrl$movieDetail."
              ))
            ),
          )
        ],
      )
    );
  }
}
