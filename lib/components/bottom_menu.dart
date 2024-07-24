import 'package:expenses_tracker/screen/home.dart';
import 'package:expenses_tracker/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomMenu(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.white, // Background color of BottomAppBar
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: kMinInteractiveDimension,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[500],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()),
                  );
                  break;
              }
              onTap(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 1.0), // Reduce padding
                  child: FaIcon(
                    FontAwesomeIcons.house,
                    size: 20.0, // Adjust icon size
                  ),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 1.0), // Reduce padding
                  child: FaIcon(
                    FontAwesomeIcons.gear,
                    size: 20.0, // Adjust icon size
                  ),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
