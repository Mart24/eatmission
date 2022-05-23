import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:meta/meta.dart';

part 'recent_state.dart';

class RecentCubit extends Cubit<RecentState> {
  RecentCubit() : super(RecentInitial());

  static RecentCubit instance(BuildContext context) =>
      BlocProvider.of(context, listen: false);

  List<Trip> tripsList = [];
  final uid = FirebaseAuth.instance.currentUser.uid;
  final db = FirebaseFirestore.instance;

  Future<void> getUserRecentTripsList(Source source) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('recent')
        .orderBy("eatDate", descending: true)
        .limit(10)
        .get(GetOptions(source: source))
        .then((myQuerySnapShot) {
      List<DocumentSnapshot> docList = myQuerySnapShot.docs;

      tripsList = docList.map((e) => Trip.fromSnapshot(e, 'gram')).toList();
      emit(RecentResultFound(tripsList: tripsList));
    });
  }

  Future<void> addRecentTrip(Trip trip) async {
    trip.eatDate = DateTime.now();
    if (!contains(trip)) {
      print('add to state list');
      tripsList.insert(0, trip);
      if( tripsList.length > 10){
        tripsList.removeLast();
      }
    }
    print("id: " + trip.productid.toString());
    await db
        .collection("userData")
        .doc(uid)
        .collection("recent")
        .doc(trip.productid.toString())
        .set(trip.toJson());
    emit(RecentResultFound(tripsList: tripsList));
  }

  bool contains(Trip trip) {
    for (int i = 0; i < tripsList.length; i++) {
      if (trip.documentId == tripsList[i].documentId) {
        return true;
      }
    }
    return false;
  }

  Future<void> deleteRecentTrip(Trip trip) async {
    tripsList.removeWhere((element) => element.documentId == trip.documentId);
    await db
        .collection("userData")
        .doc(uid)
        .collection("recent")
        .doc(trip.productid.toString())
        .delete();
    emit(RecentResultFound(tripsList: tripsList));
  }
}
