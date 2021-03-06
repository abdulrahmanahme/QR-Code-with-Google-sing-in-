import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

class ScanProvider extends ChangeNotifier {
  bool isPermissionGranted = false;
  String url = '';

  ScanProvider() {
    _permissions = <Permission>[
      Permission.camera,
    ];
  }

  List<Permission> _permissions;

  Future<void> scanQRCode() async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.reload();
    _sharedPreferences.setBool("permission_allowed", true);
    isPermissionGranted = true;
    notifyListeners();
  }

  Future<bool> checkForPermission() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    bool status = sharedPreferences.getBool("permission_allowed");
    if (status != null && status) {
      isPermissionGranted = true;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> openQRScanner() async {
    String qrCodeScanRes;
    try {
      qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      qrCodeScanRes = 'Failed to get platform version.';
    }

//    if (!mounted) {
//      return;
//    }
    if (qrCodeScanRes.isNotEmpty && qrCodeScanRes != null) {
      bool isUrl = isURL(qrCodeScanRes, requireTld: false);
      if (isUrl) {
        //open webview
        url = qrCodeScanRes;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
