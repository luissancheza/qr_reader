import 'package:flutter/cupertino.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    await canLaunch(scan.valor)
        ? await launch(scan.valor)
        : throw 'Could not launch ${scan.valor}';
  } else {
    print('geo');
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
