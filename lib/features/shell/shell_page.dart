import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logeria/core/theme/app_colors.dart';

class ShellPage extends StatefulWidget {
  final Widget child;

  const ShellPage({
    super.key,
    required this.child,
  });

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int index = 0;

  final pages = [
    '/properties',
    '/calendar',
    '/alerts',
  ];

  void onTap(int i) {
    setState(() {
      index = i;
    });

    context.go(pages[i]);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color.fromARGB(255, 124, 124, 124),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500, // Полужирный для активного таба
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 20,
              height: 20,
              colorFilter: index == 0 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : ColorFilter.mode(Color.fromARGB(255, 124, 124, 124), BlendMode.srcIn)),
            label: 'Properties',
            
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: 20,
              height: 20,
              colorFilter: index == 1 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : ColorFilter.mode(Color.fromARGB(255, 124, 124, 124), BlendMode.srcIn)),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20,
              height: 20,
              colorFilter: index == 2 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : ColorFilter.mode(Color.fromARGB(255, 124, 124, 124), BlendMode.srcIn)),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}