import { HitCanvas, SceneCanvas } from "../canvas/canvas"
import { KLineNode } from "../type/type"
import { getRandomColor } from "../util/util"

export interface IABNode {
  x?: number
  y?: number
  width?: number
  height?: number
  idx: number
}

export class NodesController {
  static node: Array<[number, string, ABNode]> = []
  static colors: Array<string> = []

  static addNode(colorKey: string, node: ABNode) {
    NodesController.colors.push(colorKey)
    NodesController.node.push([node.idx, colorKey, node])
  }

  static getByColorKey(color: string): ABNode | undefined {
    for (let index = 0; index < NodesController.node.length; index++) {
      const element = NodesController.node[index];
      if (element[1] == color) {
        return element[2]
      }
    }

    return undefined
  }

  static getByIdxKey(idx: number): ABNode | undefined {
    for (let index = 0; index < NodesController.node.length; index++) {
      const element = NodesController.node[index];
      if (element[0] == idx) {
        return element[2]
      }
    }

    return undefined
  }

  static hasColorKey(color: string): boolean {
    return NodesController.colors.includes(color)
  }
}

export abstract class ABNode implements KLineNode {
  idx: number = 0
  x?: number = 0
  y?: number = 0
  width?: number = 0
  height?: number = 0
  colorKey: string = ""

  constructor(config: IABNode) {
    this.x = config.x
    this.y = config.y
    this.width = config.width
    this.height = config.height
    this.idx = config.idx

    while (true) {
      const key = getRandomColor();
      if (key && !NodesController.hasColorKey(key)) {
        this.colorKey = key
        break;
      }
    }

    NodesController.addNode(this.colorKey, this)
  }

  updateNode(x: number, y: number, w: number, h: number) {
    this.x = x
    this.y = y
    this.width = w
    this.height = h
  }

  abstract drawScene(canvas: SceneCanvas): void

  drawHit(canvas: HitCanvas) {
  }

  clearNode(canvas: SceneCanvas, hit: HitCanvas) {
    canvas.clear(this.x!, this.y!, this.width!, this.height!)
    hit.clear(this.x!, this.y!, this.width!, this.height!)
  }
}