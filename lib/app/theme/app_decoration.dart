import 'package:church_app/app/core/app_export.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  static BoxDecoration get outlineBluegray100 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blueGray100,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get txtOutlineGray800 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.gray800,
          width: getHorizontalSize(
            2,
          ),
        ),
      );
  static BoxDecoration get txtFillGray800 => BoxDecoration(
        color: ColorConstant.gray800,
      );
  static BoxDecoration get fillGray50 => BoxDecoration(
        color: ColorConstant.gray50,
      );
  static BoxDecoration get gradientRedA200PinkA100 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.redA200,
            ColorConstant.pinkA100,
          ],
        ),
      );
  static BoxDecoration get fillTeal500 => BoxDecoration(
        color: ColorConstant.teal500,
      );
  static BoxDecoration get fillGreenA70002 => BoxDecoration(
        color: ColorConstant.greenA70002,
      );
  static BoxDecoration get outlineRedA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.redA700,
          width: getHorizontalSize(
            3,
          ),
        ),
      );
  static BoxDecoration get fillRedA70002 => BoxDecoration(
        color: ColorConstant.redA70002,
      );
  static BoxDecoration get gradientGreenA700GreenA400 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.greenA700,
            ColorConstant.greenA400,
          ],
        ),
      );
  static BoxDecoration get gradientIndigoA400IndigoA200 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.indigoA400,
            ColorConstant.indigoA200,
          ],
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get fillGray70001 => BoxDecoration(
        color: ColorConstant.gray70001,
      );
  static BoxDecoration get outlineGray100 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray100,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get gradientRed700RedA70002 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.red700,
            ColorConstant.redA70002,
          ],
        ),
      );
  static BoxDecoration get outlineGray1002 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray100,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineGray1001 => BoxDecoration(
        color: ColorConstant.deepOrange5001,
        border: Border.all(
          color: ColorConstant.gray100,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get gradientPurpleA700DeeppurpleA200 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.purpleA700,
            ColorConstant.deepPurpleA200,
          ],
        ),
      );
  static BoxDecoration get outlineBlack9000c => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get fillRed50 => BoxDecoration(
        color: ColorConstant.red50,
      );
  static BoxDecoration get gradientAmber500AmberA100 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.amber500,
            ColorConstant.amberA100,
          ],
        ),
      );
  static BoxDecoration get gradientOrangeA400OrangeA200 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            1,
            1,
          ),
          end: Alignment(
            0,
            0,
          ),
          colors: [
            ColorConstant.orangeA400,
            ColorConstant.orangeA200,
          ],
        ),
      );
  static BoxDecoration get fillGray5001 => BoxDecoration(
        color: ColorConstant.gray5001,
      );
}

class BorderRadiusStyle {
  static BorderRadius txtCircleBorder16 = BorderRadius.circular(
    getHorizontalSize(
      16,
    ),
  );

  static BorderRadius customBorderTL40 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        40,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        40,
      ),
    ),
  );

  static BorderRadius circleBorder125 = BorderRadius.circular(
    getHorizontalSize(
      125,
    ),
  );

  static BorderRadius customBorderTL32 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        32,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        32,
      ),
    ),
  );

  static BorderRadius roundedBorder16 = BorderRadius.circular(
    getHorizontalSize(
      16,
    ),
  );

  static BorderRadius roundedBorder28 = BorderRadius.circular(
    getHorizontalSize(
      28,
    ),
  );

  static BorderRadius circleBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24,
    ),
  );

  static BorderRadius roundedBorder48 = BorderRadius.circular(
    getHorizontalSize(
      48,
    ),
  );

  static BorderRadius circleBorder40 = BorderRadius.circular(
    getHorizontalSize(
      40,
    ),
  );

  static BorderRadius roundedBorder12 = BorderRadius.circular(
    getHorizontalSize(
      12,
    ),
  );

  static BorderRadius roundedBorder32 = BorderRadius.circular(
    getHorizontalSize(
      32,
    ),
  );

  static BorderRadius circleBorder80 = BorderRadius.circular(
    getHorizontalSize(
      80,
    ),
  );

  static BorderRadius circleBorder70 = BorderRadius.circular(
    getHorizontalSize(
      70,
    ),
  );

  static BorderRadius roundedBorder20 = BorderRadius.circular(
    getHorizontalSize(
      20,
    ),
  );

  static BorderRadius circleBorder92 = BorderRadius.circular(
    getHorizontalSize(
      92,
    ),
  );

  static BorderRadius customBorderTL60 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        60,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        60,
      ),
    ),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
