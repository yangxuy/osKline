export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends Array<infer U>
    ? Array<DeepPartial<U>>
    : T[P] extends ReadonlyArray<infer X>
      ? ReadonlyArray<DeepPartial<X>>
      : T[P] extends object
        ? DeepPartial<T[P]>
        : T[P]
}

export type DeepRequired<T> = {
  [P in keyof T]-?: T[P] extends Array<infer U>
    ? Array<DeepRequired<U>>
    : T[P] extends ReadonlyArray<infer X>
      ? ReadonlyArray<DeepRequired<X>>
      : T[P] extends object
        ? DeepRequired<T[P]>
        : T[P]
}

export type PickPartial<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
