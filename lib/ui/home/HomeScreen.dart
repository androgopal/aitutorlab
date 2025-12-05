import 'dart:async';

import 'package:aitutorlab/cantroller/HomeController.dart';
import 'package:aitutorlab/session/SessionManager.dart';
import 'package:aitutorlab/utils/AppBars.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/common_color.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBackground.dart';
import '../../utils/CategoryCard.dart';
import '../../utils/HeaderSection.dart';
import '../../utils/styleUtil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: AppBackground(
          child: Column(
            children: [
              // Enhanced Header with gradient
              _buildEnhancedHeader(context, textTheme, isDarkTheme),

              // Main Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 20),
                        const HeaderSection(),
                        const SizedBox(height: 20),
                        _buildMainContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
          ),
        ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, TextTheme textTheme, bool isDarkTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkTheme
              ? [
            myprimarycolor.withOpacity(0.3),
            Theme.of(context).colorScheme.primaryContainer,
          ]
              : [
            myprimarycolor.withOpacity(0.1),
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? myprimarycolor.withAlpha(60)
                : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            myprimarycolorAccent.withOpacity(0.25),
                            myprimarycolor.withOpacity(0.25),
                          ],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey, ${SessionManager.getUserName() ?? ""}! 👋",
                            style: textTheme.titleLarge?.copyWith(
                              color: myprimarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "What do you wanna learn today?",
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkTheme
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: myprimarycolor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: myprimarycolor,
                    size: 26,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> testList = [
    {
      "title": "English Test",
      "subtitle": "Spoken • 5Hr",
      "icon": Icons.language,
    },
    {
      "title": "Math Exam",
      "subtitle": "Math Test • 2 Days",
      "icon": Icons.calculate,
    },
    {
      "title": "Science Test",
      "subtitle": "Physics • 3Hr",
      "icon": Icons.science,
    },
    {
      "title": "GK Exam",
      "subtitle": "General Knowledge • 1Hr",
      "icon": Icons.public,
    },
  ];


  Widget _buildMainContent() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    HomeController homeCtrl = Get.find<HomeController>();
    return Obx(
            () {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border(
              top: BorderSide(
                color: myprimarycolorAccent.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              if(homeCtrl.upcommingSessions.isNotEmpty)
              _buildTestScheduleSection(isDarkTheme),
              if(homeCtrl.upcommingSessions.isNotEmpty)
              const SizedBox(height: 20),
              if(homeCtrl.featuredSessions.isNotEmpty)
              catVeiw(),
              if(homeCtrl.featuredSessions.isNotEmpty)
              const SizedBox(height: 30),
            ],
          ),
        );
      }
    );
  }

  Widget _buildTestScheduleSection(bool isDarkTheme) {
    TextTheme textTheme = Theme.of(context).textTheme;

    HomeController homeContr = Get.find<HomeController>();
    return Obx(
            () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [myprimarycolor, myprimarycolorAccent],
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Upcoming Sessions",
                    style: textTheme.titleLarge?.copyWith(
                      color: myprimarycolorAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ✅ HORIZONTAL LIST
            SizedBox(
              height: 150, // adjust based on your card height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: homeContr.upcommingSessions.length,
                itemBuilder: (context, index) {
                  final item = homeContr.upcommingSessions[index];

                  // ✅ Auto color gradient based on odd/even
                  final gradientColors = index.isOdd
                      ? [Colors.blue.shade400, Colors.blue.shade600]   // odd
                      : [Colors.purple.shade400, Colors.purple.shade600]; // even

                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: _buildTestCard(
                      item["category_name"] ?? "",
                      "Session",
                      "${homeContr.imgBaseUrl.value}${item["category_image"] ?? ""}",
                      gradientColors,
                      isDarkTheme,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildTestCard(String title, String subtitle, String icon,
      List<Color> gradientColors, bool isDarkTheme) {
    print("wertyuytre $icon") ;
    return Container(
      width: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: setCachedImage(icon, 30, 30, 2)
                // Icon(icon, color: Colors.white, size: 20),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget catVeiw() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = homeController.categoryListData;

    if (homeController.categoryListData.isEmpty) {
      return apiLoader();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Categories", () {
          // Get.to(() => AllCatgoryScreen());
        }),
        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: homeController.featuredSessions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: screenHeight < 825 ? 0.95 : 1.1,
            ),
            itemBuilder: (context, index) {
              final item = homeController.featuredSessions[index];
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 300 + (index * 100)),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: InkWell(
                        onTap: () {
                          // Get.to(() => SubCatWishScreen(...));
                        },
                        child: EnhancedCategoryCard(
                          title: item["category_name"] ?? '',
                          subtitle: "20 Lessons",
                          icon: "${homeController.imgBaseUrl.value}${item["category_image"] ?? ""}",
                          // icon: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFH3NcMTzwqPd8jJfz_UihpQvdqtdnQQ8dhfS_anEM9nkifTxdAgDHP-OFLFViHP2Avt0&usqp=CAU",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),

        if (homeController.featuredTools.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionHeader("Popular Tools", () {
            // Get.to(() => AllProductScreen());
          }),
          const SizedBox(height: 12),
          Obx(() {
            final products = homeController.featuredTools ?? [];
            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      // Get.to(() => ProductDetailScreen(...));
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 16, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDarkTheme
                              ? [
                            Colors.grey.shade800,
                            Colors.grey.shade900,
                          ]
                              : [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: myprimarycolor.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            setCachedImage(
                              homeController.toolImgLink+product["tool_image"],
                              220,
                              180,
                              20,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        product["tool_name"],
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,

                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [myprimarycolor, myprimarycolorAccent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: myprimarycolorAccent,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onViewAll,
            icon: Icon(Icons.arrow_forward, size: 18, color: myprimarycolor),
            label: Text(
              "View all",
              style: TextStyle(
                color: myprimarycolor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedCategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback? onTap;

  const EnhancedCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  State<EnhancedCategoryCard> createState() => _EnhancedCategoryCardState();
}

class _EnhancedCategoryCardState extends State<EnhancedCategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkTheme
                ? [
              Colors.grey.shade800,
              Colors.grey.shade900,
            ]
                : [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: myprimarycolor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: myprimarycolor.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 00,
                  height: 00,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: myprimarycolor.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: myprimarycolor.withOpacity(0.05),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: myprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: setCachedImage(widget.icon, 80, 80, 7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: myprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: myprimarycolor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeCtrl = Get.find<HomeController>();
    return Obx(
            () {
              if(homeCtrl.sliderData.isEmpty){
                return SizedBox.shrink();
              }
        return Column(
              children: [
                sliderView(context),
              ],
        );
      }
    );
  }
}

Widget sliderView(BuildContext context) {
  HomeController homeController = Get.find<HomeController>();
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

  late List<Widget> imageSliders = homeController.sliderData
      .map((item) => InkWell(
    onTap: () {},
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: myprimarycolor.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          children: [
            setCachedImage(homeController.sliderImgLink+item['slider_image'], 150, double.infinity, 7),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ))
      .toList();

  return Obx(() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          CarouselSlider(
            items: imageSliders,
            carouselController: homeController.controller,
            options: CarouselOptions(
              height: 150,
              viewportFraction: 0.85,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                homeController.current.value = index;
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: homeController.sliderItemListData.asMap().entries.map((entry) {
              bool isActive = homeController.current.value == entry.key;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                    colors: [myprimarycolor, myprimarycolorAccent],
                  )
                      : null,
                  color: isActive ? null : myprimarycolor.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  });
}
