import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/model/user.dart';

import 'index.dart';

class InitialState extends AppState {}

class LogoutSucces extends AppState {}

class OnLogoutState extends AppState {}

class HomeLoading extends AppState {}

class HistoriqueLoading extends AppState {}

class HistoriqueLoaded extends AppState {
  final ResultTransaction result;
  HistoriqueLoaded({this.result}) : super([result]);
}

class LogoutRequest extends AppState {}

class HomeLoaded extends AppState {
  final ResultTransaction result;
  HomeLoaded({this.result}) : super([result]);
}

class LoginSucces extends AppState {
  final ResultUser user;
  LoginSucces({this.user}) : super([user]);
}

class OnLoginInitialState extends AppState {}

class OnLoadingState extends AppState {}

class ErrorUIState extends AppState {}

class ValidateState extends AppState {}

class RejeteState extends AppState {}

class SuccessState extends AppState {
  final String message;
  SuccessState({this.message});
}

class NoAccessState extends AppState {}

class NotConnected extends AppState {}
