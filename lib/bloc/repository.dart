import 'package:http/http.dart';
import 'package:up_depense/bloc/http_helper.dart';
import 'package:up_depense/utils/up_depense.dart';
// import 'package:up_depense/model/transaction.dart';

class AppRepository {
  String _transactionService = "/transactions/";
  String _loginService = "/login";
  String _logoutService = "/logout";

  Future<Response> getDepense() async {
    String codeEntreprise = UpDepense.user.codeEntrep.toString();
    print("Voici le code entreprise $codeEntreprise");
    var result = await httpGetWithToken(
      serviceApi: "$_transactionService$codeEntreprise",
    );

    return result;
  }

  Future<Response> login({String username, String password}) async {
    String deviceInfo = await getDeviceIdentity();
    var result = await httpPost(serviceApi: _loginService, data: {
      "username": username,
      "password": password,
      "device_name": deviceInfo
    });
    return result;
  }
  Future<Response> logout() async {
    String deviceInfo = await getDeviceIdentity();
    var result = await httpPostWithToken(serviceApi: _logoutService, data: {
      "device_name": deviceInfo
    });
    return result;
  }
}
