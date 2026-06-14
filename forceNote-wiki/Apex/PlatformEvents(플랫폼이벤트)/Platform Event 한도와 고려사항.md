---
tags: [apex, platform-events, limits, considerations, allocations, cdc]
source: platform_events.pdf (Platform Events Developer Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [Platform Event 한도, Platform Event 고려사항, Platform Event Allocations, 디커플드 발행 구독, decoupled publishing, PE vs CDC, 이벤트 종류 비교, 72시간 보관]
---

# Platform Event 한도와 고려사항

> 플랫폼 이벤트의 할당량(allocations)·보관 기간, 정의/발행/구독 시 고려사항, 그리고 **Publish Immediately의 디커플드(decoupled) 발행-구독** 함정과 다른 Salesforce 이벤트와의 차이.

> [!note] 공식 *Platform Events Developer Guide v67.0* 발췌. 정의·구독은 [[Platform Event 정의와 구독]] 참조.

---

## 할당량·보관 (Allocations)

- **고볼륨(High-volume)** 이벤트: 메시지 **72시간(3일)** 보관. 비동기 발행. 에디션별 기본 할당량 + 사용량 기반 entitlement(전달 이벤트 수).
- **표준볼륨(Standard-volume)**: **Summer '27 은퇴 예정**(v45.0+ 신규 이벤트는 고볼륨이 기본).
- 한도는 REST **`/limits`** 엔드포인트로 조회 가능.

```bash
# 플랫폼 이벤트 사용량/할당량 조회 — REST /limits (엔드포인트는 가이드 확인, 응답 키는 구조 예시)
curl https://MyDomain.my.salesforce.com/services/data/v67.0/limits/ \
  -H "Authorization: Bearer <access_token>"
# 응답 JSON에 일일 이벤트 발행/전달 할당량 항목 포함 (예: 고볼륨 이벤트 전달 한도)
```

---

## 정의 고려사항

| 항목 | 내용 |
|---|---|
| 필드 read-only | 모든 플랫폼 이벤트 필드는 **기본 read-only**, 필드 레벨 보안 적용 안 됨(메시지에 전 필드 포함) |
| 필드 속성 강제 | Required·Default·숫자 정밀도·텍스트 최대 길이 등 커스텀 필드 속성이 검증됨 |
| **영구 삭제** | 이벤트 정의 삭제 시 **복구 불가**. 삭제 전 연결 트리거 먼저 삭제. 해당 정의의 발행된 이벤트도 삭제됨 |
| **이름 변경 → 재구독** | 이벤트 이름 변경 시 구독 클라이언트는 **재구독 필요**(새 토픽). 변경 전 트리거 삭제 |
| 탭 없음 | 플랫폼 이벤트는 UI에서 레코드를 볼 수 없어 **연결 탭 없음** |
| **SOQL 불가** | 이벤트 메시지를 SOQL로 **쿼리할 수 없음** |
| Lightning App Builder | 레코드 페이지 생성 목록에 보이지만 **레코드 페이지 생성 불가**(UI에 레코드 없음) |
| 패키지 | uninstall 시 데이터 보존(48h) 옵션 켜도 플랫폼 이벤트는 export 안 됨 |

---

## 디커플드 발행-구독 (Publish Immediately)

**Publish Immediately** 이벤트는 DB 트랜잭션 **밖에서** 발행된다 → 발행·구독 프로세스가 **분리(decoupled)**. 구독자는 발행 트랜잭션의 변경이 **커밋됐다고 가정할 수 없다.**

> [!warning] **발행자는 트랜잭션 경계를 존중하지 않는다.** 예: ① Process가 이벤트 발행 + Task 생성 → ② Task 트리거가 커밋을 지연 → ③ 이벤트를 구독한 다른 Process가 그 Task를 조회하면 **아직 커밋 전이라 못 찾음**(에러). API·트리거로 발행/구독해도 동일.
>
> **해결:** publish behavior를 **Publish After Commit**으로 변경 → 트랜잭션 커밋 후 발행되어 구독자가 레코드를 찾을 수 있다.

(이 디커플드 동작은 Publish After Commit 이벤트와 Pub/Sub API 발행에는 적용되지 않는다.)

---

## 다른 Salesforce 이벤트와의 차이

Salesforce에는 이벤트 기반 기능이 여러 가지이며, 일부는 표준 플랫폼 이벤트 기반이고 일부는 "이벤트 같지만" 알림이 아니다.

| 이벤트 | 용도 |
|---|---|
| **Platform Events** (커스텀 `__e`) | 직접 정의한 커스텀 메시지 발행/구독 (본 시리즈) |
| **Change Data Capture (CDC)** | 레코드 변경(생성/수정/삭제/언델리트)을 자동 이벤트로 — 필드 정의 불필요. → [[ChangeEventHeader]] |
| **(기타)** | PushTopic, Generic Event 등 레거시 스트리밍 — 신규는 플랫폼 이벤트/Pub-Sub 권장 |

---

## 관련 노트

- [[Platform Event 정의와 구독]] — 정의·Publish Behavior·구독 트리거
- [[Platform Event Apex 테스트]] — Test.getEventBus
- [[Platform Event 발행]] · [[EventBus Namespace]] — Apex 발행
- [[ChangeEventHeader]] — CDC 변경 이벤트
- [[Governor Limits]] — 거버너 한도 일반
