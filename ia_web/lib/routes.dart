import 'package:flutter/material.dart';
import 'package:ia_web/pages/children_list_page.dart';
import 'package:ia_web/pages/home_page.dart';

Route<dynamic> generateRoute(settings) {
  switch (settings.name) {
    case 'home':
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case 'childrenList':
      return MaterialPageRoute(builder: (_) {
        final List<dynamic> argumentos = settings.arguments;
        return ChildrenListPage(
          claseArreglada: argumentos[0],
        );
      });
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
