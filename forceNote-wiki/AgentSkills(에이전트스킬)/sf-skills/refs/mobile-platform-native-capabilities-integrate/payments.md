---
tags: [agent-skill, sf-skills, reference, mobile, payments]
source: forcedotcom/sf-skills (skills/mobile-platform-native-capabilities-integrate/references/payments.md, 공식 Salesforce)
created: 2026-06-27
aliases: [PaymentsService, 결제 서비스, Tap to Pay, collectPayment, Stripe]
---

# Payments Service — 결제 서비스

> 모바일 기기의 결제 기능을 LWC에서 활용하기 위한 API 타입과 메서드의 그라운딩 컨텍스트. Stripe의 Tap to Pay를 실행하는 Nimbus 플러그인으로 결제 수집과 지원 결제 수단 조회를 다룬다.

---

The following content provides grounding information for generating a Salesforce LWC that leverages payments facilities on mobile devices. Specifically, this context will cover the API types and methods available to leverage the payments API of the mobile device, within the LWC.

## Payments Service API

```typescript
/*
 * Copyright (c) 2024, Salesforce, Inc.
 * All rights reserved.
 * For full license text, see the LICENSE.txt file
 */

import { BaseCapability } from '../BaseCapability.js';

/**
 * Use this factory function to get an instance of {@linkcode PaymentsService}.
 * @returns An instance of {@linkcode PaymentsService}.
 */
export function getPaymentsService(): PaymentsService;

/**
 * PaymentsService is a Nimbus plugin that allows JavaScript code in a Lightning web component to call functions that launches Stripe's Tap to Pay capabilities.
 */
export interface PaymentsService extends BaseCapability {
  /**
   * Process payment.
   * @param options The customization options.
   * @returns A Promise object that resolves to {@linkcode CollectPaymentResult} object.
   */
  collectPayment(options: CollectPaymentOptions): Promise<CollectPaymentResult>;

  /**
   * Get the supported payment methods on this device
   * @param options The customization options.
   * @returns  A Promise object that resolves to an array containing {@linkcode PaymentMethod} objects.
   */
  getSupportedPaymentMethods(options: GetSupportedPaymentMethodsOptions): Promise<PaymentMethod[]>;
}

/**
 * PaymentMethod values.
 */
export type PaymentMethod = 'TAP_TO_PAY' | 'CREDIT_CARD_DETAILS' | 'PAY_VIA_LINK';

/**
 * GetSupportedPaymentMethodsOptions interface.
 */
export interface GetSupportedPaymentMethodsOptions {
  countryIsoCode?: string;
  merchantAccountId?: string;
  permissionRationaleText?: string;
}

/**
 * CollectPaymentOptions interface.
 */
export interface CollectPaymentOptions {
  amount: number;
  paymentMethod: PaymentMethod;
  currencyIsoCode: string;
  merchantAccountId: string;
  merchantName: string;
  payerAccountId?: string;
  sourceObjectIds?: string[];
  permissionRationaleText?: string;
}

/**
 * CollectPaymentResult interface.
 */
export interface CollectPaymentResult {
  gatewayRefId?: string;
  guid?: string;
  paymentGatewayId?: string;
  status?: string;
}

/**
 * PaymentsServiceFailure interface.
 */
export interface PaymentsServiceFailure {
  code: PaymentsServiceFailureCode;
  message: string;
}

/**
 * Possible failure codes.
 */
export type PaymentsServiceFailureCode =
  | 'USER_DISMISSED' // User cancelled the operation.
  | 'USER_DENIED_PERMISSION' // Permission to access device location is denied.
  | 'SERVICE_NOT_ENABLED' // The service is not enabled and therefore cannot be used.
  | 'UNKNOWN_REASON'; // An error happened in the native code that is not permission based. Will give more information in the PaymentsServiceFailure message.
```

## 관련 노트
- [[mobile-platform-native-capabilities-integrate]]
- [[base-capability]]
- [[mobile-capabilities]]
