import { SceneCanvas } from "../canvas/canvas";
import { KLineData } from "../type/type";
import { KLineFigure, KLineIndicator } from "./indicator";

export class MAIndicator implements KLineIndicator {
  name: string = "MA";
  datas: Record<string, ESObject>[] = []
  static figures: KLineFigure[] = [
    {
      key: "ma5",
      title: "MA5",
      type: "line",
      gap: 5,
      color: "#FF9600"
    },
    {
      key: "ma10",
      title: "MA10",
      type: "line",
      gap: 10,
      color: "#935EBD"
    },
    {
      key: "ma30",
      title: "MA30",
      type: "line",
      gap: 30,
      color: "#E11D74"
    },
    {
      key: "ma60",
      title: "MA60",
      type: "line",
      gap: 60,
      color: "#01C5C4"
    },
  ]
  currentMAData: Record<string, ESObject> = {}

  updateCurrentMAData(idx: number) {
    if (this.datas[idx] && this.datas[idx].ma5) {
      this.currentMAData = this.datas[idx]
    }
  }

  // [{ma5:10,ma10:20},{ma5:10,ma10:20}]
  calcFunction(dataList: KLineData[]) {
    const closeSums: number[] = []
    dataList.forEach((item, i) => {
      const close = item.close
      MAIndicator.figures.forEach((p, index) => {
        closeSums[index] = (closeSums[index] ?? 0) + close
        if (i >= p.gap - 1) {
          // ma[this.figures[index].key] = closeSums[index] / p
          item[MAIndicator.figures[index].key] = closeSums[index] / p.gap
          closeSums[index] -= dataList[i-(p.gap - 1)].close
        }
      })
    })
    // this.datas = dataList.map<Record<string, ESObject>>((item, i) => {
    //   const ma: Record<string, ESObject> = {}
    //   const close = item.close
    //   this.calcConfig.forEach((p, index) => {
    //     closeSums[index] = (closeSums[index] ?? 0) + close
    //     if (i >= p - 1) {
    //       ma[this.figures[index].key] = closeSums[index] / p
    //       item[this.figures[index].key] = closeSums[index] / p
    //       closeSums[index] -= dataList[i-(p - 1)].close
    //     }
    //   })
    //
    //   return ma;
    // })
  };

  batchDrawData(scene: SceneCanvas) {

  }
}