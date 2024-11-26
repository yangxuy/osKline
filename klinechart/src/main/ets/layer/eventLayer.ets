import { MAIndicator } from "../indicator/ma";
import { CandleNode } from "../node/candleNode";
import { NodesController } from "../node/node";
import { DeepPartial } from "../type/extention";
import { KLineData, KLineStyles, LayerOptions, Vector2d } from "../type/type";
import { CanvasLayer, IContainer } from "./baseLayer";

export class EventLayer extends CanvasLayer implements IContainer<CandleNode> {
  nodes: CandleNode[] = [];
  style?: DeepPartial<KLineStyles>;
  eventType: number = 0
  scrollX: number = 0

  constructor(option: LayerOptions) {
    super(option)
    this.style = option.style
    this.sceneCanvas.frameNode?.commonEvent.setOnTouch((event) => {
      console.log("touch event")
      this.onTouch(event)
    })
  }

  onTouch(event: TouchEvent) {
    const touch = event.touches[0]
    if (event.type == TouchType.Down) {
      this.eventType = 0
      this.scrollX = touch.x
    } else if (event.type == TouchType.Up) {
      if (this.eventType == 0) {
        this.eventType = 2
        this.onClickEvent({ x: touch.x, y: touch.y })
      }
      this.scrollX = 0
    } else {
      const distance = touch.x - this.scrollX
      if (distance != 0) {
        this.eventType = 1
        this.scrollX = touch.x
        this.controller.onScrollX(distance)
      }
    }
  }

  getChild(color: string) {
    return NodesController.getByColorKey(color)
  }

  addChild(node: CandleNode) {
    this.nodes.push(node)
  };

  onClickEvent(event: Vector2d) {
    // 获取点击的元素
    const x = event.x
    const y = event.y
    const colorKey = this.getIntersection({ x, y })
    console.log("000", colorKey)
    if (colorKey) {
      const node = this.getChild(colorKey)
      this.drawElementCrossaxis(node as CandleNode)
    }
  }

  drawElementCrossaxis(ele?: CandleNode) {
    super.batchDraw()
    const el: KLineData = this.controller.kLineData[ele?.idx??(this.controller.kLineData.length - 1)]
    if (ele) {
      this.sceneCanvas.save()
      const x = ele.x! + (ele.width!) / 2
      const y = Math.round((this.controller.maxPrice - el.close) * this.controller.averagePriceHeight)
      const p1: Vector2d = { x: 0, y }
      const p2: Vector2d = { x: this.width, y }

      const p3: Vector2d = { x, y: 0 }
      const p4: Vector2d = { x, y: this.height }
      this.sceneCanvas.canvasContext.strokeStyle = Color.White
      this.sceneCanvas.canvasContext.lineWidth = 1
      this.sceneCanvas.drawLine(p1, p2)
      this.sceneCanvas.drawLine(p3, p4)
    }
    this.drawSelectedKLineData(el)
  }

  drawSelectedKLineData(data?: KLineData) {
    if (!data) {
      data = this.controller.kLineData[this.controller.kLineData.length-1]
    }
    this.sceneCanvas.canvasContext.fillStyle = Color.White
    this.sceneCanvas.canvasContext.font = this.style?.indicator?.tooltip?.text?.fontSize!
    const time = "日期" + data.time
    this.sceneCanvas.drawText(time, 20, 20)
  }

  batchDraw() {
    super.batchDraw()
    this.drawSelectedKLineData()
  }
}