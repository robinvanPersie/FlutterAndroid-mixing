import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 不需要左右箭头的control,
/// Swiper(
///   control: SwipeWithoutControl()
/// )
class SwipeWithoutControl extends SwiperPlugin {

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Text('');
  }

}