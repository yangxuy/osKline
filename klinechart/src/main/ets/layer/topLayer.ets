import { MAIndicator } from "../indicator/ma";
import { CandleNode } from "../node/candleNode";
import { ABNode, NodesController } from "../node/node";
import { DeepPartial } from "../type/extention";
import { KLineData, KLineStyles, LayerOptions, Vector2d } from "../type/type";
import { CanvasLayer, IContainer } from "./baseLayer";

export class TopLayer extends CanvasLayer implements IContainer<CandleNode> {
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

  getNodeByClick(event: Vector2d): ABNode | undefined {
    // 获取点击的元素
    const x = event.x
    const y = event.y
    const colorKey = this.getIntersection({ x, y })

    if (colorKey) {
      const node = this.getChild(colorKey)
      return node
    }

    return undefined
  }

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

  drawGrid() {
    const r: number = this.style?.grid?.horizontal?.length ?? 4
    const c: number = this.style?.grid?.vertical?.length ?? 5

    this.sceneCanvas.drawWithSave(() => {
      this.sceneCanvas.canvasContext.strokeStyle = this.style?.grid?.horizontal?.color ?? ''
      this.sceneCanvas.canvasContext.lineWidth = this.style?.grid?.horizontal?.size ?? 1
      for (let i = 0; i < r; i++) {
        const gap = this.height / (r - 1)
        const y = i * gap
        const p1: Vector2d = { x: 0, y: y }
        const p2: Vector2d = { x: this.width, y: y }

        this.sceneCanvas.drawLine(p1, p2)
      }
    })

    this.sceneCanvas.drawWithSave(() => {
      this.sceneCanvas.canvasContext.strokeStyle = this.style?.grid?.vertical?.color ?? ''
      this.sceneCanvas.canvasContext.lineWidth = this.style?.grid?.vertical?.size ?? 1
      for (let i = 0; i < c; i++) {
        const gap = this.width / (c - 1)
        const x = i * gap
        const p1: Vector2d = { x: x, y: 0 }
        const p2: Vector2d = { x: x, y: this.height }

        this.sceneCanvas.drawLine(p1, p2)
      }
    })
  }

  drawCandle() {
    for (let index = 0; index < this.controller.kLineVisibleList.length; index++) {
      const element = this.controller.kLineVisibleList[index]
      if (element.data) {
        const x = Math.round(this.width - element.index)
        const y = Math.round((this.controller.maxPrice -
        Math.max(element.data.close, element.data.open)) * this.controller.averagePriceHeight)
        const height =
          Math.abs(Math.round((element.data.open - element.data.close) * this.controller.averagePriceHeight))
        const color = element.data.open > element.data.close ? this.style?.candle?.color?.upColor :
          this.style?.candle?.color?.downColor
        this.sceneCanvas.canvasContext.fillStyle = color ?? 0xfffffff
        let node = NodesController.getByIdxKey(element.idx);
        if (node) {
          node.updateNode(x, y, this.style?.candle?.area?.lineSize!, height)
        } else {
          node = new CandleNode({
            x,
            y,
            width: this.style?.candle?.area?.lineSize!,
            height,
            idx: element.idx
          })
          this.addChild(node as CandleNode)
        }

        node.drawScene(this.sceneCanvas)
        node.drawHit(this.hitCanvas!)
      }
    }
  }

