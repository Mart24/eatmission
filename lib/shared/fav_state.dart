part of 'fav_cubit.dart';

@immutable
abstract class FavState {}

class FavInitial extends FavState {}

class FavCancelled extends FavState {}

class FavPlatformError extends FavState {}

class FavResultFound extends FavState {
  final List<Trip> tripsList;

  FavResultFound({@required this.tripsList});
}

class FavResultNotFound extends FavState {}
