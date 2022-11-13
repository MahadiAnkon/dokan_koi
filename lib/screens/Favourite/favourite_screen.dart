import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/favcard.dart';
import '../../models/Store.dart';
import '../../size_config.dart';
import '../home/components/section_title.dart';
class favscreen extends StatelessWidget {
  static String routeName = "/favscreen";
  final _shop = FirebaseFirestore.instance.collection('favourite').doc(FirebaseAuth.instance.currentUser?.uid).collection('items');
  final fav =
  FirebaseFirestore.instance.collection("favourite").doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("items");
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text("My Favourites",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        //elevation: 3,

      ),
      body: StreamBuilder(
        stream: _shop.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData)
          {
            print("ok");
            return Center(
              child: Container(
                width: getProportionateScreenWidth(350),
                height: getProportionateScreenHeight(670),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context,index)=>Favcard(store: Store(
                      id: streamSnapshot.data!.docs[index]['id'],
                      description: streamSnapshot.data!.docs[index]['description'],
                      address: streamSnapshot.data!.docs[index]['address'],
                      images: [streamSnapshot.data!.docs[index]['image']],
                      rating: streamSnapshot.data!.docs[index]['rating'].toDouble(),
                      title: streamSnapshot.data!.docs[index]['name'],
                      district: streamSnapshot.data!.docs[index]['district'],
                      subDistrict: streamSnapshot.data!.docs[index]['subDistrict']),
                  ),
                ),
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator());
        },
      ),
    );
  }
}