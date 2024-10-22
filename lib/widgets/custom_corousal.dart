import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../models/top_rated_series_model.dart';
import '../screens/movie_details_screen.dart';

class CustomCorousalSlider extends StatelessWidget {
  final TopRatedSeriesModel data;
  const CustomCorousalSlider({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: (size.height * 0.33<300)? 300 : size.height * 0.33,
      child: CarouselSlider.builder(itemCount: data.results.length,itemBuilder: (BuildContext context,int index,int realIndex){

        var url = data.results[index].backdropPath.toString();

        return GestureDetector(
            onTap:(){},
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(
                      movieId: data.results[index].id,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  CachedNetworkImage(imageUrl: "$imageUrl$url",),
                  SizedBox(height: 20,),
                  Text(data.results[index].name)
                ],
              ),
            ));
      },options: CarouselOptions(
        height: (size.height * 0.33<300)? 300 : size.height * 0.33,
        aspectRatio: 16/9,
        initialPage: 0,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enlargeCenterPage: true,

      ),),
    );
  }
}
