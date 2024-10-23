import 'dart:convert';
import 'dart:developer';

import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_detail_model.dart';
import 'package:netflix_clone/models/top_rated_series_model.dart';
import 'package:netflix_clone/models/upcoming_movie_model.dart';
import 'package:http/http.dart' as http;

import '../models/movie_recommendation_model.dart';
import '../models/now_playing_model.dart';
import '../models/recommendation_model.dart';
import '../models/search_movie_model.dart';

const  baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Upcoming Movies: ${response.statusCode} - ${response.body}");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  Future<NowPlayingModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Now Playing Movies: ${response.statusCode} - ${response.body}");
      return NowPlayingModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Now Playing movies");
  }

  Future<TopRatedMoviesModel> getTopRatedSeries() async {
    endPoint = "movie/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Now Playing Movies: ${response.statusCode} - ${response.body}");
      return TopRatedMoviesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Top rated series");
  }

  Future<SearchedMovieModel> getSearchedMovie(String searchText) async {
    endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    // Correct the log statement
    log('Search URL: $url');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': authorisationToken  // Replace with your token
        },
      );
      log('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        log('Success');
        return SearchedMovieModel.fromJson(jsonDecode(response.body));
      } else {
        // Log the error message if status code is not 200
        log('Failed to fetch movie: ${response.body}');
        throw Exception('Failed to load search movie. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle and log any exceptions
      log('Error occurred: $e');
      throw Exception('Failed to load search movie: $e');
    }
}

  Future<MovieRecommendationModel> getTvRecommendationModel() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint";

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': authorisationToken  // Replace with your token
        });
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Recommended Tv movies : ${response.statusCode} - ${response.body}");
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movies");
  }

  Future<MovieDetailModel> getMovieDetailModel(int movieId) async {
    endPoint = "movie/$movieId";
    final url = "$baseUrl$endPoint$key";
    log('Movie detail URL : $url');
    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Movie details: ${response.statusCode} - ${response.body}");
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Movie Details");
  }

  Future<RecommendationModel> getRecommendedMovies(int movieId) async {
    endPoint = "movie/$movieId/recommendations";
    final url = "$baseUrl$endPoint$key";
    log('Recommended movies URL : $url');
    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Recommended movies details: ${response.statusCode} - ${response.body}");
      return RecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load recommended movies");
  }

}