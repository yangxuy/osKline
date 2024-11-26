import { KLineConfig } from "./config";

import { emitter } from "@kit.BasicServicesKit";
import { Animator as animator } from "@kit.ArkUI";


type EventType = "candle" | "time" | "price"

class EmitterEvent {
  currentOffset: number = 0
  distance: number = 0
  startOffset: number = 0

  emit(type: EventType, data?: ESObject) {
    emitter.emit(type, {
      data: data
    });
  }

  on<T>(type: EventType, callBack: Callback<T>) {
    emitter.on(type, (data: emitter.GenericEventData<ESObject>) => {
      callBack(data.data)
    });
  }

  onActionStart(event: GestureEvent) {
    this.startOffset = event.offsetX
  }

  onActionUpdate(event: GestureEvent) {
    this.distance = event.offsetX - this.startOffset;
    this.currentOffset += this.distance
    this.startOffset = event.offsetX
  }

  onActionEnd(event: GestureEvent) {
    this.startOffset = 0
  }
}

interface IInitConfig {
  width: number
  config: KLineConfig
}

interface IHighAndLow {
  x: number
  price: number
}

export interface KLineData {
  id: number
  open: number
  high: number
  low: number
  close: number
  volume?: number
  turnover?: number
}

export interface VisibleRangeData {
  dataIndex: number
  x: number
  data: Nullable<Market>
}

export class KLineController extends EmitterEvent {
  config!: KLineConfig;
  width!: number;
  // 缩放
  @Track mScaleX: number = 1.0
  // 滚动
  @Track mScrollX: number = 0.0
  // 选择
  @Track mSelectX: number = 0.0
  private marks: Market[] = []
  private visibleCandleCount: number = 0
  // 右边占据的个数
  rightCandleCount: number = 0
  candleAndGap: number = 0
  totalCandleCont: number = 0

  /// 初始化
  initBase(config: IInitConfig) {
    this.width = config.width
    this.config = config.config
    this.candleAndGap = this.config.kLineCandlerWidth + this.config.kLineCandleGap
    this.visibleCandleCount = this.width / this.candleAndGap
    this.rightCandleCount = this.config.offsetRightDistance / this.candleAndGap
  }

  applyNewData(data: KLineData[]) {
    for (let index = 0; index < data.length; index++) {
      const element = data[index];
      this.marks.push(new Market(element))
    }
    this.totalCandleCont = data.length

    this.calculateData()

    this.update()
  }


  update() {
    this.emit('candle', this._visibleRangeData)
  }

  /*************************数据处理*******************************/
  _visibleDataHL: IHighAndLow[] = [
    {
      x: 0,
      price: Number.MIN_SAFE_INTEGER
    },
    {
      x: 0,
      price: Number.MAX_SAFE_INTEGER
    }
  ]
  // 可是区域的数据
  _visibleRangeData: Array<VisibleRangeData> = []

  calculateData() {
    let to = Math.round(this.rightCandleCount + this.totalCandleCont + 0.5)
    let from = Math.round(to - this.visibleCandleCount) - 1
    if (from < 0) {
      from = 0
    }

    this._visibleRangeData = []
    for (let index = from; index < to; index++) {
      const lineData = this.marks[index]
      const x = this.calculateIndexToAxis(index)
      this._visibleRangeData.push({
        x: x,
        data: lineData,
        dataIndex: index
      })
      if (lineData) {
        if (this._visibleDataHL[0].price < lineData.high) {
          this._visibleDataHL[0].price = lineData.high
          this._visibleDataHL[0].x = x
        }
        if (this._visibleDataHL[1].price > lineData.low) {
          this._visibleDataHL[1].price = lineData.low
          this._visibleDataHL[1].x = x
        }
      }
    }

  }

  calculateIndexToAxis(index: number) {
    const dataRightWidth = this.rightCandleCount + this.totalCandleCont - index

    return Math.floor(this.width - (dataRightWidth - 0.5) * this.candleAndGap + 0.5)
  }

  /*************************价格处理start*******************************/

  /*************************价格处理end*******************************/

  /*************************手势处理*******************************/
  onActionStart(event: GestureEvent): void {
    super.onActionStart(event)
  }

  onActionUpdate(event: GestureEvent): void {
    super.onActionUpdate(event)
    const distanceCount = this.distance / this.candleAndGap
    this.rightCandleCount = this.rightCandleCount - distanceCount
    this.calculateData()
    this.update()
    // const gutterIndex = Math.ceil(this.currentOffset / (this.config.kLineCandlerWidth + this.config.kLineCandleGap))
    //
    // this.startIndex = this.actionStartIndex - gutterIndex
    //
    // if (this.startIndex > this.marks.length - 1 - this.amountLength) {
    //   this.startIndex = this.marks.length - 1 - this.amountLength
    // }
    //
    // if (this.startIndex < 0) {
    //   this.startIndex = 0
    // }
    //
    // this.candleList = this.marks.slice(this.startIndex, this.endIndex)
    //
    // this.calculatePrice()
    // this.update()
  }

  onActionEnd(event: GestureEvent): void {
    super.onActionEnd(event)
    return
    // const deceleration = 0.03
    // const destination = event.offsetY / deceleration / 200
    // const animationResult = animator.create({
    //   duration: 2500,
    //   easing: "cubic-bezier(0.17,0.89,0.45,1)",
    //   delay: 0,
    //   fill: "forwards",
    //   direction: "normal",
    //   iterations: 1,
    //   begin: 0,
    //   end: destination
    // })
    //
    // animationResult.onFrame = (progress) => {
    //   if (event.offsetX > 0) {
    //     this.startIndex -= 1
    //
    //     if (this.startIndex < 0) {
    //       this.startIndex = 0
    //     }
    //
    //     this.endIndex = this.startIndex + this.amountLength
    //     if (this.endIndex > this.marks.length - 1) {
    //       this.endIndex = this.marks.length - 1
    //     }
    //   } else {
    //     this.endIndex += 1
    //     if (this.endIndex > this.marks.length - 1) {
    //       this.endIndex = this.marks.length - 1
    //     }
    //     this.startIndex = this.endIndex - this.amountLength
    //
    //     if (this.startIndex < 0) {
    //       this.startIndex = 0
    //     }
    //   }
    //
    //   this.candleList = this.marks.slice(this.startIndex, this.endIndex)
    //
    //   this.calculatePrice()
    //   this.update()
    // }
    //
    // animationResult.play()
  }
}

export class Market {
  id: number
  vol: number
  close: number
  open: number
  low: number
  high: number

  constructor(config: ESObject) {
    this.id = config.id
    this.vol = config.vol
    this.close = config.close
    this.open = config.open
    this.low = config.low
    this.high = config.high
  }
}

