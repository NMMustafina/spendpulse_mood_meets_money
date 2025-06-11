import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/providers/limit_provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/premasdf.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/speednapumoode.dart';

import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../models/mood_cart.dart';
import '../providers/mood_cart_provider.dart';
import '../providers/mood_category_provider.dart';

class AddEditMoodCart extends StatefulWidget {
  final MoodCart? moodCart;

  const AddEditMoodCart({super.key, this.moodCart});

  @override
  State<AddEditMoodCart> createState() => _AddEditMoodCartState();
}

class _AddEditMoodCartState extends State<AddEditMoodCart> {
  final TextEditingController _nameCntrl = TextEditingController();
  final TextEditingController _priceCntrl = TextEditingController();
  final TextEditingController _descCntrl = TextEditingController();

  Uint8List? _photoBts;
  MoodCartCategory? _selCategory;
  String _selMood = 'Neutral';
  DateTime _selDate = DateTime.now();
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    if (widget.moodCart != null) {
      _nameCntrl.text = widget.moodCart!.moodCartName;
      _priceCntrl.text = widget.moodCart!.moodCartPrice.toString();
      _descCntrl.text = widget.moodCart!.moodCartDescription;
      _photoBts = widget.moodCart!.moodCartPhoto;
      _selCategory = widget.moodCart!.moodCartCategory;
      _selMood = widget.moodCart!.firstMood.moodName;
      _selDate = widget.moodCart!.moodCartDatePurch;
    } else {
      Future.microtask(() {
        final categoryProvider = context.read<MoodCategoryProvider>();
        if (categoryProvider.categories.isNotEmpty) {
          setState(() {
            _selCategory = categoryProvider.categories.first;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCntrl.dispose();
    _priceCntrl.dispose();
    _descCntrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _photoBts = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Permission Denied'),
          content:
              const Text('Please allow access to your gallery in Settings.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
            ),
          ],
        ),
      );
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorG.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) => _buildCategorySheet(),
    );
  }

