import 'package:flutter/material.dart';
import 'package:huawei_ads/huawei_ads.dart';

class HuaweiAdKitBanner extends StatelessWidget {
  final String adSlotId;

  const HuaweiAdKitBanner({super.key, required this.adSlotId});

  @override
  Widget build(BuildContext context) {
    return BannerView(
      size: BannerSize.BANNER_SIZE_320_50,
      adId: adSlotId,
      listener: AdListener(
        onAdLoaded: () => debugPrint('Ad Loaded'),
        onAdFailed: (code) => debugPrint('Ad Failed: $code'),
      ),
    );
  }
}
