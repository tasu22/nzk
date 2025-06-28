import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/setting_section.dart';
import 'favourites_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 30)),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SettingSection(
            title: 'General',
            children: [
              ListTile(
                leading: const Icon(
                  CupertinoIcons.info,
                  color: Color(0xFFC19976),
                ),
                title: const Text('About App'),
                trailing: const Icon(CupertinoIcons.forward),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    backgroundColor: Color(0xFFC19976),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                'assets/images/nzk.png',
                              ), // <-- Replace with your image asset path
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'A B O U T',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF30382F),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 16.0,
                            ),
                            child: const Text(
                              'GOD IS GOOD ALL THE TIME\n\n'
                              'Made an app for us to sing and praise the lord, without ads without payments. All we need is your support and love through a follow on our socialswhere we will post human improvement apps',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF30382F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.heart,
                  color: Color(0xFFC19976),
                ),
                title: const Text('Favourites'),
                trailing: const Icon(CupertinoIcons.forward),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouritesPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.person_2,
                  color: Color(0xFFC19976),
                ),
                title: const Text('Follow Us'),
                trailing: const Icon(CupertinoIcons.forward),
                onTap: () async {
                  const url =
                      'https://www.tiktok.com/@smartalleni?_t=ZS-8xaNtb7BLnU&_r=1';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
