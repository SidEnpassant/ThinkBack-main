import 'package:flutter/material.dart';
import 'package:thinkback4/screens/add_future_jar_screen.dart';
import 'package:thinkback4/screens/add_memory/text_entry_screen.dart';
import 'package:thinkback4/screens/add_memory/voice_entry_screen.dart';
import 'package:thinkback4/screens/future_screen.dart';
import 'package:thinkback4/screens/home_screen.dart';
import 'package:thinkback4/screens/profile_screen.dart';
import 'package:thinkback4/screens/recall_screen.dart';
import 'package:thinkback4/screens/timeline_screen.dart';
import 'package:thinkback4/widgets/bottom_nav_bar.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RecallScreen(),
    const FutureScreen(),
    // const TimelineScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: _widgetOptions.elementAt(_selectedIndex)),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
          //if (_selectedIndex == 0)
          // Positioned(
          //   bottom: 90,
          //   left: 0,
          //   right: 0,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       _showAddMemoryOptions(context);
          //     },
          //     backgroundColor: Colors.blueAccent,
          //     child: const Icon(Icons.add),
          //   ),
          // ),
        ],
      ),
    );
  }

  // void _showAddMemoryOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext bc) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: <Widget>[
  //             ListTile(
  //               leading: const Icon(Icons.edit),
  //               title: const Text('Text'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const TextEntryScreen(),
  //                   ),
  //                 );
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.mic),
  //               title: const Text('Voice'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const VoiceEntryScreen(),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
