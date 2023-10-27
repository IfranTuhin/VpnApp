import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/App_Perferences/perferences.dart';
import 'package:vpn_basic_project/Controllers/controller_home.dart';
import 'package:vpn_basic_project/Models/vpn_status.dart';
import 'package:vpn_basic_project/Screens/available_vpn_servers_location_screen.dart';
import 'package:vpn_basic_project/Widgets/custom_widget.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/vpnEngine/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  //
  final homeController = Get.put(ControllerHome());

  // Location Selection  Button
  locationSelectionBottomNavigation(BuildContext context) {
    return SafeArea(
      child: Semantics(
        button: true,
        child: GestureDetector(
          onTap: () {
            Get.to(() => AvailableVpnServersLocationScreen());
          },
          child: Container(
            color: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * .041),
            height: 62,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.flag_circle,
                  color: Colors.white,
                  size: 36,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Select Country / Locations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.redAccent,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // vpn round button
  Widget vpnRoundButton() {
    return Column(
      children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              homeController.connectToVpnNow();
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: homeController.getRoundVpnButtonColor.withOpacity(.1),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeController.getRoundVpnButtonColor.withOpacity(.3),
                ),
                child: Container(
                  height: sizeScreen.height * .14,
                  width: sizeScreen.height * .14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: homeController.getRoundVpnButtonColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        homeController.getRoundVpnButtonText,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
  //

  @override
  Widget build(BuildContext context) {

    VpnEngine.snapshotVpnStage().listen((event) {
      homeController.vpnConnectionState.value = event;
    });
    // Size
    sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Free VPN"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.perm_device_info),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                AppPerferences.isModeDark ? ThemeMode.light : ThemeMode.dark,
              );
              AppPerferences.isModeDark = !AppPerferences.isModeDark;
            },
            icon: Icon(Icons.brightness_2_outlined),
          ),
        ],
      ),
      bottomNavigationBar: locationSelectionBottomNavigation(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 2 round widget
          // location  +  ping
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidget(
                titleText: homeController.vpnInfo.value.countryLongName.isEmpty ? "Location" : homeController.vpnInfo.value.countryLongName,
                subTitleText: "Free VPN",
                roundWidgetWithIcon: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.redAccent,
                  child: homeController.vpnInfo.value.countryLongName.isEmpty ?  Icon(
                    Icons.flag_circle,
                    size: 35,
                    color: Colors.white,
                  ) : null,
                  backgroundImage: homeController.vpnInfo.value.countryLongName.isEmpty ? null : AssetImage("countryFlags/${homeController.vpnInfo.value.countryShortName.toLowerCase()}.png"),
                ),
              ),
              CustomWidget(
                titleText: homeController.vpnInfo.value.countryLongName.isEmpty ? "60 ms" : "${homeController.vpnInfo.value.ping} ms",
                subTitleText: "PING",
                roundWidgetWithIcon: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.graphic_eq,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),),

          //  button for vpn
          Obx(() => vpnRoundButton(),),

          // 2 button
          // download + upload
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.snapshotVpnStatus(),
            builder: (context, dataSnapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget(
                    titleText: "${dataSnapshot.data!.byteIn ?? '0 kbps'}",
                    subTitleText: "Download",
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.arrow_circle_down,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CustomWidget(
                    titleText: "${dataSnapshot.data!.byteOut ?? '0 kbps'}",
                    subTitleText: "Upload",
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.pink,
                      child: Icon(
                        Icons.arrow_circle_up,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
