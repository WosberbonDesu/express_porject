import 'package:flutter/material.dart';
import '../../constants/styles/text_styles.dart';

class AuthPageTemplate extends StatelessWidget {
  const AuthPageTemplate({Key? key, required this.page, this.profilePicWidget})
      : super(key: key);

  final Widget page;
  final Widget? profilePicWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "./dev_assets/top.png",
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.38,
                ),
                profilePicWidget ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "./dev_assets/logo.png",
                          height: 100,
                        ),
                        const Text(
                          "E-Cüzdan",
                          style: PersonalTStyles.w600s32W,
                        )
                      ],
                    )
              ],
            ),
            Positioned(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.38 - 50),
                padding: const EdgeInsets.only(top: 44, right: 24, left: 24),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: page,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
