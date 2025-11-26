import 'package:aitutorlab/cantroller/HomeController.dart';
import 'package:aitutorlab/utils/styleUtil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/common_color.dart';
import '../theme/mythemcolor.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key,});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sliderView(context)
          ],
        ),
      ],
    );
  }
}

Widget sliderView(BuildContext context) {
  HomeController homeController = Get.find<HomeController>();
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  late List<Widget> imageSliders = homeController.sliderItemListData
      .map((item) => InkWell(
    onTap: () {

    },
    child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: setCachedImage(item['slider_image'], 120, double.infinity, 10)
            ),
          ],
        )),
  ))
      .toList();

  return Obx(
          () {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
                color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                blurRadius: 4,
                offset: Offset(-0.5, 0)
            )
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CarouselSlider(
              items: imageSliders,
              carouselController: homeController.controller,
              options: CarouselOptions(
                  height: 120,
                  viewportFraction: 0.923,
                  // aspectRatio: 1.2,
                  // viewportFraction: .9,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                      homeController.current.value = index;
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: homeController.sliderItemListData.asMap().entries.map((entry) {
                return GestureDetector(
                  // onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: homeController.current.value == entry.key
                            ? myprimarycolor
                            : myprimarycolor.withOpacity(0.5)
                        ,
                      ),
                    )
                );
              }).toList(),
            ),
          ],
        ),
      );
    }
  );
}
