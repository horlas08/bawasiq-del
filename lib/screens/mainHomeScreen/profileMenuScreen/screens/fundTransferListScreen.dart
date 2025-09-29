import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/fundTransfer.dart';
import 'package:project/provider/fundTransferListProvider.dart';

class FundTransferListScreen extends StatefulWidget {
  const FundTransferListScreen({Key? key}) : super(key: key);

  @override
  State<FundTransferListScreen> createState() =>
      _FundTransferListScreenState();
}

class _FundTransferListScreenState extends State<FundTransferListScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<FundTransferProvider>().hasMoreData) {
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
      context.read<FundTransferProvider>().offset = 0;
      context.read<FundTransferProvider>().fundTransfer = [];
    }
    
    Map<String, String> params = {};
    params[ApiAndParams.search] = searchController.text.toString();

    context.read<FundTransferProvider>().getFundTransferProvider(
        params: params,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: fundTransferLabel,
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
            Consumer<FundTransferProvider>(
              builder: (context, fundTransferDataProvider, _) {
                if (fundTransferDataProvider.fundTransferState ==
                        FundTransferState.initial ||
                    fundTransferDataProvider.fundTransferState ==
                        FundTransferState.loading) {
                  return getTransactionListShimmer();
                } else if (fundTransferDataProvider.fundTransferState ==
                        FundTransferState.loaded ||
                    fundTransferDataProvider.fundTransferState ==
                        FundTransferState.loadingMore) {
                  return Column(
                    children: List.generate(
                        fundTransferDataProvider.fundTransfer.length, (index) {
                      return getFundTransferItemWidget(
                          fundTransferDataProvider.fundTransfer[index]);
                    }),
                  );
                } else {
                  return DefaultBlankItemMessageScreen(
                    image: "no_transaction",
                    title: getTranslatedValue(
                        context, emptyFundTransferMessageLabel),
                    description: getTranslatedValue(context,
                        emptyFundTransferDescriptionLabel),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getFundTransferItemWidget(FundTransferData fundTransferData) {
    String message = fundTransferData.message.toString();
    bool fundTransferType = fundTransferData.type?.toLowerCase() == "credit";
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
                  text: "${getTranslatedValue(context, idLabel)} #${fundTransferData.id}",
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
                  fundTransferType
                      ? ColorsRes.appColorGreen.withValues(alpha: 0.1)
                      : ColorsRes.appColorRed.withValues(alpha: 0.1),
                  5,
                  bordercolor: fundTransferType
                      ? ColorsRes.appColorGreen
                      : ColorsRes.appColorRed,
                  isboarder: true,
                  borderwidth: 1,
                ),
                child: CustomTextLabel(
                  jsonKey: fundTransferType ? getTranslatedValue(context, creditLabel) : getTranslatedValue(context, debitLabel),
                  style: TextStyle(
                    color: fundTransferType
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
            text: message.isNotEmpty?message: "-",
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
            text: fundTransferData.createdAt.toString().formatDate(),
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
                text: fundTransferData.amount?.currency,
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