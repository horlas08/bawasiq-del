import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/utils/generalImports.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> /*
    with TickerProviderStateMixin */
{
  // late Animation<double> animation;
  // late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1500),
    //   upperBound: 0.5,
    // );
    // animation = Tween<double>(
    //   begin: 0,
    //   end: 600,
    // ).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller.stop();
    //     }
    //   });
    //
    // controller.forward();

    Future.delayed(
      Duration.zero,
      () async {
        final String response =
            await rootBundle.loadString(Constant.getAssetsPath(4, "en"));
        context
            .read<LanguageProvider>()
            .setLocalLanguage(await json.decode(response));

        Map<String, String> params = {ApiAndParams.system_type: "2"};
        if (Constant.session
            .getData(SessionManager.keySelectedLanguageId)
            .isEmpty) {
          params[ApiAndParams.is_default] = "1";
        } else {
          params[ApiAndParams.id] =
              Constant.session.getData(SessionManager.keySelectedLanguageId);
        }

        await context.read<LanguageProvider>().getAvailableLanguageList(
            params: {ApiAndParams.system_type: "2"},
            context: context).then((value) {
          context
              .read<LanguageProvider>()
              .getLanguageDataProvider(
                params: params,
                context: context,
              )
              .then((value) {
            if (Constant.session.isUserLoggedIn()) {
              // if (Constant.session.getData(SessionManager.status) == "1") {
                context
                    .read<SettingsProvider>()
                    .getSettingsApiProvider({}, context).then(
                  (value) async {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                  },
                );
              // } else {
              //   if (Constant.session.isSeller()) {
              //     Navigator.pushReplacementNamed(
              //         context, editSellerProfileScreen,
              //         arguments: "");
              //   } else {
              //     Navigator.pushReplacementNamed(
              //         context, editDeliveryBoyProfileScreen);
              //   }
              // }
            } else {
              if (Constant.appLoginType == 1) {
                Constant.session
                    .setData(SessionManager.keyUserType, "seller", false);
                Navigator.pushNamed(context, loginScreen);
              } else if (Constant.appLoginType == 2) {
                Constant.session
                    .setData(SessionManager.keyUserType, "delivery_boy", false);

                Navigator.pushNamed(context, loginScreen);
              } else {
                Navigator.pushReplacementNamed(context, accountTypeScreen);
              }
            }
          });
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 150,
            maxWidth: 150,
          ),
          child: defaultImg(
            image: AppAssets.logo,
          ),
        ),
      ),
      // body: Align(
      //   alignment: FractionalOffset(
      //     controller.value,
      //     controller.value,
      //   ),
      //   child: Transform.scale(
      //     alignment: FractionalOffset(
      //       controller.value,
      //       controller.value,
      //     ),
      //     scale: controller.value * 2,
      //     child: defaultImg(
      //       image: 'logo',
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    // animation.removeListener(
    //   () {},
    // );
    // controller.dispose();
    super.dispose();
  }
}