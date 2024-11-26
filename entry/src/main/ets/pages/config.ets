export class KLineConfig {
  static _instance: KLineConfig;

  static get instance() {
    return KLineConfig._instance ??= new KLineConfig()
  }

  offsetRightDistance = 80
  // todo: k线配置
  kLineBgColor = 0xFF171929;
  kLineMarginTop = 30;
  kLineMarginRight = 0;
  kLineMarginLeft = 0;
  kLineMarginBottom = 0;
  ///grid配置
  gridLineColor = 0xff263347;
  gridLineWidth = 1.0;
  gridTopRowLength = 5;
  gridBottomRowLength = 2;
  gridColumnLength = 6;
  gridTextColor = 0xff7287A5;
  gridTextFs = 11;
  ///烛台的配置
  kLineCandleGap = 2;
  kLineCandlerWidth = 7;
  kLineCandleIncreaseColor = 0xFF16D5A8;
  kLineCandleDecreaseColor = 0xFFFF3B71;
  kLineCandleLineWidth = 1.0;
  kLineGap = 10
}