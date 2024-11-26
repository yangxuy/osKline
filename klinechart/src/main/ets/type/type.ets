import { DeepPartial } from "./extention"
import { ValueType } from "@kit.ArkData"

export interface ControllerOptions {
  locale?: string
  styles?: KLineStyles | string
}

export interface Vector2d {
  x: number
  y: number
}

export interface KLineNode {
  colorKey: string
  x?: number
  y?: number
  width?: number
  height?: number
}

export interface NodeExtention {
  averagePriceHeight: number
  averageVolHeight: number
  maxVol: number
  maxPrice: number
  minPrice: number
  kLineVisibleList: KLineVisibleData[]
  kLineData: KLineData[]
  onScrollX: (distance: number) => void
}

export interface LayerOptions {
  width: number
  height: number
  offset?: number,
  style: DeepPartial<KLineStyles>,
  controller: NodeExtention
  hit?: boolean
}

export interface KLineData extends Record<string, ESObject> {
  id: number
  open: number
  high: number
  low: number
  close: number
  vol: number
  time?: string
}

export interface KLineVisibleData {
  index: number
  idx: number
  data: Nullable<KLineData>
}

export interface KLineVisibleMaxAndMin {
  index: number
  value: number,
}

export const defaultMaxAndMin: KLineVisibleMaxAndMin[] = [
  {
    index: 0,
    value: Number.MIN_SAFE_INTEGER
  },
  {
    index: 0,
    value: Number.MAX_SAFE_INTEGER
  },
  {
    index: 0,
    value: Number.MIN_SAFE_INTEGER
  },
  {
    index: 0,
    value: Number.MIN_SAFE_INTEGER
  }
]

// style ----------------------------
export enum LineType {
  Dashed = 'dashed',
  Solid = 'solid'
}

export enum CandleType {
  CandleSolid = 'candle_solid',
  CandleStroke = 'candle_stroke',
  CandleUpStroke = 'candle_up_stroke',
  CandleDownStroke = 'candle_down_stroke',
  Ohlc = 'ohlc',
  Area = 'area'
}

export interface Margin {
  marginLeft: number
  marginTop: number
  marginRight: number
  marginBottom: number
}

export interface LineStyle {
  style: LineType
  size: number
  color: string
  dashedValue: number[]
}

export interface TextStyle extends Padding {
  color: string
  size: number
  family: string
  weight: number | string
  borderStyle: LineType
  borderDashedValue: number[]
  borderSize: number
  borderColor: string
  borderRadius: number
  backgroundColor: string | CanvasGradient
}

export interface StateLineStyle extends LineStyle {
  show: boolean
  length: number
}

export interface StateTextStyle extends TextStyle {
  show: boolean
}

export interface GridStyle {
  show: boolean
  horizontal: StateLineStyle
  vertical: StateLineStyle
}

export interface ChangeColor {
  upColor: string | number
  downColor: string | number
  noChangeColor: string | number
}

export interface CandleBarColor extends ChangeColor {
  upBorderColor: string
  downBorderColor: string
  noChangeBorderColor: string
  upWickColor: string
  downWickColor: string
  noChangeWickColor: string
}


export interface GradientColor {
  offset: number
  color: string
}

export interface CandleAreaStyle {
  lineSize: number
  lineColor: string
  lineGap: number
  value: string
  backgroundColor: string
  maxLineSize: number
  minLineSize: number
}

export interface CandleHighLowPriceMarkStyle {
  color: string | number
  textOffset: number
  textSize: string
  textFamily: string
  textWeight: string
  precision: number
  rightPadding: number
  lineSize: number
}

export interface CandleStyle {
  type: CandleType
  color: CandleBarColor
  area: CandleAreaStyle
  price: CandleHighLowPriceMarkStyle
}

export interface ToolTipText {
  fontSize: string,
  color: string
  gap: number
}

export interface IndicatorStyleTooltip {
  text: ToolTipText
}

export interface IndicatorStyle {
  tooltip: IndicatorStyleTooltip
}

export interface CrosshairDirectionStyle {
  show: boolean
  line: StateLineStyle
  text: StateTextStyle
}

export interface CrosshairStyle {
  show: boolean
  horizontal: CrosshairDirectionStyle
  vertical: CrosshairDirectionStyle
}

export interface OverlayStyle {}

export interface CommonStyle {
  height: number | string
  backgroundColor: string | number
  defaultRightWidth: number,
  textColor: string | number
  textSize: string
}

export const DefaultCommonStyle: CommonStyle = {
  height: 400,
  backgroundColor: 0xFF171929,
  defaultRightWidth: 80,
  textColor: Color.White,
  textSize: '30px'
}

export interface TimeStyle {
  color: string | number
  size: string
  length: number
}

export interface KLineStyles {
  grid: GridStyle
  candle: CandleStyle
  indicator: IndicatorStyle
  time: TimeStyle
  crosshair: CrosshairStyle
  overlay: OverlayStyle
  common: CommonStyle
}
