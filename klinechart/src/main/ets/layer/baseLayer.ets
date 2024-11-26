import { HitCanvas, SceneCanvas } from "../canvas/canvas";
import { BuilderNode, FrameNode, NodeController, Size, UIContext } from "@kit.ArkUI";
import { LayerOptions, NodeExtention, Vector2d } from "../type/type";
import { rgbToHex } from "../util/util";
import { ABNode } from "../node/node";


const INTERSECTION_OFFSETS: Vector2d[] = [
  { x: 0, y: 0 }, // 0
  { x: -1, y: -1 }, // 2
  { x: 1, y: -1 }, // 4
  { x: 1, y: 1 }, // 6
  { x: -1, y: 1 },// 8
]
const INTERSECTION_OFFSETS_LEN = INTERSECTION_OFFSETS.length;

export interface IContainer<T extends ABNode = ABNode> {
  readonly nodes: Array<T>
  addChild: (node: T) => void
  getChild: (color: string) => T | undefined
}

export abstract class CanvasLayer {
  sceneCanvas: SceneCanvas // 当前的画布
  hitCanvas?: HitCanvas // 离屏
  rootNode: FrameNode | undefined // 节点
  width: number = 0
  height: number = 0
  controller: NodeExtention;

  constructor(option: LayerOptions) {
    this.width = option.width
    this.height = option.height
    this.controller = option.controller
    this.sceneCanvas = new SceneCanvas(option)
    if (option.hit) {
      this.hitCanvas = new HitCanvas({
        width: this.width,
        height: this.height
      })
    }
  }

  getIntersection(position: Vector2d): Nullable<string> {
    for (let index = 0; index < INTERSECTION_OFFSETS.length; index++) {
      const intersectionOffset = INTERSECTION_OFFSETS[index];
      const obj = this._getIntersection({
        x: position.x + intersectionOffset.x,
        y: position.y + intersectionOffset.y,
      });

      if (obj) {
        return obj
      }
    }
    return undefined
  }

  _getIntersection(position: Vector2d): Nullable<string> {
    const p = this.hitCanvas?.canvasContext.getImageData(position.x, position.y, 1, 1).data
    if (p) {
      const p3 = p[3];
      if (p3 === 255) {
        const colorKey = rgbToHex(p![0], p[1], p[2]);
        return colorKey
      }
    }
    return undefined
  }

  clear() {
    this.sceneCanvas.clear(0, 0, this.width, this.height)
    this.hitCanvas?.clear(0, 0, this.width, this.height)
  }

  batchDraw() {
    this.clear()
  }
}