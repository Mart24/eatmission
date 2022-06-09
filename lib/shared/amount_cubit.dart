import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:meta/meta.dart';

part 'amount_state.dart';

class AmountCubit extends Cubit<AmountState> {
  AmountCubit() : super(AmountInitial());

  static AmountCubit instance(BuildContext context) =>
      BlocProvider.of(context, listen: false);

  Future<Map<String, dynamic>> getFood(Trip inTrip, double size, portion,
      DateTime eattime, categoryChoice, String unit) async {
    Trip trip = inTrip;

    DocumentSnapshot<Map<String, dynamic>> d = await FirebaseFirestore.instance
        .collection('fdd')
        .doc(trip.id.toString())
        .get();
    var foodDocument = d.data();

    final nutriscoreType = trip.nutriscoreimage();
    final ecoscoreType = trip.ecoscoreimage();
    //nutriscore
    String nutriscore = foodDocument['nutriscore'];
    //ecoscore
    String ecoscore = foodDocument['ecoscore'];
    // Plantbase string
    String plantbased = foodDocument['plantbased'];
    // Calorieën double
    double kcal =
        ((foodDocument['kcal'].toDouble()) * size * portion * 0.01.toDouble());
    // Calorieën CO2
    double co2 =
        ((foodDocument['co2'].toDouble()) * size * portion * 0.01.toDouble());
    // Calorieën Koolhydraten
    double koolhy =
        ((foodDocument['carbs'].toDouble()) * size * portion * 0.01.toDouble());
    // Calorieën Eiwitten
    double protein = ((foodDocument['proteins'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double proteinplant = ((foodDocument['proteinsplant'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double proteinanimal = ((foodDocument['proteinsanimal'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    // Calorieën Vetten
    double fat =
        ((foodDocument['fat'].toDouble()) * size * portion * 0.01.toDouble());
    double saturatedfat = ((foodDocument['saturatedfat'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double sugars = ((foodDocument['sugars'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double dietaryfiber = ((foodDocument['dietaryfiber'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double salt =
        ((foodDocument['salt'].toDouble()) * size * portion * 0.01.toDouble());
    double selenium = ((foodDocument['selenium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double vitA =
        ((foodDocument['vitA'].toDouble()) * size * portion * 0.01.toDouble());
    double alcohol = ((foodDocument['alcohol'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double natrium = ((foodDocument['natrium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double kalium = ((foodDocument['kalium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double calcium = ((foodDocument['calcium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double magnesium = ((foodDocument['magnesium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double iron =
        ((foodDocument['iron'].toDouble()) * size * portion * 0.01.toDouble());
    double zink =
        ((foodDocument['zink'].toDouble()) * size * portion * 0.01.toDouble());
    double vitD =
        ((foodDocument['vitD'].toDouble()) * size * portion * 0.01.toDouble());
    double vitE =
        ((foodDocument['vitE'].toDouble()) * size * portion * 0.01.toDouble());
    double vitC =
        ((foodDocument['vitC'].toDouble()) * size * portion * 0.01.toDouble());
    double vitB1 =
        ((foodDocument['vitB1'].toDouble()) * size * portion * 0.01.toDouble());
    double vitB2 =
        ((foodDocument['vitB2'].toDouble()) * size * portion * 0.01.toDouble());
    double vitB6 =
        ((foodDocument['vitB6'].toDouble()) * size * portion * 0.01.toDouble());
    double vitB12 = ((foodDocument['vitB12'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double foliumzuur = ((foodDocument['foliumzuur'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double niacine = ((foodDocument['niacine'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double jodium = ((foodDocument['jodium'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double fosfor = ((foodDocument['fosfor'].toDouble()) *
        size *
        portion *
        0.01.toDouble());
    double water =
        ((foodDocument['water'].toDouble()) * size * portion * 0.01.toDouble());

    //  trip.startDate = _startDate;
    // trip.endDate = _endDate;
    trip.kcal = kcal;
    trip.co2 = co2;
    trip.carbs = koolhy;
    trip.protein = protein;
    trip.proteinplant = proteinplant;
    trip.proteinanimal = proteinanimal;
    trip.fat = fat;
    trip.sugars = sugars;
    trip.dietaryfiber = dietaryfiber;
    trip.salt = salt;
    trip.selenium = selenium;
    trip.vitA = vitA;
    trip.vitD = vitD;
    trip.vitB1 = vitB1;
    trip.vitB2 = vitB2;
    trip.vitB12 = vitB12;
    trip.vitB6 = vitB6;
    trip.vitC = vitC;
    trip.vitE = vitE;
    trip.alcohol = alcohol;
    trip.calcium = calcium;
    trip.foliumzuur = foliumzuur;
    trip.fosfor = fosfor;
    trip.iron = iron;
    trip.zink = zink;
    trip.jodium = jodium;
    trip.kalium = kalium;
    trip.magnesium = magnesium;
    trip.natrium = natrium;
    trip.niacine = niacine;
    trip.water = water;

    // zink = snapshot['zink'];
    // alcohol = snapshot['alcohol'];
    // calcium = snapshot['calcium'];
    // foliumzuur = snapshot['foliumzuur'];
    // fosfor = snapshot['fosfor'];
    // iron = snapshot['iron'];
    // jodium = snapshot['jodium'];
    // kalium = snapshot['kalium'];
    // magnesium = snapshot['magnesium'];
    // natrium = snapshot['natrium'];
    // niacine = snapshot['niacine'];
    // water = snapshot['water'];

    trip.saturatedfat = saturatedfat;
    trip.eatDate = eattime;
    trip.amount = size;
    trip.categorie = categoryChoice;
    trip.plantbased = plantbased;
    trip.nutriscore = nutriscore;
    trip.ecoscore = ecoscore;
    trip.amountUnit = unit;

    return {
      "trip": trip,
      "foodDocument": foodDocument,
    };
  }

  void saveFood() {
    // var foodDocument = snapshot.data;
  }
}
