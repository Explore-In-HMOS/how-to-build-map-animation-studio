import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { mapAnimationViewModel } from '../common/viewmodel/MapAnimationViewModel';
import { AnimationConstants, AnimationType } from '../common/constants/AnimationConstants';

const DOMAIN = 0x0000;
const TAG = 'MapStudioPage';

interface AnimationButton {
  type: AnimationType;
  label: string;
  color: Resource;
}

@Component
export struct MapStudioPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  private mapOptions: mapCommon.MapOptions = {
    position: {
      target: {
        latitude: AnimationConstants.MAP_CENTER_LAT,
        longitude: AnimationConstants.MAP_CENTER_LNG
      },
      zoom: AnimationConstants.MAP_ZOOM
    }
  };
  private animationButtons: AnimationButton[] = [
    { type: AnimationType.ROTATE, label: 'Rotate', color: $r('app.color.accent_blue') },
    { type: AnimationType.SCALE, label: 'Scale', color: $r('app.color.accent_green') },
    { type: AnimationType.TRANSLATE, label: 'Translate', color: $r('app.color.accent_orange') },
    { type: AnimationType.PLAY_IMAGE, label: 'Play', color: $r('app.color.accent_purple') },
    { type: AnimationType.ANIMATION_SET, label: 'All', color: $r('app.color.accent_teal') }
  ];

  private async onMapReady(ctrl: map.MapComponentController): Promise<void> {
    mapAnimationViewModel.setMapController(ctrl);
    const eventManager = ctrl.getEventManager();
    eventManager.on('mapLoad', async () => {
      try {
        const markerOptions: mapCommon.MarkerOptions = {
          position: {
            latitude: AnimationConstants.MAP_CENTER_LAT,
            longitude: AnimationConstants.MAP_CENTER_LNG
          },
          clickable: true,
          draggable: false,
          anchorU: 0.5,
          anchorV: 1
        };
        const marker = await ctrl.addMarker(markerOptions);
        mapAnimationViewModel.setMarker(marker);
      } catch (err) {
        hilog.error(DOMAIN, TAG, 'Failed to add marker: %{public}s', JSON.stringify(err));
      }
    });
  }

  @Builder
  buildAnimationButton(item: AnimationButton) {

    GridItem() {
      Button() {
        Text(item.label)
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .fontSize(11)
      }
      .fontSize($r('app.float.small_font_size'))
      .fontColor(Color.White)
      .backgroundColor(
        mapAnimationViewModel.config.activeType === item.type && mapAnimationViewModel.config.isAnimating
          ? item.color
          : $r('app.color.btn_inactive')
      )
      .borderRadius($r('app.float.button_radius'))
      .width(57)
      .height(26)
      .enabled(!mapAnimationViewModel.config.isAnimating)
      .onClick(() => {
        mapAnimationViewModel.playAnimation(item.type);
      })
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {

          Button() {
            Image($r('app.media.settings'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
          }
          .align(Alignment.Center)
          .fontSize($r('app.float.small_font_size'))
          .fontColor($r('app.color.text_secondary'))
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.pageInfos.pushPathByName('AnimationSettingsPage', null);
          })
          .width('15%')


          Text($r('app.string.studio_title'))
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .width('32%')

          Button() {
            SymbolGlyph($r('sys.symbol.info_rectangle_portrait'))
              .fontSize(24)
              .fontColor([Color.White])
          }
          .fontSize($r('app.float.small_font_size'))
          .fontColor($r('app.color.text_secondary'))
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.pageInfos.pushPathByName('AnimationInfoPage', null);
          })
          .width('15%')
          .align(Alignment.Start)

        }
        .width('100%')
        .height('21%')
        .justifyContent(FlexAlign.Center)

        Stack({ alignContent: Alignment.Bottom }) {
          MapComponent({
            mapOptions: this.mapOptions,
            mapCallback: (err: BusinessError, ctrl: map.MapComponentController) => {
              if (!err) {
                this.onMapReady(ctrl);
              } else {
                hilog.error(DOMAIN, TAG, 'Map init error: %{public}s', JSON.stringify(err));
              }
            }
          })
            .width('100%')
            .layoutWeight(1)

          Column({ space: 1 }) {
            Text(mapAnimationViewModel.statusText)
              .fontSize($r('app.float.small_font_size'))
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .maxLines(1)

            Row({ space: 1 }) {
              this.buildAnimationButton(this.animationButtons[0])
              this.buildAnimationButton(this.animationButtons[1])
              this.buildAnimationButton(this.animationButtons[2])

            }
            .justifyContent(FlexAlign.Center)
            .width('85%')

            Row({ space: 1 }) {
              this.buildAnimationButton(this.animationButtons[3])
              this.buildAnimationButton(this.animationButtons[4])
            }
            .width('55%')
            .justifyContent(FlexAlign.Center)

          }
          .width('100%')
          .height('35%')
          .padding({
            left: 8,
            right: 8,
            bottom: 1,
            top: 1
          })
          .backgroundColor(Color.Transparent)
        }
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.primary_bg'))
  }
}
