import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/cashCollection.dart';
import 'package:project/provider/cashCollectionListProvider.dart';

class CashCollectionListScreen extends StatefulWidget {
  const CashCollectionListScreen({Key? key}) : super(key: key);

  @override
  State<CashCollectionListScreen> createState() =>
      _CashCollectionListScreenState();
}

class _CashCollectionListScreenState extends State<CashCollectionListScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  String startDate = "";
  String endDate = "";

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<CashCollectionProvider>().hasMoreData) {
          callApi();
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  bool isDateRangeValidate() {
    return (startDate != getTranslatedValue(context, startDateLabel) && endDate != getTranslatedValue(context, endDateLabel));
  }

  resetDate() {
    startDate = getTranslatedValue(context, startDateLabel);
    endDate = getTranslatedValue(context, endDateLabel);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      searchController.addListener(() {
        if (mounted) {
          setState(() {});
        callApi(reset: true);
        }
      });
      scrollController.addListener(scrollListener);
      callApi(reset: true);
    });

    super.initState();
  }

  callApi({bool? reset}) async {
    if (reset == true) {
      resetDate();
      context.read<CashCollectionProvider>().offset = 0;
      context.read<CashCollectionProvider>().cashCollection = [];
    }
    
    Map<String, String> params = {};
    params[ApiAndParams.search] = searchController.text.toString();
    if (isDateRangeValidate()) {
      params[ApiAndParams.startDate] = startDate;
      params[ApiAndParams.endDate] = endDate;
    }

    context.read<CashCollectionProvider>().getCashCollectionProvider(
        params: params,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: cashCollectionLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
        refreshCallback: () {
          return callApi(reset: true);
        },
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(10),
              margin: EdgeInsetsDirectional.only(start: 10, end: 10, top: 10, bottom: 5),
              decoration: DesignConfig.boxDecoration(
                Theme.of(context).cardColor,
                10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextLabel(
                          jsonKey: cashCollectionLabel,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CustomTextLabel(
                          text: "${context.watch<CashCollectionProvider>().cashInHand}".currency,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextLabel(
                          jsonKey: cashCollectedLabel,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CustomTextLabel(
                          text: "${context.watch<CashCollectionProvider>().cashCollected}".currency,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 10,
                end: 10,
                top: 10,
                bottom: 10
              ),
              child: Container(
                padding: EdgeInsetsDirectional.all((!isDateRangeValidate()) ? 12 : 14),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsRes.subTitleTextColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextLabel(
                        text: "$startDate\t\t${getTranslatedValue(context, toLabel)}\t\t$endDate",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    getSizedBox(width: 10),
                    if (!isDateRangeValidate())
                      GestureDetector(
                        onTap: () {
                          showDateRangePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100, 1, 1),
                            lastDate: DateTime.now(),
                            currentDate: DateTime.now(),
                            keyboardType: TextInputType.datetime,
                            builder: (context, child) {
                              return Theme(
                                data: Constant.session.getBoolData(SessionManager.isDarkTheme)
                                    ? ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: ColorsRes.appColor,
                                          onPrimary: ColorsRes.mainTextColor,
                                          surface: Theme.of(context).cardColor,
                                          inverseSurface: ColorsRes.subTitleTextColor,
                                          onSurface: ColorsRes.mainTextColor,
                                          secondary: ColorsRes.appColor,
                                        ),
                                        visualDensity: VisualDensity.compact, dialogTheme: DialogThemeData(backgroundColor: Theme.of(context).cardColor),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: ColorsRes.appColor,
                                          onPrimary: ColorsRes.mainTextColor,
                                          surface: Theme.of(context).cardColor,
                                          onSurface: ColorsRes.mainTextColor,
                                          inverseSurface: ColorsRes.subTitleTextColor,
                                          secondary: ColorsRes.appColor,
                                        ),
                                        visualDensity: VisualDensity.compact, dialogTheme: DialogThemeData(backgroundColor: Theme.of(context).cardColor),
                                      ),
                                child: child!,
                              );
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                startDate = value.start.toString().split(" ")[0];
                                endDate = value.end.toString().split(" ")[0];
                                context.read<CashCollectionProvider>().offset = 0;
                                context.read<CashCollectionProvider>().cashCollection.clear();
                                setState(() {});
                                callApi();
                              }
                            },
                          );
                        },
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    if (isDateRangeValidate())
                      GestureDetector(
                        onTap: () {
                          callApi(reset: true);
                          setState(() {});
                        },
                        child: CustomTextLabel(
                          jsonKey: clearLabel,
                          style: TextStyle(
                            color: ColorsRes.appColorRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
              child: editBoxWidget(
                maxlines: 1,
                context: context,
                edtController: searchController,
                validationFunction: (value)=> optionalFieldValidation("",  ""),
                label: getTranslatedValue(context, searchLabel),
                hint: getTranslatedValue(context, searchLabel),
                bgcolor: Theme.of(context).cardColor,
                inputType: TextInputType.text,
                tailIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: ColorsRes.mainTextColor,
                        ),
                      )
                    : null,
              ),
            ),
            getSizedBox(height: 10),
            Consumer<CashCollectionProvider>(
              builder: (context, cashCollectionDataProvider, _) {
                if (cashCollectionDataProvider.cashCollectionState ==
                        CashCollectionState.initial ||
                    cashCollectionDataProvider.cashCollectionState ==
                        CashCollectionState.loading) {
                  return getTransactionListShimmer();
                } else if (cashCollectionDataProvider.cashCollectionState ==
                        CashCollectionState.loaded ||
                    cashCollectionDataProvider.cashCollectionState ==
                        CashCollectionState.loadingMore) {
                  return Column(
                    children: List.generate(
                        cashCollectionDataProvider.cashCollection.length, (index) {
                      return getCashCollectionItemWidget(
                          cashCollectionDataProvider.cashCollection[index]);
                    }),
                  );
                } else {
                  return DefaultBlankItemMessageScreen(
                    image: "no_transaction",
                    title: getTranslatedValue(
                        context, emptyCashCollectionMessageLabel),
                    description: getTranslatedValue(context,
                        emptyCashCollectionDescriptionLabel),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getCashCollectionItemWidget(CashCollectionData cashCollectionData) {
    String message = cashCollectionData.message.toString();
    return Container(
      padding: EdgeInsets.all(Constant.paddingOrMargin10),
      margin: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin5,
          horizontal: Constant.paddingOrMargin10),
      decoration: DesignConfig.boxDecoration(
        Theme.of(context).cardColor,
        10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextLabel(
                  text: "${getTranslatedValue(context, orderIdLabel)} #${cashCollectionData.orderId}",
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ),
              SizedBox(width: Constant.paddingOrMargin5),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: Constant.paddingOrMargin5,
                    horizontal: Constant.paddingOrMargin10),
                decoration: DesignConfig.boxDecoration(
                  cashCollectionData.status?.toLowerCase() == "success"
                      ? ColorsRes.appColorGreen.withValues(alpha: 0.1)
                      : ColorsRes.appColorRed.withValues(alpha: 0.1),
                  5,
                  bordercolor: cashCollectionData.status?.toLowerCase() == "success"
                      ? ColorsRes.appColorGreen
                      : ColorsRes.appColorRed,
                  isboarder: true,
                  borderwidth: 1,
                ),
                child: CustomTextLabel(
                  jsonKey: cashCollectionData.status == "success" ? getTranslatedValue(context, successLabel) : getTranslatedValue(context, failedLabel),
                  style: TextStyle(
                    color: cashCollectionData.status?.toLowerCase() == "success"
                        ? ColorsRes.appColorGreen
                        : ColorsRes.appColorRed,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Constant.paddingOrMargin5),
          Divider(height: 1, color: ColorsRes.grey, thickness: 0),
          SizedBox(height: Constant.paddingOrMargin5),
          CustomTextLabel(
            jsonKey: messageLabel,
            style: TextStyle(
              color: ColorsRes.grey,
            ),
            softWrap: true,
          ),
          SizedBox(height: Constant.paddingOrMargin2),
          CustomTextLabel(
            text: message,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ColorsRes.mainTextColor,
            ),
            softWrap: true,
          ),
          SizedBox(height: Constant.paddingOrMargin20),
          CustomTextLabel(
            jsonKey: dateAndTimeLabel,
            style: TextStyle(
              color: ColorsRes.grey,
            ),
            softWrap: true,
          ),
          SizedBox(height: Constant.paddingOrMargin2),
          CustomTextLabel(
            text: cashCollectionData.createdAt.toString().formatDate(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ColorsRes.mainTextColor,
            ),
            softWrap: true,
          ),
          SizedBox(height: Constant.paddingOrMargin5),
          Divider(height: 1, color: ColorsRes.grey, thickness: 0),
          SizedBox(height: Constant.paddingOrMargin5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextLabel(
                jsonKey: amountLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor,
                ),
                softWrap: true,
              ),
              CustomTextLabel(
                text: cashCollectionData.amount?.currency,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: ColorsRes.appColor),
                softWrap: true,
              ),
            ],
          )
        ],
      ),
    );
  }

  getTransactionListShimmer() {
    return Column(
      children: List.generate(20, (index) => transactionItemShimmer()),
    );
  }

  transactionItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin10,
          horizontal: Constant.paddingOrMargin10),
      height: 180,
      width: context.width,
    );
  }
}