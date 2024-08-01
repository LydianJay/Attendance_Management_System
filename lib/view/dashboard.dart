import 'package:attendance_system/view/dashboard/homeview.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final Color _primary = const Color.fromARGB(255, 69, 178, 255);
  final Color _header = const Color.fromARGB(255, 69, 178, 255);

  Widget _getCurrentPanel(double scrWidth, double scrHeight) {
    return HomeView();
  }

  final _ctrlSideBar = SidebarXController(selectedIndex: 0, extended: true);
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            SidebarX(
              controller: _ctrlSideBar,
              items: const [
                SidebarXItem(icon: Icons.home, label: 'Home'),
                SidebarXItem(icon: Icons.search, label: 'Search'),
                SidebarXItem(icon: Icons.search, label: 'Details'),
              ],
              headerBuilder: (context, extended) {
                return extended
                    ? Column(
                        children: [
                          Container(
                            height: scrHeight * 0.22,
                            margin: const EdgeInsets.only(top: 6, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                            ),
                            child: Image.asset(
                              "assets/images/company_icon.jfif",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              'Attendance Dashboard',
                              style: TextStyle(
                                fontFamily: "Helvetica",
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Icon(
                          Icons.person_2,
                          color: Colors.black,
                        ),
                      );
              },
              theme: SidebarXTheme(
                decoration: BoxDecoration(
                  color: _primary,
                ),
              ),
              extendedTheme: SidebarXTheme(
                width: scrWidth * 0.2,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 69, 178, 255),
                  border: Border(
                    right: BorderSide(width: 1.2),
                  ),
                ),
                itemTextPadding: const EdgeInsets.only(
                  left: 32,
                ),
                selectedItemTextPadding: const EdgeInsets.only(
                  left: 32,
                ),
                iconTheme: const IconThemeData(
                  size: 50,
                ),
                selectedIconTheme: const IconThemeData(
                  size: 50,
                  color: Color.fromARGB(255, 1, 65, 117),
                ),
                textStyle: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: "Calibre",
                ),
                selectedTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 1, 65, 117),
                  fontFamily: "Calibre",
                ),
                hoverTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 1, 65, 117),
                  fontFamily: "Calibre",
                ),
                selectedItemDecoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: const Color.fromARGB(255, 1, 65, 117),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _ctrlSideBar,
              builder: ((context, child) {
                return Expanded(
                  child: Container(
                    height: scrHeight,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _header,
                            border: Border.all(),
                          ),
                          width: scrWidth,
                          height: scrHeight * 0.09,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  'Some Company Inc.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Calibre',
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: IconButton.outlined(
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _getCurrentPanel(scrWidth, scrHeight),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
