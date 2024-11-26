import { BuilderNode, FrameNode } from "@kit.ArkUI"
import { LayerOptions, Vector2d } from "../type/type"
import { KlineUIContext } from "../util/uiContext"

interface ICanvas {
  context: CanvasRenderingContext2D
  offset: number
}

interface IHitCanvas {
  width: number
  height: number
}

@Builder
function BuilderCanvas(config: ICanvas) {
  Canvas(config.context)
    .position({
      y: config.offset
    })
}

export abstract class BaseCanvas {
  canvas!: BuilderNode<[ICanvas]> | OffscreenCanvas
  canvasContext!: CanvasRenderingContext2D | OffscreenCanvasRenderingContext2D

  // 绘制线
  drawLine(p1: Vector2d, p2: Vector2d) {
    this.canvasContext.beginPath()
    this.canvasContext.moveTo(p1.x, p1.y)
    this.canvasContext.lineTo(p2.x, p2.y)
    this.canvasContext.closePath()
    this.canvasContext.stroke()
  }

  drawPolygon(...p: Vector2d[]) {
    this.canvasContext.beginPath()
    for (let index = 0; index < p.length; index++) {
      const element = p[index];
      if (index == 0) {
        this.canvasContext.moveTo(element.x, element.y)
      } else {
        this.canvasContext.lineTo(element.x, element.y)
      }
    }
    this.canvasContext.closePath()
    this.canvasContext.stroke()
  }

  fillRect(x: number, y: number, w: number, h: number) {
    this.canvasContext.fillRect(x, y, w, h)
  }

  drawText(text: string, x: number, y: number) {
    this.canvasContext.fillText(text, x, y)
  }

  clear(x: number, y: number, w: number, h: number) {
    this.canvasContext.clearRect(x, y, w, h)
  }

  clearPath() {

  }


  save() {
    this.canvasContext.save()
  }

  restore() {
    this.canvasContext.restore()
  }

  drawWithSave(fn: Function) {
    this.save()
    fn?.()
    this.restore()
  }
}

export class SceneCanvas extends BaseCanvas {
  frameNode: FrameNode | null;

  constructor(size: LayerOptions) {
    super()
    this.canvas = new BuilderNode<[ICanvas]>(KlineUIContext.instance.getUIContext(), {
      selfIdealSize: size
    })
    this.canvasContext = new CanvasRenderingContext2D()
    this.canvas.build(wrapBuilder(BuilderCanvas), {
      context: this.canvasContext,
      offset: size.offset
    })

    this.frameNode = this.canvas.getFrameNode()
  }
}

export class HitCanvas extends BaseCanvas {
  constructor(config: IHitCanvas) {
    super()
    this.canvas = new OffscreenCanvas(config.width, config.height)
    this.canvasContext = this.canvas.getContext("2d")
  }
}