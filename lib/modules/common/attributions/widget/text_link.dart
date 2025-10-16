import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.name, required this.link});

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          TextSpan(text: 'Link to $name used:   '),
          TextSpan(
            text: 'asset-link',
            style: TextStyle(
              color: CColors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    final url = Uri.parse(link);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.platformDefault);
                    } else {
                      // Handle error
                    }
                  },
          ),
        ],
      ),
    );
  }
}
