import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/walletHistory.dart';

class WalletHistoryListScreen extends StatefulWidget {
  const WalletHistoryListScreen({Key? key}) : super(key: key);

  @override
  State<WalletHistoryListScreen> createState() =>
      _WalletHistoryListScreenState();
}

class _WalletHistoryListScreenState extends State<WalletHistoryListScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<WalletHistoryProvider>().hasMoreData) {
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
    Future.delayed(Duration.zero).then((value) {
      searchController.addListener(() {
        callApi(reset: true);
      });
      callApi();
    });

    scrollController.addListener(scrollListener);

    super.initState();
  }

  callApi({bool? reset}) async {
    if (reset == true) {
      context.read<WalletHistoryProvider>().offset = 0;
      context.read<WalletHistoryProvider>().walletHistories = [];
    }

    context.read<WalletHistoryProvider>().getWalletHistoryProvider(
        params: {ApiAndParams.search: searchController.text.toString()},
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: walletHistoryLabel,
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
            Consumer<WalletHistoryProvider>(
              builder: (context, walletHistoryProvider, _) {
                if (walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.initial ||
                    walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loading) {
                  return getTransactionListShimmer();
                } else if (walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loaded ||
                    walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loadingMore) {
                  return Column(
                    children: List.generate(
                        walletHistoryProvider.walletHistories.length, (index) {
                      return getWalletHistoryItemWidget(
                          walletHistoryProvider.walletHistories[index]);
                    }),
                  );
                } else {
                  return DefaultBlankItemMessageScreen(
                    image: "no_transaction",
                    title: getTranslatedValue(
                        context, emptyWalletHistoryListMessageLabel),
                    description: getTranslatedValue(context,
                        emptyWalletHistoryTransactionDescriptionLabel),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getWalletHistoryItemWidget(WalletHistoryData walletHistory) {
    String message = walletHistory.message ?? "";
    String? orderId = walletHistory.orderId??"";
    String? orderItemId = walletHistory.orderItemId;
    String? type = walletHistory.type?.toLowerCase();
    bool isCredit = type == "credit";
    bool isDebit = type == "debit";

    bool hasOrder = orderId != "null";
    bool hasOrderItem = orderItemId != null && orderItemId != "null";

    if (!hasOrder && !hasOrderItem) {
      // No order info
      message = walletHistory.message ?? "";
    } else if (hasOrder && hasOrderItem && isDebit) {
      // Debit with order info
      String orderIdText = (orderId != "null") ? "-${getTranslatedValue(context, orderIdLabel)}:$orderId" : "";
      message = "${getTranslatedValue(context, orderPlacedLabel)}$orderIdText";
    } else if (hasOrder && hasOrderItem && isCredit) {
      // Credit with order info
      String? productName = walletHistory.productName;
      String? variantName = walletHistory.variantName;

      bool hasProductInfo =
          productName != null && productName != "null" && variantName != null && variantName != "null" && orderId != "null";

      String orderDetail = hasProductInfo
          ? " [${getTranslatedValue(context, orderIdLabel)}:$orderId, ${getTranslatedValue(context, itemLabel)}: $productName ($variantName)]"
          : "";

      message = "${walletHistory.message ?? ""}$orderDetail";
    }

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
                  text: "ID #${walletHistory.id}",
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
                  isCredit
                      ? ColorsRes.appColorGreen.withValues(alpha: 0.1)
                      : ColorsRes.appColorRed.withValues(alpha: 0.1),
                  5,
                  bordercolor: isCredit
                      ? ColorsRes.appColorGreen
                      : ColorsRes.appColorRed,
                  isboarder: true,
                  borderwidth: 1,
                ),
                child: CustomTextLabel(
                  jsonKey: isCredit ? creditLabel : debitLabel,
                  style: TextStyle(
                    color: isCredit
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
            text: walletHistory.createdAt.toString().formatDate(),
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
                text: walletHistory.amount?.currency,
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