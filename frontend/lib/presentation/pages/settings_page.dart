import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

/// 設定画面
/// アプリの設定とプロフィール管理
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Manage your profile information'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Configure notification settings'),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacy'),
            subtitle: Text('Privacy and data settings'),
          ),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text('Premium'),
            subtitle: Text('Upgrade to premium features'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
          ),
          const ListTile(leading: Icon(Icons.info), title: Text('About')),
        ],
      ),
    );
  }
}
