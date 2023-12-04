import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:church_app/app/core/app_export.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.errorText,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.onChanged,
    this.labelText,
    this.helperText,
    this.onFieldSubmitted,
    this.cursorColor,
  });

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;
  String? errorText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  String? labelText;
  String? helperText;
  ValueSetter<String>? onFieldSubmitted;
  Color? cursorColor;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
        cursorColor: cursorColor ?? Colors.black,
        onFieldSubmitted: (value) {
          if (onFieldSubmitted != null) {
            onFieldSubmitted!(value);
          }
          focusNode?.unfocus();
          // Close the keyboard
        },
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      errorText: errorText ?? "",
      errorStyle: const TextStyle(color: Colors.white),
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      labelText: labelText,
      helperText: helperText,
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.UrbanistRegular14Gray500:
        return TextStyle(
          color: Colors.black,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.21,
          ),
        );
      default:
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
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            16.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      default:
        return Colors.white;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT21_1:
        return getPadding(
          top: 21,
          bottom: 21,
        );
      case TextFormFieldPadding.PaddingT18_1:
        return getPadding(
          left: 19,
          top: 19,
          bottom: 19,
        );
      case TextFormFieldPadding.PaddingT21:
        return getPadding(
          top: 19,
          right: 19,
          bottom: 19,
        );
      case TextFormFieldPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      default:
        return getPadding(
          all: 10,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder16,
}

enum TextFormFieldPadding {
  PaddingT21_1,
  PaddingAll18,
  PaddingT18_1,
  PaddingT21,
  PaddingAll6,
}

enum TextFormFieldVariant {
  None,
  FillGray50,
}

enum TextFormFieldFontStyle {
  UrbanistSemiBold14Gray900,
  UrbanistRegular14Gray500,
}
