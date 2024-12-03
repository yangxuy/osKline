/**
 * 组件的节点
 * top
 *   - ma
 *   - candle
 *   - max/min
 * */
import { AnimatorResult, FrameNode, NodeController, UIContext } from "@kit.ArkUI";
import { BottomLayer } from "../layer/bottomLayer";
import { EventLayer } from "../layer/eventLayer";
import { MiddleLayer } from "../layer/middleLayer";
import { TopLayer } from "../layer/topLayer";
import { NodeExtention } from "../type/type";
import { KlineUIContext } from "../util/uiContext";
import { KLineChartController } from "./KLineChartController";
import { IndicatorLayer } from '../layer/indicatorLayer'
import { Animator as animator } from "@kit.ArkUI";

export class KLineViewNode extends NodeController implements NodeExtention {
  _controller: KLineChartController

  constructor(controller: KLineChartController) {
    super()
    this._controller = controller
  }

  eventType: number = 0
  scrollX: number = 0
  rootNode: Nullable<FrameNode>
  uiContext: Nullable<UIContext>
  private _topNode: Nullable<TopLayer>;
  private _middleNode: Nullable<MiddleLayer>;
  private _bottomNode: Nullable<BottomLayer>;
  private _indicator: Nullable<IndicatorLayer>;
  private _flingStartTime: number = 0
  private offsetDistance: number = 0
  private _scrollX: number = 0
  private momentumTimeThreshold = 300 // 惯性滑动的启动 时间阈值
  private momentumStartY = 0 // 惯性滑动的启动 时间阈值
  private _animation?: AnimatorResult;

  get maxPrice() {
    return this._controller.visibleRangeDataMaxAndMin[0].value
  };

  get minPrice() {
    return this._controller.visibleRangeDataMaxAndMin[1].value
  }

  get averagePriceHeight() {
    return this._topNode!.height / this._controller.averagePrice
  }

  get maxVol() {
    return this._controller.visibleRangeDataMaxAndMin[2].value
  }

  get averageVolHeight() {
    return this._bottomNode!.height / this.maxVol
  }

  get kLineVisibleList() {
    return this._controller.kLineVisibleList
  }

  get kLineData() {
    return this._controller.kLineList
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    this.uiContext = uiContext
    KlineUIContext.instance.context = uiContext;
    if (!this.rootNode) {
      this.rootNode = new FrameNode(uiContext)
      this.rootNode.commonAttribute
        .width('100%')
        .height(this._controller.styles?.common?.height)
        .backgroundColor(this._controller.styles?.common?.backgroundColor)

      this.rootNode.commonEvent.setOnTouch((event) => {
        this.onTouch(event)
      })
    }
    return this.rootNode
  }

  onTouch(event: TouchEvent) {
    const touch = event.touches[0]
    if (event.type == TouchType.Down) {
      this.eventType = 0
      this._flingStartTime = new Date().getTime()
      this.scrollX = touch.x
      this._scrollX = touch.x
      this.offsetDistance = 0
      this.momentumStartY = 0
    } else if (event.type == TouchType.Up) {
      if (this.eventType == 0) {
        this.eventType = 2
        const node = this._topNode?.getNodeByClick({ x: touch.x, y: touch.y })
        this._indicator?.batchDraw(node)
      } else if (this.eventType == 1) {
        const absDeltaY = Math.abs(this.offsetDistance - this.momentumStartY);
        const duration = new Date().getTime() - this._flingStartTime;
        if (absDeltaY > 15 && duration < this.momentumTimeThreshold) {
          this.onAnimation(this.offsetDistance, this.momentumStartY, duration)
        }
      }
    } else {
      const distance = touch.x - this.scrollX
      this.offsetDistance = touch.x - this._scrollX
      if (distance != 0) {
        this.eventType = 1
        this.scrollX = touch.x
        this.onScrollX(distance)
        const now = new Date().getTime();
        if (now - this._flingStartTime > this.momentumTimeThreshold) {
          this.momentumStartY = this.offsetDistance;
          this._flingStartTime = now;
        }
      } else {
        this.eventType = 0
      }
    }
  }

  onAnimation(current: number, start: number, duration: number) {
    const deceleration = 0.003;
    const distance = current - start;
    const speed = 2 * Math.abs(distance) / duration;
    let destination = current + speed / deceleration * (distance < 0 ? -1 : 1);

    this._animation = animator.create({
      duration: 800,
      easing: "cubic-bezier(.17, .89, .45, 1)",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0,
      end: destination
    })

    this.scrollX = 0
    this._animation.onFrame = (progress) => {
      const distance = progress - this.scrollX
      if (Math.abs(distance) < 100) {
        this.onScrollX(distance)
        this.scrollX = progress
      }
    }

    this._animation.play()
  }

  onAnimationStop() {
    if (this._animation) {
      this._animation.cancel()
      this._animation.finish()
    }
  }

  onScrollX(distance: number) {
    this._controller.calculateRightCount(distance)
    this.batchDraw()
  }

  batchDraw() {
    this._topNode?.batchDraw()
    this._indicator?.batchDraw()
    this._middleNode?.batchDraw()
    this._bottomNode?.batchDraw()
  }

  aboutToResize(size: Size): void {
    const width = size.width
    const height = size.height
    const topHeight = Math.round(height * 0.7)
    const middleHeight = Math.round(height * 0.1)
    const bottomHeight = Math.round(height * 0.2)
    this._topNode = new TopLayer({
      width: width,
      height: topHeight,
      style: this._controller.styles!,
      controller: this,
      hit: true
    })

    this._indicator = new IndicatorLayer({
      width: width,
      height: topHeight,
      style: this._controller.styles!,
      controller: this,
    })

    this._middleNode = new MiddleLayer({
      width: width,
      height: middleHeight,
      offset: topHeight,
      style: this._controller.styles!,
      controller: this
    })

    this._bottomNode = new BottomLayer({
      width: width,
      height: bottomHeight,
      offset: topHeight + middleHeight,
      style: this._controller.styles!,
      controller: this
    })

    this.rootNode?.appendChild(this._topNode.sceneCanvas.frameNode)
    this.rootNode?.appendChild(this._indicator.sceneCanvas.frameNode)
    this.rootNode?.appendChild(this._middleNode.sceneCanvas.frameNode)
    this.rootNode?.appendChild(this._bottomNode.sceneCanvas.frameNode)

    if (size.width == 0 || size.height == 0) {
      return
    }

    this._controller.calculateVisibleView(size)

    this.batchDraw()
  }
}