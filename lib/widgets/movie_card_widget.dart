import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import '../models/upcoming_movie_model.dart';

class MovieCardWidget extends StatefulWidget {
  final Future<UpcomingMovieModal> future;
  final String headLineText;

  const MovieCardWidget({required this.future,required this.headLineText,super.key});

  @override
  State<MovieCardWidget> createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  @override
  void initState() {
    super.initState();
    // Log the headline text to check if it's being passed
    log("Headline Text: ${widget.headLineText}");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: widget.future, builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
      } else if(snapshot.hasData){
        var data = snapshot.data?.results;

        log("${widget.headLineText} Data Loaded: ${data?.length}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(widget.headLineText,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  itemCount: data!.length,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network("$imageUrl${data[index].posterPath}"),
                    );
                  }),
            )
          ],
        );
      }
      else {
        return SizedBox.shrink();
      }
    });
  }
}
