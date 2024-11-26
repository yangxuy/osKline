import { DeepPartial } from "../type/extention";
import { KLineStyles } from "../type/type";

export const dark: DeepPartial<KLineStyles> = {
  grid: {
    show: true,
    horizontal: {
      size: 1,
      length: 4,
      color: '#292929'
    },
    vertical: {
      size: 1,
      length: 5,
      color: '#292929'
    }
  },
  candle: {
    area: {
      lineSize: 7,
      lineGap: 2
    },
    color: {
      upColor: 0xFF16D5A8,
      downColor: 0xFFFF3B71
    },
    price: {
      color: 0xff7287A5,
      textSize: '50px',
      textOffset: 15,
      precision: 0.7,
      rightPadding: 8,
      lineSize: 1
    }
  },
  indicator: {
    tooltip: {
      text: {
        color: '#929AA5',
        fontSize: "30px",
        gap: 10
      }
    }
  },
  crosshair: {
    horizontal: {
      line: {
        color: '#929AA5'
      },
      text: {
        borderColor: '#373a40',
        backgroundColor: '#373a40'
      }
    },
    vertical: {
      line: {
        color: '#929AA5'
      },
      text: {
        borderColor: '#373a40',
        backgroundColor: '#373a40'
      }
    }
  },
  common: {
    backgroundColor: 0xFF171929,
    height: 350,
    defaultRightWidth: 80
  },
  time: {
    size: '50px',
    length: 3,
    color: 0xff7287A5
  }
}