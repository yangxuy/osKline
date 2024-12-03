/**
 * 组件的控制器
 * - 组件的数据
 * - 组件的样式
 * - 组件的销毁
 */

import { MAIndicator } from "../indicator/ma"
import { getStyles } from "../style"
import { DeepPartial } from "../type/extention"
import {
  ControllerOptions,
  defaultMaxAndMin,
  KLineData,
  KLineStyles,
  KLineVisibleData,
  KLineVisibleMaxAndMin
} from "../type/type"
import { formatTime, mergeOptions } from "../util/util"

export class KLineChartController {
  rightCandleCount: number = 0
  kLineList: KLineData[] = []
  kLineVisibleList: KLineVisibleData[] = []
  visibleRangeDataMaxAndMin: KLineVisibleMaxAndMin[] = []
  kLineInViewCount: number = 0
  startIndex: number = 0
  endIndex: number = 0
  precision: number = 0.2
  scale: number = 1 // 缩放管理
  styles?: DeepPartial<KLineStyles>
  formatTime: (time: number) => string = formatTime
  preX: number = 0
  maIndicator = new MAIndicator()
  eventType: number = 0

  get averageCandleWidth() {
    return ((this.styles?.candle?.area?.lineSize ?? 0) + (this.styles?.candle?.area?.lineGap ?? 0)) * this.scale
  }

  get averagePrice() {
    return this.visibleRangeDataMaxAndMin[0].value - this.visibleRangeDataMaxAndMin[1].value
  }

  setOptions(options?: ControllerOptions) {
    const opt = mergeOptions(options)
    if (typeof opt.styles == 'string') {
      this.styles = getStyles(opt.styles)
    }
    this.rightCandleCount = (this.styles!.common!.defaultRightWidth!) / this.averageCandleWidth
  }

  applyNewData(data: KLineData[]) {
    this.kLineList = data
    this.calculateIndicator()
  }

  calculateVisibleView(size: Size) {
    this.kLineInViewCount = size.width / this.averageCandleWidth
    this.calculateRangeIndex()
  }

  calculateIndicator() {
    this.maIndicator.calcFunction(this.kLineList)
  }

  calculateRangeIndex() {
    this.endIndex = Math.round(this.kLineList.length + this.rightCandleCount + this.precision)
    this.startIndex = Math.round(this.endIndex - this.kLineInViewCount) - 1
    this.calculateRangeList()
  }

  calculateRangeList() {
    this.kLineVisibleList = []
    this.visibleRangeDataMaxAndMin = []
    for (let index = this.startIndex; index < this.endIndex; index++) {
      const element = this.kLineList[index];
      if (element) {
        if ((this.visibleRangeDataMaxAndMin[0]?.value ?? Number.MIN_SAFE_INTEGER) < element.high) {
          this.visibleRangeDataMaxAndMin[0] = {
            index: index,
            value: element.high
          }
        }

        if ((this.visibleRangeDataMaxAndMin[1]?.value ?? Number.MAX_SAFE_INTEGER) > element.low) {
          this.visibleRangeDataMaxAndMin[1] = {
            index: index,
            value: element.low
          }
        }

        if ((this.visibleRangeDataMaxAndMin[2]?.value ?? Number.MIN_SAFE_INTEGER) < element.vol) {
          this.visibleRangeDataMaxAndMin[2] = {
            index: index,
            value: element.vol
          }
        }

        if (!element.time) {
          element.time = this.formatTime(element.id * 100)
        }
      }

      this.kLineVisibleList.push({
        idx: index,
        index: (this.kLineList.length + this.rightCandleCount - index - this.precision) * this.averageCandleWidth,
        data: element
      })
    }

    // this.visibleRangeDataMaxAndMin[3] = {
    //   index: (this.visibleRangeDataMaxAndMin[0].index + this.visibleRangeDataMaxAndMin[1].index) / 2,
    //   value: (this.visibleRangeDataMaxAndMin[0].value + this.visibleRangeDataMaxAndMin[1].value) / 2
    // }
  }

  calculateRightCount(distance: number) {
    const rightCount = distance / this.averageCandleWidth
    this.rightCandleCount -= rightCount

    if (this.rightCandleCount > ((this.styles!.common!.defaultRightWidth!) / this.averageCandleWidth)) {
      this.rightCandleCount = (this.styles!.common!.defaultRightWidth!) / this.averageCandleWidth
    } else if (this.kLineList.length + this.rightCandleCount - this.kLineInViewCount < this.precision) {
      this.rightCandleCount = this.kLineInViewCount - this.kLineList.length
    }

    this.calculateRangeIndex()
  }

  calculateTouchList(event: TouchEvent) {
    const touch = event.touches[0]
    if (event.type == TouchType.Down) {
      this.eventType = 0
      this.preX = touch.x
    } else if (event.type == TouchType.Up) {
      if (this.eventType == 0) {
        this.eventType = 2
      }
      this.preX = 0
    } else {
      const distance = touch.x - this.preX
      if (distance != 0) {
        this.eventType = 1
        this.calculateRightCount(distance)
        this.preX = touch.x
      }
    }
  }


  mounted() {
  }

  destroy() {
  }
}