import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/histo_page.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/limits_page.dart';
import '../g/moti_g.dart';
import 'add_edit_mood_cart.dart';
import 'mood_cart_detail.dart';
import '../g/color_g.dart';
import '../models/mood_cart.dart';
import '../providers/mood_cart_provider.dart';
import '../providers/mood_category_provider.dart';

class Mood extends StatefulWidget {
  const Mood({super.key});

  @override
  State<Mood> createState() => _MoodState();
}

class _MoodState extends State<Mood> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Mood Cart',
          style: TextStyle(
            color: ColorG.black,
            fontWeight: FontWeight.w700,
            fontSize: 28.sp,
            height: 1.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0.w),
            child: GMotiBut(
              child: SvgPicture.asset(
                'assets/icons/siren.svg',
                height: 32.sp,
                width: 32.sp,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LimitsPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0.w),
            child: GMotiBut(
              child: SvgPicture.asset(
                'assets/icons/histor.svg',
                height: 32.sp,
                width: 32.sp,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer2<MoodCartProvider, MoodCategoryProvider>(
        builder: (context, moodCartProvider, categoryProvider, child) {
          final moodCarts = moodCartProvider.moodCarts;

          final Set<MoodCartCategory> categories = {};
          for (final gr in moodCarts) {
            categories.add(gr.moodCartCategory);
          }
          if (selectedCategory != 'All' &&
              !categories.any((element) => element.name == selectedCategory)) {
            selectedCategory == 'All';
          }

          if (moodCarts.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (categories.length >= 2)
                  _buildCategoryFilter(categories.toList()),
                _buildMoodCartsGrid(moodCarts),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
      floatingActionButton: GMotiBut(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorG.blueE,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add purchase',
                style: TextStyle(
                  color: ColorG.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.sp,
                ),
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditMoodCart(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            "You don't have any purchases",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<MoodCartCategory> categories) {
    return Container(
      height: 96.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryItem(
              isSelected: selectedCategory == 'All',
              name: 'All',
              onTap: () => setState(() => selectedCategory = 'All'),
            );
          }

          final category = categories[index - 1];
          return _buildCategoryItem(
            isSelected: selectedCategory == category.name,
            name: category.name,
            icon: category.icon,
            onTap: () => setState(() => selectedCategory = category.name),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem({
    required bool isSelected,
    required String name,
    String? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF447BFE) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF447BFE) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (name == 'All')
              SvgPicture.asset(
                'assets/icons/all.svg',
                height: 24.h,
                color: isSelected ? Colors.white : Colors.black,
              ),
            if (icon != null && icon.isNotEmpty) SizedBox(height: 4.h),
            if (icon != null && icon.isNotEmpty)
              SvgPicture.asset(
                icon,
                height: 24.h,
                color: isSelected ? Colors.white : Colors.black,
              ),
            if (icon != null && icon.isNotEmpty) SizedBox(height: 4.h),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCartsGrid(List<MoodCart> moodCarts) {
    final filteredCarts = selectedCategory == 'All'
        ? moodCarts
        : moodCarts
            .where((cart) => cart.moodCartCategory.name == selectedCategory)
            .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 16.w,
          mainAxisExtent: 210.w),
      itemCount: filteredCarts.length,
      itemBuilder: (context, index) {
        final cart = filteredCarts[index];
        return _buildMoodCartItem(cart);
      },
    );
  }

  Widget _buildMoodCartItem(MoodCart cart) {
    return GMotiBut(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodCartDetail(moodCart1: cart),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: cart.moodCartPhoto != null
                  ? Image.memory(
                      cart.moodCartPhoto!,
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/empp.png',
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 8.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.moodCartName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      getMoodIcon(cart.firstMood.moodName),
                      size: 16.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      cart.firstMood.moodName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Image.asset('assets/images/dollar.png'),
                    SizedBox(width: 4.w),
                    Text(
                      '\$${cart.moodCartPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
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
}

IconData getMoodIcon(String moodName) {
  switch (moodName.toLowerCase()) {
    case 'happy':
      return Icons.sentiment_very_satisfied;
    case 'sad':
      return Icons.sentiment_very_dissatisfied;
    case 'neutral':
      return Icons.sentiment_neutral;
    case 'angry':
      return Icons.sentiment_very_dissatisfied;
    case 'joyful':
      return Icons.sentiment_very_satisfied;
    default:
      return Icons.sentiment_neutral;
  }
}
