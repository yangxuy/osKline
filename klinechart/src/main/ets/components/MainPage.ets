import { KLineChartController } from '../controller/KLineChartController'
import { KLineViewNode } from "../controller/nodeController";
import { ControllerOptions } from '../type/type';


@Component
export struct KLineChart {
  private _controller: KLineChartController = new KLineChartController();
  private _nodeController: Nullable<KLineViewNode>
  private options?: ControllerOptions;

  aboutToAppear(): void {
    this._controller.setOptions(this.options)
    this._nodeController = new KLineViewNode(this._controller)
  }

  build() {
    NodeContainer(this._nodeController)
  }
}
