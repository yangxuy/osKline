import { HitCanvas, SceneCanvas } from "../canvas/canvas";
import { ABNode, IABNode } from "./node";

interface ICandleNode extends IABNode {}

export class CandleNode extends ABNode {
  constructor(config: ICandleNode) {
    super(config)
  }

  drawScene(canvas: SceneCanvas): void {
    canvas.fillRect(this.x!, this.y!, this.width!, this.height!)
  }

  drawHit(canvas?: HitCanvas): void {
    if (!canvas) {
      return
    }
    canvas.canvasContext.fillStyle = this.colorKey
    canvas.fillRect(this.x!, this.y!, this.width!, this.height!)
  }
}