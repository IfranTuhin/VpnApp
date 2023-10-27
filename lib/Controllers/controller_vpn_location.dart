import 'package:get/get.dart';
import 'package:vpn_basic_project/ApiVpnGate/api_vpn_gate.dart';
import 'package:vpn_basic_project/App_Perferences/perferences.dart';
import 'package:vpn_basic_project/Models/vpn_info.dart';

class ControllerVPNLocation extends GetxController{

  List<VpnInfo> vpnFreeServersAvailableList = AppPerferences.vpnList;

  final RxBool isLoadingNewLocations = false.obs;

  Future<void> retrieveVpnInformation() async
  {
    isLoadingNewLocations.value = true;

    vpnFreeServersAvailableList.clear();

    vpnFreeServersAvailableList =  await ApiVpnGate.retrieveAllAvailableFreeVpnServers();

    isLoadingNewLocations.value = false;
  }

}