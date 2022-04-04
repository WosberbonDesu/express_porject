import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../components/main_components.dart';
import '../../constants/styles/colors.dart';
import '../../models/user_model.dart';
import '../../providers/appstate.dart';
import 'add_invoice.dart';
import 'home.dart';
import 'transactions.dart';
import 'notifications.dart';
import 'profile.dart';
import '../../services/global_context.dart';
import '../../utilities/notification_dialog.dart';
import '../../utilities/routes.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  final String userID;
  const TabsScreen({Key? key, required this.userID}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _currentIndex = 0;
  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  initNotifications() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificationDialog(
        NavigationService.navigatorKey.currentContext!,
        message.data,
      );
    });
  }

  void initialize() async {
    changeLoading();
    var app = Provider.of<AppState>(context, listen: false);
    var userReturn = await app.appService.getUser(widget.userID);
    if (userReturn is UserModel) {
      await app.setUser(userReturn);
      await app.getTransactions();
      app.updateUserLogin();
    }

    changeLoading();
  }

  @override
  void initState() {
    initialize();
    initNotifications();
    super.initState();
  }

  final List<Widget> _pages = [
    const Home(),
    const Transactions(),
    const Notifications(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? buildCircularProgress() : _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: PersonalColors.blue,
        onPressed: () => navigateToPage(
            context,
            const AddInvoice(
              backgroundColor: PersonalColors.orange,
              title: "Harcama Gir",
              isExpense: true,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_task_outlined,
              color: Colors.white,
            ),
            SizedBox(height: 2),
            Text(
              "Ödeme",
              style: TextStyle(color: Colors.white, fontSize: 11),
            )
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: icons,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          activeColor: PersonalColors.orange,
          inactiveColor: PersonalColors.grey3,
          activeIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i)),
    );

    // return PersistentTabView(
    //   context,
    //   navBarHeight: 72,
    //   navBarStyle: NavBarStyle.style15,
    //   decoration: NavBarDecoration(
    //     borderRadius: BorderRadius.circular(10.0),
    //     colorBehindNavBar: Colors.black,
    //   ),
    //   items: isLoading ? null : _navBarsItems(),
    //   screens: isLoading ? [buildCircularProgress()] : _buildScreens(),
    // );
  }

  // List<Widget> _buildScreens() {
  //   return [
  //     const Home(),
  //     const Transactions(),
  //     const AddInvoice(),
  //     const Notifications(),
  //     const Profile()
  //   ];
  // }

  List<IconData> icons = [
    FeatherIcons.home,
    Icons.account_balance_wallet_outlined,
    FeatherIcons.mail,
    FeatherIcons.user
  ];

  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     buildNavBarItem(icon: FeatherIcons.home, title: "Anasayfa"),
  //     buildNavBarItem(
  //         title: "Cüzdanım", icon: Icons.account_balance_wallet_outlined),
  //     PersistentBottomNavBarItem(
  //       onPressed: (p0) => navigateToPage(context, const AddInvoice()),
  //       icon: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           Icon(
  //             Icons.add_task_outlined,
  //             color: Colors.white,
  //           ),
  //           SizedBox(height: 5),
  //           Text(
  //             "Ödeme",
  //             style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       ),
  //       activeColorPrimary: PersonalColors.blue,
  //     ),
  //     buildNavBarItem(title: "Bildirimler", icon: FeatherIcons.mail),
  //     buildNavBarItem(title: "Profil", icon: FeatherIcons.user)
  //   ];
  // }

  // PersistentBottomNavBarItem buildNavBarItem(
  //     {required String title, required IconData icon}) {
  //   return PersistentBottomNavBarItem(
  //     icon: Icon(icon),
  //     title: title,
  //     activeColorPrimary: PersonalColors.orange,
  //     inactiveColorPrimary: PersonalColors.grey3,
  //   );
  // }
}
