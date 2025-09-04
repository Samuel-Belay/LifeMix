import 'package:flutter/material.dart';
import 'package:huawei_ads/huawei_ads.dart';

class HuaweiAdKitBanner extends StatelessWidget {
  const HuaweiAdKitBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BannerView(
      adSlotId: "testw6vs28auh3", // replace with your production AdSlot ID
      size: BannerAdSize.s320x50,
      adParam: const AdParam(),
      listener: (AdEvent event, {int? errorCode}) {
        debugPrint("Huawei Banner Ad event: $event, error: $errorCode");
      },
    );
  }
}
