
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/services/api_services.dart';

import '../models/search_movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController  = TextEditingController();
  ApiServices apiServices = ApiServices();
  SearchedMovieModel? searchModel;

  void search(String query){
    apiServices.getSearchedMovie(query).then((results){
      setState(() {
        searchModel = results;
      });
    });
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
                prefixIcon: Icon(Icons.search,color: Colors.grey,),
                suffixIcon: Icon(Icons.cancel,color: Colors.grey,),
                style: TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.2),
                onChanged: (value){
                  if(value.isNotEmpty){
                    search(searchController.text);
                  }
                },
              ),
              searchModel == null? SizedBox.shrink():GridView.builder(
                shrinkWrap: true,
                itemCount: searchModel?.results.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3, mainAxisSpacing: 15, crossAxisSpacing: 5, childAspectRatio:1.2/2),
                  itemBuilder: (context,index){
                    return Column(children: [
                      CachedNetworkImage(imageUrl: "$imageUrl${searchModel!.results[index].backdropPath },",height: 170,),
                      SizedBox(
                        width:100,
                        child: Text(searchModel!.results[index].originalTitle,style: TextStyle(
                          fontSize: 14
                        ),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      )
                    ],
                    );
                  })
            ],
          ),
        )
      ),
    );
  }
}