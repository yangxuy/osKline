import { DeepPartial } from '../type/extention'
import { KLineStyles } from '../type/type'
import { dark } from './dark'
import { light } from './light'

const styles: Record<string, DeepPartial<KLineStyles>> = {}

function registerStyles(name: string, ss: DeepPartial<KLineStyles>): void {
  styles[name] = ss
}

function getStyles(name: string): DeepPartial<KLineStyles> {
  return styles[name]
}

registerStyles('dark', dark)
registerStyles('light', light)

export {
  registerStyles, getStyles
}
