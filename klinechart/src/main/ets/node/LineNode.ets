import { SceneCanvas } from "../canvas/canvas";
import { Vector2d } from "../type/type";
import { ABNode, IABNode } from "./node";

interface ILineNode extends IABNode {
  p1: Vector2d
  p2: Vector2d
}

export class LineNode extends ABNode {
  p1: Vector2d
  p2: Vector2d

  constructor(config: ILineNode) {
    super(config)
    this.p1 = config.p1
    this.p2 = config.p2
  }

  drawScene(canvas: SceneCanvas): void {
    canvas.drawLine(this.p1, this.p2)
  }
}