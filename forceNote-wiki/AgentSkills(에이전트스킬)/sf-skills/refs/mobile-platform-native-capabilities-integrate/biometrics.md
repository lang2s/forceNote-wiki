---
tags: [agent-skill, sf-skills, reference, mobile, biometrics]
source: forcedotcom/sf-skills (skills/mobile-platform-native-capabilities-integrate/references/biometrics.md, 공식 Salesforce)
created: 2026-06-27
aliases: [BiometricsService, 생체 인증 서비스, 지문, 얼굴 인식, checkUserIsDeviceOwner]
---

# Biometrics Service — 생체 인증 서비스

> 모바일 기기의 생체 인증(얼굴 인식·지문 스캐너) 기능을 LWC에서 활용하기 위한 API 타입과 메서드의 그라운딩 컨텍스트. 기기 소유자 인증에 사용한다.

---

The following content provides grounding information for generating a Salesforce LWC that leverages biometrics scanning facilities on mobile devices. Specifically, this context will cover the API types and methods available to leverage the face recognition and the finger printing scanner of the mobile device to authorize the user, within the LWC.

## Biometrics Service API

```typescript
/*
 * Copyright (c) 2024, Salesforce, Inc.
 * All rights reserved.
 * For full license text, see the LICENSE.txt file
 */

import { BaseCapability } from '../BaseCapability.js';

/**
 * Use this factory function to get an instance of {@linkcode BiometricsService}.
 * @returns An instance of {@linkcode BiometricsService}.
 */
export function getBiometricsService(): BiometricsService;

/**
 * Access a device’s biometrics capabilities from a Lightning web component.
 * @see {@link https://developer.salesforce.com/docs/platform/lwc/guide/reference-lightning-biometricsservice.html|BiometricsService API}
 */
export interface BiometricsService extends BaseCapability {
  /**
   * Verify if the biometrics hardware or pin code is available to use to verify the user’s device ownership.
   * @param options A {@linkcode BiometricsServiceOptions} object to configure the {@linkcode BiometricsService} request.
   * @returns A Promise object that resolves as a Boolean value. True if the biometrics hardware or pin code is available for use and false otherwise.
   */
  isBiometricsReady(options?: BiometricsServiceOptions): Promise<boolean>;

  /**
   * Verify if the user is the device owner using the device’s biometrics hardware or pin code.
   * @param options A {@linkcode BiometricsServiceOptions} object to configure the {@linkcode BiometricsService} request.
   * @returns A Promise object that resolves as a Boolean value. True if the user is the registered device owner and false otherwise.
   */
  checkUserIsDeviceOwner(options?: BiometricsServiceOptions): Promise<boolean>;
}

/**
 * An object for specifying which instances of a recurring event are affected by an update to or deletion of one instance of the event.
 */
export interface BiometricsServiceOptions {
  /**
   * Reason to use biometrics scanner.
   */
  permissionRequestBody?: string;

  /**
   * Title used in the dialog when the reason text is displayed. Allowed on iOS, but effective only on Android.
   */
  permissionRequestTitle?: string;

  /**
   * Policies specified in the array allows customization of the biometrics scan behavior.
   */
  additionalSupportedPolicies?: BiometricsServicePolicy[];
}

/**
 * An object representing policy to use pin code as an alternative to biometrics.
 */
export type BiometricsServicePolicy = /** User cancelled the operation. */ 'PIN_CODE';

/**
 * An object representing an error that occurred when accessing {@linkcode BiometricsService} features.
 */
interface BiometricsServiceFailure {
  /**
   * A value representing the reason for a biometrics service error. See {@linkcode BiometricsServiceFailureCode} for the list of possible values.
   */
  code: BiometricsServiceFailureCode;

  /**
   * A string value describing the reason for the failure. This value is suitable for use in user interface messages. The message is provided in English and isn’t localized.
   */
  message: string;
}

/**
 * Correlates with the code property on the {@linkcode BiometricsServiceFailure} object.
 */
type BiometricsServiceFailureCode =
  | 'HARDWARE_NOT_AVAILABLE' // There is no fingerprint scanner or face recognition hardware found.
  | 'NOT_CONFIGURED' // Biometrics hardware was found but has not been set up yet.
  | 'SERVICE_NOT_ENABLED' // BiometricsService is not enabled and cannot be used.
  | 'UNKNOWN_REASON'; // An error occurred in the native code that isn’t related to permissions or hardware issues. More information is provided in the BiometricsServiceFailure message.
```

## 관련 노트
- [[mobile-platform-native-capabilities-integrate]]
- [[base-capability]]
- [[mobile-capabilities]]
