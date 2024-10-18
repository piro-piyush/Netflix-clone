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
  Widget build(BuildContext context) {
    return FutureBuilder(future: widget.future, builder: (context, snapshot){
      if(snapshot.hasData){
        var data = snapshot.data?.results;
        return Column(
          children: [
            Text(widget.headLineText,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
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