  drawLastKLineData() {
    const last = this.controller.kLineData[this.controller.kLineData.length-1]
    this.sceneCanvas.canvasContext.fillStyle = this.style?.candle?.price?.color ?? Color.White
    this.sceneCanvas.canvasContext.font = this.style?.candle?.price?.textSize ?? ""
    const text = last.close + ""
    const measure = this.sceneCanvas.canvasContext.measureText(text)
    const x = Math.round(this.width - measure.width - this.style?.candle?.price?.rightPadding!)

    let y = Math.round(((this.controller.maxPrice - last.close) * this.controller.averagePriceHeight))
    if (y < 0) {
      y = 20
    } else if (y > this.height) {
      y = this.height - 20
    }
    const middle = y + measure.height / 3

    this.sceneCanvas.save()
    this.sceneCanvas.canvasContext.translate(-this.style?.candle?.price?.rightPadding!, 0)
    this.sceneCanvas.drawText(text, x, middle)
    this.sceneCanvas.canvasContext.strokeStyle = Color.White
    const lX = x - this.style?.candle?.price?.textOffset!
    const lY = y - measure.height * this.style?.candle?.price?.precision!
    const lYY = y + measure.height * this.style?.candle?.price?.precision!
    const p1: Vector2d = { x: lX, y: y }
    const p2: Vector2d = { x: x, y: lY }
    const p3: Vector2d = { x: this.width, y: lY }
    const p4: Vector2d = { x: this.width, y: lYY }
    const p5: Vector2d = { x: x, y: lYY }
    this.sceneCanvas.drawPolygon(p1, p2, p3, p4, p5)
    this.sceneCanvas.restore()

    this.sceneCanvas.save()
    this.sceneCanvas.canvasContext.strokeStyle = Color.White
    this.sceneCanvas.canvasContext.setLineDash([5, 5])
    this.sceneCanvas.drawLine({ x: 0, y: y }, { x: lX, y: y })
    this.sceneCanvas.restore()
  }

  drawAveragePrice() {
    this.sceneCanvas.save()
    const r = this.style?.grid?.horizontal?.length!
    this.sceneCanvas.canvasContext.fillStyle = Color.White
    this.sceneCanvas.canvasContext.font = this.style?.candle?.price?.textSize!
    const range = (this.controller.maxPrice - this.controller.minPrice) / (r - 1)
    const rangeHeight = this.height / (r - 1)
    for (let index = 0; index < this.style?.grid?.horizontal?.length!; index++) {
      const text = (this.controller.minPrice + range * index).toFixed(2)
      const x = Math.round(this.width - this.sceneCanvas.canvasContext.measureText(text).width)
      let dy = this.height - index * rangeHeight
      if (index == (r - 1)) {
        dy += this.sceneCanvas.canvasContext.measureText(text).height
      } else if (index > 0) {
        dy += (this.sceneCanvas.canvasContext.measureText(text).height / 2)
      }

      this.sceneCanvas.drawText(text, x, dy)
    }
    this.sceneCanvas.restore()
  }

  drawMA() {
    for (let index = 0; index < this.controller.kLineVisibleList.length; index++) {
      for (let i = 0; i < MAIndicator.figures.length; i++) {
        const indicator = MAIndicator.figures[i]
        const element1 = this.controller.kLineVisibleList[index-1];
        const element2 = this.controller.kLineVisibleList[index];
        if (element1 && element1.data && element1.data[indicator.key] && element2 && element2.data &&
        element2.data[indicator.key]) {
          const p1: Vector2d = {
            x: Math.round(this.width - element1.index),
            y: (this.controller.maxPrice - element1.data[indicator.key]) * this.controller.averagePriceHeight
          }
          const p2: Vector2d = {
            x: Math.round(this.width - element2.index),
            y: (this.controller.maxPrice - element2.data[indicator.key]) * this.controller.averagePriceHeight
          }

          this.sceneCanvas.canvasContext.strokeStyle = indicator.color
          this.sceneCanvas.drawLine(p1, p2)
        }
      }
    }
  }

  drawSelectedKLineData(data: KLineData) {
    const h = data.high
    this.sceneCanvas.canvasContext.fillStyle = Color.White
    this.sceneCanvas.canvasContext.font = this.style?.indicator?.tooltip?.text?.fontSize!
    const time = "日期" + data.time
    this.sceneCanvas.drawText(time, 20, 20)
  }

  batchDraw() {
    super.batchDraw()
    this.drawGrid()
    this.drawCandle()
    this.drawLastKLineData()
    this.drawAveragePrice()
    this.drawMA()
  }
}