import 'package:aitutorlab/cantroller/HomeController.dart';
import 'package:aitutorlab/theme/mythemcolor.dart';
import 'package:aitutorlab/ui/home/Dashboard.dart';
import 'package:aitutorlab/utils/styleUtil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constant.dart';
import '../../utils/YoutubePopupPlayer.dart';

class InfoPortfolioPage extends StatefulWidget {
  @override
  State<InfoPortfolioPage> createState() => _InfoPortfolioPageState();
}

class _InfoPortfolioPageState extends State<InfoPortfolioPage> {
  final PageController sliderController = PageController();
  final ScrollController partnerScrollController = ScrollController();

  int _current = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<String> sliderImages = [
    "https://picsum.photos/400/200?1",
    "https://picsum.photos/400/200?2",
    "https://picsum.photos/400/200?3",
  ];

  final List<Map<String, String>> videoTestimonials = [
    {
      "name": "Sarah Johnson",
      "role": "Student",
      "quote": "AI Tutor Lab transformed my learning experience!"
    },
    {
      "name": "Michael Chen",
      "role": "Educator",
      "quote": "The perfect blend of AI and personalized education."
    },
    {
      "name": "Emma Williams",
      "role": "Parent",
      "quote": "My kids love learning with AI Tutor Lab!"
    },
  ];

  final List<String> partners = [
    "https://logowik.com/content/uploads/images/google-ai-gemini91216.logowik.com.webp",
    "https://threatconnect.com/wp-content/uploads/2025/02/ChatGpt-logo-1536x452.png",
    "https://thetechblink.com/wp-content/uploads/2025/05/Claude_AI_logo.svg-1024x220.png",
    "https://1000logos.net/wp-content/uploads/2024/08/Perplexity-Logo-500x281.png",
  ];

  final List<Map<String, dynamic>> features = [
    {
      "icon": Icons.psychology_outlined,
      "title": "AI-Powered Learning",
      "description": "Personalized study paths adapted to your learning style"
    },
    {
      "icon": Icons.analytics_outlined,
      "title": "Real-Time Analytics",
      "description": "Track your progress with detailed insights"
    },
    {
      "icon": Icons.groups_outlined,
      "title": "Interactive Sessions",
      "description": "Engage with AI tutors and collaborative tools"
    },
    {
      "icon": Icons.workspace_premium_outlined,
      "title": "Premium Content",
      "description": "Access to curated educational resources"
    },
  ];

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    // Start partner auto-scroll after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 50));
      if (!partnerScrollController.hasClients) continue;

      double max = partnerScrollController.position.maxScrollExtent;
      double next = partnerScrollController.offset + 2;

