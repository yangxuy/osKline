import { LineNode } from "../node/LineNode";
import { DeepPartial } from "../type/extention";
import { KLineStyles, KLineVisibleData, LayerOptions, } from "../type/type";
import { CanvasLayer, IContainer } from "./baseLayer";

export class MiddleLayer extends CanvasLayer {
  style?: DeepPartial<KLineStyles>;

  constructor(option: LayerOptions) {
    super(option!)
    this.style = option.style
  }

  drawText() {
    for (let index = 0; index < this.controller.kLineVisibleList.length; index++) {
      const element = this.controller.kLineVisibleList[index]
      if (element.data && element.idx % 15 == 0) {
        const text = element.data.time!;
        const x = Math.round(this.width - element.index)
        this.sceneCanvas.canvasContext.font = this.style?.time?.size ?? ""
        this.sceneCanvas.canvasContext.fillStyle = this.style?.time?.color ?? Color.White
        const height = this.sceneCanvas.canvasContext.measureText(text).height
        this.sceneCanvas.drawText(text, x, height)
      }
    }
  }

  batchDraw() {
    super.batchDraw()
    this.drawText()
  }

  batchDrawStyle(color: number, width: number): void {
    this.sceneCanvas.canvasContext.strokeStyle = color
    this.sceneCanvas.canvasContext.lineWidth = width
  }

  batchDrawData(): void {
  }
}