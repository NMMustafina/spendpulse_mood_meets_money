import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../models/mood_cart.dart';
import '../providers/mood_cart_provider.dart';
import 'add_edit_mood_cart.dart';

class MoodCartDetail extends StatefulWidget {
  final MoodCart moodCart1;

  const MoodCartDetail({super.key, required this.moodCart1});

  @override
  State<MoodCartDetail> createState() => _MoodCartDetailState();
}

class _MoodCartDetailState extends State<MoodCartDetail> {
  @override
  Widget build(BuildContext context) {
    final moodCartProvider = context.watch<MoodCartProvider>();
    final currentMood = moodCartProvider.moodCarts.firstWhereOrNull(
      (elen) => elen.moodCartId == widget.moodCart1.moodCartId,
    );
    if (currentMood == null) {
      return const Scaffold(
        body: Center(
          child: Text('No mood cart found'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GMotiBut(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My purchase',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditMoodCart(moodCart: widget.moodCart1),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context, currentMood);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.black),
                    SizedBox(width: 8.w),
                    const Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8.w),
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Purchased ${DateFormat('MMM dd, yyyy').format(currentMood.moodCartDatePurch)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              if (currentMood.moodCartPhoto != null)
                Container(
                  width: double.infinity,
                  height: 240.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    image: DecorationImage(
                      image: MemoryImage(currentMood.moodCartPhoto!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentMood.moodCartName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${currentMood.moodCartPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (currentMood.moodCartCategory.icon.isNotEmpty)
                          SvgPicture.asset(
                            currentMood.moodCartCategory.icon,
                            height: 20.h,
                            width: 20.w,
                          ),
                        if (currentMood.moodCartCategory.icon.isNotEmpty)
                          SizedBox(width: 8.w),
                        Text(
                          currentMood.moodCartCategory.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    if (currentMood.moodCartDescription.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Text(
                        currentMood.moodCartDescription,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    Text(
                      'Your feelings about the purchase:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildMoodsList(context, currentMood),
                    SizedBox(height: 16.h),
                    GMotiBut(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorG.blueE),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: ColorG.blueE, size: 24.sp),
                          ],
                        ),
                      ),
                      onPressed: () =>
                          _showAddMoodDialog(context, null, currentMood),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodsList(BuildContext context, MoodCart moodCart) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: moodCart.allMood.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final mood = moodCart.allMood[index];
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(mood.moodDate),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (index > 0)
                    PopupMenuButton<String>(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Icon(Icons.more_horiz)),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteMood(context, mood.moodId, moodCart);
                        } else if (value == 'edit') {
                          _showAddMoodDialog(context, mood, moodCart);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.black),
                              SizedBox(width: 8.w),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8.w),
                              const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'On this day, you felt',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: ColorG.blueE.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getMoodEmoji(mood.moodName),
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mood.moodName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (mood.moodDescription.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  mood.moodDescription,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getMoodEmoji(String moodName) {
    switch (moodName.toLowerCase()) {
      case 'angry':
        return '😠';
      case 'sad':
        return '😔';
      case 'neutral':
        return '😐';
      case 'joyful':
        return '😊';
      case 'happy':
        return '😄';
      default:
        return '😐';
    }
  }

  void _showAddMoodDialog(
      BuildContext context, Mood? mood, MoodCart curmoodCart) {
    String selectedMood = mood?.moodName ?? '';
    final nameCntrl = TextEditingController(text: mood?.moodDescription ?? '');
    DateTime selDate = mood?.moodDate ?? DateTime.now();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorG.background,
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        mood == null ? 'New mood' : 'Edit mood',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Your current mood',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMoodOption('Angry', '😠', selectedMood, (mood) {
                            setState(() => selectedMood = mood);
                          }),
                          _buildMoodOption('Sad', '😔', selectedMood, (mood) {
                            setState(() => selectedMood = mood);
                          }),
                          _buildMoodOption('Neutral', '😐', selectedMood,
                              (mood) {
                            setState(() => selectedMood = mood);
                          }),
                          _buildMoodOption('Joyful', '😊', selectedMood,
                              (mood) {
                            setState(() => selectedMood = mood);
                          }),
                          _buildMoodOption('Happy', '😄', selectedMood, (mood) {
                            setState(() => selectedMood = mood);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'What made the mood change?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    TextFf(
                      controller: nameCntrl,
                      hintText: 'Describe your thoughts',
                      prefixIcon: '',
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Date of change in mood',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    GMotiBut(
                      onPressed: () {
                        DateTime? newselDate = selDate;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              height: 300.h,
                              decoration: BoxDecoration(
                                color: ColorG.background,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      initialDateTime: selDate,
                                      mode: CupertinoDatePickerMode.date,
                                      maximumDate: DateTime.now(),
                                      onDateTimeChanged: (DateTime value) {
                                        setState(() {
                                          newselDate = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  GMotiBut(
                                    onPressed: () {
                                      setState(() {
                                        selDate = newselDate!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: ColorG.blueE,
                                        borderRadius:
                                            BorderRadius.circular(15.r),
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
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.grey.shade600),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                DateFormat('MMM dd, yyyy').format(selDate),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 18.sp, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GMotiBut(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color:
                              selectedMood.isEmpty ? Colors.grey : ColorG.blueE,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        if (selectedMood.isEmpty) {
                          return;
                        }
                        _addNewMood(context, selectedMood, nameCntrl.text,
                            curmoodCart, mood, selDate);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMoodOption(
    String mood,
    String emoji,
    String selectedMood,
    Function(String) onSelect,
  ) {
    final isSelected = selectedMood == mood;

    return GMotiBut(
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? ColorG.blueE : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              mood,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? ColorG.blueE : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onPressed: () => onSelect(mood),
    );
  }

  void _addNewMood(BuildContext context, String moodName, String descr,
      MoodCart curmoodCart, Mood? mood, DateTime date) {
    final moodCartProvider = context.read<MoodCartProvider>();
    final newMood = Mood(
      moodId: mood?.moodId ?? DateTime.now().millisecondsSinceEpoch,
      moodName: moodName,
      moodDate: date,
      moodDescription: descr,
    );
    if (mood != null) {
      moodCartProvider.updateMoodInCart(curmoodCart.moodCartId, newMood);
    } else {
      moodCartProvider.addMoodToCart(curmoodCart.moodCartId, newMood);
    }
    setState(() {});
  }

  void _deleteMood(BuildContext context, int moodId, MoodCart curmoodCart) {
    if (curmoodCart.allMood.length <= 1) {
      return;
    }

    final moodCartProvider = context.read<MoodCartProvider>();
    moodCartProvider.deleteMoodFromCart(curmoodCart.moodCartId, moodId);
    setState(() {});
  }

  void _showDeleteConfirmation(BuildContext context, MoodCart curmoodCart) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete item?'),
          content: const Text(
              'You will irretrievably lose all of your purchase information'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                final moodCartProvider = context.read<MoodCartProvider>();
                moodCartProvider.deleteMoodCart(curmoodCart.moodCartId);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
