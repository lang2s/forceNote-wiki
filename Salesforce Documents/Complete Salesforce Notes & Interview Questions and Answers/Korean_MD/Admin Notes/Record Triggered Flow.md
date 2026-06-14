# Record-Triggered Flow(레코드 트리거 플로우)

## Trigger Flow란?

특정 이벤트(레코드 삽입·업데이트·삭제)가 발생할 때 실행되는 시스템(Salesforce 등)의 자동화 프로세스입니다.

**왜 사용하나요?**
- 자동화: 작업을 자동 실행해 수작업 감소
- 일관성: 비즈니스 규칙과 로직을 항상 올바르게 적용
- 효율성: 실시간 처리로 프로세스 가속
- 오류 방지: 유효하지 않은 데이터 입력 방지, 저장 전 규칙 강제

CRM, 데이터베이스, 워크플로우 자동화에서 흔히 사용됩니다.

## Salesforce의 자동화 방법 두 가지

- **선언적(노코드/로우코드):** Record-Triggered Flow
- **코드:** Apex Trigger

**Record-Triggered Flow 사용 시점:** 비즈니스 시나리오가 단순하고 직관적일 때.
**Apex Trigger 사용 시점:** 복잡한 비즈니스 시나리오.

레코드 생성/업데이트/삭제 시 자동화에 도움이 되며, 사용자 상호작용 없이 자동 실행됩니다.

## Record-Triggered Flow의 유형

**1. Fast Field Update (Before-Save 레코드 트리거 플로우)**
- 사용 시점: 플로우를 발동시킨 같은 레코드의 필드를 업데이트할 때.
- 같은 레코드의 필드를 업데이트하는 데 도움.

**2. Actions and Related Records (After-Save 레코드 트리거 플로우)**
- 사용 시점: 관련 레코드에 CRUD 작업, 액션 호출(기본/커스텀).
- 발동 시점: 레코드 저장 후.
- 일반 사례: 관련/비관련 레코드에 CRUD, 액션 호출(이메일 전송, 커스텀 알림).

## Flow에서 트리거된 레코드 필드 값 접근

`$Record`(Flow 변수) = 현재 레코드.

## Update Related Records

Record-Triggered Flow에서 Get Records 요소 없이 트리거 레코드와 관련된 레코드를 업데이트할 수 있습니다.

예: Account의 전화번호가 업데이트되면 모든 관련 Contact의 전화번호를 자동 업데이트.

**장점:** Get Records 불필요, 효율적(관련 레코드 대량 업데이트), 동적 동기화. **제한:** 트리거 레코드와 관련된 레코드만 업데이트 가능(비관련 레코드 불가).

## Deleted Record

- **Before Delete:** 레코드 삭제 전 발동. 검증, 삭제 방지, 관련 레코드 업데이트에 사용.
- **After Delete:** 레코드 삭제 후 발동. 관련 데이터 정리, 사용자 알림, 삭제 이벤트 로깅에 사용.

예: Contact가 삭제되면 모든 관련 Task를 자동 제거.

## 기타 개념

- **Schedule Path:** 예약 경로.
- **What Id (Related To):** Account, Opportunity, Contact 등. **Who Id (Name):** Lead, Contact.
- **Quick Action Flow:** 페이지 레이아웃에 추가.
- **Custom Notification:** Quick Search에서 Custom Notification을 찾아 새 알림 생성.

## Subflow

메인 플로우 안의 미니 플로우입니다. 여러 플로우에서 같은 단계를 반복하는 대신, subflow를 한 번 만들어 필요할 때마다 호출합니다.

예: 레코드 업데이트 시 이메일을 보내는 여러 플로우가 있을 때, 모든 플로우에 이메일 로직을 설정하는 대신 이메일 전송을 처리하는 Subflow를 만들어 호출.

**장점:** 시간 절약(반복 불필요), 쉬운 유지보수(한 곳에서 로직 업데이트), 더 나은 성능.

## 이메일 전송

- **이메일 템플릿 없이:** Text Template(Resource) 사용.
- 두 가지: Send Email Alert(이메일 템플릿 사용), Send Email(템플릿 없이 Text Template Resource 사용).
- **Org-Wide Address**, **Auto Launched** 옵션 사용 가능.
