import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
// import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorBar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

import 'mapas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text('Historial')),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                borrarTodo(context);
              })
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void borrarTodo(context) {
    final scansListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    scansListProvider.borrarTodo();
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el select menu opt
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansxTipo('geo');
        return MapasPage();
      case 1:
        scanListProvider.cargarScansxTipo('http');
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
