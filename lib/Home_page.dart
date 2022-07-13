import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_scan/providers/scan_provider.dart';
import 'package:just_scan/screen/scan_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScanProvider>(
        create: (_) => ScanProvider(),
        child: Consumer<ScanProvider>(builder:
            (BuildContext context, ScanProvider provider, Widget child) {
          return Scaffold(
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scan Now ',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0XFF4C68DA),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 140, right: 140),
                        // shadowColor: Color(0xffFF4500),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Scan',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        provider.scanQRCode();

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScanPage()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 110, right: 110),
                          // shadowColor: Color(0xffFF4500),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset('lib/assets/GOOGLE.jpg',
                                width: 32, height: 32),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          await _googleSignIn.signIn();
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
          );
        }));
  }
}
