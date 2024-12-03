import { testData } from '../bloc/data'
import { KLineChart, KLineChartController } from '@yx/klinechart';

@Entry
@Component
struct Index {
  private _controller: KLineChartController = new KLineChartController();

  aboutToAppear(): void {
    this._controller.applyNewData(testData)
  }

  build() {
    Column() {
      KLineChart({
        controller: this._controller
      })
    }
  }
}