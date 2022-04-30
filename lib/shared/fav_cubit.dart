import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:meta/meta.dart';

part 'fav_state.dart';
/*
* amount 100
amountUnit "gram"
carbs 20.5 (number)
categorie "Breakfast"
co2 0.2
dietaryfiber 2.3
eatDate 22 April 2022 at 16:43:21 UTC+2
ecoscore "B"
fat 0.3
kcal 94
name "Aardappel zoete gekookt"
nutriscore "A"
plantbased "WAAR"
productid 100302990
protein 1.1
proteinanimal 0
proteinplant 1.1
saturatedfat 0.1
sugars 11.6
* */

class FavCubit extends Cubit<FavState> {
  FavCubit() : super(FavInitial());

  static FavCubit instance(BuildContext context) =>
      BlocProvider.of(context, listen: false);

  List<Trip> tripsList = [];
  final uid = FirebaseAuth.instance.currentUser.uid;
  final db = FirebaseFirestore.instance;

  Future<void> getUserFavTripsList(Source source) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('favorites')
        .orderBy("eatDate", descending: true)
        .get(GetOptions(source: source))
        .then((myQuerySnapShot) {
      List<DocumentSnapshot> docList = myQuerySnapShot.docs;

      tripsList = docList.map((e) => Trip.fromSnapshot(e, 'gram')).toList();
      emit(FavResultFound(tripsList: tripsList));
    });
  }

  Future<void> addFavTrip(Trip trip) async {
    tripsList.add(trip);
    print("id: " + trip.productid.toString());
    await db
        .collection("userData")
        .doc(uid)
        .collection("favorites")
        .doc(trip.productid.toString())
        .set(trip.toJson());
    emit(FavResultFound(tripsList: tripsList));
  }

  bool contains(Trip trip) {
    for (int i = 0; i<tripsList.length ;i++) {
      if (trip.documentId == tripsList[i].documentId) {
        print('contains will return true');
        return true;
      }
    }
    print('contains will return false');
    return false;
    // return tripsList.contains(trip);
  }

  Future<void> deleteFavTrip(Trip trip) async {
    tripsList.removeWhere((element) => element.documentId == trip.documentId);
    await db
        .collection("userData")
        .doc(uid)
        .collection("favorites")
        .doc(trip.productid.toString())
        .delete();
    emit(FavResultFound(tripsList: tripsList));
  }
}
