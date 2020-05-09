import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up_depense/bloc/bloc.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:up_depense/model/user.dart';
import 'package:up_depense/screens/home/home.dart';
import 'package:up_depense/screens/home/login.dart';
import 'package:up_depense/utils/fade_animation.dart';
import 'package:up_depense/utils/up_depense.dart';
import 'package:up_depense/utils/util.dart';

class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  var _bloc;
  @override
  void initState() {
    isLog();
    super.initState();
  }

  Future<void> isLog() async {
    _bloc = AppBloc();
    UpDepense.prefs = await SharedPreferences.getInstance();
    // setMobileToken('');
    String token = getMobileToken();

    if (token.isEmpty) {
      Timer(Duration(seconds: 2), () async {
        Navigator.pushReplacementNamed(
          context,
          Login.routeName,
        );
      });
    } else {
      var data = jsonDecode(getUserID());
      UpDepense.user = User.fromJson(data);
      _bloc.add(HomeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  FadeAnimation(
                    1.3,
                    getIcon(),
                  ),
                  FadeAnimation(
                    1.6,
                    appName(),
                  ),
                  FadeAnimation(
                    2.2,
                    BlocListener<AppBloc, AppState>(
                      bloc: _bloc,
                      child: BlocBuilder<AppBloc, AppState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            // print(state);
                            if (state is HomeLoading) {
                              return Loading(
                                color: Theme.of(context).primaryColor,
                                size: 30.0,
                              );
                            } else if (state is NoAccessState) {
                              return buildUIError(
                                context,
                                img: "assets/images/noAccess.svg",
                                titleMessage: "Pas d'acces internet",
                                subTitleMessage:
                                    "Pas d'acces aux données mobiles\nveuillez verifier votre connexion.",
                                onPressed: () {
                                  _bloc.add(HomeEvent());
                                },
                              );
                            } else if (state is NotConnected) {
                              return buildUIError(context,
                                  img: "assets/images/noAccess.svg",
                                  titleMessage: "Pas d'acces internet",
                                  subTitleMessage:
                                      "Pas d'internet\nveuillez vous connecter à internet.",
                                  onPressed: () {
                                _bloc.add(HomeEvent());
                              });
                            } else {
                              return Container();
                            }
                          }),
                      listener: (BuildContext context, state) {
                        if (state is HomeLoaded) {
                          Navigator.pushReplacementNamed(
                            context,
                            UpdepenseHome.routeName,
                            arguments: _bloc,
                          );
                        }
                      },
                    ),
                  ),
                  Spacer(),
                  FadeAnimation(
                    1.9,
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: upDev(),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  appName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Up dépense",
        style: GoogleFonts.dmSans(
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(.7),
          ),
        ),
      ),
    );
  }

  upDev() {
    return FadeAnimation(
      2,
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'From',
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                  // color: Colors.black87,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(width: 5.0),
          Text(
            'Updev',
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
