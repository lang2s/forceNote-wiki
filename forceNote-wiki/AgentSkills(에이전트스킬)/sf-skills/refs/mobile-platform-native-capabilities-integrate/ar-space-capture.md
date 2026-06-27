---
tags: [agent-skill, sf-skills, reference, mobile, ar-space-capture]
source: forcedotcom/sf-skills (skills/mobile-platform-native-capabilities-integrate/references/ar-space-capture.md, 공식 Salesforce)
created: 2026-06-27
aliases: [ARSpaceCapture, AR 공간 캡처, scanRoom, RoomPlan, 방 스캔]
---

# AR Space Capture Service — AR 공간 캡처 서비스

> 모바일 기기의 AR 공간 캡처 기능을 LWC에서 활용하기 위한 API 타입과 메서드의 그라운딩 컨텍스트. Apple의 RoomPlan AR 기능으로 방을 스캔한다.

---

The following content provides grounding information for generating a Salesforce LWC that leverages AR Space Capture facilities on mobile devices. Specifically, this context will cover the API types and methods available to leverage the AR Space Capture API of the mobile device, within the LWC.

## AR Space Capture Service API

```typescript
/*
 * Copyright (c) 2024, Salesforce, Inc.
 * All rights reserved.
 * For full license text, see the LICENSE.txt file
 */

import { BaseCapability } from '../BaseCapability.js';

/**
 * Use this factory function to get an instance of {@linkcode ARSpaceCapture}.
 * @returns An instance of {@linkcode ARSpaceCapture}.
 */
export function getARSpaceCapture(): ARSpaceCapture;

/**
 * Scan a room using Apple's RoomPlan AR Capabilities.
 */
export interface ARSpaceCapture extends BaseCapability {
  /**
   * Scan Room using Apple's AR Capabilities.
   * @param options The customization options for the {@linkcode ARSpaceCapture} Plugin.
   * @returns A resolved promise returns {@linkcode ARSpaceCaptureResult} object.
   */
  scanRoom(options?: ARSpaceCaptureOptions): Promise<ARSpaceCaptureResult>;
}

/**
 * ARSpaceCaptureResult interface.
 */
export interface ARSpaceCaptureResult {
  capturedRooms: CapturedRoom[] | null;
}

/**
 * CapturedRoom interface.
 */
export interface CapturedRoom {
  /**
   * An array of walls that the framework identifies during a scan.
   */
  walls: unknown[];

  /**
   * An array of doors that the framework identifies during a scan.
   */
  doors: unknown[];

  /**
   * An array of windows that the framework identifies during a scan.
   */
  windows: unknown[];

  /**
   * An array of openings that the framework identifies during a scan.
   */
  openings: unknown[];

  /**
   * An array of floors that the framework identifies during a scan.
   * Available iOS 17.0+.
   */
  floors: unknown[];

  /**
   * An array of objects that the framework identifies during a scan.
   */
  objects: unknown[];

  /**
   * A unique alphanumeric value that the framework assigns the room.
   */
  identifier: string;

  /**
   * One or more room types that the framework observes in the room.
   * Available iOS 17.0+.
   */
  sections: unknown[];

  /**
   * The story, floor number, or level on which the captured room resides within a larger structure.
   * Available iOS 17.0+.
   */
  story: number;

  /**
   * A version number for the captured room.
   * Available iOS 17.0+.
   */
  version: number;
}

/**
 * ARSpaceCaptureOptions interface.
 */
export interface ARSpaceCaptureOptions {
  permissionRationaleText?: string;
  presentWithAnimation: boolean;
}

/**
 * ARSpaceCaptureFailure interface.
 */
export interface ARSpaceCaptureFailure {
  code: ARSpaceCaptureFailureCode;
  message: string;
}

/**
 * Possible failure codes.
 */
type ARSpaceCaptureFailureCode =
  | 'USER_DISMISSED' // User cancelled the operation.
  | 'USER_DENIED_PERMISSION' // The user denied permissions to use the device camera.
  | 'AR_NOT_SUPPORTED' // The AR capabilities are not enabled/available on the device.
  | 'SERVICE_NOT_ENABLED' // The service is not enabled and therefore cannot be used.
  | 'UNKNOWN_REASON'; // An error happened in the native code that is not permission based. Will give more information in the ARSpaceCaptureFailure message
```

## 관련 노트
- [[mobile-platform-native-capabilities-integrate]]
- [[base-capability]]
- [[mobile-capabilities]]
