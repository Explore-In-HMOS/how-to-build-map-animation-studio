@Component
export struct AnimationInfoPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column({ space: 0 }) {
        Text($r('app.string.info_title'))
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 8 })

        Divider()
          .color($r('app.color.divider'))

        Scroll() {
          Column({ space: 0 }) {
            this.buildInfoRow('RotateAnimation', $r('app.string.info_rotate_desc'), $r('app.color.accent_blue'))
            Divider().color($r('app.color.divider'))
            this.buildInfoRow('ScaleAnimation', $r('app.string.info_scale_desc'), $r('app.color.accent_green'))
            Divider().color($r('app.color.divider'))
            this.buildInfoRow('TranslateAnimation', $r('app.string.info_translate_desc'), $r('app.color.accent_orange'))
            Divider().color($r('app.color.divider'))
            this.buildInfoRow('PlayImageAnimation', $r('app.string.info_play_image_desc'), $r('app.color.accent_purple'))
            Divider().color($r('app.color.divider'))
            this.buildInfoRow('AnimationSet', $r('app.string.info_set_desc'), $r('app.color.accent_teal'))
          }
        }
        .layoutWeight(1)

        Divider()
          .color($r('app.color.divider'))

        Button($r('app.string.btn_back'))
          .fontSize($r('app.float.button_font_size'))
          .fontColor($r('app.color.text_secondary'))
          .backgroundColor($r('app.color.btn_inactive'))
          .borderRadius($r('app.float.button_radius'))
          .width('60%')
          .height(40)
          .margin({ top: 10, bottom: 14 })
          .onClick(() => {
            this.pageInfos.pop();
          })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.primary_bg'))
  }

  @Builder
  buildInfoRow(name: string, desc: Resource, accentColor: Resource) {
    Row({ space: 10 }) {
      Column()
        .width(4)
        .height(40)
        .backgroundColor(accentColor)
        .borderRadius(2)

      Column({ space: 4 }) {
        Text(name)
          .fontSize($r('app.float.subtitle_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Text(desc)
          .fontSize($r('app.float.small_font_size'))
          .fontColor($r('app.color.text_secondary'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .alignItems(VerticalAlign.Top)
  }
}
