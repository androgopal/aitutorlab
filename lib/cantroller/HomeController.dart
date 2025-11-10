import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var bottomTabIndex = 0.obs;

  // Change bottom tab index
  void changeTabIndex(int index) {
    bottomTabIndex.value = index;
  }

  // Slider, Category & Product static data
  var sliderImagePath = "https://dummyimage.com/600x300/000/fff&text=" .obs;
  var sliderItemListData = <Map<String, dynamic>>[].obs;
  var categoryListData = <CategoryModel>[].obs;
  var productListData = <ProductModel>[].obs;

  String getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat("MMM d, yyyy").format(now);
  }

  @override
  void onInit() {
    super.onInit();
    _initPackageInfo();
    loadStaticData(); // load dummy data
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  var cartItemCount = "".obs;

  final CarouselSliderController controller = CarouselSliderController();
  var current = 0.obs;
  /// ✅ Load dummy static data
  void loadStaticData() {
    isLoading(true);

    // --- Slider Data ---
    sliderItemListData.value = [
      {"slider_image": "https://template.canva.com/EAFBMfxEyos/2/0/1600w-gZYZmuvUqqA.jpg"},
      {"slider_image": "https://template.canva.com/EAEtXehB_8s/1/0/1600w-rFsB6UcFEJ0.jpg"},
      {"slider_image": "https://template.canva.com/EAGgKUHmxU0/2/0/1600w-TSLkiNHZcuo.jpg"},
      {"slider_image": "https://template.canva.com/EAEKdZM_DU0/2/0/1600w-lBsmvpwECL4.jpg"},
    ];

    // --- Category Data ---
    categoryListData.value = [
      CategoryModel(catId: 1, catName: "Fiction"),
      CategoryModel(catId: 2, catName: "Science"),
      CategoryModel(catId: 3, catName: "History"),
      CategoryModel(catId: 4, catName: "Comics"),
      CategoryModel(catId: 5, catName: "Kids"),
      CategoryModel(catId: 6, catName: "Technology"),
    ];

    // --- Product Data ---
    productListData.value = [
      ProductModel(
        productId: 101,
        productName: "Flutter for Beginners",
        productImage: "https://aalimsirkiclass.com/wp-content/uploads/2023/12/CP114-Matric-and-Metric.png",
        productEbookPrice: "399",
        productEbookSellingPrice: "299",
        productEbookDiscount: "25",
        productPhySellingPrice: "499",
        productPhyDiscount: "15",
      ),
      ProductModel(
        productId: 102,
        productName: "Advanced Dart",
        productImage: "https://aalimsirkiclass.com/wp-content/uploads/2023/12/CP114-Matric-and-Metric.png",
        productEbookPrice: "299",
        productEbookSellingPrice: "199",
        productEbookDiscount: "30",
        productPhySellingPrice: "399",
        productPhyDiscount: "20",
      ),
      ProductModel(
        productId: 103,
        productName: "History of Space",
        productImage: "https://aalimsirkiclass.com/wp-content/uploads/2023/12/CP114-Matric-and-Metric.png",
        productEbookPrice: "499",
        productEbookSellingPrice: "349",
        productEbookDiscount: "30",
        productPhySellingPrice: "599",
        productPhyDiscount: "25",
      ),
      ProductModel(
        productId: 104,
        productName: "Machine Learning 101",
        productImage: "https://aalimsirkiclass.com/wp-content/uploads/2023/12/CP114-Matric-and-Metric.png",
        productEbookPrice: "699",
        productEbookSellingPrice: "549",
        productEbookDiscount: "20",
        productPhySellingPrice: "799",
        productPhyDiscount: "15",
      ),
    ];

    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading(false);
    });
  }
}

// -------------------
// Category Model
// -------------------
class CategoryModel {
  final int? catId;
  final String? catName;

  CategoryModel({this.catId, this.catName});
}

// -------------------
// Product Model
// -------------------
class ProductModel {
  final int? productId;
  final String? productName;
  final String? productImage;
  final String? productEbookPrice;
  final String? productEbookSellingPrice;
  final String? productEbookDiscount;
  final String? productPhySellingPrice;
  final String? productPhyDiscount;

  ProductModel({
    this.productId,
    this.productName,
    this.productImage,
    this.productEbookPrice,
    this.productEbookSellingPrice,
    this.productEbookDiscount,
    this.productPhySellingPrice,
    this.productPhyDiscount,
  });
}
