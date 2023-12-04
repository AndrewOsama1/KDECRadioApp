import 'package:church_app/app/core/app_export.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  ButtonShape? shape;

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingT18:
        return getPadding(
          left: 16,
          top: 18,
          right: 16,
          bottom: 18,
        );
      case ButtonPadding.PaddingT19:
        return getPadding(
          top: 20,
          right: 20,
          bottom: 20,
        );
      case ButtonPadding.PaddingT9:
        return getPadding(
          top: 11,
          right: 11,
          bottom: 11,
        );
      case ButtonPadding.PaddingAll11:
        return getPadding(
          all: 11,
        );
      case ButtonPadding.PaddingAll19:
        return getPadding(
          all: 19,
        );
      default:
        return getPadding(
          all: 7,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineBluegray100:
        return Colors.blue;
      case ButtonVariant.FillGray80002:
        return Colors.blue;
      case ButtonVariant.FillWhiteA700:
        return Colors.blue;
      case ButtonVariant.OutlineGray800:
      case ButtonVariant.OutlineGray80002:
        return null;
      default:
        return Colors.blue;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineBluegray100:
        return BorderSide(
          color: Colors.blue,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray800:
        return BorderSide(
          color: Colors.white,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineGray80002:
        return BorderSide(
          color: Colors.blue,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.FillGray800:
      case ButtonVariant.FillGray80002:
      case ButtonVariant.FillWhiteA700:
        return null;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder16:
        return BorderRadius.circular(
          getHorizontalSize(
            16.00,
          ),
        );
      case ButtonShape.RoundedBorder22:
        return BorderRadius.circular(
          getHorizontalSize(
            22.00,
          ),
        );
      case ButtonShape.CircleBorder19:
        return BorderRadius.circular(
          getHorizontalSize(
            19.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            29.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.UrbanistSemiBold14WhiteA700:
        return TextStyle(
          color: variant == ButtonVariant.FillWhiteA700
              ? Colors.black
              : ColorConstant.whiteA700,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold16Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.25,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold16Gray800_1:
        return TextStyle(
          color: ColorConstant.gray800,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.38,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14Gray800_1:
        return TextStyle(
          color: ColorConstant.gray800,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold18WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.22,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold16WhiteA700_1:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.25,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14RedA70002_1:
        return TextStyle(
          color: ColorConstant.redA70002,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold16Gray80002_1:
        return TextStyle(
          color: ColorConstant.gray80002,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.38,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold18Gray80002_1:
        return TextStyle(
          color: ColorConstant.gray80002,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.22,
          ),
        );
      default:
        return TextStyle(
          color: Colors.white,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'ArabicSukar',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.38,
          ),
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder16,
  CircleBorder29,
  RoundedBorder22,
  CircleBorder19,
}

enum ButtonPadding {
  PaddingAll7,
  PaddingT18,
  PaddingT19,
  PaddingT9,
  PaddingAll11,
  PaddingAll19,
}

enum ButtonVariant {
  FillGray800,
  OutlineBluegray100,
  OutlineGray800,
  FillGray80002,
  OutlineGray80002,
  FillWhiteA700,
}

enum ButtonFontStyle {
  UrbanistSemiBold14WhiteA700,
  UrbanistRomanBold16WhiteA700,
  UrbanistSemiBold16Gray900,
  UrbanistRomanBold16Gray800_1,
  UrbanistSemiBold14Gray800_1,
  UrbanistRomanBold18WhiteA700,
  UrbanistSemiBold16WhiteA700_1,
  UrbanistSemiBold14RedA70002_1,
  UrbanistRomanBold16Gray80002_1,
  UrbanistRomanBold18Gray80002_1,
}
