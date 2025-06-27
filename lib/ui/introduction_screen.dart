import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void skipToLastPage() {
    introKey.currentState?.animateScroll(3);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "List Your Product",
          body: "Here are all types of product",
          image: Image.asset("images/First_page.jpg", height: 300, width: 300),
        ),
        PageViewModel(
          title: "Lot of Collections",
          body: "Here are lots of collection for all",
          image:
              Image.asset("images/Second_page.jpg", height: 300, width: 300),
        ),
        PageViewModel(
          title: "Easy and Secure Pay",
          body: "আগে পণ্য পরে টাকা",
          image: Image.asset("images/Third_page.jpg", height: 300, width: 300),
        ),
        PageViewModel(
          title: "Quick Door Delivery",
          body: "We deliver your product as fast as possible",
          image:
              Image.asset("images/Fourth_page.jpg", height: 300, width: 300),
        ),
      ],
      onDone: completeOnboarding,
      onSkip: skipToLastPage,
      done: const Text("Done", style: TextStyle(fontSize: 20.0)),
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(fontSize: 20.0)),
      next: const Text("Next", style: TextStyle(fontSize: 20.0)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.blue,
        activeSize: Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}
