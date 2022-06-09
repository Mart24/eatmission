part of 'log_cubit.dart';

@immutable
abstract class LogState {}

class LogInitial extends LogState {}

class LogCancelled extends LogState {}

class LogPlatformError extends LogState {}

class LogResultAdded extends LogState {}

class LogResultNotFound extends LogState {}
