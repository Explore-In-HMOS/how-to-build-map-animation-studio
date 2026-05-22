@Component
export struct SplashPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column({ space: 20 }) {
          Text($r('app.string.splash_title'))
            .fontSize($r('app.float.title_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)

          Text($r('app.string.splash_subtitle'))
            .fontSize($r('app.float.subtitle_font_size'))
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .padding({ left: 16, right: 16 })

          Button($r('app.string.splash_start'))
            .fontSize($r('app.float.button_font_size'))
            .fontColor(Color.White)
            .backgroundColor($r('app.color.btn_active'))
            .borderRadius($r('app.float.button_radius'))
            .width(140)
            .height(40)
            .onClick(() => {
              this.pageInfos.pushPathByName('MapStudioPage', null);
            })
        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.primary_bg'))
  }
}
