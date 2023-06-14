import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Globals/globals.dart';
import 'Toast.dart';

class ViewDetailsCustomSpeedDial extends StatelessWidget {
  final Function() onCarburantTap;
  final Function() onMaintenanceTap;

  const ViewDetailsCustomSpeedDial({super.key,
    required this.onCarburantTap,
    required this.onMaintenanceTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.blueGrey.withOpacity(0.5),
      animatedIcon: AnimatedIcons.list_view,
      foregroundColor: Colors.white54,
      direction: SpeedDialDirection.down,
      animationCurve: Curves.slowMiddle,
      overlayColor: Colors.black,
      overlayOpacity: 0.7,
      spacing: 12,
      spaceBetweenChildren: 12,
      animatedIconTheme: const IconThemeData(size: 50),
      curve: Curves.easeInOutCubic,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.local_gas_station),
          foregroundColor: Colors.blue,
          backgroundColor: Colors.yellow,
          label: "Ajouter Carburant",
          onTap: () {
            onCarburantTap();

            fToast.showToast(
              child: toastM("Ajouter Carburant", Colors.blue),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          },
        ),
        SpeedDialChild(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.amberAccent,
          child: const Icon(Icons.auto_fix_high),
          label: "Ajouter maintenance",
          onTap: () {
            onMaintenanceTap();

            fToast.showToast(
              child: toastM("Ajouter Maintenance", Colors.blue),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          },
        ),
      ],
    );
  }
}
