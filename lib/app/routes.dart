
import 'package:tic_task_app/route/SplashScreen.dart';
import 'package:tic_task_app/route/LoginScreen.dart';
import 'package:tic_task_app/route/TasksScreen.dart';

final routes = {
  "/": (_) => const SplashScreen(),
  "/login": (_) => const LoginScreen(),
  "/tasks": (_) => const TaskScreen(),
};

