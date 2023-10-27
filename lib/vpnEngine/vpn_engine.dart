import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vpn_basic_project/Models/vpn_configuration.dart';
import 'package:vpn_basic_project/Models/vpn_status.dart';

class VpnEngine {
  // Native channel
  static final String eventChannelVpnStage = "vpnStage";
  static final String eventChannelVpnStatus = "vpnStatus";
  static final String methodChannelVpnControl = "vpnControl";

  // vpn connection stage snapshot
  static Stream<String> snapshotVpnStage() =>
      EventChannel(eventChannelVpnStage).receiveBroadcastStream().cast();

// vpn connection status snapshot
  static Stream<VpnStatus?> snapshotVpnStatus() =>
      EventChannel(eventChannelVpnStatus)
          .receiveBroadcastStream()
          .map((eventStatus) => VpnStatus.fromJson(jsonDecode(eventStatus))).cast();

  // Start vpn method
  static Future<void>  startVpnNow(VpnConfiguration vpnConfiguration) {
    return MethodChannel(methodChannelVpnControl).invokeMethod(
      "start",
      {
        "config" : vpnConfiguration.config,
        "country" : vpnConfiguration.countryName,
        "username" : vpnConfiguration.username,
        "password" : vpnConfiguration.password,
      },
    );
  }

  // Stop vpn now
  static Future<void> stopVpnNow()
  {
    return MethodChannel(methodChannelVpnControl).invokeMethod("stop");
  }

  // kill switch open
  static Future<void> killSwitchOpenNow()
  {
    return MethodChannel(methodChannelVpnControl).invokeMethod("kill_switch");
  }

  // refresh stage now
  static Future<void> refreshStageNow()
  {
    return MethodChannel(methodChannelVpnControl).invokeMethod("refresh");
  }

  // get stage now
  static Future<String?> getStageNow()
  {
    return MethodChannel(methodChannelVpnControl).invokeMethod("stage");
  }

  // vpn connected now
  static Future<bool> isConnectedNow()
  {
    return getStageNow().then((valueStage) => valueStage!.toLowerCase() == "connected");
  }

  // Stages of vpn connection
  static const String vpnConnectedNow = "connected";
  static const String vpnDisconnectedNow = "disconnected";
  static const String vpnWaitConnectionNow = "wait_connection";
  static const String vpnAuthenticatingNow = "authenticating";
  static const String vpnReconnectNow = "reconnect";
  static const String vpnNoConnectionNow = "no_connection";
  static const String vpnConnectingNow = "connecting";
  static const String vpnPrepareNow = "prepare";
  static const String vpnDeniedNow = "denied";

}