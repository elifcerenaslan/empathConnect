import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
const HomeView({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('EmpathConnect Ana Sayfa'),
backgroundColor: Colors.teal.shade100,
),
body: const Center(
child: Text(
'Ekip çalışmasına hazırız! 🚀',
style: TextStyle(fontSize: 20),
),
),
);
}
}