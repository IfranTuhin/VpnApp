import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/App_Perferences/perferences.dart';
import 'package:vpn_basic_project/Controllers/controller_home.dart';
import 'package:vpn_basic_project/Models/vpn_info.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/vpnEngine/vpn_engine.dart';

class VpnLocationCardWidget extends StatelessWidget {
  final VpnInfo vpnInfo;

  VpnLocationCardWidget({Key? key, required this.vpnInfo}) : super(key: key);

  // Speed
  String formatSpeedBytes(int speedBytes, int decimals)
  {
    if(speedBytes <= 0) {
      return "0 B";
    }
    const suffixesTitle = ["Bps", "Kbps", "Mbps", "Gbps", "Tbps"];

    var speedTitleIndex = (log(speedBytes) / log(1024)).floor();

    return "${(speedBytes / pow(1024, speedTitleIndex)).toStringAsFixed(decimals)} ${suffixesTitle[speedTitleIndex]} ";
  }

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    final homeController = Get.find<ControllerHome>();

    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: sizeScreen.height * .01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          homeController.vpnInfo.value = vpnInfo;
          AppPerferences.vpnInfoObj = vpnInfo;
          Get.back();

          if(homeController.vpnConnectionState.value == VpnEngine.vpnConnectedNow){
            VpnEngine.stopVpnNow();

            Future.delayed(Duration(seconds: 3), () => homeController.connectToVpnNow(),);
          }
          else{
            homeController.connectToVpnNow();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Country flags
          leading: Container(
            padding: EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              "countryFlags/${vpnInfo.countryShortName.toLowerCase()}.png",
              height: 40,
              width: sizeScreen.width * .15,
              fit: BoxFit.cover,
            ),
          ),
          // Country name
          title: Text(vpnInfo.countryLongName),

          // vpn speed
          subtitle: Row(
            children: [
              Icon(
                Icons.shutter_speed,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 4,),
              Text(
                formatSpeedBytes(vpnInfo.speed, 2),
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),

          //  number of sessions
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpnInfo.vpnSessionsNum.toString(),
                style: TextStyle(
                  color: Theme.of(context).lightTextColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                CupertinoIcons.person_2_alt,
                color: Colors.redAccent,
              )
            ],
          ),

        ),
      ),
    );
  }
}
