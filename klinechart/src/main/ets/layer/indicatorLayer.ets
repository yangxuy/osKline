import { MAIndicator } from "../indicator/ma";
import { CandleNode } from "../node/candleNode";
import { ABNode, NodesController } from "../node/node";
import { DeepPartial } from "../type/extention";
import { KLineData, KLineStyles, LayerOptions, Vector2d } from "../type/type";
import { CanvasLayer, IContainer } from "./baseLayer";

export class IndicatorLayer extends CanvasLayer implements IContainer<CandleNode> {
  nodes: CandleNode[] = [];
  style?: DeepPartial<KLineStyles>;

  constructor(option: LayerOptions) {
    super(option)
    this.style = option.style
  }

  getChild(color: string) {
    return NodesController.getByColorKey(color)
  }

  addChild(node: CandleNode) {
    this.nodes.push(node)
  };


  drawElementCrossaxis(ele?: CandleNode) {
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

  drawSelectedKLineData(data: KLineData) {
    this.sceneCanvas.canvasContext.fillStyle = Color.White
    this.sceneCanvas.canvasContext.font = this.style?.indicator?.tooltip?.text?.fontSize!
    const time = "日期:" + data.time
    const high = "高:" + data.high
    const low = "低:" + data.low
    const open = "开:" + data.open
    const close = "开:" + data.close

    const renderText = [time, high, low, open, close]
    let left = this.style?.indicator?.tooltip?.text?.gap || 10
    for (let index = 0; index < renderText.length; index++) {
      const element = renderText[index];
      const width = this.sceneCanvas.canvasContext.measureText(element).width
      this.sceneCanvas.drawText(element, left, 20)
      left += width + (this.style?.indicator?.tooltip?.text?.gap || 10)
    }

    let ma = this.style?.indicator?.tooltip?.text?.gap || 10
    for (let index = 0; index < MAIndicator.figures.length; index++) {
      const element = MAIndicator.figures[index];
      if (data[element.key]) {
        this.sceneCanvas.canvasContext.fillStyle = element.color
        const va = element.title + ":" + (data[element.key] as number).toFixed(2)
        const width = this.sceneCanvas.canvasContext.measureText(va).width
        this.sceneCanvas.drawText(va, ma, 40)
        ma += width + (this.style?.indicator?.tooltip?.text?.gap || 10)
      }
    }
  }

  batchDraw(node?: ABNode) {
    super.batchDraw()
    this.drawElementCrossaxis(node as CandleNode)
  }
}