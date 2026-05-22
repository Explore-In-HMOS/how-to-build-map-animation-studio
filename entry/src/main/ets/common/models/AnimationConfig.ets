import { AnimationConstants, AnimationType } from '../constants/AnimationConstants';

@ObservedV2
export class AnimationConfig {
  @Trace duration: number = AnimationConstants.DEFAULT_DURATION;
  @Trace repeatCount: number = AnimationConstants.DEFAULT_REPEAT_COUNT;
  @Trace activeType: AnimationType = AnimationType.ROTATE;
  @Trace isAnimating: boolean = false;
}
