## 0.5.0+1

 - **FIX**: type and linter errors ([#54](https://github.com/blaugold/fleet/issues/54)). ([011f2dee](https://github.com/blaugold/fleet/commit/011f2deea5b00cfc204afc4fedac66b017b4c695))

## 0.5.0

> Note: This release has breaking changes.

 - **FEAT**: add more drop-in replacements for Flutter widgets ([#53](https://github.com/blaugold/fleet/issues/53)). ([e79ac71a](https://github.com/blaugold/fleet/commit/e79ac71aad5ce4f353c9107f41b8df94ee895932))
 - **BREAKING** **FEAT**: streamline modifier API by overloading modifier methods ([#52](https://github.com/blaugold/fleet/issues/52)). ([42a676f2](https://github.com/blaugold/fleet/commit/42a676f23b14fa993853982db97852e9a1c97f13))

## 0.4.0

> Note: This release has breaking changes.

 - **REFACTOR**: restructure source files and categories ([#47](https://github.com/blaugold/fleet/issues/47)). ([12daa157](https://github.com/blaugold/fleet/commit/12daa157b9e8fb90414bc6d13c06ded35c8a9ec1))
 - **FEAT**: add `fleet_imports` package ([#51](https://github.com/blaugold/fleet/issues/51)). ([8a93e9d0](https://github.com/blaugold/fleet/commit/8a93e9d03d0534a1cc059a5760d89dbd6c38696b))
 - **FEAT**: add `FleetFlex` and related widgets ([#50](https://github.com/blaugold/fleet/issues/50)). ([4525bb91](https://github.com/blaugold/fleet/commit/4525bb91c21b52e54f7e019624fd9f0fddda0744))
 - **FEAT**: add `UniformPadding` ([#46](https://github.com/blaugold/fleet/issues/46)). ([a33f4d89](https://github.com/blaugold/fleet/commit/a33f4d891cb2c158b62143e05f5f63e951b03908))
 - **FEAT**: make `AnimatableRenderObjectWidget` work with `InheritedWidget`s ([#45](https://github.com/blaugold/fleet/issues/45)). ([677060d5](https://github.com/blaugold/fleet/commit/677060d528643b93f79de0aa899d742e44c143a7))
 - **FEAT**: add `AnimatableStatelessWidget` ([#44](https://github.com/blaugold/fleet/issues/44)). ([fd949360](https://github.com/blaugold/fleet/commit/fd949360c4c5ed833ecbca7beb19e7d9bd8accc3))
 - **FEAT**: add extension-based widget API ([#41](https://github.com/blaugold/fleet/issues/41)). ([8c3d283b](https://github.com/blaugold/fleet/commit/8c3d283b8b1ce74e44f5276e839ba87e1c17f738))
 - **FEAT**: support always animating state changes with `Animated` ([#40](https://github.com/blaugold/fleet/issues/40)). ([4d2533e4](https://github.com/blaugold/fleet/commit/4d2533e43fa252bbec07e12f0a5a14d630b8372d))
 - **BREAKING** **REFACTOR**: use `Fleet` as the prefix for Flutter drop-in replacements ([#48](https://github.com/blaugold/fleet/issues/48)). ([fe20ceb5](https://github.com/blaugold/fleet/commit/fe20ceb516c2d65df53b220305c3203ea2d189ec))
 - **BREAKING** **FEAT**: remove `AnimatableState(Mixin)?` ([#49](https://github.com/blaugold/fleet/issues/49)). ([6996c597](https://github.com/blaugold/fleet/commit/6996c597d2ad3055bb00a397c78adaf2f40148f4))
 - **BREAKING** **FEAT**: support making `RenderObjectWidget`s animatable ([#43](https://github.com/blaugold/fleet/issues/43)). ([adf9fb01](https://github.com/blaugold/fleet/commit/adf9fb01567956052739db6ced821a905a04b8de))
 - **BREAKING** **FEAT**: upgrade SDK constraints ([#42](https://github.com/blaugold/fleet/issues/42)). ([5e4d611a](https://github.com/blaugold/fleet/commit/5e4d611a2a27189c5ae1f6bdda0d0831fae5bca2))

## 0.3.0

> Note: This release has breaking changes.

 - **FIX**: scheduling transactions while building ([#36](https://github.com/blaugold/fleet/issues/36)). ([ff9fe03d](https://github.com/blaugold/fleet/commit/ff9fe03ddad1dcce25dc96a21301b2e7e70b632d))
 - **BREAKING** **FEAT**: make transactions always synchronous ([#38](https://github.com/blaugold/fleet/issues/38)). ([8005fa8f](https://github.com/blaugold/fleet/commit/8005fa8f440f0b24764ce0d4afb800c6f5357103))

## 0.2.0

> Note: This release has breaking changes.

 - **FIX**: support scheduling transactions while building ([#35](https://github.com/blaugold/fleet/issues/35)). ([0cb5d90c](https://github.com/blaugold/fleet/commit/0cb5d90c4e6cec6419df12126bf5f57e30c3c7ba))
 - **FIX**: give local transaction the highest precedence ([#33](https://github.com/blaugold/fleet/issues/33)). ([c0737c44](https://github.com/blaugold/fleet/commit/c0737c4435c09dfd03aff5acef650dc7987ed444))
 - **BREAKING** **FEAT**: turn `SetStateWithAnimationExtension` into  `AnimatingStateMixin` for proper ordering of state changes ([#34](https://github.com/blaugold/fleet/issues/34)). ([6bc4079a](https://github.com/blaugold/fleet/commit/6bc4079a051ee7ec2353871b19be1ce222a083f0))
 - **BREAKING** **FEAT**: require `animation` and `value` for `Animated` ([#32](https://github.com/blaugold/fleet/issues/32)). ([93205068](https://github.com/blaugold/fleet/commit/932050684934fac4af9decee17d965b3a056ffde))
 - **BREAKING** **FEAT**: rename `setStateWithAnimation` to `setStateWithAnimationAsync` and `withAnimation` to `withAnimationAsync` ([#26](https://github.com/blaugold/fleet/issues/26)). ([23606ef4](https://github.com/blaugold/fleet/commit/23606ef486fa90396d39f88829db0e945871b732))

## 0.1.3+1

 - **DOCS**: reword a few sentences. ([c243c225](https://github.com/blaugold/fleet/commit/c243c225c0e6c08c20374e17367b320c94caa2ec))
 - **DOCS**: explain state-based approach. ([d39c77f1](https://github.com/blaugold/fleet/commit/d39c77f1c2d2c29c817e910685ef8fbf05c3ad19))
 - **DOCS**: fix typos. ([27c72ab8](https://github.com/blaugold/fleet/commit/27c72ab8d01760c474550063a41bd1eb59b4bed2))

## 0.1.3

 - **FEAT**: add `APositioned`, `APositionedDirectional` and `ATransform` ([#23](https://github.com/blaugold/fleet/issues/23)). ([9910986d](https://github.com/blaugold/fleet/commit/9910986d0f689008ed475e5f90d6a329ef90ecd0))
 - **FEAT**: slightly revise API and improve doc comments ([#22](https://github.com/blaugold/fleet/issues/22)). ([7ddd4ef9](https://github.com/blaugold/fleet/commit/7ddd4ef93fe840b8520c3e892e40ad660b86280a))

## 0.1.2

 - **FEAT**: add widgets for padding and opacity ([#21](https://github.com/blaugold/fleet/issues/21)). ([c389a655](https://github.com/blaugold/fleet/commit/c389a655003f82e7feef081a0fc0c2e985a78b47))
 - **DOCS**: add feature list and categories ([#20](https://github.com/blaugold/fleet/issues/20)). ([e0300e09](https://github.com/blaugold/fleet/commit/e0300e09889a16aff96cd78883d7213641718b47))

## 0.1.1

 - **FIX**: ensure animations finish at target value ([#19](https://github.com/blaugold/fleet/issues/19)). ([49126dc5](https://github.com/blaugold/fleet/commit/49126dc5fc315bc34cd62c9d060d83645b501531))
 - **FEAT**: add extensions for creating `AnimationSpec` and `Duration`. ([97ec3218](https://github.com/blaugold/fleet/commit/97ec3218a1562cd95b7030ad1bad2307be353507))
 - **DOCS**: fix more typos. ([095cdd9f](https://github.com/blaugold/fleet/commit/095cdd9f8ff7ae4182a54de64a00281f535da3b2))
 - **DOCS**: fix typos. ([7508784f](https://github.com/blaugold/fleet/commit/7508784f7595aaa98530924640edc3b4026b573e))
 - **DOCS**: add interactive animation demo and improve README. ([f2dd0507](https://github.com/blaugold/fleet/commit/f2dd050787ad1d5cb51a4206b4445c509d46affb))

## 0.1.0

 - Initial release


