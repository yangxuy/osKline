import { ControllerOptions } from "../type/type";

export function getRandomColor() {
  let randColor = (Math.random() * 0xffffff << 0).toString(16)

  while (randColor.length < 6) {
    randColor = "0" + randColor;
  }

  return "#" + randColor;
}

export function rgbToHex(r: number, g: number, b: number) {
  return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

export function formatTime(timestamp: number, format?: string) {
  const date = new Date(timestamp)
  const Y = date.getFullYear()
  const M = date.getMonth()
  const D = date.getDate()

  const h = date.getHours()
  const m = date.getMinutes()
  const s = date.getSeconds()

  return `${h}:${m}:${s}`
}

export function mergeOptions(options?: ControllerOptions): ControllerOptions {
  let opt: ControllerOptions = {
    locale: "",
    styles: "dark"
  }

  if (options?.styles) {
    opt.styles = options.styles
  }

  return opt

}