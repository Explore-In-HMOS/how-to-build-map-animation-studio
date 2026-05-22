import { map, mapCommon } from '@kit.MapKit';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AnimationConstants, AnimationType } from '../constants/AnimationConstants';
import { AnimationConfig } from '../models/AnimationConfig';

const TAG = 'MapAnimationViewModel';
const DOMAIN = 0x0000;

@ObservedV2
export class MapAnimationViewModel {
  @Trace config: AnimationConfig = new AnimationConfig();
  @Trace statusText: string = 'Select an animation to start';
  @Trace mapReady: boolean = false;

  private mapController: map.MapComponentController | null = null;
  private marker: map.Marker | null = null;

  setMapController(ctrl: map.MapComponentController): void {
    this.mapController = ctrl;
    this.mapReady = true;
  }

  setMarker(marker: map.Marker): void {
    this.marker = marker;
  }

  async playAnimation(type: AnimationType): Promise<void> {
    if (!this.marker || this.config.isAnimating) {
      return;
    }
    this.config.activeType = type;
    this.config.isAnimating = true;
    this.statusText = `Running: ${this._label(type)}`;

    try {
      switch (type) {
        case AnimationType.ROTATE:
          await this._playRotate();
          break;
        case AnimationType.SCALE:
          await this._playScale();
          break;
        case AnimationType.TRANSLATE:
          await this._playTranslate();
          break;
        case AnimationType.PLAY_IMAGE:
          await this._playImage();
          break;
        case AnimationType.ANIMATION_SET:
          await this._playAnimationSet();
          break;
        default:
          break;
      }
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Animation error: %{public}s', JSON.stringify(err));
    }

    this.config.isAnimating = false;
    this.statusText = `Completed: ${this._label(type)}`;
  }

  private async _playRotate(): Promise<void> {
    const animation: map.RotateAnimation = new map.RotateAnimation(
      AnimationConstants.ROTATE_FROM,
      AnimationConstants.ROTATE_TO
    );
    animation.setDuration(this.config.duration);
    animation.setRepeatCount(this.config.repeatCount);
    this.marker?.setAnimation(animation);
    this.marker?.startAnimation();
    await this._delay(this.config.duration * this.config.repeatCount + 200);
  }

  private async _playScale(): Promise<void> {
    const animation: map.ScaleAnimation = new map.ScaleAnimation(
      AnimationConstants.SCALE_FROM,
      AnimationConstants.SCALE_TO,
      AnimationConstants.SCALE_FROM,
      AnimationConstants.SCALE_TO
    );
    animation.setDuration(this.config.duration);
    animation.setRepeatCount(this.config.repeatCount);
    this.marker?.setAnimation(animation);
    this.marker?.startAnimation();
    await this._delay(this.config.duration * this.config.repeatCount + 200);
  }

  private async _playTranslate(): Promise<void> {
    const target: mapCommon.LatLng = {
      latitude: AnimationConstants.MAP_CENTER_LAT + AnimationConstants.TRANSLATE_OFFSET_LAT,
      longitude: AnimationConstants.MAP_CENTER_LNG + AnimationConstants.TRANSLATE_OFFSET_LNG
    };
    const animation: map.TranslateAnimation = new map.TranslateAnimation(target);
    animation.setDuration(this.config.duration);
    animation.setRepeatCount(this.config.repeatCount);
    this.marker?.setAnimation(animation);
    this.marker?.startAnimation();
    await this._delay(this.config.duration * this.config.repeatCount + 200);
    await this._resetMarkerPosition();
  }

  private async _playImage(): Promise<void> {
    const frames: Array<ResourceStr | image.PixelMap> = [
      $r('app.media.frame0'),
      $r('app.media.frame1'),
      $r('app.media.frame2'),
      $r('app.media.frame3')
    ];
    const animation: map.PlayImageAnimation = new map.PlayImageAnimation();
    await animation.addImages(frames);
    animation.setDuration(this.config.duration);
    animation.setRepeatCount(this.config.repeatCount);
    this.marker?.setAnimation(animation);
    this.marker?.startAnimation();
    await this._delay(this.config.duration * this.config.repeatCount + 200);
  }

  private async _playAnimationSet(): Promise<void> {
    const rotAnim: map.RotateAnimation = new map.RotateAnimation(
      AnimationConstants.ROTATE_FROM,
      AnimationConstants.ROTATE_TO
    );
    rotAnim.setDuration(this.config.duration);

    const scaleAnim: map.ScaleAnimation = new map.ScaleAnimation(
      AnimationConstants.SCALE_FROM,
      AnimationConstants.SCALE_TO,
      AnimationConstants.SCALE_FROM,
      AnimationConstants.SCALE_TO
    );
    scaleAnim.setDuration(this.config.duration);

    const animSet: map.AnimationSet = new map.AnimationSet(true);
    animSet.addAnimation(rotAnim);
    animSet.addAnimation(scaleAnim);
    animSet.setDuration(this.config.duration);
    animSet.setRepeatCount(this.config.repeatCount);
    this.marker?.setAnimation(animSet);
    this.marker?.startAnimation();
    await this._delay(this.config.duration * this.config.repeatCount + 200);
  }

  private async _resetMarkerPosition(): Promise<void> {
    const origin: mapCommon.LatLng = {
      latitude: AnimationConstants.MAP_CENTER_LAT,
      longitude: AnimationConstants.MAP_CENTER_LNG
    };
    const resetAnim: map.TranslateAnimation = new map.TranslateAnimation(origin);
    resetAnim.setDuration(500);
    this.marker?.setAnimation(resetAnim);
    this.marker?.startAnimation();
    await this._delay(600);
  }

  private _delay(ms: number): Promise<void> {
    return new Promise<void>((resolve) => {
      setTimeout(resolve, ms);
    });
  }

  private _label(type: AnimationType): string {
    const labels: Record<string, string> = {
      [AnimationType.ROTATE]: 'RotateAnimation',
      [AnimationType.SCALE]: 'ScaleAnimation',
      [AnimationType.TRANSLATE]: 'TranslateAnimation',
      [AnimationType.PLAY_IMAGE]: 'PlayImageAnimation',
      [AnimationType.ANIMATION_SET]: 'AnimationSet'
    };
    return labels[type] ?? type;
  }
}

export const mapAnimationViewModel: MapAnimationViewModel = new MapAnimationViewModel();
