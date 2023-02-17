import 'package:belly_rate/auth/signin_page.dart';
import 'package:belly_rate/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'HomePage.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'A reader lives a thousand lives',
              body: 'The man who never reads lives only one.',
              image: buildImage('asset/auth/2022-login.gif'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Featured Books',
              body: 'Available right at your fingerprints',
              image: buildImage('asset/auth/2022-login.gif'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Simple UI',
              body: 'For enhanced reading experience',
              image: buildImage('asset/auth/2022-login.gif'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Today a reader, tomorrow a leader',
              body: 'Start your journey',
              footer: ButtonWidget(
                text: 'Start Reading',
                onClicked: () => goToHome(context),
              ),
              image: buildImage('asset/auth/2022-login.gif'),
              decoration: getPageDecoration(),
            ),
          ],

          done: Text(
            'Done',
            style: TextStyle(
                color: Color(0xFF5a3769), fontWeight: FontWeight.w600),
            selectionColor: Colors.grey,
          ),
          onDone: () => goToHome(context),
          showSkipButton: true,

          skip: Text('Skip', style: TextStyle(color: Color(0xFF5a3769))),
          onSkip: () => goToHome(context),
          next: Icon(Icons.arrow_forward, color: Color(0xFF5a3769)),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          globalBackgroundColor: Colors.white,
          dotsFlex: 4,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SignIn()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.grey,
        activeColor: Color(0xFF5a3769),
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        contentMargin: const EdgeInsets.all(3.0),
        imagePadding: EdgeInsets.fromLTRB(0, 70, 0, 0),
        bodyAlignment: Alignment.topCenter,
        imageFlex: 2,
        bodyFlex: 1,
        safeArea: 90,
        pageColor: Colors.white,
      );

  ButtonWidget({required String text, required void Function() onClicked}) {}
}
