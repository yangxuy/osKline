export class OffsetPosition {
  x: number
  y: number

  constructor(x: number, y: number) {
    this.x = x
    this.y = y
  }
}

export class Canvas2d extends CanvasRenderingContext2D {
  drawLine(d1: OffsetPosition, d2: OffsetPosition) {
    this.beginPath()
    this.moveTo(d1.x, d1.y)
    this.lineTo(d2.x, d2.y)
    this.closePath()
    this.stroke()
  }

  drawText(text: string, p: OffsetPosition) {
    this.fillText(text, p.x, p.y)
  }

  drawRect(){
    // this.fillRect()
  }
}