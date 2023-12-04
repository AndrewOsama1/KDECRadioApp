import 'package:church_app/app/core/app_export.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  SaveButton(
      {this.shape,
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

  ButtonPadding2? padding;

  ButtonVariant2? variant;

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
        width ?? getHorizontalSize(40),
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
      case ButtonPadding2.PaddingT18:
        return getPadding(
          left: 16,
          top: 18,
          right: 16,
          bottom: 18,
        );
      case ButtonPadding2.PaddingT19:
        return getPadding(
          top: 20,
          right: 20,
          bottom: 20,
        );
      case ButtonPadding2.PaddingT9:
        return getPadding(
          top: 11,
          right: 11,
          bottom: 11,
        );
      case ButtonPadding2.PaddingAll11:
        return getPadding(
          all: 11,
        );
      case ButtonPadding2.PaddingAll19:
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
      case ButtonVariant2.OutlineBluegray155:
        return Colors.white;
      case ButtonVariant2.FillGray85552:
        return Colors.white;
      case ButtonVariant2.FillWhiteA755:
        return Colors.white;
      case ButtonVariant2.OutlineGray855:
      case ButtonVariant2.OutlineGray85552:
        return null;
      default:
        return Colors.white;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant2.OutlineBluegray155:
        return BorderSide(
          color: Colors.white,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant2.OutlineGray855:
        return BorderSide(
          color: Colors.white,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant2.OutlineGray85552:
        return BorderSide(
          color: Colors.white,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant2.FillGray855:
      case ButtonVariant2.FillGray85552:
      case ButtonVariant2.FillWhiteA755:
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
            10.00,
          ),
        );
      case ButtonShape.RoundedBorder22:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
      case ButtonShape.CircleBorder19:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.UrbanistSemiBold14WhiteA700:
        return TextStyle(
          color: variant == ButtonVariant2.FillWhiteA755
              ? Colors.black
              : ColorConstant.whiteA700,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14WhiteA700:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold16Gray900:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.25,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold16Gray800_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.38,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14Gray800_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold18WhiteA700:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.22,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold16WhiteA700_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.25,
          ),
        );
      case ButtonFontStyle.UrbanistSemiBold14RedA70002_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold16Gray80002_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.38,
          ),
        );
      case ButtonFontStyle.UrbanistRomanBold18Gray80002_1:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.22,
          ),
        );
      default:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Urbanist',
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

enum ButtonPadding2 {
  PaddingAll7,
  PaddingT18,
  PaddingT19,
  PaddingT9,
  PaddingAll11,
  PaddingAll19,
}

enum ButtonVariant2 {
  FillGray855,
  OutlineBluegray155,
  OutlineGray855,
  FillGray85552,
  OutlineGray85552,
  FillWhiteA755,
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
