import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String> isConnected() async {
  bool connected = await DataConnectionChecker().hasConnection;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    if (connected) {
      return 'access';
    } else {
      return "no access";
    }
  } else {
    return "not connected";
  }
}

getIcon() {
  return Container(
    height: 70,
    width: 70,
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage("assets/icons/updepenseIcon.png"),
      fit: BoxFit.cover,
    )),
  );
}

custormAppBar(BuildContext context,
    {String monthAndYear,
    String day,
    IconData icon,
    onLeadingIconTap,
    onChevronLeftAction,
    onChevronRightAction}) {
  return Material(
    shadowColor: Colors.grey.withOpacity(.5),
    elevation: 2,
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: onLeadingIconTap,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: Colors.black,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "$monthAndYear",
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                Spacer(),
                SizedBox(
                  width: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

buildUIError(
  BuildContext context, {
  String titleMessage,
  String subTitleMessage,
  String img,
  Function onPressed,
}) {
  return Center(
    child: Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width - 70,
      child: Material(
        shadowColor: Colors.grey.withOpacity(.2),
        elevation: 7,
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: SvgPicture.asset(img),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Text(
                "$titleMessage",
                style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "$subTitleMessage",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0, right: 80, bottom: 10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "Réessayer",
                        style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class Loading extends StatelessWidget {
  final double size;
  final Color color;

  const Loading({
    Key key,
    this.size,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: color,
        size: size,
      ),
    );
  }
}
