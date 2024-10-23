import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/movie_details_screen.dart';

import '../common/utils.dart';
import '../models/now_playing_model.dart';

class NowPlayingWidget extends StatelessWidget {
  final Future<NowPlayingModel> future;
  final String headLineText;

  const NowPlayingWidget({super.key,
    required this.future,
    required this.headLineText,});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NowPlayingModel>(
        future: future,
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

            log("$headLineText Data Loaded: ${data?.length}");

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headLineText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // padding: const EdgeInsets.all(3),
                      scrollDirection: Axis.horizontal,
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                      movieId: data[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.network(
                                  '$imageUrl${data[index].posterPath}',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ));
                      },
                    ),
                  )
                ]);
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
