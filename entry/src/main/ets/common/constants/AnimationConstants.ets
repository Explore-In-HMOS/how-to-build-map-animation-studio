export class AnimationConstants {
  static readonly DEFAULT_DURATION: number = 2000;
  static readonly DEFAULT_REPEAT_COUNT: number = 1;
  static readonly MIN_DURATION: number = 500;
  static readonly MAX_DURATION: number = 5000;
  static readonly MAP_CENTER_LAT: number = 39.9334;
  static readonly MAP_CENTER_LNG: number = 32.8597;
  static readonly MAP_ZOOM: number = 13;
  static readonly TRANSLATE_OFFSET_LAT: number = 0.012;
  static readonly TRANSLATE_OFFSET_LNG: number = 0.015;
  static readonly ROTATE_FROM: number = 0;
  static readonly ROTATE_TO: number = 360;
  static readonly SCALE_FROM: number = 1;
  static readonly SCALE_TO: number = 2.5;
  static readonly FRAME_COUNT: number = 4;
}

export const enum AnimationType {
  ROTATE = 'ROTATE',
  SCALE = 'SCALE',
  TRANSLATE = 'TRANSLATE',
  PLAY_IMAGE = 'PLAY_IMAGE',
  ANIMATION_SET = 'ANIMATION_SET'
}
