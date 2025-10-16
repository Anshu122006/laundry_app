import 'package:flutter/material.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/modules/client/account/widgets/account_update_form.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class AccountUpdateScreen extends StatelessWidget {
  const AccountUpdateScreen({super.key});

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
                      padding: const EdgeInsets.only(top: 20, left: 15),
                      child: CBackButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Update Profile",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AccountUpdateForm(),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CLineDivider(),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "You can change these details anytime\nKeep your account up to date !",
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        textAlign: TextAlign.center,
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
