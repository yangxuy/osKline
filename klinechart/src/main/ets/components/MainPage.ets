import { KLineChartController } from '../controller/KLineChartController'
import { KLineViewNode } from "../controller/nodeController";
import { ControllerOptions } from '../type/type';


@Component
export struct KLineChart {
  private controller: KLineChartController = new KLineChartController();
  private _nodeController: Nullable<KLineViewNode>
  private options?: ControllerOptions;

  aboutToAppear(): void {
    this.controller.setOptions(this.options)
    this._nodeController = new KLineViewNode(this.controller)
  }

  build() {
    NodeContainer(this._nodeController)
  }
}
