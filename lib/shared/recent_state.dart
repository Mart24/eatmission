part of 'recent_cubit.dart';

@immutable
abstract class RecentState {}

class RecentInitial extends RecentState {}
class RecentCancelled extends RecentState {}

class RecentPlatformError extends RecentState {}

class RecentResultFound extends RecentState {
  final List<Trip> tripsList;

  RecentResultFound({@required this.tripsList});
}

class RecentResultNotFound extends RecentState {}
