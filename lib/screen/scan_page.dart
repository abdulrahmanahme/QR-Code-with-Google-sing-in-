import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScanProvider>(
      create: (_) => ScanProvider(),
      child: Consumer<ScanProvider>(
        builder: (BuildContext context, ScanProvider provider, Widget child) {
          return Scaffold(
              body: FutureBuilder<bool>(
            future: provider.checkForPermission(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data) {
//                provider.openQRScanner();
                return FutureBuilder<bool>(
                  future: provider.openQRScanner(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data) {
                      return WebView(
                        initialUrl: provider.url,
                        onPageFinished: (String url) {},
                        onWebViewCreated: (WebViewController controller) {},
                      );
                    } else if (snapshot.hasData && !snapshot.data) {
                      return buildAlertDialog('OOPS!!', 'URL is not valid');
                    } else {
                      return Container();
                    }
                  },
                );
              } else if (snapshot.hasData && !snapshot.data) {
                return Column(
                  children: [
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
                        'Scan Again',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScanPage()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                              'SignOut',
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          await _googleSignIn.signOut();
                          setState(() {});
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => SocialLayout()),
                          // );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ));
        },
      ),
    );
  }

  Widget buildAlertDialog(String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
