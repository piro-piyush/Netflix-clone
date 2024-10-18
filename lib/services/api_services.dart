import 'dart:convert';
import 'dart:developer';

import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/upcoming_movie_model.dart';
import 'package:http/http.dart' as http;

const  baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModal> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Upcoming Movies: ${response.statusCode} - ${response.body}");
      return UpcomingMovieModal.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  Future<UpcomingMovieModal> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response  = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      log("Success");
      log("Fetching Now Playing Movies: ${response.statusCode} - ${response.body}");
      return UpcomingMovieModal.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Now Playing movies");
  }
}