import { Canvas2d, OffsetPosition } from "../canvas2D";
import { KLineConfig } from "../config";
import { KLineController } from "../controller";

@Component
export struct DrawText {
  private candleContext = new Canvas2d()
  @Consume controller: KLineController;
  @Consume config: KLineConfig

  aboutToAppear(): void {
    this.controller.on<[number, number]>('price', (d) => {
      this.candleContext.clearRect(0, 0, this.candleContext.width, this.candleContext.height)
      const min = d[0]
      const max = d[0]
      const duration = (max - min) / (this.config.gridTopRowLength - 1)
      const distance = this.candleContext.height / (this.config.gridTopRowLength - 1)
      this.candleContext.font = "50px"
      this.candleContext.fillStyle = this.config.gridTextColor
      for (let index = 0; index < this.config.gridColumnLength; index++) {
        const text = (min + duration * index).toFixed(2)
        const dx = this.candleContext.width - this.candleContext.measureText(text).width
        let dy = this.candleContext.height - distance * index
        if (index == this.config.gridColumnLength - 1) {
          dy += this.candleContext.measureText(text).height
        } else if (index > 0) {
          dy += this.candleContext.measureText(text).height / 2
        }
        this.candleContext.drawText(text,
          new OffsetPosition(dx, dy)
        )
      }
    })
  }

  build() {
    Canvas(this.candleContext)
  }
}