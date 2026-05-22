import { mapAnimationViewModel } from '../common/viewmodel/MapAnimationViewModel';
import { AnimationConstants } from '../common/constants/AnimationConstants';

@Component
export struct AnimationSettingsPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  @State localDuration: number = AnimationConstants.DEFAULT_DURATION;
  @State localRepeat: number = AnimationConstants.DEFAULT_REPEAT_COUNT;

  aboutToAppear() {
    this.localDuration = mapAnimationViewModel.config.duration;
    this.localRepeat = mapAnimationViewModel.config.repeatCount;
  }

  build() {
    NavDestination() {
      Column({ space: 7 }) {
        Text($r('app.string.settings_title'))
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 15 })

        Divider()
          .color($r('app.color.divider'))

        Column({ space: 2 }) {
          Row() {
            Text($r('app.string.settings_duration'))
              .fontSize($r('app.float.subtitle_font_size'))
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)
              .width(250)

            Text(`${this.localDuration} ms`)
              .fontSize($r('app.float.subtitle_font_size'))
              .fontColor($r('app.color.text_primary'))
              .width(80)
              .textAlign(TextAlign.End)
          }
          .width('120%')
          .height(32)

          Slider({
            value: this.localDuration,
            min: AnimationConstants.MIN_DURATION,
            max: AnimationConstants.MAX_DURATION,
            step: 100,
            style: SliderStyle.InSet
          })
            .width('100%')
            .trackColor($r('app.color.btn_inactive'))
            .selectedColor($r('app.color.btn_active'))
            .onChange((value: number) => {
              this.localDuration = Math.round(value / 100) * 100;
            })
            .height('17.00vp')
            .trackThickness('13.00vp')

        }
        .padding({ left: 16, right: 16 })

        Divider()
          .color($r('app.color.divider'))

        Column({ space: 2 }) {
          Row() {
            Text($r('app.string.settings_repeat'))
              .fontSize($r('app.float.subtitle_font_size'))
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)
              .textAlign(TextAlign.Start)

            Text(`${this.localRepeat}x`)
              .fontSize($r('app.float.subtitle_font_size'))
              .fontColor($r('app.color.text_primary'))
              .width(40)
              .textAlign(TextAlign.End)
          }
          .width('100%')

          Slider({
            value: this.localRepeat,
            min: 1,
            max: 5,
            step: 1,
            style: SliderStyle.InSet
          })
            .trackThickness('13.00vp')
            .width('100%')
            .height('17.00vp')
            .trackColor($r('app.color.btn_inactive'))
            .selectedColor($r('app.color.btn_active'))
            .onChange((value: number) => {
              this.localRepeat = Math.round(value);
            })
        }
        .padding({ left: 16, right: 16 })

        Divider()
          .color($r('app.color.divider'))

        Row({ space: 12 }) {
          Button($r('app.string.btn_back'))
            .fontSize($r('app.float.button_font_size'))
            .fontColor($r('app.color.text_secondary'))
            .backgroundColor($r('app.color.btn_inactive'))
            .borderRadius($r('app.float.button_radius'))
            .layoutWeight(1)
            .height(30)
            .onClick(() => {
              this.pageInfos.pop();
            })

          Button($r('app.string.settings_save'))
            .fontSize($r('app.float.button_font_size'))
            .fontColor(Color.White)
            .backgroundColor($r('app.color.btn_active'))
            .borderRadius($r('app.float.button_radius'))
            .layoutWeight(1)
            .height(30)
            .onClick(() => {
              mapAnimationViewModel.config.duration = this.localDuration;
              mapAnimationViewModel.config.repeatCount = this.localRepeat;
              this.pageInfos.pop();
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('80%')
      .height('80%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.primary_bg'))
  }
}
