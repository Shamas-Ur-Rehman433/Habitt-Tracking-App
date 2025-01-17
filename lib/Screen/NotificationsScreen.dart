import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For checking the platform
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // For local notifications

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];
  Map<String, String> allHabitsMap = {};

  // Notification setup for mobile (using flutter_local_notifications)
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadData();

    // Initialize local notifications for mobile platforms
    if (!kIsWeb) {
      _initializeNotifications();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      allHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  // Initialize local notifications (only for mobile platforms)
  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure this icon exists
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Save the notification settings
  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationHabits', selectedHabits);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  // Send a test notification based on platform (mobile)
  void _sendTestNotification() {
    if (!kIsWeb) {
      // Mobile notification using flutter_local_notifications
      if (notificationsEnabled) {
        _showLocalNotification();
      } else {
        print('Notifications are not enabled');
      }
    }
  }

  // Show mobile notifications (local notifications)
  Future<void> _showLocalNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'habit_channel_id',
      'Habit Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',  // Make sure the icon is valid
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Habit Reminder',
      'It\'s time to work on your habits!',
      notificationDetails,
    );
    print('Mobile Notification sent');
  }

  // Helper function to get color from hex code
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveNotificationSettings();
              },
            ),
            Divider(),
            Text(
              'Select Habits for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: allHabitsMap.entries.map((entry) {
                final habit = entry.key;
                final colorHex = entry.value;
                final color = _getColorFromHex(colorHex);
                return FilterChip(
                  label: Text(habit),
                  labelStyle: TextStyle(color: color),
                  selected: selectedHabits.contains(habit),
                  selectedColor: color.withOpacity(0.3),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: color, width: 2.0),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedHabits.add(habit);
                      } else {
                        selectedHabits.remove(habit);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Times for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                return FilterChip(
                  label: Text(time),
                  selected: selectedTimes.contains(time),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimes.add(time);
                      } else {
                        selectedTimes.remove(time);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Use the _sendTestNotification method to trigger the notification
                _sendTestNotification();
              },
              child: Text('Send Test Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
