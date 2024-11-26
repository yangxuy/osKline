import { LineNode } from "../node/LineNode";
import { DeepPartial } from "../type/extention";
import { KLineStyles, KLineVisibleData, LayerOptions, Vector2d } from "../type/type";
import { CanvasLayer, IContainer } from "./baseLayer";

export class BottomLayer extends CanvasLayer {
  style?: DeepPartial<KLineStyles>;

  constructor(options: LayerOptions) {
    super(options!)
    this.style = options.style
  }

  drawGrid() {
    const r: number = 2
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
        const y = Math.round((this.controller.maxVol - element.data.vol) * this.controller.averageVolHeight)
        const height = Math.round(element.data.vol * this.controller.averageVolHeight)
        const color = element.data.open > element.data.close ? this.style?.candle?.color?.upColor :
          this.style?.candle?.color?.downColor
        this.sceneCanvas.canvasContext.fillStyle = color ?? 0xfffffff
        this.sceneCanvas.fillRect(x, y, this.style?.candle?.area?.lineSize!, height)
      }
    }
  }

  batchDraw(): void {
    super.batchDraw()
    this.drawGrid()
    this.drawCandle()
  }
}