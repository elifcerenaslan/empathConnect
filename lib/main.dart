import 'package:flutter/material.dart';
import 'features/home/view/home_view.dart';

void main() {
runApp(const EmpathConnectApp());
}

class EmpathConnectApp extends StatelessWidget {
const EmpathConnectApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'EmpathConnect',
debugShowCheckedModeBanner: false,
theme: ThemeData(
useMaterial3: true,
),
home: const HomeView(),
);
}
}