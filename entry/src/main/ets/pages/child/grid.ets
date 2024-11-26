import { Canvas2d, OffsetPosition } from "../canvas2D"
import { KLineConfig } from "../config"
import { Position } from "@kit.ArkUI"

export enum GridType {
  top,
  bottom
}

@Component
export struct GridView {
  @Consume config: KLineConfig
  private type: GridType = GridType.top
  private gridContext = new Canvas2d()

  build() {
    Canvas(this.gridContext)
      .onReady(() => {
        this.gridContext.strokeStyle = this.config.gridLineColor
        this.gridContext.lineWidth = this.config.gridLineWidth
        const gridRowLength =
          this.type == GridType.top ? this.config.gridTopRowLength : this.config.gridBottomRowLength;
        const lineRowGap = this.gridContext.height / (gridRowLength - 1);

        for (let i = 0; i < gridRowLength; i++) {
          this.gridContext.beginPath()
          let dy = this.gridContext.height - lineRowGap * i;

          if (i == 0) {
            dy -= this.config.gridLineWidth
          }
          if (i == gridRowLength - 1) {
            dy += this.config.gridLineWidth
          }

          const d1: OffsetPosition = new OffsetPosition(this.config.kLineMarginLeft, dy)
          const d2: OffsetPosition = new OffsetPosition(this.gridContext.width - this.config.kLineMarginRight, dy)
          this.gridContext.drawLine(d1, d2)
        }

        const gridColumnLength = this.config.gridColumnLength
        const lineColumnGap = this.gridContext.width / (gridColumnLength - 1)

        for (let index = 0; index < gridColumnLength; index++) {
          const dx = this.config.kLineMarginLeft + lineColumnGap * index
          const d1: OffsetPosition = new OffsetPosition(dx, this.gridContext.height)
          const d2: OffsetPosition = new OffsetPosition(dx, 0)
          this.gridContext.drawLine(d1, d2)
        }
      })
  }
}