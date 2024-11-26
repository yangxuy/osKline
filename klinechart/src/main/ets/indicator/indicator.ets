export interface KLineIndicator {
  name: string,
  datas: Record<string, ESObject>[],
  calcFunction: Function
  batchDrawData: Function
}

export interface KLineFigure {
  key: string;
  title: string;
  type: string;
  gap: number,
  color: string | number
}