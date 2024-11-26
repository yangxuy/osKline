import { Canvas2d } from "../canvas2D"
import { KLineConfig } from "../config";
import { KLineController, Market, VisibleRangeData } from "../controller";

@Component
export struct Candle {
  private candleContext = new Canvas2d()
  @Consume controller: KLineController;
  @Consume config: KLineConfig;

  aboutToAppear(): void {
    this.controller.on<VisibleRangeData[]>('candle', (d) => {
      this.candleContext.clearRect(0, 0, this.candleContext.width, this.candleContext.height)
      this.candleContext.fillStyle = this.config.kLineCandleIncreaseColor
      const gutter = this.controller._visibleDataHL[0].price - this.controller._visibleDataHL[1].price
      const dx = gutter / this.candleContext.height

      for (let index = 0; index < d.length; index++) {
        const element = d[index];
        if (element.data) {
          if (element.data.open > element.data.close) {
            this.candleContext.fillStyle = this.config.kLineCandleDecreaseColor
          } else {
            this.candleContext.fillStyle = this.config.kLineCandleIncreaseColor
          }

          const height = (element.data.high - element.data.low) / dx
          const x = element.x
          const y = (this.controller._visibleDataHL[0].price - element.data.high) / dx

          this.candleContext.fillRect(x, y, this.config.kLineCandlerWidth, height)
        }
      }
    })
  }

  build() {
    Canvas(this.candleContext)
  }
}