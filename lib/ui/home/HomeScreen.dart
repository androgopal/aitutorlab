import 'package:aitutorlab/cantroller/HomeController.dart';
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
          ),
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
                            "Hey, Gk Kumawat! 👋",
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
          _buildTestScheduleSection(isDarkTheme),
          const SizedBox(height: 20),
          catVeiw(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTestScheduleSection(bool isDarkTheme) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
                "Test Schedule",
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
            itemCount: testList.length,
            itemBuilder: (context, index) {
              final item = testList[index];

              // ✅ Auto color gradient based on odd/even
              final gradientColors = index.isOdd
                  ? [Colors.blue.shade400, Colors.blue.shade600]   // odd
                  : [Colors.purple.shade400, Colors.purple.shade600]; // even

              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: _buildTestCard(
                  item["title"],
                  item["subtitle"],
                  item["icon"],
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

  Widget _buildTestCard(String title, String subtitle, IconData icon,
      List<Color> gradientColors, bool isDarkTheme) {
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
                child: Icon(icon, color: Colors.white, size: 20),
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
            itemCount: mainCats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: screenHeight < 825 ? 0.95 : 1.1,
            ),
            itemBuilder: (context, index) {
              final item = mainCats[index];
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
                          title: item.catName ?? '',
                          subtitle: "20 Lessons",
                          icon: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFH3NcMTzwqPd8jJfz_UihpQvdqtdnQQ8dhfS_anEM9nkifTxdAgDHP-OFLFViHP2Avt0&usqp=CAU",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),

        if (homeController.productListData.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionHeader("Popular Lessons", () {
            // Get.to(() => AllProductScreen());
          }),
          const SizedBox(height: 12),
          Obx(() {
            final products = homeController.productListData ?? [];
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
                        borderRadius: BorderRadius.circular(7),
                        child: Stack(
                          children: [
                            setCachedImage(
                              product.productImage,
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
    return Column(
      children: [
        sliderView(context),
      ],
    );
  }
}

Widget sliderView(BuildContext context) {
  HomeController homeController = Get.find<HomeController>();
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

  late List<Widget> imageSliders = homeController.sliderItemListData
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
            setCachedImage(item['slider_image'], 150, double.infinity, 7),
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

/*
import 'package:aitutorlab/cantroller/HomeController.dart';
import 'package:aitutorlab/utils/AppBars.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    // ✅ You can place initialization logic here (like theme or data loading)
    // Example: setStatusBarTheme(context);
  }

  @override
  void dispose() {
    // ✅ Clean up any controllers or listeners here if added later
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: myStatusBarNew(context),
      body: SafeArea(
        child: AppBackground(
          child: Padding(
            padding: const EdgeInsets.all(.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                          color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                          blurRadius: 4,
                          offset: Offset(1, 1)
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "Hey, Gk Kumawat!",
                              style: textTheme.titleMedium?.copyWith(
                                color: myprimarycolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "What do you wanna learn today?",
                              style: textTheme.titleMedium?.copyWith(
                                color: myprimarycolor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          // onInviteFriends();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Image.asset( "assets/images/notification.png",
                            height: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 10,),
                      const HeaderSection(),
                      const SizedBox(height: 10),
                      */
/*Expanded(
                        child: ListView(
                          children: [*//*

                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                  top:BorderSide(color: myprimarycolorAccent, width: 2)
                              )
                          ),
                          child: mainWidget()
                      ),
                      */
/*],
                        ),
                      )*//*

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainWidget(){
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 12),
        // --- Test Schedule ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Test Schedule",
            style: textTheme.titleMedium?.copyWith(
              color: myprimarycolorAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 0)
                        )
                      ],
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                          bottom:BorderSide(color: CommonColor.lightCardColor.withOpacity(0.5), width: 2)
                      )
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "English Test",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Spoken • 5Hr",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 0)
                        )
                      ],
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                          bottom:BorderSide(color: CommonColor.lightCardColor.withOpacity(0.5), width: 2)
                      )
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Math Exam",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Math Test • 2 Days",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        catVeiw(),
        const SizedBox(height: 25),
        const SizedBox(height: 25),
      ],
    );
  }


  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = homeController.categoryListData;
    if (homeController.categoryListData.isEmpty) {
      return apiLoader(); // Or your loader
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: myprimarycolorAccent),
                  ),
                  InkWell(
                    onTap: (){
                      // Get.to(()=> AllCatgoryScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "View all",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: myprimarycolorAccent, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // Prevent internal scrolling
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                itemCount: mainCats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: screenHeight < 825 ? 1.0 : 1.15,
                ),
                itemBuilder: (context, index) {
                  final item = mainCats[index];
                  return InkWell(
                    onTap: (){
                      // Get.to(()=> SubCatWishScreen(catId: item.catId.toString(), title: item.catName,));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CategoryCard(
                            title: item.catName ?? '',
                            subtitle: "20 Lessons",
                            icon: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFH3NcMTzwqPd8jJfz_UihpQvdqtdnQQ8dhfS_anEM9nkifTxdAgDHP-OFLFViHP2Avt0&usqp=CAU"),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),

        if(homeController.productListData.isNotEmpty)
          SizedBox(height: 10,),
        if(homeController.productListData.isNotEmpty)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Popular Lessons",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            color: myprimarycolorAccent
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // Get.to(()=> AllProductScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "View all",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: myprimarycolorAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final products = homeController.productListData ?? [];
                return SizedBox(
                  height: screenWidth > 400 ? 205 : 195,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: (){
                              // Get.to(()=> ProductDetailScreen(pId : product.productId.toString()));
                            },
                            child: Container(
                              width: screenWidth > 400 ? 190 : 180,
                              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(-0.5, 0)
                                    )
                                  ],
                                  border: Border(
                                      bottom:BorderSide(color: Colors.white, width: 2)
                                  )
                              ),
                              child: setCachedImage(product.productImage, screenWidth > 400 ? 190 : 180, screenWidth > 400 ? 190 : 170, 12),
                            ),
                          ),
                          if(index == products.length-1)
                            const SizedBox(width: 10,),
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

}


class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width/2.2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border(
              bottom:BorderSide(color: CommonColor.lightCardColor.withOpacity(0.5), width: 2)
          ),
          boxShadow: [
            BoxShadow(
                color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 0)
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(icon, size: 40),
            setCachedImage(icon, 110, double.infinity, 10),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}



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
*/
