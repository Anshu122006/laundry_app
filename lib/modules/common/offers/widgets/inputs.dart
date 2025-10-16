import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/offer_cloud_db.dart';
import 'package:laundary_app/data/models/offer.dart';

class OfferInputs {
  static Widget getUpdateInput(BuildContext context, Offer offer) {
    TextEditingController title = TextEditingController();
    TextEditingController desc = TextEditingController();
    title.text = offer.title;
    desc.text = offer.desc;

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
          mainAxisSize: MainAxisSize.min, // <-- THIS is important
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),

            TextField(
              controller: title,
              decoration: InputDecoration(hintText: "Enter new title"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 12),

            Text("Description", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),

            TextField(
              controller: desc,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Enter new description"),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await OfferCloudDb.instance.updateOffer(
                    offer.copyWith(title: title.text, desc: desc.text),
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

  static Widget getAddInput(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController desc = TextEditingController();

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
          mainAxisSize: MainAxisSize.min, // <-- THIS is important
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),

            TextField(
              controller: title,
              decoration: InputDecoration(hintText: "Enter title"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 12),

            Text("Description", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),

            TextField(
              controller: desc,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Enter description"),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await OfferCloudDb.instance.addOffer(
                    Offer(
                      id: "",
                      title: title.text,
                      desc: desc.text,
                      priority: 0,
                      updatedAt: 0,
                      deleted: false,
                    ),
                  );
                  Get.back();
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