      if (next >= max) {
        partnerScrollController.jumpTo(0);
      } else {
        partnerScrollController.jumpTo(next);
      }
    }
  }

  @override
  void dispose() {
    sliderController.dispose();
    partnerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = myprimarycolor;
    Color secondary = myprimarycolorAccent;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
              () {
          return SingleChildScrollView(
            child: Column(
              children: [
                _modernHeader(primary, secondary),
                _heroSection(primary, secondary),
                SizedBox(height: 40),
                _aboutUsSection(primary),
                SizedBox(height: 60),
                if(homeController.videoTestimonial.isNotEmpty)
                _sectionTitle("What Our Users Say", primary),
                if(homeController.videoTestimonial.isNotEmpty)
                SizedBox(height: 50),
                if(homeController.videoTestimonial.isNotEmpty)
                _imageSlider(),
                if(homeController.videoTestimonial.isNotEmpty)
                SizedBox(height: 60),
                _featuresGrid(primary),
                if(homeController.textTestimonial.isNotEmpty)
                SizedBox(height: 50),
                if(homeController.textTestimonial.isNotEmpty)
                _sectionTitle("What Our Users Say", primary),
                if(homeController.textTestimonial.isNotEmpty)
                SizedBox(height: 30),
                if(homeController.textTestimonial.isNotEmpty)
                _modernTestimonials(secondary, primary),
                SizedBox(height: 50),
                _sectionTitle("Powered By Leading AI", primary),
                SizedBox(height: 30),
                _partnersSmoothScroll(),
                SizedBox(height: 40),
                _modernFooter(primary),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _modernHeader(Color primary, Color secondary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            secondary.withOpacity(0.25),
            primary.withOpacity(0.25),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 40,
                    height: 40,
                    color: primary,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "AI TUTOR LAB",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "Smart Education",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroSection(Color primary, Color secondary) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, secondary],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 50, color: Colors.white),
          SizedBox(height: 15),
          Text(
            "Master AI Tools & ChatGPT Skills \n-Just One Free Workshop!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Experience the future of education with personalized AI tutoring",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: _glassButton("Get Started", Colors.white, primary, () {
                  Get.to(
                        () => Dashboard(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 600),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glassButton(String text, Color bgColor, Color textColor,
      VoidCallback? onTap, {bool isOutlined = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : bgColor,
            border: isOutlined ? Border.all(color: Colors.white, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _featuresGrid(Color primary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _sectionTitle("Why Choose Us", primary),
          SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _featureCard(
                features[index]["icon"],
                features[index]["title"],
                features[index]["description"],
                primary,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc, Color primary) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 32, color: primary),
          ),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSlider() {
    final List<Widget> imageSliders = homeController.videoTestimonial.asMap().entries.map((entry) {
      final testimonial = entry.value;
      return InkWell(
        onTap: (){
          YoutubePopupPlayer.show(
            context,
            testimonial["testimonial_link"],
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              alignment: AlignmentGeometry.center,
              children: [
                setCachedImage(homeController.testimonialImgLink.value+testimonial["testimonial_image"], 120, MediaQuery.of(context).size.width - 30, 0),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: myprimarycolor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Featured",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "AI-Powered Education ${entry.key + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 50,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 350,
            viewportFraction: 0.72,
            enlargeCenterPage: true,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInOutCubic,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderImages.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _current == entry.key ? 24.0 : 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _current == entry.key ? myprimarycolor : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _aboutUsSection(Color primary) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white38,
        image: DecorationImage(
          image: NetworkImage(
            homeController.settingData["aboutus_img"] ?? "https://wpriverthemes.com/aveit/wp-content/uploads/2022/04/21-sub.png",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.75),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.school_outlined, size: 40, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            homeController.settingData["aboutus_title"] ?? "About AI Tutor Lab",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            homeController.settingData["aboutus_desc"] ?? "AI Tutor Lab brings future-ready learning experiences using advanced artificial intelligence, personalized study solutions, real-time analytics, and interactive learning systems. Our goal is to make education smarter, easier, and more engaging for students worldwide.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernTestimonials(Color primary, Color accent) {
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: homeController.textTestimonial.length,
        itemBuilder: (context, index) {
          final item = homeController.textTestimonial[index];
          return Container(
            width: 260,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.15),
                  blurRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                    setCachedImage(homeController.testimonialImgLink.value+item["testimonial_image"], 60, 60, 180),
                  ),
                  SizedBox(height: 20),
                  Text(
                    item["testimonial_designation"] ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 1,
                    width: 60,
                    color: primary.withOpacity(0.3),
                  ),
                  SizedBox(height: 15),
                  Text(
                    item["testimonial_name"] ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  _ratingCard(double.parse("${item["testimonial_rating"] ?? "5.0"}")),
                  SizedBox(height: 4),
                  Text(
                    videoTestimonials[index]["role"]!,
                    style: TextStyle(
                      fontSize: 13,
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, Color primary) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 4,
          width: 10.0 * title.length,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, myprimarycolorAccent],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _ratingCard(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingStars(
          axis: Axis.horizontal,
          value: value,
          onValueChanged: (v) {
            //

          },
          starCount: 5,
          starSize: 10,
          valueLabelRadius: 10,
          maxValue: 5,
          starSpacing: 3,
          maxValueVisibility: true,
          valueLabelVisibility: false,
          animationDuration: Duration(
            milliseconds: 1000,
          ),
          valueLabelPadding: const EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 8,
          ),
          valueLabelMargin: const EdgeInsets.only(
            right: 8,
          ),
          starOffColor: const Color(0xffe7e8ea),
          starColor: const Color(0XFFf8b81f),
          angle: 0,
        ),
      ],
    );
  }

  Widget _partnersSmoothScroll() {
    final extendedList = List.generate(
      40,
          (index) => partners[index % partners.length],
    );

    return Container(
      height: 70,
      child: ListView.builder(
        controller: partnerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: extendedList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: setCachedImageOt(extendedList[index], 70, 140, 10),
          );
        },
      ),
    );
  }

  Widget _modernFooter(Color primary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              "assets/images/logo.png",
              width: 50,
              height: 50,
              color: primary,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "AI Tutor Lab",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Innovating Education With Intelligence",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(homeController.settingData["facebook_url"] != null)
              InkWell(
                onTap: (){
                  openWhatsApp(homeController.settingData["facebook_url"] ?? "#");
                },
                  child: _socialIcon(Icons.facebook, primary)
              ),
              if(homeController.settingData["admin_support_email"] != null)
              SizedBox(width: 15),
              if(homeController.settingData["admin_support_email"] != null)
              InkWell(
                onTap: () async {
                  String email = Uri.encodeComponent(homeController.settingData["admin_support_email"] ?? "#");
                  Uri mail = Uri.parse("mailto:$email");
                  if (await launchUrl(mail)) {
                  //email app opened
                  }else{
                  //email app is not opened
                  }
                },
                  child: _socialIcon(Icons.email_outlined, primary)
              ),
              if(homeController.settingData["admin_support_mobile"] != null)
                SizedBox(width: 15),
              if(homeController.settingData["admin_support_mobile"] != null)
              InkWell(
                  onTap: () async {
                    String email = Uri.encodeComponent(homeController.settingData["admin_support_mobile"] ?? "#");
                    Uri mail = Uri.parse("tel:$email");
                    if (await launchUrl(mail)) {
                    //email app opened
                    }else{
                    //email app is not opened
                    }
                  },
                  child: _socialIcon(Icons.call_outlined, primary)
              ),
              if(homeController.settingData["site_address"] != null)
                SizedBox(width: 15),
              if(homeController.settingData["site_address"] != null)
              InkWell(
                  onTap: (){
                    openWhatsApp(homeController.settingData["site_address"] ?? "#");
                  },
                  child: _socialIcon(Icons.language, primary)
              ),
            ],
          ),
          SizedBox(height: 25),
          Container(
            height: 1,
            width: 100,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 20),
          Text(
            "© 2025 AI Tutor Lab. All Rights Reserved",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color primary) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: primary),
    );
  }
}



/*
import 'dart:async';
import 'package:aitutorlab/theme/mythemcolor.dart';
import 'package:aitutorlab/ui/home/Dashboard.dart';
import 'package:aitutorlab/utils/styleUtil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoPortfolioPage extends StatefulWidget {
  @override
  State<InfoPortfolioPage> createState() => _InfoPortfolioPageState();
}

class _InfoPortfolioPageState extends State<InfoPortfolioPage> with TickerProviderStateMixin {
  final PageController sliderController = PageController();
  final ScrollController partnerScrollController = ScrollController();
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _current = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<String> sliderImages = [
    "https://picsum.photos/400/200?1",
    "https://picsum.photos/400/200?2",
    "https://picsum.photos/400/200?3",
  ];

  final List<Map<String, String>> videoTestimonials = [
    {
      "name": "Sarah Johnson",
      "role": "Student",
      "quote": "AI Tutor Lab transformed my learning experience!"
    },
    {
      "name": "Michael Chen",
      "role": "Educator",
      "quote": "The perfect blend of AI and personalized education."
    },
    {
      "name": "Emma Williams",
      "role": "Parent",
      "quote": "My kids love learning with AI Tutor Lab!"
    },
  ];

  final List<String> partners = [
    "https://logowik.com/content/uploads/images/google-ai-gemini91216.logowik.com.webp",
    "https://threatconnect.com/wp-content/uploads/2025/02/ChatGpt-logo-1536x452.png",
    "https://thetechblink.com/wp-content/uploads/2025/05/Claude_AI_logo.svg-1024x220.png",
    "https://1000logos.net/wp-content/uploads/2024/08/Perplexity-Logo-500x281.png",
  ];

  final List<Map<String, dynamic>> features = [
    {
      "icon": Icons.psychology_outlined,
      "title": "AI-Powered Learning",
      "description": "Personalized study paths adapted to your learning style"
    },
    {
      "icon": Icons.analytics_outlined,
      "title": "Real-Time Analytics",
      "description": "Track your progress with detailed insights"
    },
    {
      "icon": Icons.groups_outlined,
      "title": "Interactive Sessions",
      "description": "Engage with AI tutors and collaborative tools"
    },
    {
      "icon": Icons.workspace_premium_outlined,
      "title": "Premium Content",
      "description": "Access to curated educational resources"
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    // Smooth auto slider
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!sliderController.hasClients) return;
      final nextPage = (sliderController.page ?? 0).round() + 1;
      sliderController.animateToPage(
        nextPage % sliderImages.length,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 50));
      if (!partnerScrollController.hasClients) continue;

      double max = partnerScrollController.position.maxScrollExtent;
      double next = partnerScrollController.offset + 2;

      if (next >= max) {
        partnerScrollController.jumpTo(0);
      } else {
        partnerScrollController.jumpTo(next);
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    sliderController.dispose();
    partnerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = myprimarycolor;
    Color secondary = myprimarycolorAccent;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _modernHeader(primary, secondary),
            _heroSection(primary, secondary),
            SizedBox(height: 40),
            _aboutUsSection(primary),
            SizedBox(height: 60),
            _sectionTitle("What Our Users Say", primary),
            SizedBox(height: 50),
            _imageSlider(),
            SizedBox(height: 60),
            _featuresGrid(primary),
            SizedBox(height: 50),
            _sectionTitle("What Our Users Say", primary),
            SizedBox(height: 30),
            _modernTestimonials(secondary, primary),
            SizedBox(height: 50),
            _sectionTitle("Powered By Leading AI", primary),
            SizedBox(height: 30),
            _partnersSmoothScroll(),
            SizedBox(height: 40),
            _modernFooter(primary),
          ],
        ),
      ),
    );
  }

  Widget _modernHeader(Color primary, Color secondary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            secondary.withOpacity(0.25),
            primary.withOpacity(0.25),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 40,
                      height: 40,
                      color: primary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "AI TUTOR LAB",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        "Smart Education",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroSection(Color primary, Color secondary) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, secondary],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Icon(Icons.auto_awesome, size: 50, color: Colors.white),
            SizedBox(height: 15),
            Text(
              // "Transform Your Learning\nWith AI",
              "Master AI Tools & ChatGPT Skills \n-Just One Free Workshop!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Experience the future of education with personalized AI tutoring",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: _glassButton("Get Started", Colors.white, primary, () {
                    Get.to(
                          () => Dashboard(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 600),
                    );
                  }),
                ),
               */
/* SizedBox(width: 12),
                Expanded(
                  child: _glassButton("Learn More", Colors.white.withOpacity(0.2),
                      Colors.white, null, isOutlined: true),
                ),*//*

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassButton(String text, Color bgColor, Color textColor,
      VoidCallback? onTap, {bool isOutlined = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : bgColor,
            border: isOutlined ? Border.all(color: Colors.white, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _featuresGrid(Color primary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _sectionTitle("Why Choose Us", primary),
          SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _featureCard(
                features[index]["icon"],
                features[index]["title"],
                features[index]["description"],
                primary,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc, Color primary) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 32, color: primary),
          ),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSlider() {
    final List<Widget> imageSliders = sliderImages.asMap().entries.map((entry) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image.network(entry.value, fit: BoxFit.cover),
              setCachedImage(entry.value, 120, MediaQuery.of(context).size.width-30, 0),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: myprimarycolor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Featured",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "AI-Powered Education ${entry.key + 1}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 350,
            viewportFraction: 0.72,
            enlargeCenterPage: true,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInOutCubic,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderImages.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _current == entry.key ? 24.0 : 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _current == entry.key ? myprimarycolor : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _aboutUsSection(Color primary) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
            "https://wpriverthemes.com/aveit/wp-content/uploads/2022/04/21-sub.png",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.75),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.school_outlined, size: 40, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "About AI Tutor Lab",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "AI Tutor Lab brings future-ready learning experiences using advanced artificial intelligence, personalized study solutions, real-time analytics, and interactive learning systems. Our goal is to make education smarter, easier, and more engaging for students worldwide.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernTestimonials(Color primary, Color accent) {
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: videoTestimonials.length,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.15),
                  blurRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.format_quote, size: 40, color: primary),
                  ),
                  SizedBox(height: 20),
                  Text(
                    videoTestimonials[index]["quote"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 1,
                    width: 60,
                    color: primary.withOpacity(0.3),
                  ),
                  SizedBox(height: 15),
                  Text(
                    videoTestimonials[index]["name"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    videoTestimonials[index]["role"]!,
                    style: TextStyle(
                      fontSize: 13,
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, Color primary) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 4,
          width: 10.0 * title.length,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, myprimarycolorAccent],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _partnersSmoothScroll() {
    final extendedList = List.generate(
      40,
          (index) => partners[index % partners.length],
    );

    return Container(
      height: 70,
      child: ListView.builder(
        controller: partnerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: extendedList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: setCachedImageOt(extendedList[index], 70, 140, 10),
          );
        },
      ),
    );
  }

  Widget _modernFooter(Color primary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              "assets/images/logo.png",
              width: 50,
              height: 50,
              color: primary,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "AI Tutor Lab",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Innovating Education With Intelligence",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook, primary),
              SizedBox(width: 15),
              _socialIcon(Icons.email_outlined, primary),
              SizedBox(width: 15),
              _socialIcon(Icons.call_outlined, primary),
              SizedBox(width: 15),
              _socialIcon(Icons.language, primary),
            ],
          ),
          SizedBox(height: 25),
          Container(
            height: 1,
            width: 100,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 20),
          Text(
            "© 2025 AI Tutor Lab. All Rights Reserved",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color primary) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: primary),
    );
  }
}*/
