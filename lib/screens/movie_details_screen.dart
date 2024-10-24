import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie_detail_model.dart';
import '../common/utils.dart';
import '../models/recommendation_model.dart';
import '../services/api_services.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  MovieDetailsScreenState createState() => MovieDetailsScreenState();
}

class MovieDetailsScreenState extends State<MovieDetailsScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;
  late Future<RecommendationModel> movieRecommendationModel;

  @override
  void initState() {
    log(widget.movieId.toString());
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetailModel(widget.movieId);
    movieRecommendationModel = apiServices.getRecommendedMovies(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    log("Hey, movie id is: ${widget.movieId}");
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
          child: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
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
            } else if (snapshot.hasData){
              final movie = snapshot.data;
              String genresText =
              movie!.genres!.map((genre) => genre.name).join(', ');
              return Column(
              children: [
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "$imageUrl${movie.posterPath}"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            movie.releaseDate!.year.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            child: Text(
                              genresText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        movie.overview!,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: movieRecommendationModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final movie = snapshot.data;
                      return movie!.results.isEmpty
                          ? const SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "More like this",
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: movie.results.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1.5 / 2,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailsScreen(
                                              movieId: movie
                                                  .results[index].id),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "$imageUrl${movie.results[index].posterPath}",
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const Text("Something Went wrong");
                  },
                ),
              ],
                              );
            }
            return const SizedBox();
          },
                    ),
        ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),]
      ),
    );
  }
}