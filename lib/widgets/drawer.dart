import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:tasky/pages/employe_pages/notification_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // Darker Background
          Positioned.fill(
            child: Container(
              color: Color(0xFF4A3F8A), // Dark muted purple
            ),
          ),
          // Sparkly effect on top of the background

          // Drawer content on top of the background
          Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Pushes sign out to the bottom
            children: [
              Column(
                children: [
                  SizedBox(height: 40), // Add spacing at the top

                  CircleAvatar(
                    radius: 60, // Enlarge profile picture
                    backgroundImage:
                        AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  SizedBox(height: 20), // Add some spacing
                  // Artistic and larger text for the username
                  Text(
                    "hussain",
                    style: TextStyle(
                      fontSize: 24, // Larger font size for the username
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .white, // White for contrast against dark background
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10), // Add some spacing
                  // Artistic and larger text for Finished Exercises
                  InkWell(
                    onTap: () {
                      // Handle click event for finished exercises
                      print('Finished Exercises Clicked');
                      // Navigate to details or perform any action here
                    },
                    child: Text(
                      'Finished Exercises:',
                      style: TextStyle(
                        fontSize: 20, // Larger font size
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFBEC3FF), // Lighter purple for emphasis
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Sign out button section with improved visibility
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30.0), // Add padding at the bottom
                child: Column(
                  children: [
                    Divider(
                        color: Color(0xFFBEC3FF),
                        thickness: 1), // Lighter divider
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      title: Text(
                        'log out',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        context.read<AuthProvider>().logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
