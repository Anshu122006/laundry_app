import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text("Feedback", style: Theme.of(context).textTheme.titleLarge),
            TextField(
              decoration: InputDecoration(
                label: Text(
                  "Your Name",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(
                  "Your Feedback",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                hintText: 'Let us know what you think...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 3,
                  children: [
                    Icon(Icons.send, color: CColors.white),
                    Text("Send"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
