import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:meta/meta.dart';

part 'log_state.dart';

class LogCubit extends Cubit<LogState> {
  LogCubit() : super(LogInitial());

  static LogCubit instance(BuildContext context) =>
      BlocProvider.of(context, listen: false);

  final uid = FirebaseAuth.instance.currentUser.uid;
  final db = FirebaseFirestore.instance;

  Future<void> addLog(String collectionName) async {
    Timestamp now = Timestamp.now();
    await db
        .collection("userData")
        .doc(uid)
        .collection(collectionName)
        .doc()
        .set({"date": now});
    emit(LogResultAdded());
  }

  Future<void> add1Log(String buttonName) async {
    Timestamp now = Timestamp.now();
    String knop = buttonName;
    await db
        .collection("userData")
        .doc(uid)
        .collection("activity")
        .doc()
        .set({"date": now, 'knop': knop});
    emit(LogResultAdded());
  }

  Future<void> add2Log(String buttonName) async {
    Timestamp now = Timestamp.now();
    String knop = buttonName;
    await db
        .collection("userData")
        .doc(uid)
        .collection("button graph")
        .doc()
        .set({"date": now, 'knop': knop});
    emit(LogResultAdded());
  }
}
