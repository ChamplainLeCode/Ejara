import 'package:ejara/app/entities/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/core.dart';

/*
 * @Author Champlain Marius Bakop
 * @Email champlainmarius20@gmail.com
 * @Github ChamplainLeCode
 * 
 */

void main() {
  // Do not modify
  initCore();
  runApp(MyKareeApp());

  //! Add your custom configurations
  /**
     * To stuck your app in portrait
     */
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

class MyKareeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Don't change this widget
    return KareeMaterialApp(

        // This represents your app's title
        title: 'Ejara Test',
        theme: ThemeData(
            primaryColor: MaterialColor(Style.primaryColor.value, {
              100: Style.primaryColor.withOpacity(0.1),
              200: Style.primaryColor.withOpacity(0.2),
              300: Style.primaryColor.withOpacity(0.3),
              400: Style.primaryColor.withOpacity(0.4),
              500: Style.primaryColor.withOpacity(0.5),
              600: Style.primaryColor.withOpacity(0.6),
              700: Style.primaryColor.withOpacity(0.7),
              800: Style.primaryColor.withOpacity(0.8),
              900: Style.primaryColor.withOpacity(0.9),
            }),
            secondaryHeaderColor: Style.primaryColor),
        debugShowCheckedModeBanner: false);
  }
}
