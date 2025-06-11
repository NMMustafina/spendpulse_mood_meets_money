import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../models/limit.dart';
import '../models/mood_cart.dart';
import '../providers/limit_provider.dart';
import '../providers/mood_category_provider.dart';

class AddEditLimitPage extends StatefulWidget {
  final Limit? limit;

  const AddEditLimitPage({super.key, this.limit});

  @override
  State<AddEditLimitPage> createState() => _AddEditLimitPageState();
}

class _AddEditLimitPageState extends State<AddEditLimitPage> {
  final _amtCtrl = TextEditingController();
  MoodCartCategory? _selCat;
  DateTime? _selDt;
  bool _inclCurrItems = false;

  @override
  void initState() {
    super.initState();
    if (widget.limit != null) {
      _amtCtrl.text = widget.limit!.amount.toString();
      _selCat = widget.limit!.category;
      _selDt = widget.limit!.endDate;
      _inclCurrItems = widget.limit!.includeCurrentItems;
    }
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorG.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GMotiBut(
            child: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.limit == null ? 'New limit' : 'Edit limit',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              _buildLimitAmountField(),
              SizedBox(height: 16.h),
              _buildCategoryField(context),
              SizedBox(height: 16.h),
              _buildDateField(context),
              SizedBox(height: 16.h),
              _buildIncludeCurrentItemsSwitch(),
              SizedBox(height: 24.h),
              GMotiBut(
                onPressed: _saveLmt,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: (_selCat == null ||
                            _selDt == null ||
                            _amtCtrl.text.isEmpty)
                        ? Colors.grey
                        : ColorG.blueE,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: Text(
                      widget.limit == null ? 'Add limit' : 'Save changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildLimitAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit amount',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          onChanged: (value) {
            setState(() {});
          },
          controller: _amtCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
              fontSize: 14.sp,
              color: ColorG.black,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'How much are you willing to spend?',
            prefixIcon: SvgPicture.asset(
              'assets/icons/price.svg',
              fit: BoxFit.none,
              height: 24.sp,
              width: 24.sp,
            ),
            hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        GMotiBut(
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                if (_selCat != null && _selCat!.icon.isNotEmpty)
                  SvgPicture.asset(
                    _selCat!.icon,
                    height: 24.sp,
                    width: 24.sp,
                    fit: BoxFit.none,
                  ),
                SizedBox(width: 8.w),
                Text(
                  _selCat?.name ?? 'Select a limit category',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: _selCat == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          onPressed: () => _showCatPicker(context),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit end date',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        GMotiBut(
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/alarm.svg',
                  height: 24.sp,
                  width: 24.sp,
                  fit: BoxFit.none,
                ),
                SizedBox(width: 8.w),
                Text(
                  _selDt == null
                      ? 'Select a deadline'
                      : DateFormat('MMM dd, yyyy').format(_selDt!),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: _selDt == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          onPressed: () => _selectDt(context),
        ),
      ],
    );
  }

  Widget _buildIncludeCurrentItemsSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Include the value of current items',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Enable this option to include previously added purchases when calculating the remaining limit.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                CupertinoSwitch(
                  value: _inclCurrItems,
                  onChanged: (value) {
                    setState(() {
                      _inclCurrItems = value;
                    });
                  },
                  activeColor: ColorG.blueE,
                ),
              ],
            )),
      ],
    );
  }

  void _showCatPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GMotiBut(
                    child: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer2<MoodCategoryProvider, LimitProvider>(
                builder: (context, catProv, limProv, child) {
                  final cats = [
                    MoodCartCategory(
                      isCustom: false,
                      id: 0,
                      icon: 'assets/icons/all.svg',
                      name: 'All',
                    ),
                    ...catProv.categories,
                  ];

                  return ListView.builder(
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      final cat = cats[index];
                      final hasLim = limProv.hasLimitForCategory(cat);
                      final isSel = cat == _selCat;

                      return ListTile(
                        enabled: !hasLim || isSel,
                        leading: cat.icon.isNotEmpty
                            ? SvgPicture.asset(
                                cat.icon,
                                height: 24.sp,
                                width: 24.sp,
                                color: hasLim && !isSel
                                    ? Colors.grey
                                    : Colors.black,
                              )
                            : null,
                        title: Text(
                          cat.name,
                          style: TextStyle(
                            color:
                                hasLim && !isSel ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: isSel
                            ? Icon(
                                Icons.check_circle,
                                color: ColorG.blueE,
                                size: 24.sp,
                              )
                            : null,
                        onTap: hasLim && !isSel
                            ? null
                            : () {
                                setState(() {
                                  _selCat = cat;
                                });
                                Navigator.pop(context);
                              },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: GMotiBut(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: ColorG.blueE,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDt(BuildContext context) async {
    DateTime? _newselDt = _selDt;
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
                        initialDateTime: _selDt,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            _newselDt = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GMotiBut(
                      onPressed: () {
                        setState(() {
                          if (_selDt != _newselDt) {
                            _selDt = _newselDt!;
                          }
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
            ));
  }

  void _saveLmt() {
    if (_selCat == null || _selDt == null || _amtCtrl.text.isEmpty) {
      return;
    }

    final limProv = context.read<LimitProvider>();
    final lmt = Limit(
      limitId: widget.limit?.limitId ?? limProv.generateNewLimitId(),
      amount: double.parse(_amtCtrl.text),
      category: _selCat!,
      endDate: _selDt!,
      includeCurrentItems: _inclCurrItems,
      spentAmount: widget.limit?.spentAmount ?? 0,
    );

    if (widget.limit == null) {
      limProv.addLimit(lmt);
    } else {
      limProv.updateLimit(lmt);
    }

    Navigator.pop(context);
  }
}
