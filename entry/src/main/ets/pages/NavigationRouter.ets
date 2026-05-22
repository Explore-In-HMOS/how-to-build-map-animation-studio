import { SplashPage } from './SplashPage';
import { MapStudioPage } from './MapStudioPage';
import { AnimationSettingsPage } from './AnimationSettingsPage';
import { AnimationInfoPage } from './AnimationInfoPage';

@Entry
@Component
struct NavigationRouter {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  @Builder
  routerMap(builderName: string, param: object) {
    if (builderName === 'SplashPage') {
      SplashPage()
    } else if (builderName === 'MapStudioPage') {
      MapStudioPage()
    } else if (builderName === 'AnimationSettingsPage') {
      AnimationSettingsPage()
    } else if (builderName === 'AnimationInfoPage') {
      AnimationInfoPage()
    }
  }

  aboutToAppear() {
    this.pageInfos.pushPathByName('SplashPage', null);
  }

  build() {
    Navigation(this.pageInfos) {
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.routerMap)
  }
}
