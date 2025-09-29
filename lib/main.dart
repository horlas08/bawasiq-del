import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/provider/sellerStatusProvider.dart';

import 'helper/utils/generalImports.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ColorsRes.appColorTransparent));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) {
            return LanguageProvider();
          },
        ),
        ChangeNotifierProvider<ProductListProvider>(
          create: (context) {
            return ProductListProvider();
          },
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) {
            return SettingsProvider();
          },
        ),
        ChangeNotifierProvider<SellerStatusProvider>(
          create: (context) {
            return SellerStatusProvider();
          },
        ),
        ChangeNotifierProvider<CategoryListProvider>(
          create: (context) {
            return CategoryListProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionManager>(
      create: (_) => SessionManager(prefs: prefs),
      child: Consumer<SessionManager>(
        builder: (context, SessionManager sessionNotifier, child) {
          Constant.session =
              Provider.of<SessionManager>(context, listen: false);

          if (Constant.session
              .getData(SessionManager.appThemeName)
              .toString()
              .isEmpty) {
            Constant.session.setData(
                SessionManager.appThemeName, Constant.themeList[0], false);
            Constant.session.setBoolData(
                SessionManager.isDarkTheme,
                ui.PlatformDispatcher.instance.platformBrightness ==
                    Brightness.dark,
                false);
          }

          // This callback is called every time the brightness changes from the device.
          ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
            if (Constant.session.getData(SessionManager.appThemeName) ==
                Constant.themeList[0]) {
              Constant.session.setBoolData(
                  SessionManager.isDarkTheme,
                  ui.PlatformDispatcher.instance.platformBrightness ==
                      Brightness.dark,
                  true);
            }
          };

          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              Constant.session = Provider.of<SessionManager>(context);

              if (Constant.session
                  .getData(SessionManager.appThemeName)
                  .toString()
                  .isEmpty) {
                Constant.session.setData(
                    SessionManager.appThemeName, Constant.themeList[0], false);
                Constant.session.setBoolData(
                    SessionManager.isDarkTheme,
                    ui.PlatformDispatcher.instance.platformBrightness ==
                        Brightness.dark,
                    false);
              }

              // This callback is called every time the brightness changes from the device.
              ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
                if (Constant.session.getData(SessionManager.appThemeName) ==
                    Constant.themeList[0]) {
                  Constant.session.setBoolData(
                      SessionManager.isDarkTheme,
                      ui.PlatformDispatcher.instance.platformBrightness ==
                          Brightness.dark,
                      true);
                }
              };

              return /* AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(systemNavigationBarColor:
                        ColorsRes.appColorTransparent,
                        systemNavigationBarDividerColor: ColorsRes.appColorTransparent,
                        statusBarColor: Theme.of(context).colorScheme.onSurface,
                        systemStatusBarContrastEnforced: true
                    ),
                    child: */MaterialApp(
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: GlobalScrollBehavior(),
                    child: Directionality(
                      textDirection:
                          languageProvider.languageDirection.toLowerCase() ==
                                  "rtl"
                              ? ui.TextDirection.rtl
                              : ui.TextDirection.ltr,
                      child: /* SafeArea(bottom: true, top: false, child: */ child!/* ) */,
                    ),
                  );
                },
                navigatorKey: Constant.navigatorKay,
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: "/",
                scrollBehavior: ScrollGlowBehavior(),
                debugShowCheckedModeBanner: false,
                title: Constant.appName,
                theme: ColorsRes.setAppTheme().copyWith(
                  textTheme:
                      GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
                ),
                home: SplashScreen(),
              )/* ) */;
            },
          );
        },
      ),
    );
  }
}