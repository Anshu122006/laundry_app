import 'package:flutter/material.dart';
import 'package:laundary_app/modules/common/attributions/widget/text_link.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';

class AttributionsScreen extends StatelessWidget {
  const AttributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 15),
                      child: CBackButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Attributions",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLink(
                            name: "washing machine logo",
                            link:
                                "https://iconscout.com/contributors/kerismaker",
                          ),
                          TextLink(
                            name: "employee logo",
                            link:
                                "https://www.freepik.com/icon/profile_3135715#fromView=search&page=1&position=46&uuid=72a9a37f-a1d6-483a-bcab-63f6f8349622",
                          ),
                          TextLink(
                            name: "account icon",
                            link: "https://www.flaticon.com/free-icons/avatar",
                          ),
                          TextLink(
                            name: "place order bucket image",
                            link: "https://iconscout.com/contributors/surang",
                          ),
                          TextLink(
                            name: "place order bucket image",
                            link: "https://iconscout.com/contributors/surang",
                          ),
                          TextLink(
                            name: "employee form illustration",
                            link: "https://storyset.com/worker",
                          ),
                          TextLink(
                            name: "email verification illustration",
                            link: "https://storyset.com/internet",
                          ),
                          TextLink(
                            name: "wallet illustration",
                            link: "https://storyset.com/money",
                          ),
                          TextLink(
                            name: "passbook illustration",
                            link: "https://storyset.com/home",
                          ),
                          TextLink(
                            name: "order placed illustration",
                            link: "https://storyset.com/business",
                          ),
                          TextLink(
                            name: "order picked illustration",
                            link: "https://storyset.com/transport",
                          ),
                          TextLink(
                            name: "order washing illustration",
                            link: "https://storyset.com/work",
                          ),
                          TextLink(
                            name: "order ready illustration",
                            link: "https://storyset.com/work",
                          ),
                          TextLink(
                            name: "order delivered illustration",
                            link: "https://storyset.com/business",
                          ),
                          TextLink(
                            name: "order cancelled illustration",
                            link: "https://storyset.com/coronavirus",
                          ),
                          TextLink(
                            name: "no internet illustration",
                            link: "https://storyset.com/online",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
