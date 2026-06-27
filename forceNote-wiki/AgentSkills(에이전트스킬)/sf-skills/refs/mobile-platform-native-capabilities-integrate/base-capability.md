---
tags: [agent-skill, sf-skills, reference, mobile, base-capability]
source: forcedotcom/sf-skills (skills/mobile-platform-native-capabilities-integrate/references/base-capability.md, 공식 Salesforce)
created: 2026-06-27
aliases: [BaseCapability, 베이스 케이퍼빌리티, isAvailable, 모바일 공통 인터페이스]
---

# BaseCapability — 모바일 네이티브 케이퍼빌리티 공통 인터페이스

> 모든 모바일 네이티브 케이퍼빌리티가 구현하는 공통 인터페이스. `isAvailable()`로 코드 경로를 게이트하여 미지원 환경(데스크톱, 모바일 웹)에서 LWC가 우아하게 동작 저하되도록 한다.

---

## BaseCapability

Common interface implemented by every mobile native capability. Use `isAvailable()` to gate code paths so the LWC degrades gracefully on unsupported surfaces (desktop, mobile web).

```typescript
/*
 * Copyright (c) 2024, Salesforce, Inc.
 * All rights reserved.
 * For full license text, see the LICENSE.txt file
 */

/**
 * Provide all services with common functionalities.
 */
export interface BaseCapability {
  /**
   * Use this function to determine whether the respective service functionality is available.
   * @returns Returns true when used on a supported device and false otherwise.
   */
  isAvailable(): boolean;
}
```

## 관련 노트
- [[mobile-platform-native-capabilities-integrate]]
- [[mobile-capabilities]]
- [[app-review]]