  Widget _buildCategorySheet() {
    final categoryProvider = context.watch<MoodCategoryProvider>();
    final categories = categoryProvider.categories;
    final TextEditingController customCatCntrl = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder<bool>(
          future: getSpenpulseMood(),
          builder: (context, snapshot) {
            return SafeArea(
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      padding: EdgeInsets.only(
                        top: 16.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Category',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          if (snapshot.data == false)
                            Padding(
                              padding: EdgeInsets.all(16.r),
                              child: GMotiBut(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 11.h),
                                  decoration: BoxDecoration(
                                    color: ColorG.blueE,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/corwn.svg',
                                        height: 24.h,
                                        width: 24.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Create category',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      SvgPicture.asset(
                                        'assets/icons/corwn.svg',
                                        height: 24.h,
                                        width: 24.w,
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text('Premium is required'),
                                      content: Text(
                                          'You can’t create categories without premium'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text('No'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        CupertinoDialogAction(
                                          child: Text('Premium'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Premasdf(
                                                  isAs: true,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (snapshot.data == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: customCatCntrl,
                                      maxLength: 15,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your own',
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF9A9A9A)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        contentPadding: EdgeInsets.all(12.r),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  GMotiBut(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: ColorG.blueE,
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (customCatCntrl.text.isNotEmpty) {
                                        final newId = categoryProvider
                                            .generateNewCategoryId();
                                        final newCategory = MoodCartCategory(
                                          isCustom: true,
                                          id: newId,
                                          icon: '',
                                          name: customCatCntrl.text,
                                        );
                                        categoryProvider
                                            .addOrUpdateCategory(newCategory);
                                        customCatCntrl.clear();
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          Divider(color: Colors.grey.shade300),
                          SizedBox(
                            height: 350.h,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: categories.length,
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16.h),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return Slidable(
                                  key: ValueKey(category.id),
                                  endActionPane: category.isCustom
                                      ? ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      CupertinoAlertDialog(
                                                    title: const Text(
                                                        'Delete Category'),
                                                    content: Text(
                                                        'Are you sure you want to delete "${category.name}"?'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.pop(ctx),
                                                      ),
                                                      CupertinoDialogAction(
                                                        isDestructiveAction:
                                                            true,
                                                        child: const Text(
                                                            'Delete'),
                                                        onPressed: () {
                                                          Navigator.pop(ctx);
                                                          categoryProvider
                                                              .deleteCategory(
                                                                  category.id);
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Row(
                                        children: [
                                          if (category.icon.isNotEmpty)
                                            SvgPicture.asset(
                                              category.icon,
                                              height: 24.h,
                                              width: 24.w,
                                            ),
                                          if (category.icon.isNotEmpty)
                                            SizedBox(width: 8.w),
                                          Text(category.name),
                                          const Spacer(),
                                          Radio<int>(
                                            value: category.id,
                                            groupValue: _selCategory?.id,
                                            activeColor: ColorG.blueE,
                                            onChanged: (_) {
                                              setState(() {
                                                _selCategory = category;
                                              });
                                              this.setState(() {
                                                _selCategory = category;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.r),
                            child: GMotiBut(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Select',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  void _showDatePicker() {
    DateTime? _newselDate = _selDate;
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          height: 300.h,
          decoration: BoxDecoration(
            color: ColorG.background,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  const Spacer(),
                  Text('Select a date',
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GMotiBut(
                    child: Icon(
                      Icons.clear,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selDate,
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      _newselDate = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16.h),
              GMotiBut(
                onPressed: () {
                  setState(() {
                    _selDate = _newselDate!;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: ColorG.blueE,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
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

  Future<void> _saveForm() async {
    if (_nameCntrl.text.isEmpty ||
        _priceCntrl.text.isEmpty ||
        _selCategory == null ||
        _selMood.isEmpty) {
      return;
    }

    setState(() {
      _isLoad = true;
    });

    try {
      final moodCartProvider = context.read<MoodCartProvider>();

      final mood = Mood(
        moodId: widget.moodCart?.firstMood.moodId ??
            DateTime.now().millisecondsSinceEpoch,
        moodName: _selMood,
        moodDate: _selDate,
        moodDescription: '',
      );

      final price =
          double.tryParse(_priceCntrl.text.replaceAll(',', '.')) ?? 0.0;

      final List<Mood> allMoods = widget.moodCart?.allMood != null
          ? List<Mood>.from(widget.moodCart!.allMood)
          : [];

      final index = allMoods.indexWhere((m) => m.moodId == mood.moodId);

      if (index != -1) {
        allMoods[index] = mood;
      } else {
        allMoods.add(mood);
      }

      final moodCart = MoodCart(
        moodCartId: widget.moodCart?.moodCartId ??
            DateTime.now().millisecondsSinceEpoch,
        moodCartPhoto: _photoBts,
        moodCartName: _nameCntrl.text,
        moodCartPrice: price,
        moodCartCategory: _selCategory!,
        moodCartDescription: _descCntrl.text,
        moodCartDatePurch: _selDate,
        firstMood: mood,
        allMood: allMoods,
      );

      await moodCartProvider.addOrUpdateMoodCart(moodCart);

      final limitProvider = context.read<LimitProvider>();

      if (_selCategory != null) {
        final hasLimit = limitProvider.hasLimitForCategory(_selCategory!);
        if (hasLimit) {
          await limitProvider.updateSpentAmount(
            _selCategory!,
            price.toDouble(),
          );
        }
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoad = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selCategory == null) {
      final categoryProvider = context.watch<MoodCategoryProvider>();
      if (categoryProvider.categories.isNotEmpty) {
        _selCategory = categoryProvider.categories.first;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: _buildSubmitButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text(
            widget.moodCart == null ? 'New purchase' : 'Edit purchase',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoad
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelText('Add a photo'),
                    SizedBox(height: 8.h),
                    _buildPhotoSelector(),
                    SizedBox(height: 16.h),
                    _labelText('Purchase item*'),
                    SizedBox(height: 8.h),
                    TextFf(
                      controller: _nameCntrl,
                      hintText: 'What did you buy?',
                      prefixIcon: 'assets/icons/item.svg',
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    _labelText('Purchase price*'),
                    SizedBox(height: 8.h),
                    TextFf(
                      controller: _priceCntrl,
                      hintText: 'How much did you spend?',
                      prefixIcon: 'assets/icons/price.svg',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    _labelText('Category'),
                    SizedBox(height: 8.h),
                    _buildCategorySelector(),
                    SizedBox(height: 16.h),
                    _labelText('The emotion of buying*'),
                    SizedBox(height: 8.h),
                    _buildMoodSelector(),
                    SizedBox(height: 16.h),
                    _labelText('Description'),
                    SizedBox(height: 8.h),
                    TextFf(
                      prefixIcon: '',
                      controller: _descCntrl,
                      hintText: 'Describe the details',
                      maxLines: 3,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    _labelText('Date of purchase*'),
                    SizedBox(height: 8.h),
                    _buildDateSelector(),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _labelText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPhotoSelector() {
    return GMotiBut(
      onPressed: _pickImage,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: _photoBts != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.memory(
                  _photoBts!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    color: ColorG.blueE,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GMotiBut(
      onPressed: _showCategoryPicker,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/category.svg',
              height: 20.h,
              width: 20.w,
              fit: BoxFit.none,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                _selCategory?.name ?? 'Select a category',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _selCategory != null
                      ? Colors.black
                      : const Color(0xFF9A9A9A),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMoodOption('Angry', '😠'),
          _buildMoodOption('Sad', '😔'),
          _buildMoodOption('Neutral', '😐'),
          _buildMoodOption('Joyful', '😊'),
          _buildMoodOption('Happy', '😄'),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String mood, String emoji) {
    final isSelected = _selMood == mood;

    return GMotiBut(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border:
              Border.all(color: isSelected ? ColorG.blueE : Colors.transparent),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              mood,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isSelected ? ColorG.blueE : Colors.black,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        setState(() {
          _selMood = mood;
        });
      },
    );
  }

  Widget _buildDateSelector() {
    return GMotiBut(
      onPressed: _showDatePicker,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                DateFormat('MMM dd, yyyy').format(_selDate),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GMotiBut(
      onPressed: _saveForm,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        height: 60.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: _nameCntrl.text.isEmpty ||
                  _priceCntrl.text.isEmpty ||
                  _selCategory == null ||
                  _selMood.isEmpty
              ? Colors.grey
              : ColorG.blueE,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.moodCart == null ? 'Add purchase' : 'Edit purchase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(Icons.shopping_cart, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class TextFf extends StatelessWidget {
  const TextFf({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    required this.onChanged,
  });
  final String hintText;
  final String prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9A9A9A)),
        prefixIcon: prefixIcon.isNotEmpty
            ? SvgPicture.asset(
                prefixIcon,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.none,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: ColorG.blueE),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.all(12.r),
      ),
      onChanged: onChanged,
    );
  }
}
