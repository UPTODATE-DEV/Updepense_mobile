import 'dart:convert';
import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/model/user.dart';
import 'package:up_depense/utils/up_depense.dart';
import 'package:up_depense/utils/util.dart';

import 'index.dart';

class HomeEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    String checkConnexion = await isConnected();
    yield HomeLoading();
    if (checkConnexion == 'access') {
      yield HomeLoading();
      try {
        var _repository = AppRepository();
        var getResponse = await _repository.getDepense();
        var data = jsonDecode(getResponse.body);
        print(data);
        ResultTransaction list = ResultTransaction.fromJson(data);

        yield HomeLoaded(result: list);
      } catch (e, _) {
        print(e.toString());
      }
    } else if (checkConnexion == "no access") {
      yield NoAccessState();
    } else {
      yield NotConnected();
    }
  }
}

class InitialLoginEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    yield OnLoginInitialState();
  }
}

class HistoriqueEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    String checkConnexion = await isConnected();
    yield HistoriqueLoading();
    if (checkConnexion == 'access') {
      yield HistoriqueLoading();
      try {
        var _repository = AppRepository();
        var getResponse = await _repository.getDepense();
        var data = jsonDecode(getResponse.body);
        print(data);
        ResultTransaction list = ResultTransaction.fromJson(data);

        yield HistoriqueLoaded(result: list);
      } catch (e, _) {
        print(e.toString());
      }
    } else if (checkConnexion == "no access") {
      yield NoAccessState();
    } else {
      yield NotConnected();
    }
  }
}

class LogoutRequestEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    yield LogoutRequest();
  }
}

class LoginEvent extends AppEvent {
  final String username;
  final String password;
  final bool remember;

  LoginEvent({this.username, this.password, this.remember});
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    String checkConnexion = await isConnected();

    if (checkConnexion == 'access') {
      yield OnLoadingState();
      try {
        var _repository = AppRepository();
        var getResponse = await _repository.login(
            username: this.username, password: this.password);
        var data = jsonDecode(getResponse.body);

        ResultUser resultUser = ResultUser.fromJson(data);

        if (data['message'] == null) {
          UpDepense.user = resultUser.user;
          setUserID(resultUser.user.toJson());
          setMobileToken(remember ? resultUser.token : '');
          yield LoginSucces(user: resultUser);
        } else
          yield ErrorUIState();
      } catch (e, stactTrace) {
        yield ErrorUIState();
        print(stactTrace.toString());
      }
    } else if (checkConnexion == "no access") {
      yield NoAccessState();
    } else {
      yield NotConnected();
    }
  }
}

class LogoutEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    String checkConnexion = await isConnected();

    if (checkConnexion == 'access') {
      yield OnLogoutState();
      try {
        var _repository = AppRepository();
        var getResponse = await _repository.logout();
        var data = jsonDecode(getResponse.body);

        if (data['message'] == 'Vous avez été deconnecté') {
          UpDepense.user = null;
          setUserID('');
          setMobileToken('');
          yield LogoutSucces();
        } else
          yield ErrorUIState();
      } catch (e, stactTrace) {
        yield ErrorUIState();
        print(stactTrace.toString());
      }
    } else if (checkConnexion == "no access") {
      yield NoAccessState();
    } else {
      yield NotConnected();
    }
  }
}

class ValidateEvent extends AppEvent {
  final String opID;
  final int status;

  ValidateEvent({this.opID, this.status});
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    String checkConnexion = await isConnected();

    if (checkConnexion == 'access') {
      print(this.status);
      yield this.status == 0 ? ValidateState() : RejeteState();
      try {
        var _repository = AppRepository();
        var getResponse = await _repository.validateDepense(
            opID: this.opID, status: this.status);

        if (getResponse.statusCode == 200) {
          yield this.status == 0
              ? SuccessState(message: "Validation reussi avec succes")
              : SuccessState(message: "Rejet reussi avec succes");
        } else {
          print(getResponse.body);
          yield ErrorUIState();
        }
      } catch (e, stactTrace) {
        yield ErrorUIState();
        print(stactTrace.toString());
      }
    } else if (checkConnexion == "no access") {
      yield NoAccessState();
    } else {
      yield NotConnected();
    }
  }
}

class RejeteEvent extends AppEvent {
  @override
  Stream<AppState> applyAnsyc({AppState curentState, AppBloc bloc}) async* {
    yield RejeteState();
  }
}
