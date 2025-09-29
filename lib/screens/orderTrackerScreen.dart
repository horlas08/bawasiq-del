import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:http/http.dart' as http;

class OrderTrackerScreen extends StatefulWidget {
  final double addressLatitude;
  final double addressLongitude;
  final String address;
  final String orderId;
  final String customerName;
  final String customerNumber;

  const OrderTrackerScreen({
    Key? key,
    required this.addressLatitude,
    required this.addressLongitude,
    required this.address,
    required this.orderId,
    required this.customerName,
    required this.customerNumber,
  }) : super(key: key);

  @override
  State<OrderTrackerScreen> createState() => _OrderTrackerScreenState();
}

class _OrderTrackerScreenState extends State<OrderTrackerScreen> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;
  double mapZoom = 14.4746;

  late LatLng currentPosition;

  List<Marker> customMarkers = [];
  String googleMapCurrentStyle = "[]";

  late LatLng SOURCE;
  late LatLng DEST;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late BitmapDescriptor deliveryBoyIcon;
  late BitmapDescriptor customerIcon;

  Set<Marker> _markers = {};

  late Timer? timer;

  callApi() async {
    deliveryBoyIcon = await bitmapDescriptorFromSvgAsset(
        context, Constant.getAssetsPath(1, "delivery_boy"));

    customerIcon = await bitmapDescriptorFromSvgAsset(
        context, Constant.getAssetsPath(1, "customer_location"));

    await getDeliveryBoyLocation();

    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await getDeliveryBoyLocation();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      kMapCenter = LatLng(widget.addressLatitude, widget.addressLongitude);

      kGooglePlex = CameraPosition(
        target: kMapCenter,
        zoom: mapZoom,
      );

      googleMapCurrentStyle =
          Constant.session.getBoolData(SessionManager.isDarkTheme)
              ? await rootBundle.loadString(Constant.getAssetsPath(5, "nightMode"))
              : await rootBundle.loadString(Constant.getAssetsPath(5, "dayMode"));
      await checkPermission();

      callApi();
    });
  }

  getDeliveryBoyLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
    ));

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    context.read<LiveOrderTrackingProvider>().updateDeliveryBoyLatLongProvider(
      params: {
        ApiAndParams.orderStatus: "5",
        ApiAndParams.orderId: widget.orderId,
        ApiAndParams.latitude: currentPosition.latitude.toString(),
        ApiAndParams.longitude: currentPosition.longitude.toString(),
      },
      context: context,
    ).then(
      (value) async{
        DEST = LatLng(widget.addressLatitude,
            widget.addressLongitude); // Static source coordinates

        polylineCoordinates.add(DEST);

        SOURCE = LatLng(
            context.read<LiveOrderTrackingProvider>().deliveryBoyLatitude,
            context
                .read<LiveOrderTrackingProvider>()
                .deliveryBoyLongitude); // Dynamic destination coordinate
        if (polylineCoordinates.contains(SOURCE)) {
          polylineCoordinates.remove(SOURCE);
        }
        polylineCoordinates.clear();
        polylineCoordinates.add(SOURCE);
        polylineCoordinates.add(DEST);

        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('SOURCE'),
            position: SOURCE,
            icon: deliveryBoyIcon,
          ),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('DEST'),
            position: DEST,
            icon: customerIcon,
          ),
        );
      },
    );
  }

  //street router
  Future<List<LatLng>> getRoutePoints(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${Platform.isAndroid ? Constant.androidApiKey : Constant.iOSApiKey}';//${Constant.decodeBase64(Constant.googleApiKey)}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      return decodePolyline(points);
    } else {
      return [origin, destination];
    }
  }

  //street router
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return poly;
  }

  checkPermission() async {
    await hasLocationPermissionGiven().then(
      (value) async {
        if (value is PermissionStatus) {
          if (value.isDenied) {
            await Permission.location.request();
          } else if (value.isPermanentlyDenied) {
            showMessage(
                context,
                getTranslatedValue(context, locationPermissionMessageLabel),
                MessageType.error);
          }
        }
      },
    );
  }

  Future<dynamic> hasLocationPermissionGiven() async {
    try {
      bool permissionGiven = await Permission.location.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.location.request()).isGranted;
        return Permission.location.status;
      }
      return Permission.location.status;
    } catch (e) {
      return false;
    }
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );

    _markers.add(
      Marker(
        markerId: MarkerId('SOURCE'),
        position: SOURCE,
        icon: deliveryBoyIcon,
      ),
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  }

  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(svgString), null);

    double width = 39;
    double height = 50;

    // Convert to ui.Picture
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.scale(
        width / pictureInfo.size.width, height / pictureInfo.size.height);
    canvas.drawPicture(pictureInfo.picture);
    final ui.Picture scaledPicture = recorder.endRecording();

    final image = await scaledPicture.toImage(width.toInt(), height.toInt());

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI

    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: orderTrackingLabel,
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              Navigator.pop(context, true);
            });
          }
        },
        child: Consumer<LiveOrderTrackingProvider>(
          builder: (_, liveOrderTrackingProvider, __) {
            if (liveOrderTrackingProvider.liveOrderTrackingState ==
                LiveOrderTrackingState.loading) {
              return CustomShimmer(
                height: context.height,
                width: context.width,
                margin: EdgeInsets.all(10),
              );
            }
            if (liveOrderTrackingProvider.liveOrderTrackingState ==
                LiveOrderTrackingState.empty) {
              return Container(
                alignment: Alignment.center,
                height: context.height,
                width: context.width,
                child: DefaultBlankItemMessageScreen(
                  image: "something_went_wrong",
                  title: deliveryBoyIsNotLiveYetLabel,
                  description: "",
                  buttonTitle: tryAgainLabel,
                  callback: () {
                    getDeliveryBoyLocation();
                  },
                ),
              );
            }
            if (liveOrderTrackingProvider.liveOrderTrackingState ==
                LiveOrderTrackingState.error) {
              return Container(
                alignment: Alignment.center,
                height: context.height,
                width: context.width,
                child: DefaultBlankItemMessageScreen(
                  image: "something_went_wrong",
                  title: deliveryBoyIsNotLiveYetLabel,
                  description: "",
                  buttonTitle: tryAgainLabel,
                  callback: () {
                    getDeliveryBoyLocation();
                  },
                ),
              );
            }
            if (liveOrderTrackingProvider.liveOrderTrackingState ==
                LiveOrderTrackingState.loaded) {
              return Stack(
                children: [
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: mapWidget(),
                  ),
                  PositionedDirectional(
                    end: 10,
                    start: 10,
                    bottom: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorsRes.appColorLightHalfTransparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: ColorsRes.appColor,
                                  ),
                                ),
                                getSizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextLabel(
                                        jsonKey: deliveryLocationLabel,
                                        style: TextStyle(
                                          color: ColorsRes.mainTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                      CustomTextLabel(
                                        jsonKey: widget.address,
                                        style: TextStyle(
                                          color: ColorsRes.mainTextColor,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            getSizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                try {
                                  launchUrl(Uri.parse(
                                      "tel:${widget.customerNumber.replaceAll(" ", "")}"));
                                } catch (e) {
                                  showMessage(
                                      context,
                                      getTranslatedValue(
                                          context, somethingWentWrongLabel),
                                      MessageType.warning);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextLabel(
                                                  jsonKey: widget.customerName,
                                                  style: TextStyle(
                                                    color:
                                                        ColorsRes.mainTextColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                CustomTextLabel(
                                                  jsonKey:
                                                      widget.customerNumber,
                                                  style: TextStyle(
                                                    color:
                                                        ColorsRes.mainTextColor,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                          getSizedBox(width: 10),
                                          Container(
                                            padding:
                                                EdgeInsetsDirectional.all(5),
                                            decoration: BoxDecoration(
                                              color: ColorsRes
                                                  .appColorLightHalfTransparent,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.call,
                                              color: ColorsRes.appColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      style: googleMapCurrentStyle,
      onCameraMove: (position) {
        mapZoom = position.zoom;
      },
      polylines: {
        Polyline(
          polylineId: PolylineId("1"),
          color: ColorsRes.appColor,
          points: polylineCoordinates,
          visible: true,
          zIndex: -1,
          width: 2,
          consumeTapEvents: true,
          geodesic: true,
        )
      },
      markers: _markers, // Use updated markers
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
  }

  @override
  Future<void> didChangeDependencies() async {
    googleMapCurrentStyle =
        Constant.session.getBoolData(SessionManager.isDarkTheme)
            ? await rootBundle.loadString(Constant.getAssetsPath(5, "nightMode"))
            : await rootBundle.loadString(Constant.getAssetsPath(5, "dayMode"));
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
