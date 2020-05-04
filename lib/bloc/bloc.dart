import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'index.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => InitialState();

  factory AppBloc() {
    return AppBloc._internal();
  }
  AppBloc._internal();
  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    yield* event.applyAnsyc(curentState: state, bloc: this);
  }
}

abstract class AppState extends Equatable {
  final List<Object> _props;
  AppState([this._props]);
  @override
  List<Object> get props => _props;
}

abstract class AppEvent {
  Stream<AppState> applyAnsyc({
    AppState curentState,
    AppBloc bloc,
  });
}
