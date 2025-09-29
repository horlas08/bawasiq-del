import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> profileMenus = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        setProfileMenuList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setProfileMenuList();

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: titleProfileLabel,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            profileHeader(
              context: context,
              name: Constant.session.getData(SessionManager.name),
              mobile: Constant.session.getData(SessionManager.mobile),
            ),
            SizedBox(height: 1),
            Flexible(
              child: Card(
                color: Theme.of(context).cardColor,
                surfaceTintColor: ColorsRes.appColorTransparent,
                child: profileMenuWidget(profileMenus: profileMenus),
              ),
            )
          ],
        ),
      ),
    );
  }

  setProfileMenuList() {
    profileMenus = [];
    profileMenus = [
      {
        "icon": AppAssets.themeIcon,
        "label": getTranslatedValue(context, changeThemeLabel),
        "clickFunction": themeDialog,
      },
      if (context.read<LanguageProvider>().languages.length > 1)
        {
          "icon": AppAssets.translateIcon,
          "label": getTranslatedValue(context, changeLanguageLabel),
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              backgroundColor: Theme.of(context).cardColor,
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetLanguageListContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": true,
        },
      /*
        {
          "icon": AppAssets."notification_icon",
          "label": getTranslatedValue(context,"lblNotification,
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },

        {
          "icon": AppAssets."transaction_icon",
          "label": getTranslatedValue(context,"lblTransactionHistory,
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },*/
      if (Constant.session.isSeller())
        {
          "icon": AppAssets.categoryIcon,
          "label": getTranslatedValue(context, titleCategoriesLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, categoryListScreen, arguments: "");
          },
          "isResetLabel": false
        },
      if (Constant.session.isSeller())
        {
          "icon": AppAssets.productsIcon,
          "label": getTranslatedValue(context, titleProductsLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, productListScreen, arguments: 0);
          },
          "isResetLabel": false
        },
      if (Constant.session.isSeller())
        {
          "icon": AppAssets.soldOutProductsIcon,
          "label": getTranslatedValue(context, titleStockManagementLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, productStockManagementScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isSeller())
        {
          "icon": AppAssets.productsBulkUploadIcon,
          "label": getTranslatedValue(context, titleProductsBulkUploadLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, productBulkOperationScreen,
                arguments: "upload");
          },
          "isResetLabel": false
        },
      if (Constant.session.isSeller())
        {
          "icon": AppAssets.productsBulkUpdateIcon,
          "label": getTranslatedValue(context, titleProductsBulkUpdateLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, productBulkOperationScreen,
                arguments: "update");
          },
          "isResetLabel": false
        },
      // {
      //   "icon": AppAssets."settings",
      //   "label": getTranslatedValue(context, notificationsSettingsLabel),
      //   "clickFunction": (context) {
      //     Navigator.pushNamed(
      //         context, notificationsAndMailSettingsScreenScreen);
      //   },
      //   "isResetLabel": false
      // },
      if (Constant.session.isUserLoggedIn() && !Constant.session.isSeller())
        {
          "icon": AppAssets.cashCollectionIcon,
          "label": getTranslatedValue(context, cashCollectionLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, cashCollectionScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn() && !Constant.session.isSeller())
        {
          "icon": AppAssets.fundTransferIcon,
          "label": getTranslatedValue(context, fundTransferLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, fundTransferScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn() &&
          Constant.session.isSeller())
        {
          "icon": AppAssets.walletHistoryIcon,
          "label": getTranslatedValue(context, walletHistoryLabel),
          "clickFunction": (context) {
            Navigator.pushNamed(context, walletHistoryListScreen);
          },
          "isResetLabel": false
        },
      {
        "icon": AppAssets.withdrawalRequestsIcon,
        "label": getTranslatedValue(context, withdrawalRequestsLabel),
        "clickFunction": (context) {
          Navigator.pushNamed(context, withdrawalRequestsListScreen);
        },
        "isResetLabel": false
      },
      {
        "icon": AppAssets.rateIcon,
        "label": getTranslatedValue(context, rateUsLabel),
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
/*      {
        "icon": AppAssets."share_icon",
        "label": getTranslatedValue(context,"lblShareApp,
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(context,"lblShareAppMessage;
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      }*/
      {
        "icon": AppAssets.termsIcon,
        "label": getTranslatedValue(context, termsOfServiceLabel),
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(context, termsOfServiceLabel),
          );
        }
      },
      {
        "icon": AppAssets.privacyIcon,
        "label": getTranslatedValue(context, privacyPolicyLabel),
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(context, privacyPolicyLabel),
          );
        }
      },
      {
        "icon": AppAssets.logoutIcon,
        "label": getTranslatedValue(context, logoutLabel),
        "clickFunction": Constant.session.logoutUser,
        "isResetLabel": false
      },
      {
        "icon": AppAssets.deleteUserAccountIcon,
        "label": getTranslatedValue(context, deleteUserAccountLabel),
        "clickFunction": (context) {
          showDialog<String>(
            context: context,
            builder: (BuildContext buildContext) => AlertDialog(
              backgroundColor: Theme.of(buildContext).cardColor,
              surfaceTintColor: ColorsRes.appColorTransparent,
              title: CustomTextLabel(
                jsonKey: deleteUserAccountLabel,
                softWrap: true,
              ),
              content: CustomTextLabel(
                jsonKey: deleteUserMessageLabel,
                softWrap: true,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(buildContext),
                  child: CustomTextLabel(
                    jsonKey: cancelLabel,
                    softWrap: true,
                    style: TextStyle(color: ColorsRes.subTitleTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    deleteUserAccount(params: {}).then((value) {
                      if (value[ApiAndParams.status].toString() == "1") {
                        showMessage(context, value[ApiAndParams.message],
                            MessageType.warning);
                        Navigator.pop(context);
                        Constant.session.processToLogout(buildContext);
                      }
                    });
                  },
                  child: CustomTextLabel(
                    jsonKey: okLabel,
                    softWrap: true,
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            ),
          );
        },
        "isResetLabel": false
      },
    ];

    setState(() {});
  }
}
