import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Image.asset("assets/logo.png",
        height: 50,
        width: 120,),
        actions: [
          InkWell(
            onTap: (){

            },
            child: Icon(Icons.search,size: 30,
            color: Colors.white,),
          ),
          SizedBox(width: 20,),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.blue,
              height: 27,
              width: 27,
              ),
          ),
          SizedBox(width: 20,)
        ],
        centerTitle: true,
      ),
      body: Center(child: Text("Home Screen",style: TextStyle(color: Colors.white),),),
    );
  }
}