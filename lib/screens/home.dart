import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wit_canteen_app/auth/auth_backend.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/menuGrid.dart';
import 'package:wit_canteen_app/menuitem.dart';
import 'package:wit_canteen_app/cart.dart';
import 'package:wit_canteen_app/otherScreens/about.dart';
import 'package:wit_canteen_app/otherScreens/edit_profile.dart';
import 'package:wit_canteen_app/otherScreens/order_history.dart';
import 'package:wit_canteen_app/profile.dart';
import 'package:wit_canteen_app/screens/my_orders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  /*Animation? notiHeight;
  Animation? notiWidth;
  AnimationController? controller;*/
  final _advancedDrawerController = AdvancedDrawerController();

  TabController? _tabController;

  AnimationController? _ColorAnimationController;
  Animation? _colorTween;
  ScrollController? _scrollController;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController!
          .animateTo(scrollInfo.metrics.pixels / 300); //org-300
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController!);
    _tabController = TabController(length: 3, vsync: this);
    /*controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    notiHeight = Tween<double>(begin: 0.0, end: 80.0).animate(controller!);
    notiWidth = Tween<double>(begin: 0.0, end: 300).animate(controller!);
    /*controller!.addListener(() {
      setState(() {});
    });*/
    controller!.reverse();*/
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  HotReloader? reloader;

  void onRefresh() async {
    //await HotReloader.create();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        //border: Border.all(width: 2, color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900.withOpacity(0.05),
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: ((context, snapshot) {
                var map = snapshot.data;
                if (!snapshot.hasData) return Container();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getHeight(context) * 0.2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        child: Text(
                          map!['userType'].toString().toUpperCase(),
                          style: TextStyle(
                            fontFamily: "SemiBold",
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      map['name'],
                      style: TextStyle(
                        fontFamily: "SemiBold",
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      map['email'],
                      style: TextStyle(
                        fontFamily: "SemiBold",
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      '${map['class']}   (${map['uniqueNumber']})',
                      style: TextStyle(
                        fontFamily: "SemiBold",
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      '+91 ${map['phone']}',
                      style: TextStyle(
                        fontFamily: "SemiBold",
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.06,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: EditProfile()));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: color2.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      SvgPicture.asset('assets/icons/edit.svg'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontFamily: "SemiBold",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: OrderHistory()));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: color2.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      'assets/icons/history.svg'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Order History',
                                style: TextStyle(
                                  fontFamily: "SemiBold",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: About()));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: color2.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      'assets/icons/about.svg'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'About',
                                style: TextStyle(
                                  fontFamily: "SemiBold",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.15,
                    ),
                    InkWell(
                        onTap: () {
                          logOut(context);
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: Colors.black.withOpacity(0.4)),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              }),
            )
          ],
        ),
      )),
      child: Stack(children: [
        NotificationListener<ScrollNotification>(
          //onNotification: _scrollListener,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  elevation: 4,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.white,
                  expandedHeight: getHeight(context) * 0.50,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [StretchMode.zoomBackground],
                    background: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*SizedBox(
                            height: 40,
                          ),*/
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _handleMenuButtonPressed();
                                        /*Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut,
                                  type: PageTransitionType.leftToRight,
                                  child: ProfilePage()),
                            );*/
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(80)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Icon(Iconsax.menu) //
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    !open
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18.0,
                                                      vertical: 12),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.lock_outline_rounded,
                                                    size: 14,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    'Canteen closed',
                                                    style: TextStyle(
                                                      fontFamily: 'SemiBold',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'DELIVER TO',
                                                style: TextStyle(
                                                    letterSpacing: 1.2,
                                                    fontFamily: 'SemiBold',
                                                    color: color),
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Text(
                                                'WIT Canteen',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Medium',
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              )
                                            ],
                                          )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.bounceInOut,
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: OrderView()),
                                        );
                                      },
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Orders')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .orderBy('time', descending: true)
                                              .where('status',
                                                  isEqualTo: 'SUCCESS')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Container();
                                            if (snapshot.data!.docs.length >=
                                                1) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80)),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14.0),
                                                    child: Badge(
                                                        elevation: 0,
                                                        badgeColor: color,
                                                        badgeContent: Text(
                                                          snapshot
                                                              .data!.docs.length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Medium',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        child: Icon(
                                                            Iconsax.reserve)) //
                                                    ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    /*InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut,
                                  type: PageTransitionType.rightToLeft,
                                  child: OrderPage()),
                            );
                          },
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Carts')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Items')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Container();
                                if (!snapshot.hasError) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(80)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Badge(
                                            elevation: 0,
                                            badgeColor: color,
                                            badgeContent: Text(
                                              snapshot.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Medium',
                                                  color: Colors.white),
                                            ),
                                            child: Icon(Iconsax.shopping_cart)) //
                                        ),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: color2,
                                        borderRadius: BorderRadius.circular(80)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Badge(
                                            elevation: 0,
                                            badgeColor: color,
                                            badgeContent: Text(
                                              '0',
                                              style: TextStyle(
                                                  fontFamily: 'Medium',
                                                  color: Colors.white),
                                            ),
                                            child: Icon(Iconsax.shopping_cart)) //
                                        ),
                                  );
                                }
                              }),
                        ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 2,
                            width: getWidth(context),
                            color: Colors.black.withOpacity(0.05),
                          ),
                          SizedBox(height: 8),

                          /*Stack(
                                  children: [
                                    Container(
                                      width: getWidth(context),
                                      // color: Colors.red,
                                      child: Text(
                      "Welcome!",
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 35,
                      ),
                                      ),
                                    ),
                                    Container(
                                      height: notiHeight!.value,
                                      width: notiWidth!.value,
                                      decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(100)),
                                    ),
                                  ],
                                ),*/
                          /*SizedBox(
                                  height: 20,
                                ),*/

                          //Search box
                          /*Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ConstrainedBox(
                                    constraints:
                      BoxConstraints.tightFor(width: getWidth(context)),
                                    child: TextField(
                                      decoration: InputDecoration(
                      labelText: "What would you like to eat?",
                      labelStyle: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.5),
                          fontWeight: FontWeight.w500),
                      prefixIcon: Row(
                        children: [
                          Icon(Iconsax.search_normal),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 20,
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          )
                        ],
                      ),
                      prefixIconColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color.fromARGB(255, 224, 224, 224)
                          .withOpacity(0.3),
                      filled: false,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),*/
                          /*SizedBox(
                                  height: getHeight(context) * 0.03,
                                ),*/
                          Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              header: ClassicHeader(),
                              controller: refreshController,
                              onRefresh: onRefresh,
                              onLoading: onLoading,
                              child: Container(
                                height: getHeight(context) * 0.3,
                                child: Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /*Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Container(
                                        width: getWidth(context),
                                        // color: Colors.red,
                                        child: Text(
                                          "Offers",
                                          style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),*/
                                    SizedBox(
                                      height: 10,
                                    ),
                                    /*Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Offers')
                                            .snapshots(),
                                        builder: ((BuildContext context,
                                            AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (!snapshot.hasData)
                                            return const SizedBox.shrink();
                                          return CarouselSlider(
                                            options: CarouselOptions(
                                              height: 120.0,
                                              viewportFraction: 1.0,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                            ),
                                            items: snapshot.data!.docs.map((i) {
                                              Map<String, dynamic> map =
                                                  i.data() as Map<String, dynamic>;
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: OfferItem(
                                                      img: map['image'],
                                                      condition: map['condition'],
                                                      percent: map['percent'],
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          );
                                          /*return Container(
                                height: 100,
                                child: ListView.builder(
                                    primary: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, i) {
                                      Map<String, dynamic> map =
                                          snapshot.data!.docs[i].data()
                                              as Map<String, dynamic>;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: OfferItem(
                                          img: map['image'],
                                          condition: map['condition'],
                                          percent: map['percent'],
                                        ),
                                      );
                                    }),
                                );*/
                                        }),
                                      ),
                                    ),*/
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Container(
                                        width: getWidth(context),
                                        // color: Colors.red,
                                        child: Text(
                                          "For You",
                                          style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Recommendations')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('Items')
                                          .orderBy('index', descending: true)
                                          .snapshots(),
                                      builder: ((BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData)
                                          return const SizedBox.shrink();
                                        return Container(
                                          height: getHeight(context) * 0.2,
                                          child: ListView.builder(
                                              primary: true,
                                              physics: BouncingScrollPhysics(),
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (ctx, i) {
                                                Map<String, dynamic> map =
                                                    snapshot.data!.docs[i]
                                                            .data()
                                                        as Map<String, dynamic>;
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: i == 0 ? 18.0 : 0,
                                                      right: 12),
                                                  child: MenuItemHorizontal(
                                                    img: map['image'],
                                                    price:
                                                        map['price'].toString(),
                                                    product: map['product'],
                                                    id: snapshot
                                                        .data!.docs[i].id,
                                                  ),
                                                );
                                              }),
                                        );
                                      }),
                                    ),

                                    /*Expanded(
                                                  child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                child: MenuGrid(),
                                              )),*/
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: Transform.translate(
                        offset: Offset(0, 1),
                        child: AnimatedBuilder(
                          animation: _ColorAnimationController!,
                          builder: (context, child) => Container(
                            height: getHeight(context) * 0.12,
                            color: _colorTween!.value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 0, top: 0),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Container(
                                        width: getWidth(context),
                                        // color: Colors.red,
                                        child: Text(
                                          "Menu",
                                          style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40,
                                        color: Colors.white,
                                        child: TabBar(
                                            isScrollable: true,
                                            controller: _tabController,
                                            indicatorPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 2, horizontal: 2),
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                            labelColor:
                                                Colors.black.withOpacity(0.7),
                                            labelPadding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            unselectedLabelColor:
                                                Colors.black.withOpacity(0.7),
                                            labelStyle: TextStyle(
                                                fontFamily: 'Bold',
                                                fontSize: 16),
                                            tabs: [
                                              Tab(
                                                text: 'Snacks',
                                              ),
                                              Tab(
                                                text: 'Food',
                                              ),
                                              Tab(
                                                text: 'Beverages',
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                )
              ];
            },
            body: Container(
              color: Colors.white,
              child: TabBarView(controller: _tabController, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: MenuGrid('snack'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: MenuGrid('food'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: MenuGrid('beverage'),
                ),
              ]),
            ),
          ),
        ),
        open
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Carts')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('Sum')
                        .snapshots(),
                    builder: (context, snapshot1) {
                      if (!snapshot1.hasData) return Container();
                      if (snapshot1.data!.docs[0]['sum'] > 0) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Carts')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Items')
                              .snapshots(),
                          builder: (context, snapshot) {
                            try {
                              if (snapshot.hasError) return Container();
                              if (!snapshot.hasData) return Container();
                              if (snapshot.data!.docs.length != 0) {
                                return Container(
                                  height: 80,
                                  width: getWidth(context),
                                  color: color,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 28.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('Carts')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('Sum')
                                                .snapshots(),
                                            builder: (context, snapshot2) {
                                              if (!snapshot2.hasData)
                                                return Container();
                                              return Row(
                                                children: [
                                                  Text(
                                                    '₹ ${snapshot2.data!.docs[0]['sum'].toString()}',
                                                    style: TextStyle(
                                                        fontFamily: 'SemiBold',
                                                        color: Colors.white,
                                                        fontSize: 36),
                                                  ),
                                                  Text(
                                                    '    ${snapshot2.data!.docs[0]['quantity'].toString()} items',
                                                    style: TextStyle(
                                                        fontFamily: 'SemiBold',
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontSize: 20),
                                                  )
                                                ],
                                              );
                                            }),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: OrderPage()),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0,
                                                      vertical: 16),
                                              child: Text(
                                                'View Cart',
                                                style: TextStyle(
                                                    fontFamily: 'SemiBold',
                                                    color: color,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } catch (e) {
                              print('e--${e}');
                              return Container();
                            }
                          },
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    }),
              )
            : Container(),
      ]),
    );
  }
}
