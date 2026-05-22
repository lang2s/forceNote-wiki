---
tags: [Apex, Namespace, Sfdc_Checkout, B2B-Commerce, Checkout, CartProcessing, Integration]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-23
aliases: [Sfdc_Checkout, sfdc_checkout, B2B Commerce Checkout Apex, AsyncCartProcessor, B2BCheckoutController, IntegrationInfo, IntegrationStatus]
---

# Sfdc_Checkout Namespace

> B2B Commerce 앱 체크아웃 통합을 위한 Apex 인터페이스·클래스 모음 — 비동기 카트 처리, GMV 추적, 통합 상태 관리

---

## 개념 설명

`Sfdc_Checkout`(네임스페이스 API명: `sfdc_checkout`) 네임스페이스는 **Salesforce B2B Commerce의 체크아웃 프로세스**를 Apex로 커스터마이징하기 위한 클래스와 인터페이스를 제공한다.

체크아웃 단계에서 외부 시스템(재고 확인, 가격 계산, 세금 계산, 배송비 계산 등)과 비동기로 통합할 때 이 네임스페이스를 사용한다.

---

## 클래스 목록

| 클래스/인터페이스 | 설명 |
|---|---|
| `AsyncCartProcessor` | 비동기 B2B Commerce 통합 구현 인터페이스 (기본 인터페이스) |
| `B2BCheckoutController` | 간단한 체크아웃 Apex 메서드 제공 — GMV 추적 |
| `IntegrationInfo` | B2B Commerce Checkout이 요청-응답 매핑에 사용하는 값 제공 |
| `IntegrationStatus` | 동기 Apex 통합 실행 지원 — 실행 상태 반환 |
| `IntegrationStatus.Status` | 통합 상태 enum (SUCCESS / FAILED) |

---

## AsyncCartProcessor Interface

비동기 B2B Commerce 통합 구현 인터페이스. 이 인터페이스를 확장하는 4개 하위 인터페이스가 있다:
- `CartInventoryValidation` — 재고 유효성 검사
- `CartPriceCalculations` — 가격 계산
- `CartShippingCharges` — 배송비 계산
- `CartTaxCalculations` — 세금 계산

### 메서드

#### startCartProcessAsync(integrationInfo, cartId)

비동기 통합 프레임워크에서 호출. 카트 처리를 시작한다.

```apex
// 시그니처
public sfdc_checkout.IntegrationStatus startCartProcessAsync(
    sfdc_checkout.IntegrationInfo integrationInfo, 
    Id cartId
)
```

**파라미터:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `integrationInfo` | `IntegrationInfo` | 요청-응답 매핑 정보, 메타데이터, 컨텍스트 |
| `cartId` | `Id` | WebCart 오브젝트 ID |

**반환값:** `IntegrationStatus` — SUCCESS 또는 FAILED

### 구현 예시

```apex
// CartInventoryValidation 구현 예시 (비동기 재고 검사)
global class MyInventoryValidation implements sfdc_checkout.AsyncCartProcessor {
    
    global sfdc_checkout.IntegrationStatus startCartProcessAsync(
        sfdc_checkout.IntegrationInfo integrationInfo, 
        Id cartId
    ) {
        sfdc_checkout.IntegrationStatus status = new sfdc_checkout.IntegrationStatus();
        
        try {
            // WebCartItem 목록 조회
            List<WebCartItem> cartItems = [
                SELECT Id, Product2Id, Quantity
                FROM WebCartItem
                WHERE CartId = :cartId
            ];
            
            // 외부 재고 시스템 확인 (비동기 Callout)
            Boolean inventoryAvailable = checkExternalInventory(cartItems);
            
            if (inventoryAvailable) {
                status.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
            } else {
                status.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            }
        } catch (Exception e) {
            status.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
        }
        
        return status;
    }
    
    private Boolean checkExternalInventory(List<WebCartItem> items) {
        // 외부 시스템 호출 로직 (구조 예시)
        return true;
    }
}
```

---

## B2BCheckoutController Class

간단한 체크아웃 Apex 메서드로 B2B Commerce 체크아웃 관련 데이터 처리.

**네임스페이스:** `sfdc_checkout` (인스턴스 생성 시 네임스페이스 명시 필요)

### 메서드

#### licenseCompliance(cartId, orderId)

Cart to Order flow 코어 액션 없이 자체 카트-주문 프로세스를 구현할 때 반드시 호출해야 GMV(Gross Merchandise Value) 추적이 올바르게 이루어진다.

```apex
// 시그니처
public static void licenseCompliance(String cartId, String orderId)
```

**파라미터:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `cartId` | `String` | 주문 원본 WebCart ID |
| `orderId` | `String` | 생성된 Order ID |

**반환값:** `Void`

**예시:**

```apex
// 커스텀 Cart-to-Order 프로세스에서 GMV 추적
Order newOrder = new Order();
newOrder.WebCartId = cartId;
// ... Order 설정
insert newOrder;

// GMV 라이선스 컴플라이언스 필수 호출
B2BCheckoutController.licenseCompliance(cartId, newOrder.Id);
```

---

## IntegrationInfo Class

B2B Commerce Checkout이 요청-응답 매핑에 사용하는 컨텍스트 정보를 제공한다.

**네임스페이스:** `sfdc_checkout`

### Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `integrationId` | `String` | B2B Commerce 통합의 고유 ID |
| `jobId` | `String` | Salesforce Background Operation 프레임워크의 Job ID |
| `siteLanguage` | `String` | 서드파티 서비스에서 사용할 사이트 언어 |

```apex
// IntegrationInfo 접근 패턴 (AsyncCartProcessor 메서드 내부)
global sfdc_checkout.IntegrationStatus startCartProcessAsync(
    sfdc_checkout.IntegrationInfo integrationInfo, 
    Id cartId
) {
    String integrationId = integrationInfo.integrationId;
    String jobId = integrationInfo.jobId;
    String siteLanguage = integrationInfo.siteLanguage;
    
    System.debug('Integration ID: ' + integrationId);
    System.debug('Job ID: ' + jobId);
    System.debug('Site Language: ' + siteLanguage);
    
    // 처리 로직
    sfdc_checkout.IntegrationStatus status = new sfdc_checkout.IntegrationStatus();
    status.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
    return status;
}
```

---

## IntegrationStatus Class

동기 Apex 통합 실행 결과 상태를 반환한다.

**네임스페이스:** `sfdc_checkout` (인스턴스 생성 시 네임스페이스 명시 필요)

### Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `status` | `sfdc_checkout.IntegrationStatus.Status` | 통합 실행 상태 |

---

## IntegrationStatus.Status Enum

| 값 | 설명 |
|---|---|
| `SUCCESS` | 통합 성공적으로 실행됨 |
| `FAILED` | 일시적·알 수 없는 오류 발생 (구매자가 재시도 가능) |

---

## 관련 노트
- [[CommerceBuyGrp Namespace]]
- [[CommerceExtension Namespace]]
- [[CommerceOrders Namespace]]
- [[CommercePayments Namespace]]
- [[CommerceTax Namespace]]
