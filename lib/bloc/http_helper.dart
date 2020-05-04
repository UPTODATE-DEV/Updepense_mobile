import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:up_depense/utils/up_depense.dart';
import 'package:flutter/services.dart';

// the URL of the Web Server
const String _urlBase =
    "https://updepense.uptodatedevelopers.com/mobile/api/v1";

const String storageKeyMobileToken = "token";
String deviceIdentity = "";
const String storageKeyUserID = "userID";

/// ----------------------------------------------------------
/// Method which is only run once to fetch the device identity
/// ----------------------------------------------------------
final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

Future<String> getDeviceIdentity() async {
  if (deviceIdentity == '') {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        deviceIdentity = "${info.device}-${info.id}";
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        deviceIdentity = "${info.model}-${info.identifierForVendor}";
      }
    } on PlatformException {
      deviceIdentity = "unknown";
    }
  }

  return deviceIdentity;
}

/// ----------------------------------------------------------
/// Method that returns the token from Shared Preferences
/// ----------------------------------------------------------

String getMobileToken() {
  return UpDepense.prefs.getString(storageKeyMobileToken) ?? '';
}

/// ----------------------------------------------------------
/// Method that saves the token in Shared Preferences
/// ----------------------------------------------------------
void setMobileToken(String token) {
  UpDepense.prefs.setString(storageKeyMobileToken, token);
}

void setUserID(Object userID) {
  UpDepense.prefs.setString(storageKeyUserID, jsonEncode(userID));
}

String getUserID() {
  return UpDepense.prefs.getString(storageKeyUserID) ?? '';
}

/// ----------------------------------------------------------
/// Http "GET" request
/// ----------------------------------------------------------

Future<http.Response> httpGet({String serviceApi}) async {
  var response;
  print(_urlBase + '$serviceApi');
  try {
    response = await http.get(_urlBase + '$serviceApi', headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json; charset=utf-8'
    });
  } catch (e) {
    // An error was received
    throw new Exception("ERROR");
  }
  return response;
}

Future<http.Response> httpGetWithToken({String serviceApi}) async {
  var response;
  String token = getMobileToken().isEmpty ? UpDepense.token : getMobileToken();
  try {
    response = await http.get(_urlBase + '$serviceApi', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json; charset=utf-8'
    });
  } catch (e) {
    print(e.toString());
    throw new Exception("ERROR");
  }
  return response;
}

/// ----------------------------------------------------------
/// Http "POST" request
/// ----------------------------------------------------------
Future<http.Response> httpPost(
    {String serviceApi, Map<String, dynamic> data}) async {
  var response;

  try {
    response = await http.post(_urlBase + '$serviceApi', body: data, headers: {
      'X-Requested-With': 'XMLHttpRequest',
    });

    return response;
  } catch (_) {
    print(_.toString());
    throw new Exception("ERROR");
  }
}

Future<http.Response> httpPostWithToken(
    {String serviceApi, Map<String, dynamic> data}) async {
  String token = getMobileToken().isEmpty ? UpDepense.token : getMobileToken();
  var response;
  try {
    response = await http.post(_urlBase + '$serviceApi', body: data, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'X-Requested-With': 'XMLHttpRequest',
      // 'Content-type': 'application/json',
    });
    // print(_urlBase + '$serviceApi');
    return response;
  } catch (_) {
    print(_.toString());
    throw new Exception("ERROR");
  }
}
