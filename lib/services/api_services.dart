import 'dart:convert';
import 'dart:developer';

import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/top_rated_series_model.dart';
import 'package:netflix_clone/models/upcoming_movie_model.dart';
import 'package:http/http.dart' as http;

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

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Now Playing Movies: ${response.statusCode} - ${response.body}");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Now Playing movies");
  }

  Future<TopRatedSeriesModel> getTopRatedSeries() async {
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Now Playing Movies: ${response.statusCode} - ${response.body}");
      return TopRatedSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Top rated series");
  }

  Future<SearchedMovieModel> getSearchedMovie(String searchText) async {
    endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    // Correct the log statement
    log('URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNzA1YzQzZjdhZTM3NWM0Y2NlODFhYTU5NjVmMWExZCIsIm5iZiI6MTcyOTE4NDg3NS44Njk0NjIsInN1YiI6IjY3MGZlNDQ4NmY3NzA3YWY0MGZhM2IzNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qIJUEZDLEUlum10nZxq3QmZnfuc3Q3_VjXhL9a-t_TI',  // Replace with your token
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
}