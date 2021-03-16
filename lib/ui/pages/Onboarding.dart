import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:votelink/repository/AppSharedPreferences.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  EdgeInsets containerPadding;

  final controller = PageController(
    initialPage: 0,
  );

  final titles = [
    "Fully Transparent and Verifiable",
    "Are you ready to vote?",
    "100% secure and safe voting",
    "Your identity remains anonymous"
  ];
  final descs = [
    "Our blockchain technology allows for full transparency with an open, auditable codebase. Every vote within the system is verifiable.",
    "Our blockchain technology allows for full transparency with an open, auditable codebase. Every vote within the system is verifiable.",
    "Our blockchain technology allows for full transparency with an open, auditable codebase. Every vote within the system is verifiable.",
    "Our blockchain technology allows for full transparency with an open, auditable codebase. Every vote within the system is verifiable."
  ];
  final pageImgs = [
    "assets/page1.png",
    "assets/page2.png",
    "assets/page3.png",
    "assets/page4.png"
  ];

  @override
  Widget build(BuildContext context) {
    containerPadding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Container(
          padding: containerPadding,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("SKIP",style: TextStyle(fontWeight: FontWeight.normal),),
                    onPressed: () {
                      AppSharedPreferences.instance
                          .setBooleanValue("isFirstLaunch", false);
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  )
                ],
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    page(0),
                    page(1),
                    page(2),
                    page(3),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect:
                          ExpandingDotsEffect(dotHeight: 8.0, dotWidth: 8.0),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (controller.page == 3)
                          Navigator.of(context).pushReplacementNamed('/home');
                        else
                          controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                      },
                      child: Icon(Icons.arrow_forward),
                      backgroundColor: Color(0xFF222222),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget page(int page) {
    return Container(
      padding: containerPadding,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Image.asset(
              pageImgs[page],
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  titles[page],
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  descs[page],
                  style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
