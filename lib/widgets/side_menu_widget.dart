import 'package:flutter/material.dart';
import 'package:flutter_application/pages/facility_page.dart';
import 'package:flutter_application/pages/feedback_page.dart';
import 'package:flutter_application/pages/login_screen/login_page.dart';
import 'package:flutter_application/pages/profile_page.dart';
import 'package:flutter_application/pages/options_page.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({Key? key}) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // const UserAccountsDrawerHeader(
          //   accountName: Text('Иванов Иван Иванович'),
          //   accountEmail: Text('РазРаб'),
          //   // currentAccountPicture: CircleAvatar(
          //   //   backgroundImage: NetworkImage(
          //   //       "https://m.media-amazon.com/images/M/MV5BMzUyNDg0NTQ2N15BMl5BanBnXkFtZTgwMzIyOTc5MjE@._V1_.jpg"),
          //   // ),
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: NetworkImage(
          //         "https://mobimg.b-cdn.net/v3/fetch/e9/e954d01138b54bb2a3118ea9d1b178be.jpeg",
          //       ),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Profile'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Login'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Facility'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FacilityPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OptionsPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
