import 'package:chopnow/common/color_extension.dart';
import 'package:chopnow/common/loading_lottie.dart';
import 'package:chopnow/common/reusable_text_widget.dart';
import 'package:chopnow/common/size.dart';
import 'package:chopnow/controllers/login_controller.dart';
import 'package:chopnow/views/auth/reset_pin/forgot_pin_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:lottie/lottie.dart';

class LoginPinPage extends StatelessWidget {
  const LoginPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body:  Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h), // Space at the top
                      ReuseableText(
                        title: "Login PIN",
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                          color: Tcolor.Text,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ReuseableText(
                        title: "Enter your PIN to login to your account.",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: Tcolor.Text_Secondary,
                        ),
                      ),
                      SizedBox(height: 80.h), // Space between text and icon
                      Center(
                        child: SvgPicture.asset(
                          "assets/img/lock_icon.svg", // Replace with your lock icon asset
                          height: 75.h,
                          width: 75.h,
                        ),
                      ),
                      SizedBox(height: 50.h), // Space between icon and PIN input
                      Center(
                        child: Obx(
                            () => PinDots(pinLength: controller.pin.value.length)),
                      ),
                      SizedBox(height: 80.h),
                      Center(
                        child: PinPad(
                          onKeyPress: controller.handleKeyPress,
                          onClear: controller.clearPin,
                        ),
                      ),
                      SizedBox(height: 100.h), // Space at the bottom
        
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const ForgotPinPageView(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 700));
                          },
                          child: ReuseableText(
                            title: "Forgot PIN?",
                            style: TextStyle(
                              color: Tcolor.PRIMARY_S4,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                // Lottie animation overlay for loading state
                
              
              ],
            
        )
          
        ),
        // Obx(() {
        //         if (controller.isLoading) {
        //           return Positioned.fill(
        //             child: Container(
        //               color: Colors.black.withOpacity(0.5), // Dim background
        //               child: Center(
        //                 child: LottieBuilder.asset(
        //                   'assets/animation/loading_state.json', // Replace with your Lottie file path
        //                   width: 200.w,
        //                   height: 200.h,
        //                 ),
        //               ),
        //             ),
        //           );
        //         }
        //         return const SizedBox.shrink();
        //       }),
      ],
    );
  }
}

class PinDots extends StatelessWidget {
  final int pinLength;

  const PinDots({super.key, required this.pinLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 200.w,
      decoration: BoxDecoration(
        border: Border.all(color: Tcolor.BORDER_Light),
        borderRadius: BorderRadius.circular(20.r),
        color: Tcolor.BACKGROUND_Regaular,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: index < pinLength ? Tcolor.Primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Tcolor.BORDER_Regular, width: 1.5.w),
            ),
          );
        }),
      ),
    );
  }
}

class PinPad extends StatelessWidget {
  final void Function(String) onKeyPress;
  final void Function() onClear;

  const PinPad({
    super.key,
    required this.onKeyPress,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        SizedBox(height: 40.h), // Space between rows
        _buildRow(['4', '5', '6']),
        SizedBox(height: 40.h), // Space between rows
        _buildRow(['7', '8', '9']),
        SizedBox(height: 40.h), // Space between rows
        _buildRow([null, '0', HeroiconsSolid.backspace]),
      ],
    );
  }

  Widget _buildRow(List<dynamic> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        if (button == null) {
          return SizedBox(width: 118.w); // Spacer for layout
        }
        return _PinButton(
          label: button is String ? button : null,
          icon: button is IconData ? button : null,
          onPress: () {
            if (button is String) {
              onKeyPress(button);
            } else if (button == HeroiconsSolid.backspace) {
              onClear();
            }
          },
        );
      }).toList(),
    );
  }
}

class _PinButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final void Function()? onPress;

  const _PinButton({this.label, this.icon, this.onPress});

  @override
  __PinButtonState createState() => __PinButtonState();
}

class __PinButtonState extends State<_PinButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updatePressed(true),
      onTapUp: (_) => _updatePressed(false),
      onTapCancel: () => _updatePressed(false),
      onTap: widget.onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 100.h,
        width: 100.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: widget.icon == HeroiconsSolid.backspace
              ? BoxShape.rectangle
              : BoxShape.circle,
          borderRadius: widget.icon == HeroiconsSolid.backspace
              ? BorderRadius.circular(8.r)
              : null,
          color: _isPressed ? Tcolor.White.withOpacity(0.9) : Tcolor.White,
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
          border: widget.icon == HeroiconsSolid.backspace
              ? Border.all(color: Colors.transparent, width: 0)
              : Border.all(color: Tcolor.BORDER_Light, width: 1.5),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(4.w),
        child: widget.label != null
            ? ReuseableText(
                title: widget.label!,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Tcolor.Text,
                ),
              )
            : Icon(
                widget.icon,
                size: 28.sp,
                color: Tcolor.TEXT_Placeholder,
              ),
      ),
    );
  }

  void _updatePressed(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }
}
