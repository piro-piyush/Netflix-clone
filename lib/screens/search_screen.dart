import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/screens/movie_details_screen.dart';
import 'package:netflix_clone/services/api_services.dart';

import '../models/movie_recommendation_model.dart';
import '../models/search_movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  SearchedMovieModel? searchModel;
  late Future<MovieRecommendationModel> popularMovies;

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    popularMovies = apiServices.getTvRecommendationModel();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoSearchTextField(
              padding: EdgeInsets.all(20),
              controller: searchController,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              style: TextStyle(color: Colors.white),
              backgroundColor: Colors.grey.withOpacity(0.2),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  search(searchController.text);
                } else{
                  searchModel = null;
                }
              },
            ),
            searchController.text.isEmpty
                ? FutureBuilder<MovieRecommendationModel>(
                    future: popularMovies,
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
                      } else if (snapshot.hasData) {
                        var data = snapshot.data?.results;

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Top searches",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailsScreen(
                                                movieId: data[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                '$imageUrl${data[index].posterPath}',
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              SizedBox(
                                                  width: 260,
                                                  child: Text(
                                                    data[index].title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              )
                            ]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    })
                : searchModel == null
                    ? SizedBox.shrink()
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: searchModel?.results.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(
                                    movieId: searchModel!.results[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                searchModel!.results[index].backdropPath == null
                                    ? Image.asset(
                                        "assets/netflix.png",
                                        height: 170,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "$imageUrl${searchModel!.results[index].backdropPath},",
                                        height: 170,
                                      ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    searchModel!.results[index].originalTitle,
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        })
          ],
        ),
      )),
    );
  }
}
