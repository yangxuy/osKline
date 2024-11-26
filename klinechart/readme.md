一个k线三方库

安装

```ts
ohpm install @yx/klinechart
```

页面展示
![img.png](img.png)

使用方式

```ts
import { testData } from './data'
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
        _controller: this._controller
      })
    }
  }
}
```