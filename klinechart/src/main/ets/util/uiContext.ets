export class KlineUIContext {
  static _instance: KlineUIContext

  static get instance() {
    return KlineUIContext._instance ??= new KlineUIContext()
  }

  context!: UIContext

  getUIContext(): UIContext {
    return this.context
  }
}