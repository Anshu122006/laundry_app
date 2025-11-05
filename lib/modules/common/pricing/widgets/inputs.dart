import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/pricing_cloud_db.dart';
import 'package:laundary_app/data/models/pricing.dart';

class PricingInputs {
  static Widget getUpdateInput(BuildContext context, Pricing pricing) {
    TextEditingController name = TextEditingController();
    TextEditingController cost = TextEditingController();
    name.text = pricing.name.toString();
    cost.text = pricing.cost.toString();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Name", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: InputDecoration(hintText: "Enter new name"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),

            Text("New cost", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: cost,
              decoration: InputDecoration(hintText: "Enter new cost"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                  await PricingCloudDb.instance.updatePricing(
                    pricing.copyWith(name: name.text, cost: cost.text),
                  );
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget getAddInput(BuildContext context, String type) {
    TextEditingController name = TextEditingController();
    TextEditingController cost = TextEditingController();

    TextEditingController t = TextEditingController(text: type);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: () {
      //   FocusManager.instance.primaryFocus?.unfocus();
      // },
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // <-- THIS is important
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              TextField(
                controller: name,
                decoration: InputDecoration(hintText: "Enter name"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 12),

              Text("Wash Type", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Opacity(
                opacity: 0.8,
                child: TextField(
                  controller: t,
                  decoration: InputDecoration(hintText: "Enter wash type"),
                  enabled: false,
                ),
              ),
              SizedBox(height: 12),

              Text("Cost", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              TextField(
                controller: cost,
                decoration: const InputDecoration(hintText: "Enter cost"),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                ],
              ),
              SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await PricingCloudDb.instance.addPricing(
                      Pricing(
                        id: "",
                        name: name.text,
                        type: type,
                        cost: cost.text,
                        priority: 0,
                        updatedAt: DateTime.now().millisecondsSinceEpoch,
                        deleted: false,
                      ),
                    );

                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.back();
                  },
                  child: Text("Confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
