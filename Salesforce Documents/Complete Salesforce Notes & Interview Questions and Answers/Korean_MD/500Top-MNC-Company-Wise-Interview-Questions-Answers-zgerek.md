---
tags: [general, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [500Top-MNC-Company-Wise-Interview-Questions-Answers]
---

# 500+ MNC 회사별 Salesforce 인터뷰 질문 & 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 회사별로 구성된 실무 인터뷰 Q&A 모음입니다. 각 항목은 "질문 / 답변 / 팁" 구조이며, 코드는 원문 그대로 보존했습니다.

---

# EY (Ernst & Young)

## 1. Flow를 다뤄봤나? 실행 순서에서 어떤 Flow가 먼저 실행되나?
같은 오브젝트·같은 이벤트("Before Save"/"After Save")에서 여러 Flow가 실행될 때, Flow Trigger Explorer로 "Trigger Order" 값을 정의할 수 있다. 낮은 숫자가 먼저 실행되므로 가장 작은 순서 번호의 Flow가 먼저 실행된다.
**팁:** DML 없는 검증·갱신엔 Before Save Flow / 관련 레코드 생성 같은 액션엔 After Save Flow / 실행 순서 제어엔 Flow Trigger Explorer(Spring '23 도입).

## 2. LDS(Lightning Data Service)를 다뤄봤나?
예, LWC와 Aura 모두에서 LDS를 썼다. LDS는 Apex 없이 CRUD를 단순화한다. LWC에서는 lightning-record-form, lightning-record-view-form, lightning-record-edit-form이 내부적으로 LDS를 사용한다.
**팁:** LDS로 충분하면 Apex 불필요 / 필드 수준 보안·레코드 공유 자동 처리 / 커스텀 Apex 없는 편집/조회에 이상적.

## 3. LWC를 다뤄봤나? data table에 쓰는 data 속성은?
lightning-datatable에서 행을 고유 식별하는 key-field 속성과 데이터 배열을 전달하는 data 속성을 쓴다.
```html
<lightning-datatable
key-field="Id"
data={data}
columns={columns}>
</lightning-datatable>
```
**팁:** key-field는 고유해야 함(보통 Id) / Columns 설정이 필드 표시 정의(label, fieldName, type) / 페이지네이션·정렬·행 액션이 흔한 확장.

## 4. LWC에서 A(부모), B(자식), C(손자) — 어떤 lifecycle hook이 먼저 호출되나?
부모(A)의 constructor가 먼저 호출되고 자식(B), 손자(C) 순으로 진행된다. 하지만 renderedCallback은 순서가 반대로 손자→부모다.
**팁:** constructor → connectedCallback → renderedCallback 흐름 이해 / 자식 렌더링이 부모 renderedCallback 전에 완료 / constructor에서 DOM 조작 회피, renderedCallback 사용.

## 5. 트리거 사용 사례: Account, Contact, Opportunity, 로그인 사용자 시나리오
새 Account 생성 시 관련 Contact·Opportunity를 자동 생성하고 레코드 소유자(로그인 사용자)에게 환영 이메일을 보내는 트리거를 만들었다. 벌크 안전 패턴, 트리거 핸들러 프레임워크, SOQL/DML 한도를 적절히 처리했다.
**팁:** ID나 사용자 정보 하드코딩 회피 / 로직 분리에 핸들러 클래스 / 벌크·재귀 신중히 처리.

## 6. 데이터 모델링: Lookup vs Master-Detail. 각 오브젝트에 100개 레코드. Master-Detail 적용하려면?
Lookup 관계로 레코드가 이미 있으면, 모든 자식 레코드에 부모 필드가 채워져 있어야만 Master-Detail로 변경 가능하다. 먼저 스크립트나 Data Loader로 누락된 부모 ID를 채운 뒤 관계 유형을 변경한다.
**팁:** 변환 전 lookup 필드 100% 채움 보장 / Master-Detail은 roll-up summary 허용, Lookup은 불가 / Master-Detail은 레코드 삭제 제한(부모-자식 영향).

## 7. Named Credentials란?
외부 시스템 URL과 인증 정보를 Salesforce에 안전하게 저장하는 방법. Apex에 토큰·자격 증명 하드코딩을 피한다. OAuth 2.0, AWS IAM, Basic Auth 등을 지원한다.
**팁:** 보안을 위해 External Services나 콜아웃과 함께 사용 / per-user 또는 named principal 인증 지원 / OAuth 통합엔 Auth Provider와 짝.

## 8. LWC에서 페이지네이션
lightning-datatable에 커스텀 페이지네이션을 구현했다. 페이지 크기와 현재 페이지 번호로 데이터셋을 슬라이스한다. Next/Previous 버튼이나 페이지 번호 입력도 추가 가능하다.
```js
this.displayRecords = this.fullData.slice((this.page-1)*pageSize, this.page*pageSize);
```
**팁:** 한 번에 큰 데이터셋 로드 회피, 지연 로딩이나 서버 측 페이지네이션 / JS에서 pageNumber·pageSize·totalRecords 추적 / Apex로 페이지 데이터 조회 가능.

## 9. Organization-Wide Defaults(OWD)란? 데이터 보안에 어떤 영향?
OWD는 org의 모든 사용자에 대한 레코드 기본 접근 수준을 정의한다. 예: Account OWD가 Private이면 sharing rule이나 role hierarchy로 확장하지 않는 한 사용자는 자신 소유 레코드만 본다.
**팁:** 항상 최소 권한 원칙 / OWD + sharing rule + role hierarchy로 접근 커스터마이즈 / Setup → Sharing Settings에서 OWD 확인.

## 10. Profile과 Permission Set의 차이를 설명하라
Profile은 사용자에게 할당되는 기본 접근 수준. Permission Set은 프로필 변경 없이 추가 접근을 부여한다. 권한 관리에 유연성을 제공한다.
**팁:** 사용자 1명 = 프로필 1개 / 사용자 1명 = Permission Set 다수 / 확장성·모듈식 접근엔 Permission Set.

## 11. Role Hierarchy와 Sharing Rules의 차이는?
Role Hierarchy는 레코드 소유자 위의 관리자에게 접근을 허용한다. Sharing Rules는 역할 간/측면으로 접근을 확장한다(예: Sales→Support 팀).
**팁:** Role Hierarchy = 수직 접근 / Sharing Rules = 측면/그룹 접근 / 둘 다 OWD와 함께 동작.

## 12. Salesforce의 관계 유형은?
Lookup(느슨한 연결, 부모 삭제가 자식에 영향 없음), Master-Detail(강한 연결, 자식이 부모에 의존), Junction Object(두 master-detail 필드로 다대다 모델링).
**팁:** roll-up summary가 필요하면 Master-Detail / 선택적 관계엔 Lookup / Junction = 다대다.

## 13. 특정 필드에 대한 사용자 접근을 어떻게 제한하나?
Profile이나 Permission Set으로 Field-Level Security를 쓴다. UI, API, 리포트에서 필드를 숨긴다.
**팁:** 필드 권한 감사엔 Field Accessibility View / FLS는 API 응답에도 적용 / 완전한 제어엔 페이지 레이아웃과 결합.

## 14. 사용자의 레코드 접근 이슈를 어떻게 트러블슈팅하나?
"Sharing Button", "Why can't I see this record?", "User Access Summary"를 쓴다. 또 Role, OWD, Sharing Rules, 수동 공유를 확인한다.
**팁:** Security → User Access Summary 도구 / Object > Field > Record 수준 접근 평가 / (가능하면) 사용자로 로그인해 재현.

## 15. Governor Limits란? 왜 존재하나?
멀티테넌트 클라우드에서 리소스 공정성을 보장하기 위해 Salesforce가 강제하는 런타임 한도. 예: 트랜잭션당 SOQL 100개, DML 150개 등.
**팁:** 항상 벌크 안전 코드 / Limits 클래스로 확인(Limits.getDmlStatements() 등) / 대량 작업엔 Batch Apex, Queueable, Future.

## 16. SOQL과 SOSL의 차이와 각각 언제 쓰나?
SOQL은 특정 오브젝트의 구조화된 쿼리(SELECT Name FROM Account). SOSL은 여러 오브젝트에 걸친 전문(full-text) 검색.
**팁:** 한 오브젝트 필드 쿼리엔 SOQL / 여러 오브젝트를 빠르게 검색하려면 SOSL / SOSL은 리스트의 리스트로 반환.

## 17. Apex의 Bulkification이란? 왜 중요한가?
여러 레코드를 한 번에 처리할 수 있는 코드를 작성하는 관행. 거버너 한도 이슈를 피하고 성능을 개선한다.
**팁:** 트리거에 컬렉션(List/Map/Set) 사용 / 루프 안 DML/쿼리 회피 / Trigger.new, Trigger.old, Map<Id, Record> 패턴.

## 18. Before Trigger와 After Trigger의 차이는?
Before 트리거는 DML 전 검증이나 값 설정에, After 트리거는 레코드 ID가 필요하거나 관련 레코드를 생성할 때 쓴다.
**팁:** before insert로 record.OwnerId = UserInfo.getUserId() 설정 / after insert로 관련 자식 레코드 생성 / after 트리거에서 레코드 갱신 회피(추가 DML 필요).

## 19. Batch Apex는 어떻게 동작하며 언제 써야 하나?
Batch Apex는 큰 데이터셋을 관리 가능한 청크로 나눠 비동기 처리한다. start, execute, finish 메서드를 쓴다.
**팁:** 수백만 레코드 처리에 사용 / Database.Batchable 인터페이스 구현 / Apex Jobs 탭으로 모니터링.

## 20. Salesforce에서 데이터 익스포트를 제한하는 방법은?
"Export Reports" 권한 비활성화, API 접근 제거, Salesforce Shield나 컴플라이언스 도구로 DLP 활성화.
**팁:** 페이지 레이아웃에서 "Export" 버튼 제거 / Connected App 정책으로 API 접근 제한 / Shield = 고급 로깅·이벤트 모니터링.

## 21. Salesforce에서 API 통합을 어떻게 보호하나?
Named Credentials + Auth Provider를 쓰고, IP 제한, OAuth scope, client secret 관리를 외부 API 호출에 적용한다.
**팁:** 코드에 토큰 하드코딩 금지 / 해당 시 Token Exchange Flow / Security > Session Management로 모니터링.

## 22. OAuth 2.0란? Salesforce에서 어떻게 동작하나?
OAuth 2.0은 개방형 인증 프로토콜. Salesforce에서 서드파티 앱이 username/password 공유 없이 액세스 토큰으로 연결할 수 있게 한다.
**팁:** Auth Provider + Named Credential로 설정 / 흔한 흐름: Web Server Flow, JWT, Username-Password / 장기 세션엔 refresh token.

## 23. 사용자 활동과 보안 이벤트를 어떻게 추적하나?
Event Monitoring, Login History, Setup Audit Trail, Field Audit Trail(활성 시)로 변경과 로그인을 추적한다.
**팁:** 실시간 로그엔 Shield Event Monitoring / 레코드 수준 변경엔 Field History Tracking / Salesforce Security Center의 Login Forensics 확인.

---

# Infosys

## 1. Queueable Apex로 비동기 통합을 어떻게 구현하나?
Queueable Apex로 외부 시스템에 대한 장시간 콜아웃을 비동기 처리했다. 클래스는 Queueable과 Database.AllowsCallouts를 구현하고, 레코드 삽입/갱신 후 System.enqueueJob()으로 작업을 enqueue한다.
```apex
public class CalloutIntegration implements Queueable, Database.AllowsCallouts {
public void execute(QueueableContext context) {
HttpRequest req = new HttpRequest();
req.setEndpoint('https://externalapi.com/data');
req.setMethod('POST');
// Set headers and body
HttpResponse res = new Http().send(req);
}
}
```
**팁:** 논블로킹 콜아웃·대용량 비동기 로직에 이상적 / 클래스 안에 오류 로깅 + 재시도 / 의존 Queueable엔 Chaining.

## 2. OAuth 2.0로 Salesforce를 외부 시스템과 어떻게 통합하나?
Salesforce에 Connected App을 등록한 뒤 Auth Provider + Named Credential로 인증한다. 외부 시스템은 OAuth 2.0 흐름(Web Server나 JWT)으로 인증한다. 이후 Named Credential로 안전하게 콜아웃한다.
**팁:** 코드에 액세스 토큰 저장 회피 / 인증된 콜아웃 단순화에 Named Credential / 올바른 흐름 선택: 서버 간엔 JWT, 사용자 컨텍스트엔 Web Server.

## 3. WSDL 파일로 외부 SOAP API와 어떻게 연결하나?
Salesforce의 WSDL2Apex 도구로 WSDL에서 Apex 클래스를 생성했다. 그다음 생성된 스텁으로 서비스를 호출하고 Apex에서 응답을 처리했다.
```apex
MyWebServicePort binding = new MyWebServicePort();
binding.inputHttpHeaders_x = new Map<String, String>();
binding.inputHttpHeaders_x.put('Authorization', 'Bearer <token>');
String result = binding.someSOAPMethod();
```
**팁:** WSDL이 표준 준수인지 확인 / Named Credential이나 basic auth 헤더로 보안 / 한도 모니터링 – SOAP은 REST보다 무겁다.

## 4. MuleSoft로 Salesforce를 SAP와 어떻게 통합하나?
MuleSoft Anypoint Platform으로 Salesforce와 SAP 간 다리 역할의 API를 만들었다. MuleSoft가 변환·오케스트레이션·인증을 처리한다. Salesforce에서 Named Credential과 REST 콜아웃으로 Mule API를 호출했다.
**팁:** System API → Process API → Experience API 패턴 / MuleSoft가 프로토콜·형식·인증 불일치를 효율적으로 처리 / 대용량 동기화엔 Batch Mule flow + Platform Events.

## 5. WebSocket으로 실시간 주문 추적을 어떻게 구현하나?
Salesforce는 WebSocket을 네이티브 지원하지 않지만, WebSocket 통신을 처리하는 미들웨어(Node.js나 MuleSoft)를 통합해 Platform Events나 Streaming API로 Salesforce에 업데이트를 푸시했다.
**팁:** WebSocket 서버가 양방향 실시간 통신 처리 / Salesforce UI 업데이트엔 Platform Events / LWC는 empApi나 lightning/empApi로 구독.

## 6. Google Drive와 파일 저장을 어떻게 통합하나?
Google Drive REST API로 통합했다. 인증은 OAuth 2.0(Web Server Flow)으로 관리했다. Apex에서 Named Credential로 Drive API를 통해 안전하게 파일을 업로드/다운로드했다.
**팁:** Google Drive API v3 사용 / Salesforce에 파일 메타데이터 저장 / Named Credential + Google Auth Provider로 토큰 관리.

---

# TCS & Infosys

## 1. JavaScript의 Promise 개념에 대해 아는 것은?
Promise는 비동기 작업의 최종 완료(또는 실패)와 결과 값을 나타낸다. .then()·.catch()로 더 깔끔한 비동기 코드를 가능하게 한다.
**팁:** Promise는 pending, fulfilled, rejected 세 상태 / 더 읽기 쉬운 비동기 코드엔 async/await.

## 2. 삽입된 레코드에만(갱신 제외) 검증 규칙을 작성하려면?
검증 규칙에 ISNEW() 함수를 사용해 레코드 생성 시에만 트리거되게 한다.
**팁:** ISNEW()는 레코드 생성 시 true 반환 / 특정 시나리오엔 다른 조건과 결합.

## 3. 비공개 폴더의 리포트 소유자를 프로그래밍으로 변경할 수 있나?
비공개 폴더의 리포트는 프로그래밍으로 소유권 변경 불가. 권장 방법은 리포트를 공개 폴더로 복제하고 원하는 소유자를 할당하는 것.
**팁:** 접근성을 위해 공유 폴더에 리포트 저장하도록 사용자 교육 / 폴더 공유 설정으로 리포트 가시성 관리.

## 4. 검증 규칙 대신 Flow는 언제 쓰나?
관련 레코드 갱신이나 알림 전송처럼 복잡한 로직이나 다단계 프로세스가 필요할 때 Flow. 단순 필드 검증엔 검증 규칙이 최선.
**팁:** Flow는 더 유연하나 유지보수가 복잡 / 단순 체크엔 검증 규칙이 구현 쉬움.

## 5. 사용자 비활성화(deactivate)와 동결(freeze)의 차이는?
비활성화는 접근을 제거하고 라이선스를 반환한다. 동결은 로그인을 막지만 라이선스를 유지한다.
**팁:** 조사·전환 중 임시로 동결 / 더 이상 접근이 불필요하면 비활성화로 라이선스 반환.

## 6. 사용자를 동결하고 그 이름에 이메일 알림이 설정되어 있으면, 알림을 받나?
예, 동결된 사용자도 이메일 알림을 받는다. 동결은 로그인 접근만 막을 뿐 이메일 전달엔 영향이 없다.
**팁:** 동결 시 이메일 알림 수신자 검토·갱신 / 모든 시스템 상호작용을 멈추려면 비활성화 고려.

## 7. Data Loader로 신규 레코드 적재 중 검증 규칙을 비활성화하는 기법은?
bypass 플래그 역할의 custom setting이나 custom metadata type을 구현한다. 검증 규칙이 이 플래그를 확인하고 설정되면 실행을 건너뛰도록 수정한다.
**팁:** 사용자별 bypass엔 hierarchical custom setting / 데이터 적재 후 bypass 플래그 리셋으로 검증 재활성화.

## 8. 트리거 실행을 어떻게 우회하나?
트리거 로직에 static 변수나 custom setting을 플래그로 도입한다. 플래그가 설정되면 트리거 작업을 건너뛴다.
**팁:** 우회 메커니즘이 안전하고 데이터 무결성을 해치지 않도록 / 향후 유지보수를 위해 우회 로직 문서화.

## 9. 왜 Batch Apex에서 future 메서드를 호출할 수 없나?
둘 다 비동기 프로세스라 중첩하면 예측 불가능한 동작을 유발하므로 Salesforce가 제한한다.
**팁:** 대신 체이닝이 가능하고 더 유연한 Queueable Apex 사용 / 가능하면 배치 프로세스를 동기 완료로 설계.

## 10. insert와 Database.insert()의 차이는?
insert는 어떤 레코드라도 실패하면 예외를 던지는 DML 문. Database.insert()는 부분 성공을 허용하고 개별 성공/실패를 처리하는 결과 객체를 제공한다.
**팁:** 부분 성공이 허용되는 벌크 작업엔 Database.insert() / 항상 결과 객체를 확인해 오류를 우아하게 처리.

## 11. 레코드가 DB에 저장되는 과정(실행 순서)을 설명하라
Salesforce는 특정 순서를 따른다: 시스템 검증, before 트리거, 커스텀 검증, duplicate rule, after 트리거, assignment rule, auto-response rule, workflow rule, process, escalation rule, entitlement rule, roll-up summary 필드, 기준 기반 sharing rule, 마지막으로 이메일 전송 같은 post-commit 로직.
**팁:** 이 순서 이해가 복잡한 자동화 디버깅에 도움 / workflow·process의 필드 업데이트는 검증·트리거를 재트리거할 수 있으니 주의.

## 12. 검증 규칙과 Flow 기반 검증 중 무엇이 먼저 실행되나?
검증 규칙이 Flow보다 먼저 실행된다. 따라서 검증 규칙이 실패하면 Flow는 실행되지 않는다.
**팁:** 검증 규칙이 필요한 Flow를 막지 않도록 / 복잡한 자동화 설계 시 순서 고려.

## 13. 승인 프로세스의 필드 업데이트는 검증 규칙을 우회하지만 Flow 기반 검증은 우회하지 않는다? 참/거짓
참. 승인 프로세스의 필드 업데이트는 검증 규칙을 우회하지만 구성되어 있으면 Flow를 트리거할 수 있다.
**팁:** 의도치 않은 자동화를 막으려 이 동작을 인지 / Flow의 entry condition으로 실행 제어.

## 14. Change Set, Salesforce DX, Metadata API의 차이는?
Change Set은 관련 org 간 메타데이터를 배포하는 포인트앤클릭 도구. Salesforce DX는 소스 컨트롤과 CLI로 메타데이터를 관리하는 현대적 개발 방식. Metadata API는 모든 org 간 메타데이터를 프로그래밍으로 배포한다.
**팁:** 샌드박스-운영 간 단순 배포엔 Change Set / 복잡·협업 프로젝트엔 Salesforce DX.

## 15. Apex의 Wrapper class란?
여러 객체나 데이터 타입을 캡슐화하는 커스텀 클래스로, Visualforce 페이지나 Lightning 컴포넌트에서 복잡한 데이터 구조와 쉬운 데이터 처리를 가능하게 한다.
**팁:** 여러 오브젝트의 결합 데이터 표시에 유용 / 코드 가독성·유지보수성 향상.

## 16. LWC에서 레코드 ID를 어떻게 가져오나?
컴포넌트에 @api 데코레이터와 recordId 속성을 쓴다. 레코드 페이지에서 사용 시 Salesforce가 자동으로 레코드 ID를 제공한다.
```javascript
import { LightningElement, api } from 'lwc';
export default class MyComponent extends LightningElement {
@api recordId;
}
```
**팁:** recordId를 받으려면 컴포넌트를 레코드 페이지에 배치 / recordId로 컴포넌트 내 레코드 데이터 조회·조작.

## 17. Batch Apex에서 트리거를 호출할 수 있나?
예, Batch Apex의 execute 메서드 안에서 DML이 수행되면 트리거가 자동 호출된다.
**팁:** 배치 처리 중 의도치 않은 결과를 막으려 트리거 로직 주의 / Trigger.isExecuting 같은 컨텍스트 변수로 트리거 동작 제어.

## 18. 클래스를 테스트하는 베스트 프랙티스는?
긍정·부정·엣지 케이스를 포함한 다양한 시나리오를 커버하는 테스트 메서드 작성, System.assert()로 결과 검증, Test.startTest()·Test.stopTest()로 거버너 한도 관리.
**팁:** 최소 75% 커버리지 목표이되 의미 있는 테스트에 집중 / 의존성을 피하려 테스트 클래스 안에서 테스트 데이터 생성.

## 19. Test.startTest()·Test.stopTest()와 @isTest의 차이는?
@isTest는 테스트 클래스/메서드를 정의하는 어노테이션. Test.startTest()·Test.stopTest()는 테스트 메서드 안에서 거버너 한도를 리셋하고 비동기 동작을 시뮬레이션한다.
**팁:** 비동기 코드 테스트나 한도 리셋엔 Test.startTest()·Test.stopTest() / 운영 코드에 포함되지 않도록 유틸리티 클래스에 @isTest.

## 20. private 클래스를 어떻게 테스트하나?
같은 Apex 파일에 테스트 클래스를 두거나 @TestVisible 어노테이션으로 private 멤버를 테스트용으로 노출한다.
**팁:** private 클래스 접근을 위해 같은 네임스페이스에 테스트 클래스 / 캡슐화 유지를 위해 @TestVisible 신중히.

## 21. 실행 중인 Batch Apex를 어떻게 삭제/중지하나?
System.abortJob(jobId) 메서드로 실행 중 배치 작업을 중지한다. jobId는 AsyncApexJob 오브젝트에서 가져온다.
**팁:** Setup의 Apex Jobs 페이지로 배치 작업 모니터링 / 작업 중단을 우아하게 관리하도록 적절한 오류 처리.

## 22. Account의 TotalAmount 필드를 관련 Opportunity에 균등 분배하는 트리거를 작성하라
```apex
trigger DistributeAmount on Account (after insert, after update) {
for (Account acc : Trigger.new) {
if (acc.TotalAmount__c != null) {
List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id];
if (!opps.isEmpty()) {
Decimal splitAmount = acc.TotalAmount__c / opps.size();
for (Opportunity opp : opps) {
opp.Amount = splitAmount;
}
update opps;
}
}
}
}
```
**팁:** TotalAmount__c가 Account의 커스텀 필드인지 확인 / 0으로 나누기·null 체크 적절히 처리.

## 23. LWC에서 자식 컴포넌트의 name 속성 기본값이 'Virat'인데 부모가 'Rohit'을 전달하면, 런타임에 어떤 값이 표시되나?
부모가 전달한 값('Rohit')이 자식의 기본값('Virat')을 덮어쓴다.
**팁:** 기본값은 부모가 값을 제공하지 않을 때만 사용 / 부모-자식 간 적절한 데이터 바인딩 보장.

## 24. Account의 총 Contact 수를 세는 트리거를 작성하라
```apex
trigger CountContacts on Contact (after insert, after delete, after undelete) {
Set<Id> accountIds = new Set<Id>();
if (Trigger.isInsert || Trigger.isUndelete) {
for (Contact con : Trigger.new) {
if (con.AccountId != null) {
accountIds.add(con.AccountId);
}
}
}
if (Trigger.isDelete) {
for (Contact con : Trigger.old) {
if (con.AccountId != null) {
accountIds.add(con.AccountId);
}
}
}
// 각 Account의 Contact 수를 집계해 roll-up 필드 갱신
}
```
**팁:** insert·delete·undelete 컨텍스트를 모두 처리 / Trigger.new와 Trigger.old를 컨텍스트에 맞게 사용 / 벌크 안전하게 Set으로 AccountId 수집.

---

# TCS

## 1. Salesforce에 관계 유형이 몇 가지 있나? 각각 설명하라
주로 세 가지: (1) Lookup – 두 오브젝트가 연결되지만 자식이 부모 없이 존재 가능한 느슨한 결합, (2) Master-Detail – 자식의 생애주기가 부모에 의존하는 강한 결합, 부모 삭제 시 자식 삭제, (3) 다대다(Junction Object 경유) – junction 오브젝트에 두 master-detail 관계를 결합.
**팁:** 완성도를 위해 external lookup, hierarchical 관계도 언급 / 실제 비유로 각 관계 설명.

## 2. Sharing Settings 개념을 설명하라
Sharing settings는 레코드의 기본 접근 수준을 정의한다: OWD, Role Hierarchy, Sharing Rules(기준 기반·수동). 사용자가 소유하지 않은 데이터에 접근하는 방식을 제어한다.
**팁:** sharing rule은 접근을 열기 위한 것이지 제한이 아님 / OWD가 기준이고 추가 계층이 접근을 연다.

## 3. Roll-Up Summary란? 시나리오를 제시하라
Roll-up summary 필드는 자식 레코드의 값(SUM, MIN, MAX, COUNT)을 부모 레코드에 집계한다. 예: Account에 관련 Opportunity의 총액을 계산하는 roll-up summary 생성.
**팁:** master-detail 관계에서만 가능 / lookup 관계엔 Flow나 Apex로 가능.

## 4. Lookup과 Master-Detail 관계의 차이는?
Lookup은 느슨한 결합(자식이 부모 없이 존재). Master-detail은 강한 결합(자식 생애주기가 부모에 의존). 또 master-detail은 roll-up summary 필드를 지원하지만 lookup은 기본 미지원.
**팁:** 레코드 소유권·공유에 미치는 영향 강조 / Account(부모)·Contact(자식) 같은 실제 예.

## 5. Flow와 Trigger의 차이는?
Flow는 선언적 자동화, 트리거는 프로그래밍적. Flow는 대부분의 비즈니스 로직에 적합, 트리거는 복잡·다중 오브젝트·벌크 로직에 사용.
**팁:** 충분하면 유지보수가 쉬운 Flow 선호 / 벌크 데이터 처리나 재귀 처리가 필요한 로직엔 트리거.

## 6. insert와 Database.insert()의 차이는?
insert는 실패 시 오류를 던지고 모든 레코드를 롤백. Database.insert()는 allOrNone 매개변수로 이 동작을 제어하고 부분 성공을 얻을 수 있다.
**팁:** 부분 저장이 허용되는 벌크 작업엔 Database.insert() / 항상 Database.SaveResult 배열 확인.

## 7. Apex의 Primitive와 Non-Primitive 데이터 타입은?
Primitive: Integer, String, Boolean, Date 등. Non-Primitive: sObject, 컬렉션(List, Map, Set), Enum, 커스텀 Apex 클래스.
**팁:** primitive는 값으로, 나머지는 참조로 저장 / sObject는 Salesforce 오브젝트의 인스턴스.

## 8. Salesforce의 Flow란? 유형은?
Flow는 Flow Builder의 일부로 복잡한 비즈니스 로직을 자동화한다. 유형: Screen Flow(UI 있음), Auto-Launched Flow(UI 없음, 버튼/프로세스로 트리거), Scheduled Flow(특정 시간 실행), Record-Triggered Flow(레코드 생성/갱신/삭제 시), Platform Event-Triggered Flow(이벤트로 트리거).
**팁:** 요즘 Record-Triggered Flow가 트리거 대신 자주 쓰임 / 각각 언제 쓰는지 예로 설명.

## 9. Apex의 비동기 처리(Async)란? 유형은?
비동기 처리는 작업을 백그라운드에서 실행해 시스템 리소스를 확보한다. Salesforce 제공: Future Method(단순, 제한적, 체이닝 불가), Batch Apex(대용량, 최대 5천만 건), Queueable Apex(체이닝·커스텀 로직 지원), Schedulable Apex(스케줄 실행), Apex Scheduler + Batch/Queueable(시간 기반 자동화).
**팁:** 거버너 한도와 시나리오별 최적 유형 숙지 / 더 나은 제어 때문에 Future보다 Queueable 선호.

## 10. Apex의 Decorator란? 목적은?
Decorator는 @future, @isTest, @AuraEnabled, @invocableMethod 등 메서드/클래스의 동작이나 실행 방식을 수정하는 어노테이션이다.
**팁:** 흔한 데코레이터 암기 / 각각 어디 쓰는지 언급(예: LWC엔 @AuraEnabled).

## 11. Queueable Apex와 Batch Apex의 차이는?
Queueable Apex는 경량, 소~중 볼륨 작업에 이상적, 체이닝 지원. Batch Apex는 대용량용, 청크로 분할, 상태 보존 지원.
**팁:** Apex Jobs에서 둘 다 모니터링하는 법 / 한도: Queueable 체이닝 한도 50 작업.

## 12. Setup과 Non-Setup 오브젝트 개념은?
Setup 오브젝트는 메타데이터/구성(User, Profile, Group). Non-Setup 오브젝트는 비즈니스 데이터(Account, Contact). Mixed DML은 @future나 Queueable로 처리하지 않는 한 같은 트랜잭션에서 불허.
**팁:** 비동기 메서드로 mixed DML 우회.

## 13. Before Trigger와 After Trigger는 언제 써야 하나?
저장 전 값 수정(검증)엔 Before Trigger. ID가 있거나 관련 레코드 작업엔 After Trigger.
**팁:** 가능하면 before insert에서 DML 회피 / after 트리거에서 재귀 제어 없이 같은 레코드 쿼리/갱신 금지.

## 14. Apex의 Context Variable은 몇 가지이며 용도는?
예: Trigger.isInsert·isUpdate·isBefore·isAfter, Trigger.new·Trigger.old, Trigger.newMap·oldMap. 트리거 컨텍스트를 판단하고 데이터를 그에 맞게 조작.
**팁:** 각각 사용 사례로 설명 준비 / 흔한 실수: before insert에서 Trigger.old 사용.

## 15. Batch Apex의 execute 메서드는 어떻게 동작하나?
execute 메서드는 레코드의 부분집합(배치)을 처리한다. Salesforce가 Database.executeBatch에서 정의한 크기로 내부적으로 배칭한다.
**팁:** execute 안에서 벌크 안전 코딩 강조 / 필요시 Database.Stateful로 부분 성공/실패 로깅.

## 16. Opportunity Stage = 'Closed Won'일 때 Account.Status를 'Closed'로 갱신하는 트리거
```apex
trigger OpportunityTrigger on Opportunity (after update) {
Set<Id> accountIds = new Set<Id>();
for(Opportunity opp : Trigger.new){
if(opp.StageName == 'Closed Won' &&
Trigger.oldMap.get(opp.Id).StageName != 'Closed Won'){
accountIds.add(opp.AccountId);
}
}
List<Account> accList = [SELECT Id, Status__c FROM Account WHERE Id IN :accountIds];
for(Account acc : accList){
acc.Status__c = 'Closed';
}
update accList;
}
```
**팁:** 중복 방지에 Set 사용 / 불필요한 DML을 막으려 old와 new 값 비교.

## 17. Contact 생성 시 이메일 전송 (Trigger vs Flow)
Flow 사용: Record-Triggered Flow(생성 시) → Action → Send Email. 노코드·유지보수 쉬움·단순 자동화에 적합하기 때문.
**팁:** 2025년엔 단순 로직에 Flow 우선 / 벌크·복잡 로직엔 트리거가 낫다.

## 18. LWC(Lightning Web Components)에 대해 아는 것은?
LWC는 네이티브 웹 표준 기반의 현대적이고 빠른 UI 프레임워크. HTML, JS, Apex를 쓴다. 더 나은 성능을 위해 Aura 컴포넌트를 대체한다.
**팁:** @track(대부분 속성에 선택적)과 반응형 바인딩 언급 / 모듈성·단위 테스트 가능성 강조.

## 19. LWC에서 @track 데코레이터 사용이 필수인가?
최근 LWC 업데이트 기준, @track은 비-primitive 중첩 객체에만 필요하다. primitive 타입·단순 속성은 반응성이 자동 처리된다.
**팁:** tracked와 reactive 필드의 차이 숙지 / @api는 public 속성에 사용.

## 20. Platform Event Trigger란?
시스템이나 다른 Salesforce 로직이 발행한 이벤트를 수신하는 트리거.
```apex
trigger PETrigger on Order_Event__e (after insert) {
for(Order_Event__e ev : Trigger.new){
// Custom logic here
}
}
```
**팁:** 이벤트 기반 아키텍처에 사용 / after insert만 사용, before 없음.

## 21. Batch Apex란?
대용량 데이터셋을 비동기 처리하는 데 사용. 데이터를 청크로 나눠 start(), execute(), finish() 메서드로 처리한다. 확장 가능하며 최대 5천만 건 처리.
**팁:** 데이터 정리, 대량 갱신, 복잡한 리포팅 사용 사례 / 배치 간 데이터 추적엔 Database.Stateful.

## 22. Batch Apex에서 배치 크기를 변경할 수 있나? 어떻게?
예, Database.executeBatch(batchClass, batchSize)에서 배치 크기(1~2000)를 설정. 기본값 200.
**팁:** 작은 배치 크기 = 더 나은 오류 처리 / 큰 배치 크기 = 더 나은 성능, 그러나 실패 시 위험.

## 23. Batch Apex에서 한 레코드 처리 중 오류가 나면 어떻게 되나?
한 배치에서 한 레코드가 실패하면 그 배치 전체가 실패하지만 다른 배치는 계속된다. 부분 실패 처리엔 execute() 안에 try-catch를 쓰고 오류를 로깅한다.
**팁:** 오류 추적엔 Database.Stateful / execute() 안에 항상 오류 처리 구현.

## 24. Apex 메서드 안에서 DML 작업을 수행할 수 있나?
예, 가능하다. 단 거버너 한도를 준수해야 한다. 코드를 벌크화하고 루프 안 DML을 피한다.
**팁:** 항상 메서드 로직을 벌크 테스트 / 배치 시나리오에선 더 나은 제어를 위해 Database.insert().

## 25. LWC의 Lifecycle Hook이란?
컴포넌트의 생성·렌더 사이클 동안 동작을 제어한다. 주요: constructor()(컴포넌트 초기화), connectedCallback()(DOM 삽입 시), renderedCallback()(렌더 후), disconnectedCallback()(DOM 제거 시).
**팁:** constructor 안 무거운 로직 회피 / renderedCallback은 여러 번 발생하니 신중히.

## 26. Mixed DML 작업을 어떻게 처리하나?
Mixed DML(User + Account 갱신 등)은 같은 트랜잭션에서 오류를 던진다. @future, Queueable을 쓰거나 작업을 다른 트랜잭션으로 분리한다.
**팁:** Setup vs Non-Setup 오브젝트 규칙 / 필요시 항상 mixed DML을 비동기 블록으로 분리.

## 27. Apex의 System.enqueueJob()의 용도는?
Queueable Apex 작업을 비동기 처리하기 위해 enqueue한다. @future보다 유연하고 체이닝을 허용한다.
**팁:** 비동기 체이닝이 필요한 복잡한 로직에 사용 / 체인 작업 50개만 허용.

## 28. 통합에서 400 응답 코드는 무엇을 나타내나?
HTTP 400은 Bad Request — 잘못된 구문이나 유효하지 않은 입력으로 서버가 요청을 처리할 수 없음.
**팁:** 헤더, 인증, JSON 본문 확인 / 디버깅을 위해 전체 요청·응답 로깅.

## 29. 다음 조건의 Account를 조회하는 SOQL을 작성하라 (Industry='Healthcare', 관련 Contact 이메일이 'hospital.com'으로 끝남, 관련 Opportunity의 CloseDate가 향후 60일 내)
```sql
SELECT Id, Name FROM Account
WHERE Industry = 'Healthcare' AND Id IN (
SELECT AccountId FROM Contact WHERE Email LIKE '%@hospital.com'
) AND Id IN (
SELECT AccountId FROM Opportunity WHERE CloseDate = LAST_N_DAYS:60
)
```
**팁:** 자식 기반으로 부모를 필터할 땐 IN 서브쿼리 / SOQL 한도·중첩에 주의.

## 30. Apex의 Database 클래스란?
insert(), update(), delete() 같은 메서드에 더 많은 제어를 제공한다. allOrNone = false, 부분 DML, SaveResult 접근을 허용한다.
**팁:** 배치/비동기 작업엔 Database 클래스 선호 / 항상 SaveResult.isSuccess 확인·오류 로깅.

---

# Concentrix

## 1. Profile과 Permission Set의 차이는?
Profile은 오브젝트·필드·탭·앱에 대한 기본 접근을 정의하며 사용자당 하나만 가능. Permission Set은 프로필 변경 없이 추가 권한을 부여하며 여러 개 가능.
**팁:** 기본 접근엔 Profile / 프로필 복제 없이 팀 간 유연한 접근 확장엔 Permission Set.

## 2. 거버너 한도를 고려하며 Apex에서 벌크 데이터를 어떻게 처리하나?
코드 벌크화로: 컬렉션(List, Map) 사용, 루프 안 DML/쿼리 회피, 필요시 Batch나 Queueable 같은 비동기 Apex 활용.
**팁:** 트리거·메서드를 200+ 레코드 처리하도록 설계 / 디버깅 시 Limits 클래스로 리소스 사용량 모니터링.

## 3. Salesforce의 관계와 Lookup vs Master-Detail 사용 시점을 설명하라
Lookup(느슨한 결합, 선택적/필수), Master-Detail(강한 결합, 자식이 소유자/보안 상속), 다대다(junction 오브젝트로 구현). 독립성이 필요하면 Lookup, 자식이 부모와 함께 삭제되거나 roll-up summary가 필요하면 Master-Detail.
**팁:** Master-Detail은 부모 없이 존재 불가 / Lookup이 더 유연.

## 4. 레코드 저장 시 실행 순서는?
(1) 레코드 로드, (2) 시스템 검증 규칙, (3) before 트리거, (4) 커스텀 검증 규칙, (5) after 트리거, (6) assignment rule·auto-response·workflow·process builder·flow, (7) roll-up summary, (8) post-commit 로직(이메일, 비동기 작업).
**팁:** Flow나 검증 규칙이 언제 발생하는지 숙지 / 트리거 재귀 체크 언급.

## 5. @AuraEnabled(cacheable=true)는 @AuraEnabled와 어떻게 다른가?
@AuraEnabled(cacheable=true)는 Apex 메서드를 LWC/Aura에서 쓸 수 있게 하고 결과를 클라이언트 측에 캐싱한다. @AuraEnabled, public, 읽기 전용(DML 없음)이어야 한다.
**팁:** 서버 왕복 감소를 위해 읽기 전용 메서드에 사용 / 데이터 수정 메서드엔 절대 사용 금지.

## 6. Platform Events란? Salesforce에서 실시간 통신을 어떻게 가능하게 하나?
Platform Events는 실시간 pub-sub 통신을 위한 이벤트 기반 아키텍처 기능. Salesforce와 외부/내부 시스템 간 비동기 통신에 사용.
**팁:** 주문 업데이트, IoT 이벤트, 시스템 알림에 사용 / Apex 트리거·flow·CometD 경유 외부 시스템과 동작.

## 7. Queueable Apex는 Future Method, Batch Apex와 어떻게 다른가?
Future: 경량 비동기, 체이닝 불가, 제한된 컨텍스트. Queueable: 체이닝·복잡 로직·커스텀 타입 지원. Batch Apex: 대용량(수백만 건), 재시도·모니터링 지원.
**팁:** 데이터가 무겁지 않은 비동기 로직엔 Queueable / 벌크 처리엔 Batch.

## 8. Database.Stateful이란? Batch Apex에서 언제 써야 하나?
Database.Stateful은 배치 트랜잭션 간 상태(카운트나 오류 로그)를 유지한다. execute() 호출 간 데이터가 유지되어야 할 때 유용.
**팁:** 배치 간 누적 합계, 로그, 요약 추적 시 사용.

## 9. 거버너 한도를 피하려 SOQL 쿼리를 어떻게 최적화하나?
선택적 필터, SELECT * 회피, 인덱스 필드 사용, 낮은 cardinality 필드 필터, Developer Console의 Query Plan 같은 도구 활용.
**팁:** 대용량 데이터엔 항상 인덱스 필드로 쿼리 필터 / 관계 쿼리를 현명하게, 깊은 중첩 쿼리 회피.

## 10. 재귀 트리거를 어떻게 방지하나?
헬퍼 클래스에 static Boolean 변수를 써서 트리거가 이미 실행됐는지 확인하고, 그러면 재진입을 막는다.
```apex
public class TriggerHelper {
public static Boolean isFirstRun = true;
}
```
트리거에서:
```apex
if(TriggerHelper.isFirstRun) {
TriggerHelper.isFirstRun = false;
// logic here
}
```
**팁:** 트리거 안에 직접 static 변수 사용 금지, 항상 헬퍼 클래스 / 클래스·플래그로 로직 관리해 하드 한도 회피.

## 11. Visualforce의 standard controller, custom controller, controller extension 차이는?
Standard Controller: 특정 오브젝트용 자동 생성 로직. Custom Controller: 완전한 제어의 Apex 클래스, 오브젝트에 묶이지 않음. Controller Extension: Apex 클래스로 standard controller 로직을 추가/오버라이드.
**팁:** 단순 CRUD엔 standard / 복잡한 비즈니스 로직엔 extension이나 custom.

## 12. Continuation 클래스는 장시간 콜아웃 처리에 어떻게 도움이 되나?
Continuation은 Visualforce·LWC에서 장시간 HTTP 콜아웃을 비동기 처리한다. 응답을 기다리는 동안 서버 리소스를 확보한다.
**팁:** 정상 10초 한도를 초과하는 통합에 사용 / Visualforce·Aura만 지원(LWC 직접 미지원).

## 13. Lightning Data Service(LDS)란? 성능을 어떻게 개선하나?
LDS는 LWC/Aura 버전의 Standard Controller — Apex 없이 CRUD를 처리한다. 데이터 캐싱, 서버 호출 감소, 필드 수준 보안 자동 처리로 성능을 개선한다.
**팁:** lightning-record-form, lightning-record-edit-form, getRecord wire 어댑터 사용 / 기본 작업엔 Apex 불필요.

## 14. Custom Metadata Type은 Custom Settings와 어떻게 다른가?
Custom Metadata Type은 배포·패키징·버전 관리 가능 — org 간 구성에 좋음. Custom Settings는 배포가 쉽지 않고 신규 개발에 비권장.
**팁:** 2025+엔 구성·플래그·URL 등에 CMDT 선호 / CMDT는 Apex에서 getInstance로 접근 가능.

## 15. Salesforce의 통합 방법은? 실시간 데이터 동기화엔 무엇이 최선인가?
통합 방법: REST API, SOAP API, Platform Events, Outbound Messages, Named Credentials, Apex Callouts. 실시간 동기화엔 Platform Events나 @future/Queueable이 있는 REST API가 이상적.
**팁:** 경량 JSON 데이터엔 REST / publisher-subscriber 모델이 필요하면 Platform Events.

## 16. Lightning Message Service(LMS)는 LWC, Aura, Visualforce 간 통신을 어떻게 가능하게 하나?
LMS는 DOM 경계를 넘어 컴포넌트가 통신하게 한다. LWC에서 발행하고 Aura나 Visualforce에서 구독할 수 있다.
**팁:** 모듈식·이벤트 기반 UI 설계에 이상적 / 컴포넌트 계층이 부모-자식이 아닐 때 사용.

## 17. Shield Platform Encryption이란? Field-Level Security와 어떻게 다른가?
Shield Platform Encryption은 암호화 키로 저장 데이터를 보호한다. Field-Level Security는 UI·API에서 필드 수준 가시성을 제한한다.
**팁:** 컴플라이언스(HIPAA, GDPR)엔 Shield / FLS는 접근 제어, 암호화는 저장 제어.

## 18. 대용량 데이터(LDV)를 어떻게 처리하나?
선택적 SOQL(인덱스 필드), Skinny Table, 커스텀 인덱스, 비동기 처리(Batch Apex, Queueable), 공유 계산 지연(defer sharing).
**팁:** 비인덱스 필드의 조인·필터 회피 / LDV 트러블슈팅엔 Query Plan 도구가 최선의 친구.

---

# Hexaware

## 1. 트리거에서 재귀를 효율적으로 어떻게 방지하나?
헬퍼 클래스 안에 static Boolean 변수를 써서 트리거 로직이 트랜잭션당 한 번만 실행되게 한다.
```apex
public class TriggerControl {
public static Boolean isFirstRun = true;
}
```
트리거:
```apex
if (TriggerControl.isFirstRun) {
TriggerControl.isFirstRun = false;
// Your logic here
}
```
**팁:** 플래그를 별도 클래스에 / 트리거 안 재귀 DML 회피, 로직을 핸들러 클래스로.

## 2. 트리거가 자신을 발생시킨 같은 레코드를 갱신하면?
재귀나 "maximum trigger depth exceeded" 오류를 유발할 수 있다. before 트리거에선 같은 레코드 DML 불허. after 트리거에서 같은 레코드 갱신은 재귀를 유발한다.
**팁:** 필드 값 직접 설정엔 before 트리거 / 무한 루프 방지엔 static 플래그.

## 3. 벌크 처리에서 SOQL 거버너 한도를 어떻게 피하나?
for 루프 밖에 단일 SOQL을 쓴다. 필요하면 Map<Id, SObject>로 관련 데이터를 저장해 빠르게 접근한다.
```apex
Map<Id, Account> accMap = new Map<Id, Account>(
[SELECT Id, Name FROM Account WHERE Id IN :accIds]
);
```
**팁:** 루프 안에서 쿼리 금지 / 효율을 위해 Set<Id>와 map 사용.

## 4. 일반 쿼리 대신 SOQL for 루프는 언제 써야 하나?
SOQL for 루프는 내부적으로 queryMore()를 써서 큰 데이터셋을 처리한다. 5만 건 초과 쿼리 시 안전하다.
```apex
for (Account acc : [SELECT Id, Name FROM Account]) {
// process each record
}
```
**팁:** 큰 레코드 세트에 선호 / heap size 이슈를 제한.

## 5. 폴링 없이 LWC에서 실시간 업데이트를 어떻게 처리하나?
폴링 없이 실시간 푸시엔 Platform Events나 Lightning Message Service(LMS)를 쓴다.
**팁:** Platform Events = 서버→클라이언트 / LMS = 같은 페이지의 LWC↔Aura↔VF 통신.

## 6. Lightning Data Service(LDS)의 한계는?
Apex 같은 커스텀 로직 없음, 표준 DML로 제한, 복잡한 조건·검증 처리 불가.
**팁:** 로직·커스텀 검증이 필요하면 Apex / 성능·FLS 처리엔 LDS.

## 7. 실시간 통합에서 API rate limit을 어떻게 처리하나?
rate limit 헤더가 있는 Named Credentials, 가능한 캐싱, 폴백 로직(Platform Events나 Queueable Apex 경유 재시도 큐)을 쓴다.
**팁:** 가능하면 Retry-After 헤더 사용 / Limits.getApiCalls()로 한도 모니터링.

## 8. 만료된 OAuth 토큰을 자동 갱신하는 최선의 방법은?
refresh token을 안전하게 저장하고 현재 토큰 만료 시 새 액세스 토큰을 받는다. Named Credential이 적절히 구성되면 자동 처리된다.
**팁:** 자동 갱신엔 Named Credentials(2025 업데이트가 OAuth 2.0 refresh 내장 지원) / 토큰 안전 저장(하드코딩 금지).

## 9. Queueable, Future, Batch Apex는 언제 써야 하나?

| 방법 | 사용 시점 |
|---|---|
| Future | 단순·비복잡 비동기 콜아웃 |
| Queueable | 체인 작업, 커스텀 클래스 로직 |
| Batch Apex | 5만 건 초과 처리, 청크 처리 |

**팁:** 현대 사례의 90%엔 Queueable / Future는 레거시, 최소 로직 / Batch는 스케줄된 대용량.

## 10. API 재시도에서 중복 레코드를 피하려 멱등성을 어떻게 보장하나?
고유 external key나 correlation ID를 생성하고, 레코드 삽입 전에 같은 ID 레코드가 이미 있는지 확인한다.
**팁:** 항상 external ID 필드 사용 / 안전한 재시도엔 Salesforce에서 ExternalId__c로 UPSERT.

## 11. setInterval이나 폴링 없이 LWC에서 실시간 데이터 업데이트를 어떻게 처리하나?
Platform Events나 LMS로 실시간 푸시한다. 같은 페이지 통신엔 LMS가, 크로스 유저 업데이트엔 Platform Events가 선호된다.
**팁:** 성능을 위해 setInterval 회피 / 앱 내 이벤트엔 LMS, org 전체 업데이트엔 Platform Events.

## 12. LWC에서 LDS와 Apex의 차이는? 언제 무엇을 써야 하나?
LDS는 Apex 없이 데이터 접근을 처리하며 FLS·CRUD를 자동 존중. Apex는 커스텀 로직, 다중 오브젝트, DML이 필요할 때.
**팁:** 단일 레코드의 단순 CRUD엔 LDS / 배치 로직, SOQL 필터, 관련 오브젝트엔 Apex.

## 13. 대량 데이터를 가져오는 LWC 컴포넌트를 어떻게 최적화하나?
페이지네이션 지연 로딩, sessionStorage로 자주 접근하는 데이터 캐싱, 서버 측 SOQL 선택적 필터로 반환 레코드 최소화.
**팁:** SOQL에 항상 LIMIT / 한 번에 모두 로드 회피, 무한 스크롤이나 "Load More" 사용.

## 14. Apex 없이 여러 LWC 컴포넌트 간 데이터를 공유하는 최선의 방법은?
형제·무관 컴포넌트엔 LMS, 부모-자식 통신엔 @api/@track.
**팁:** 깊게 중첩된 컴포넌트엔 이벤트 체인 회피 / LMS는 확장 가능·프레임워크 지원.

## 15. 성능 개선을 위해 LWC에서 캐싱을 어떻게 구현하나?
Apex 메서드엔 @wire with cacheable=true, 읽기 전용 데이터의 임시 캐싱엔 sessionStorage나 localStorage.
**팁:** 읽기 전용 데이터만 캐싱 / localStorage에 민감 데이터 저장 회피.

## 16. LWC에서 wire 어댑터와 명령형 Apex 호출의 핵심 차이는?
Wire는 반응형, 매개변수 변경 시 자동 새로고침. 명령형은 완전한 제어가 필요할 때(버튼 클릭 등) 유용.
**팁:** 자동 갱신 UI엔 @wire / 조건부·이벤트 기반 조회엔 명령형.

## 17. Salesforce를 외부 시스템과 통합할 때 API rate limit을 어떻게 처리하나?
Limits.getApiCalls()나 헤더(X-RateLimit-Remaining)로 사용량 모니터링. 지수 백오프 재시도를 구현하고 가능하면 배치 처리.
**팁:** 스케줄 작업으로 요청 분산 / 디버그 로그·헬스 체크로 한도 모니터링.

## 18. 장시간 통합에서 OAuth 토큰을 자동 갱신하는 최선의 접근은?
OAuth 2.0이 토큰 자동 갱신으로 구성된 Named Credentials를 쓴다. 안전하고 Salesforce가 관리한다.
**팁:** 항상 Named Credentials 선호 / 커스텀 인증이 필요하지 않으면 수동 토큰 처리 회피.

## 19. Salesforce가 외부 API 요청 처리에 실패하면 데이터 일관성을 어떻게 보장하나?
correlation ID가 있는 재시도 메커니즘을 쓰고, 실패한 요청을 커스텀 오브젝트에 로깅해 수동/자동 재시도한다.
**팁:** 재시도 추적엔 correlation ID 저장 / Mulesoft 같은 미들웨어 사용 시 DLQ 추가.

## 20. Named Credentials와 커스텀 인증 메커니즘의 차이는?
Named Credentials가 Salesforce 권장 방식이다. 인증·토큰 갱신·콜아웃을 안전하게 처리한다. 커스텀 인증은 더 많은 제어를 주지만 위험·복잡성을 높인다.
**팁:** Named Credentials = 로우코드·안전 / 커스텀 인증 = 비표준 프로토콜·서드파티 인증 흐름.

## 21. API 통합에서 중복 레코드를 막으려 재시도를 어떻게 처리하나?
external ID 필드와 UPSERT 작업을 쓴다. 실패한 요청 재시도 전 correlation ID로 레코드 존재 여부를 확인한다.
**팁:** 고유 키나 ExternalId__c 사용 / 재시도 상태용 integration log 테이블 유지.

## 22. REST API로 Salesforce 데이터를 노출할 때 보안 베스트 프랙티스는?
인증엔 Named Credentials가 있는 @RestResource 사용, 오브젝트·필드 수준 보안 강제(stripInaccessible), 입력 sanitize·접근 로깅·rate limiting 적용.
**팁:** 내부 오브젝트·시스템 필드 노출 금지 / OAuth scope 사용·액세스 토큰 수명 제한.

---

# Dell Technologies (Salesforce Developer)

## 1. Salesforce에서 Apex 코드를 실행하는 방법은?
트리거, Batch Apex, Queueable Apex, future 메서드, schedulable Apex, REST/SOAP 웹 서비스, Visualforce 컨트롤러, Lightning 컴포넌트(Apex 컨트롤러), 익명 Apex 실행으로 호출 가능.
**팁:** 비즈니스 시나리오에 맞는 컨텍스트 숙지, 특히 비동기 처리·통합.

## 2. Apex에서 벌크 데이터를 효율적으로 어떻게 처리하나?
트리거 벌크화, 루프 안 SOQL 최소화, 컬렉션(map, list, set) 사용, 대용량엔 Batch나 Queueable Apex 활용.
**팁:** 거버너 한도를 피하려 항상 벌크 데이터(200+)로 테스트.

## 3. Sharing rule과 manual sharing의 차이는?
Sharing rule은 그룹·역할에 접근을 확장하는 자동·관리자 구성 규칙. Manual sharing은 사용자가 개별 레코드에 접근을 부여하는 레코드 수준 공유.
**팁:** Manual sharing은 예외에, sharing rule은 더 넓은 접근에 유용.

## 4. Apex의 "with sharing"과 "without sharing" 키워드의 용도는?
with sharing은 sharing rule(레코드 수준 접근)을 강제해 Apex가 사용자 권한을 존중하게 한다. without sharing은 sharing rule을 무시하며 시스템 수준 작업에 유용.
**팁:** 보안을 위해 기본 with sharing / without sharing은 신중히.

## 5. Apex로 외부 API를 어떻게 호출하나?
REST 호출엔 HttpRequest·Http 클래스, SOAP엔 WSDL에서 Apex 클래스 생성. 장시간이면 콜아웃을 비동기 처리.
**팁:** 인증 관리를 쉽게 하려 Named Credentials.

## 6. 트리거 작성 시 핵심 고려사항은?
벌크화 유지, 루프 안 SOQL/DML 회피, 재귀 처리, 핸들러 클래스가 있는 오브젝트당 트리거 하나, 모든 트리거 컨텍스트(before/after insert/update/delete) 커버.
**팁:** 유지보수성을 위해 프레임워크 패턴.

## 7. 테스트 클래스가 충분한 커버리지를 제공하도록 어떻게 보장하나?
테스트 클래스 안에서 테스트 데이터 생성, 모든 분기·시나리오 커버, Test.startTest()·Test.stopTest() 사용, assertion으로 동작 검증.
**팁:** 75%+ 목표이되 라인 수가 아닌 의미 있는 테스트에 집중.

## 8. @future와 Queueable Apex의 차이는?
@future는 단순하나 제한적(체이닝·복잡 타입 없음). Queueable은 체이닝·복잡 타입·작업 상태 모니터링 지원.
**팁:** 더 많은 제어·확장성엔 Queueable Apex 선호.

## 9. 대용량 데이터(LDV)를 어떻게 처리하나?
인덱스가 있는 선택적 SOQL, Batch Apex, Skinny Table, 비동기 처리, 오래된 데이터 아카이빙.
**팁:** 성능 모니터링·SOQL 최적화에 Query Plan 도구.

## 10. Platform Events의 용도를 설명하라
Salesforce와 외부 시스템·내부 컴포넌트 간 실시간 통신을 위한 이벤트 기반 아키텍처를 비동기로 제공한다.
**팁:** 프로세스 분리·실시간 통합에 사용.

## 11. Account, Opportunity, Product 간 오브젝트 관계를 어떻게 관리하나?
Account는 표준 lookup으로 Opportunity에 연결. 각 Opportunity는 여러 Opportunity Line Item(Product)을 가질 수 있다. 이 Line Item은 Product·Pricebook에 연결되어 Opportunity별 제품 선택·가격을 가능하게 한다. 복잡한 경우 Product Schedule이나 커스텀 junction으로 가용성·번들 관리.
**팁:** OpportunityLineItem 오브젝트 구조 숙지 / Pricebook2·PricebookEntry 이해 / 번들 제품·CPQ 통합 처리 경험 강조.

## 12. Opportunity, Quote, Order의 차이를 설명하라
Opportunity는 거래를 포착. Quote는 공식 가격 제안. Opportunity당 여러 Quote 가능하나 하나만 Primary. Order는 거래 성사 후 이행을 추적. 흐름: Opportunity → Quote → Order. 자동화로 Opportunity→Quote, Quote→Order 제품 동기화.
**팁:** 실제 사용 사례 명확히(Sales → Quote → Delivery) / 해당 시 Quote Template이나 커스텀 Quote PDF 언급.

## 13. Governor Limit이란? Apex에서 어떻게 처리하나?
멀티테넌트 아키텍처에서 리소스 독점을 막는다. 벌크화, 루프 안 DML/SOQL 최소화, Map/Set 같은 컬렉션 활용으로 처리. 디버깅엔 Limits.getLimitDmlStatements(), 필요시 Queueable로 비동기 처리.
**팁:** 항상 벌크화·루프 안 SOQL 이슈 언급 / Limit 클래스·모니터링 도구 사용 경험 언급.

## 14. 성능 이슈가 있는 Flow를 어떻게 최적화하나?
루프 안 DML/SOQL을 확인해 밖으로 옮긴다. 큰 Flow를 subflow로 분할, 불필요한 화면 요소 감소, 단일 레코드 요소 대신 Fast Lookup/Create/Update 사용. 필요시 로직을 Apex로 이동.
**팁:** Flow Debug Log·Tooling 사용 강조 / Flow 실행 순서·Entry Condition 튜닝 언급.

## 15. Aura와 LWC의 차이는? 언제 무엇을 쓰나?
LWC는 ES6+ 같은 웹 표준 기반의 현대적·경량. Aura는 더 오래되고 컴포넌트 중심. 신규 개발엔 성능·표준화 때문에 LWC 선호. 레거시 호환이나 LWC가 아직 지원하지 않는 application event가 필요하면 Aura.
**팁:** 신규 빌드엔 항상 LWC 권장 / 마이그레이션·이중 사용 실제 사례 언급.

## 16. Salesforce와 서드파티 앱(Xactly, Mulesoft, BoostUp) 간 API 통합 이슈를 어떻게 트러블슈팅하나?
먼저 Salesforce의 Integration Log나 Named Credential 디버그 로그를 확인. 401(Unauthorized)·500(Internal Server Error) 같은 API 오류 응답 검토. Postman, Mulesoft 로그, Debug Log로 JSON·페이로드 불일치 식별. 엔드포인트 URL·인증 토큰·페이로드 구조 검증.
**팁:** 항상 디버그 로그·응답 코드부터 / Named Credentials·Remote Site Settings·MuleSoft Anypoint 모니터링 / 버저닝 이슈·토큰 만료 처리 강조.

## 17. Salesforce 샌드박스 새로고침 베스트 프랙티스와 새로고침 후 단계는?
새로고침 후 사용자 접근 확인, 인증서 재생성, 통합(Auth Provider, Named Credentials) 재연결. 민감 데이터 익명화·Workflow Rule·Scheduled Job 비활성화 스크립트 실행. 샌드박스 이메일 전달을 "System email only"로 설정.
**팁:** 새로고침 후 자동화 비활성화 언급 / Connected App·SSO 설정·outbound message 잊지 말 것.

## 18. Gearset 등 DevOps 도구에서 실패한 배포를 어떻게 트러블슈팅하나?
Gearset 배포 요약을 검토해 누락된 의존성이나 테스트 실패를 식별. 낮은 샌드박스에서 먼저 검증. 흔한 이슈: 필드 수준 보안 누락, 네임스페이스, 프로필 메타데이터 충돌. 테스트 재실행, 메타데이터 필터 조정, 의존 컴포넌트 수동 포함.
**팁:** scratch org이나 partial 샌드박스에서 검증 언급 / 좋은 소스 컨트롤 위생(Git 브랜치·태그) 강조.

## 19. SOQL vs SOSL — 각각 언제 써야 하나?
SOQL은 구조화된 쿼리로 단일/관련 오브젝트에서 레코드 조회. SOSL은 여러 오브젝트·필드에 걸친 전문 검색. 정밀 필터링(WHERE)엔 SOQL, Lead·Contact·Account 같은 오브젝트에 키워드 검색엔 SOSL.
**팁:** 시나리오 제시: 글로벌 검색 vs 타겟 조회 / SOSL이 관련 오브젝트 필드를 직접 지원하지 않는 한계 언급.

## 20. 데이터·애플리케이션 보안 베스트 프랙티스를 어떻게 구현하나?
데이터 수준엔 OWD, Profile, Permission Set, FLS. 통합엔 OAuth가 있는 Named Credentials, IP 화이트리스트, 토큰 기반 인증. 애플리케이션 로직엔 LWC·API에 민감 필드 노출 회피, Apex에 CRUD/FLS 체크.
**팁:** 컴플라이언스엔 Shield Platform Encryption이나 Audit Trail / guest user 접근·커뮤니티 보안 다루기.

## 21. 비즈니스 사용자가 승인 프로세스가 예상대로 트리거되지 않는다고 보고한다. 어떻게 트러블슈팅하나?
승인 프로세스의 entry criteria를 검토해 레코드가 조건을 충족하는지 확인. workflow 평가 기준("생성 시, 그리고 편집할 때마다")이 올바른지 확인. before-save Flow나 트리거가 기준에 영향을 주는 필드 값을 바꾸는지 검토.
**팁:** 승인 프로세스는 생성/갱신 시에만 발생, Apex에서 직접 아님 / 간섭하는 Process Builder/Flow/Trigger 로직 확인 언급.

## 22. 사용자가 Opportunity Line Item을 볼 수 없는 케이스. 어떻게 해결하나?
먼저 OpportunityLineItem 오브젝트에 대한 프로필·permission set 접근 확인. Opportunity 공유 설정으로 레코드 수준 접근 검증. Opportunity가 공유되고 관련 Price Book이 활성·접근 가능한지 확인. Page Layout에 관련 리스트가 포함됐는지 확인.
**팁:** Product2·PricebookEntry 권한 잊지 말 것 / 흔한 숨은 원인으로 FLS 언급.

## 23. Mulesoft 통합이 멈췄다. 어떻게 조사·수정하나?
MuleSoft Anypoint 로그를 확인해 실패 지점 파악 — 종종 인증 실패(토큰 만료나 접근 취소). Salesforce에서 Named Credential, Remote Site Settings, 디버그 로그 검토. 페이로드 형식·상태 코드(401/403 인증 이슈, 500 서버 오류) 검증.
**팁:** Mule 로그의 trace ID·Named Credentials OAuth 오류 호출 / 모니터링 대시보드·API 알림 시스템 제안.

## 24. 고객이 CPQ quote 계산이 잘못됐다고 보고한다. 어떻게 디버깅하나?
Price Rule, Product Rule, Quote Line Editor 플러그인이 예상대로 동작하는지 확인. "Calculate"를 수동 재실행하고 계산 시퀀스가 트리거되는지 확인. 가격을 오버라이드하는 커스텀 필드·스크립트 검토. 동적 규칙이면 샘플 데이터로 규칙 로직 테스트.
**팁:** CPQ 로직은 시퀀스 의존, Debug Log + CPQ Log로 디버그 / Preview Mode에서 테스트·규칙 평가 이벤트 확인.

## 25. SLA용 고객 지원 대시보드·리포트를 최적화하려면?
First Response Time, Resolution Time 같은 SLA 지표를 포착하는 커스텀 formula 필드를 만들어 Milestone에 연결. Case + Milestone 데이터로 report type 구축. bucketing·summary formula·필터로 실시간 인사이트. 대시보드는 우선순위·큐·시간별 컴포넌트 필터.
**팁:** Entitlement 경유 Milestone 추적 강조 / SLA 알림엔 report subscription 사용 언급.

---

# J.P. Morgan

## [Admin 질문]

### 1. 데이터 관리: 데이터 마이그레이션과 무결성 보장 접근은?
(1) 소스·타겟 시스템의 데이터 구조·의존성 분석, (2) Data Loader나 MuleSoft 같은 ETL 도구 사용, (3) 마이그레이션 전 데이터 정제·검증으로 중복 제거·오류 수정, (4) Salesforce 스키마 호환을 위한 데이터 매핑·변환 규칙 정의, (5) 테스트 마이그레이션으로 잠재 이슈 식별, (6) 리포트·대시보드·사용자 피드백으로 마이그레이션 데이터 검증, (7) 감사·향후 참조를 위해 전 과정 문서화.
**팁:** 실제 마이그레이션 프로젝트 예 강조 / 백업·롤백 계획 중요성 / 데이터 품질 유지에 validation rule·error log 역할 언급.

### 2. 보안 조치: 데이터 유출·무단 익스포트를 막을 전략은?
(1) 필드 수준 보안·sharing 설정으로 역할 기반 접근 제한, (2) IP 화이트리스트·세션 설정으로 신뢰 네트워크·기기 제한, (3) Salesforce Shield로 민감 데이터 모니터링·암호화, (4) DLP 전략(익스포트 로그 모니터링·과도한 다운로드 차단), (5) 2FA·SSO 활성화, (6) 사용자 보안 정책 교육.
**팁:** Event Monitoring 같은 모니터링 도구가 데이터 유출 식별에 도움 / 접근 로그·보안 구성 주기 감사 중요성 강조.

### 3. 커스터마이징: 커스텀 오브젝트·필드 생성·관리 과정은?
(1) Setup의 Object Manager 이동, (2) "Create"로 이름·라벨·record type 등 속성으로 새 커스텀 오브젝트 정의, (3) picklist·lookup·formula 등 적절한 필드 타입으로 커스텀 필드 추가, (4) 필드 수준 보안·페이지 레이아웃 설정, (5) validation rule·workflow 생성으로 무결성 강제·프로세스 자동화, (6) 비즈니스 요구사항 정렬을 위한 테스트·배포.
**팁:** 환경 간 배포에 Change Set이나 Salesforce DX / 기존 통합·리포트에 미치는 필드 변경 영향 이해 강조.

### 4. 사용자 관리: 사용자 프로비저닝과 적절한 접근 수준 유지는?
(1) 조직 요구사항에 맞는 role·profile·permission set 정의, (2) User Management 페이지·API로 프로비저닝, (3) 최소 권한 원칙으로 라이선스·권한 할당, (4) 주기적으로 역할·권한 감사, (5) 비활성 사용자 비활성화·무단 접근 시도 모니터링.
**팁:** 자동 프로비저닝 도구 경험 강조 / 사용자 온보딩·오프보딩을 효율적으로 처리한 시나리오 설명.

### 5. 자동화 도구: Workflow Rule이란? Process Builder와 어떻게 다른가?
Workflow Rule은 필드 업데이트·이메일 알림·작업 생성 같은 단순 자동화. Process Builder는 더 고급으로 다중 기준·액션(Apex 호출, 레코드 생성, Flow 시작)을 지원하고 자동화 로직을 시각적으로 표현한다.
**팁:** 향후 자동화엔 Flow를 쓰라는 Salesforce 권장 언급 / Workflow Rule에서 Process Builder/Flow로 전환한 예.

## [Development 질문]

### 6. Apex 프로그래밍: 효율적·확장 가능한 Apex 코드의 베스트 프랙티스는?
(1) 대용량 처리를 위한 벌크화 코드, (2) 하드코딩 회피·custom setting/label 사용, (3) 거버너 한도 효과적 활용, (4) 적절한 예외 처리·로깅, (5) 헬퍼 클래스·유틸리티 메서드로 재사용 가능 코드, (6) 배포 전 peer review·코드 품질 체크.
**팁:** 75%+ 커버리지의 단위 테스트 중요성 / 성능 이슈 해결을 위해 Apex 코드 최적화한 예.

### 7. 통합 기법: Apex에서 외부 서비스 콜아웃을 어떻게 구현하나?
(1) 동기 콜아웃엔 HttpRequest·Http 클래스, (2) Named Credential이나 OAuth 토큰으로 인증, (3) JSON/XML 역직렬화로 응답 파싱, (4) 필요시 @future나 Queueable로 비동기 처리, (5) 타임아웃·네트워크 오류 관리를 위한 예외 처리, (6) HttpCalloutMock으로 격리 단위 테스트.
**팁:** 콜아웃 관련 거버너 한도 중요성 / API key·민감 데이터 보안 전략.

### 8. 오류 처리: Apex에서 예외 처리 방법은?
(1) 예상 오류 관리에 try-catch, (2) 모니터링을 위해 커스텀 오브젝트나 Platform Events로 예외 로깅, (3) UI에 사용자 친화적 오류 메시지 표시, (4) 불필요한 예외 억제 회피로 중요 이슈 즉시 처리, (5) 오류 응답 표준화를 위한 재사용 예외 처리 유틸리티 클래스.
**팁:** 운영의 복잡한 예외 디버깅 예 / Debug Log·Error Log 도구 강조.

### 9. 테스트 프레임워크: Apex 테스트가 견고하고 충분한 커버리지를 갖도록 어떻게 보장하나?
(1) 긍정·부정 시나리오를 커버하는 테스트 메서드, (2) 재사용·일관된 테스트 데이터를 위한 test data factory, (3) 최소 75% 커버리지(미션 크리티컬 클래스엔 더 높게), (4) @isTest로 테스트 격리·org 데이터 의존성 회피, (5) 테스트 중 비즈니스 로직·거버너 한도 준수 검증.
**팁:** CI/CD 파이프라인 경험 / 통합 테스트에 Selenium이나 Provar 사용 언급.

### 10. Visualforce vs Lightning: 핵심 차이는?
(1) Visualforce는 서버 측 렌더링, Lightning은 클라이언트 측 렌더링으로 더 빠른 UX, (2) Lightning은 JavaScript·CSS 같은 현대 웹 표준, Visualforce는 Apex·HTML, (3) Lightning은 동적 상호작용·SPA 지원, Visualforce는 페이지 중심, (4) Lightning 개발은 모듈식·재사용 컴포넌트, Visualforce는 모놀리식.
**팁:** Visualforce→Lightning 마이그레이션 프로젝트 강조 / 성능 최적화에 LWC 사용한 방법.

## [Security & Integration 질문]

### 11. 인증 프로토콜: SSO는 Salesforce 보안을 어떻게 강화하나?
(1) 한 자격 증명으로 Salesforce·연결 앱에 접근해 비밀번호 취약성 감소, (2) MFA 같은 강한 인증 정책을 강제하는 IdP로 중앙화 인증, (3) 비밀번호 관리 과제 최소화·피싱 위험 감소, (4) SAML·OAuth 같은 토큰 기반 프로토콜로 안전한 세션 관리, (5) 로그인 활동 상세 감사 추적.
**팁:** Okta·Azure AD로 SSO 구성 경험 / IdP의 보안 정책 중요성 언급.

### 12. 데이터 암호화: 민감 데이터 암호화 옵션은?
(1) 자체 키로 저장 필드 암호화하는 Shield Platform Encryption, (2) 제한된 필드 타입의 커스텀 필드를 암호화하는 Classic Encryption, (3) 전송 데이터 보안에 HTTPS/SSL, (4) 민감 정보를 고유 식별자로 대체하는 토큰화, (5) 향상된 키 관리를 위한 외부 암호화 서비스 통합.
**팁:** Shield Platform Encryption 구현 시나리오 / 키 로테이션·안전한 키 저장 중요성.

### 13. API 보안: Salesforce의 RESTful API를 어떻게 보호하나?
(1) 안전한 API 인증·토큰 관리에 OAuth 2.0, (2) API 접근에 IP 화이트리스트·세션 제한, (3) 남용 방지·트래픽 관리에 API rate limit, (4) 안전한 전송에 TLS 암호화, (5) 의심 활동·무단 접근 시도에 API 로그 모니터링.
**팁:** JWT나 Refresh Token 흐름 경험 / API 보안 테스트에 Postman 같은 도구 언급.

### 14. 모니터링 도구: 통합 활동을 어떤 도구·방법으로 모니터링·감사하나?
(1) API 사용·로그인 시도·데이터 익스포트 추적에 Event Monitoring, (2) 통합 프로세스 상세에 Debug Log·Log Inspector, (3) 실시간 알림에 Splunk·New Relic 같은 서드파티 도구, (4) 데이터 흐름 모니터링·이상 식별에 스케줄 리포트·대시보드, (5) 통합 지점의 정기 보안 감사.
**팁:** 모니터링 도구가 중요 통합 이슈를 해결한 예 / 컴플라이언스·보안에 audit log 역할.

### 15. 컴플라이언스 표준: Salesforce 구현이 산업별 규정을 준수하도록 어떻게 보장하나?
(1) GDPR·HIPAA·SOX 같은 표준에 맞추는 철저한 요구사항 분석, (2) 데이터 암호화·감사 추적·이벤트 모니터링에 Salesforce Shield, (3) 규제 요구사항에 맞는 데이터 보존 정책 구성, (4) 산업별 컴플라이언스 기능을 위한 Health Cloud·Financial Services Cloud, (5) 변화하는 규정에 따라 구성 정기 검토·갱신.
**팁:** Salesforce 구현의 컴플라이언스 감사 경험 / 컴플라이언스 문서화·유지 도구·전략 강조.

---

# Deloitte (시나리오 기반)

## 1. Apex 트리거: 관련 Account의 전화번호가 바뀔 때 Contact를 갱신하는 트리거를 작성하라
Account에 트리거를 작성해 Trigger.oldMap·Trigger.newMap에서 phone 변경을 확인한다. 영향받은 각 account의 관련 contact를 쿼리해 phone 필드를 갱신한다.
```apex
trigger UpdateContactPhone on Account (after update) {
Map<Id, String> updatedAccounts = new Map<Id, String>();
for (Account acc : Trigger.new) {
if (Trigger.oldMap.get(acc.Id).Phone != acc.Phone) {
updatedAccounts.put(acc.Id, acc.Phone);
}
}
if (!updatedAccounts.isEmpty()) {
List<Contact> contactsToUpdate = [
SELECT Id, Phone FROM Contact WHERE AccountId IN :updatedAccounts.keySet()
];
for (Contact con : contactsToUpdate) {
con.Phone = updatedAccounts.get(con.AccountId);
}
update contactsToUpdate;
}
}
```
**팁:** 거버너 한도 준수를 위해 항상 벌크 데이터 처리 / 값 비교엔 Trigger.oldMap·newMap / 벌크 업데이트 포함 다양한 시나리오로 테스트.

## 2. 데이터 관계: Salesforce에서 일대일 관계를 어떻게 만드나?
Salesforce는 일대일 관계를 네이티브 지원하지 않지만 고유 필드와 커스텀 lookup 조합으로 시뮬레이션할 수 있다. 예: 커스텀 오브젝트에 고유 external ID와 다른 오브젝트를 가리키는 필수 lookup.
**팁:** 관계 고유성 강제에 validation rule / 같은 부모와의 다중 연결을 막으려 자식에 고유 필드.

## 3. Batch Apex: 어떻게 동작하며 언제 쓰나?
Batch Apex는 대량 레코드를 관리 가능한 청크(배치)로 나눠 비동기 처리한다. Database.Batchable 인터페이스를 start, execute, finish 세 메서드로 구현해야 한다.
**팁:** 다양한 배치 크기로 테스트 / 각 배치에서 오류 처리 / 배치 간 상태 유지엔 Database.Stateful.

## 4. 통합 경험: REST/SOAP API로 외부 시스템과 통합한 경험을 설명하라
ERP 시스템과 통합한 예를 공유했다. REST API로 레코드 실시간 업데이트를 보냈다. GET·POST 같은 HTTP 메서드와 Apex의 HttpRequest·HttpResponse 클래스를 활용했다.
**팁:** OAuth 2.0 같은 인증 프로토콜로 통합 보안 / 코딩 전 Postman으로 엔드포인트 테스트 / 콜아웃 한도·오류 응답 우아하게 처리.

## 5. 비동기 처리: @future, Queueable, Scheduled Apex를 써봤나? 실제 예는?
복잡한 계산 후 이메일 알림에 @future를 썼다. 작업 체이닝엔 Queueable, 외부 시스템 데이터 동기화 같은 일일 작업 자동화엔 Scheduled Apex를 썼다.
**팁:** 복잡 처리·작업 체이닝엔 Queueable / 한도 도달을 막으려 과도한 작업 체이닝 회피.

## 6. LWC: LWC 컴포넌트를 만들어봤나? 어떤 도전을 겪었나?
필터링이 가능한 관련 레코드 목록을 표시하는 LWC 컴포넌트를 만들었다. 도전: Apex로 비동기 데이터 조회 처리, 크로스 브라우저 호환성 보장.
**팁:** 성능 개선을 위해 필요할 때만 Apex / 가능하면 LDS 활용 / @wire 데코레이터로 성능 최적화.

## 7. 트리거 컨텍스트 변수: Trigger.new와 Trigger.old의 차이는?
Trigger.new는 레코드의 새 버전, Trigger.old는 변경 전 상태. Trigger.old는 update·delete 트리거에만 사용 가능.
**팁:** 효율적 비교엔 Trigger.oldMap·newMap / delete 트리거에서 오류를 막으려 null 체크.

## 8. 거버너 한도: 코드가 거버너 한도를 준수하도록 어떻게 보장하나?
코드 벌크화로 SOQL·DML을 최소화한다. map·set 같은 컬렉션으로 데이터를 효율 처리한다.
**팁:** 루프 안 SOQL/DML 회피 / 읽기 전용 트랜잭션엔 @ReadOnly 어노테이션.

## 9. 배포 프로세스: Salesforce 배포 과정과 쓴 CI/CD 도구는?
작은 배포엔 change set, CI/CD엔 Salesforce DX·Jenkins를 썼다. 메타데이터 배포·자동 테스트 실행 예를 공유했다.
**팁:** 협업을 위해 버전 관리 / 배포 후 오류를 막으려 타겟 환경에서 테스트 실행.

## 10. 보안 모델: Profile, Permission Set, Role의 차이는?
Profile은 기본 권한 정의, Permission Set은 프로필 변경 없이 권한 확장, Role은 role hierarchy 기반 레코드 수준 접근 결정.
**팁:** 확장성엔 permission set / 데이터 보안 유지를 위해 role hierarchy 정기 검토.

## 11. Batch Apex 사용 사례: Contact의 dueDate__c. 향후 3일 내 마감 레코드에 대해 소유자에게 알림을 보내라
향후 3일 내 마감인 모든 contact를 쿼리하고 Apex Messaging으로 알림을 보내는 Batch Apex 클래스를 만든다.
```apex
public class ContactNotificationBatch implements Database.Batchable<SObject> {
public Database.QueryLocator start(Database.BatchableContext context) {
return Database.getQueryLocator([
SELECT Id, OwnerId, DueDate__c FROM Contact WHERE DueDate__c = TODAY + 3
]);
}
public void execute(Database.BatchableContext context, List<Contact> contacts) {
for (Contact con : contacts) {
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
email.setTargetObjectId(con.OwnerId);
email.setSubject('Upcoming Due Date');
email.setPlainTextBody('Contact ' + con.Id + ' has a due date approaching.');
Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
}
}
public void finish(Database.BatchableContext context) {}
}
```
**팁:** 배치 클래스를 매일 실행하도록 스케줄 / 오류를 우아하게 처리·실패 알림 로깅.

## 12. execute 안의 SOQL: execute 메서드 안에서 SOQL을 쓸 수 있나?
가능하나 거버너 한도 이슈를 유발할 수 있어 비권장. SOQL은 start 메서드나 execute 진입 전에 수행해야 한다.
**팁:** start 메서드에서 컬렉션·map으로 데이터 사전 로드 / execute에서 레코드별 쿼리 회피.

## 13. 필드 필수 설정: Salesforce에서 필드를 필수로 만드는 방법은?
스키마의 오브젝트 수준, 페이지 레이아웃, 또는 조건부 요구사항엔 validation rule로 필수화 가능.
**팁:** 동적 요구사항엔 validation rule / 충돌을 피하려 한 가지 방법만 선택.

## 14. 트리거 베스트 프랙티스: 트리거 작성 베스트 프랙티스는?
(1) 오브젝트당 트리거 하나, (2) 로직을 핸들러 클래스에 위임, (3) 다중 레코드 처리를 위한 벌크화, (4) static 변수로 재귀 회피.
**팁:** 트리거를 작게·위임에 집중 / 변수·메서드에 의미 있는 이름.

## 15. 트리거 우회: 트리거를 어떻게 우회하나?
static 변수로 트리거 실행 시점을 제어한다. 예: 작업 전 static boolean을 설정해 트리거 로직을 우회.
**팁:** 우회 과용 회피(디버깅 복잡) / 우회가 필요한 이유 문서화.

## 16. Lifecycle Hook: 상세히 설명하라
LWC의 lifecycle hook엔 connectedCallback(컴포넌트가 DOM에 삽입될 때), disconnectedCallback(제거될 때) 등이 있다. 생애주기 동안 컴포넌트 동작을 관리한다.
**팁:** 데이터 초기화엔 connectedCallback / 메모리 누수 방지를 위해 disconnectedCallback에서 리소스 정리.

## 17. errorCallback: errorCallback()이란?
LWC에서 errorCallback은 부모 컴포넌트의 자식 컴포넌트에서 오류가 발생할 때 호출된다. 오류 처리에 사용.
**팁:** 디버깅을 위해 errorCallback으로 오류 로깅 / 사용자 친화적 오류 메시지 제공.

## 18. Lightning 컴포넌트 노출: 홈페이지에 Lightning 컴포넌트를 어떻게 노출하나?
Lightning App Builder 페이지에 컴포넌트를 추가하고 메타데이터 파일에서 target을 lightning__HomePage로 설정.
**팁:** XML의 targets 속성 사용 / 배포 전 Lightning App Builder에서 컴포넌트 테스트.

## 19. With/Without Sharing: 차이는?
"With sharing"은 로그인 사용자의 sharing rule을 존중. "Without sharing"은 시스템 권한으로 실행하며 sharing rule을 무시.
**팁:** 보안을 위해 기본 "with sharing" / "without sharing"은 필요할 때만·사용 문서화.

## 20. Sharing 설정: Salesforce의 sharing 설정 유형은?
(1) OWD: 기본 접근 수준 정의, (2) Role Hierarchy: 계층 기반 접근 부여, (3) Sharing Rules: OWD 예외 제공, (4) Manual Sharing: 레코드 소유자가 공유.
**팁:** 보안엔 최소 권한 원칙 / 비즈니스 요구에 맞게 sharing 설정 정기 검토.

---

# ENCORA

## 1. OWD(Organization-Wide Defaults)란?
OWD는 org 내 사용자가 데이터에 갖는 기본 접근 수준이다. 명시적 sharing rule이 없을 때 오브젝트의 기본 공유 설정을 결정한다. 수준: Private(소유자와 role hierarchy 상위만 접근), Public Read-Only(모두 조회 가능, 소유자만 편집), Public Read/Write(모두 조회·편집), Controlled by Parent(부모 레코드 접근에 따름). Setup의 Sharing Settings에서 설정.
**팁:** 간단한 예로 설명("Opportunity OWD가 Private이면 소유자만 조회/편집") / sharing rule·manual sharing·Apex sharing으로 오버라이드 가능 언급.

## 2. 관련 Quote가 모두 "Accepted"일 때 Opportunity Stage를 "Closed Won"으로 갱신하려면?
Quote에 After Update 트리거를 쓴다. 로직: (1) 갱신된 Quote의 관련 Opportunity 식별, (2) 모든 관련 Quote가 "Accepted"인지 확인, (3) 충족 시 Opportunity Stage를 "Closed Won"으로 갱신.
```apex
trigger UpdateOpportunityStage on Quote (after update) {
Set<Id> oppIds = new Set<Id>();
for (Quote q : Trigger.new) {
if (q.Status == 'Accepted') {
oppIds.add(q.OpportunityId);
}
}
List<Opportunity> oppsToUpdate = [SELECT Id, StageName,
(SELECT Status FROM Quotes)
FROM Opportunity
WHERE Id IN :oppIds];
for (Opportunity opp : oppsToUpdate) {
Boolean allQuotesAccepted = true;
for (Quote q : opp.Quotes) {
if (q.Status != 'Accepted') {
allQuotesAccepted = false;
break;
}
}
if (allQuotesAccepted) opp.StageName = 'Closed Won';
}
update oppsToUpdate;
}
```
**팁:** 벌크화·SOQL 한도 강조 / Opportunity에 Quote가 없는 경우 같은 엣지 케이스 테스트.

## 3. 신규 Lead를 Salesforce에서 PyDart로 동기화하는 Batch 클래스를 작성하라
단계: (1) 특정 조건의 신규 Lead 쿼리, (2) execute에서 HTTP 콜아웃으로 PyDart에 데이터 전송, (3) Database.executeBatch로 실행.
```apex
global class LeadSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
global Database.QueryLocator start(Database.BatchableContext BC) {
return Database.getQueryLocator('SELECT Id, Name, Email FROM Lead WHERE IsSynced__c = FALSE');
}
global void execute(Database.BatchableContext BC, List<Lead> scope) {
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.pydart.com/sync');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setBody(JSON.serialize(scope));
Http http = new Http();
HttpResponse res = http.send(req);
if (res.getStatusCode() == 200) {
for (Lead l : scope) l.IsSynced__c = true;
update scope;
}
}
global void finish(Database.BatchableContext BC) {}
}
```
**팁:** HTTP 콜아웃을 위한 Database.AllowsCallouts의 중요성 / 실패 콜아웃의 오류 처리·로깅 메커니즘 논의.

## 4. Lightning 컴포넌트로 모바일 개발을 어떻게 하나? 성능·UX를 어떻게 최적화하나?
LWC와 Aura 컴포넌트를 Salesforce 모바일 앱 개발에 쓸 수 있고 모바일 뷰에 맞춰 커스터마이즈된다. 최적화: Lightning Base Component(기본 모바일 최적화), Lazy Loading, CSS Media Query, 클라이언트 측 로직 감소(가능하면 서버 측).
**팁:** 브랜딩·배포에 Salesforce Mobile Publisher / 일관성에 SLDS 강조.

## 5. LWC에서 @wire와 명령형 Apex 호출의 차이는?
@wire: 자동으로 데이터를 가져오고 변경 시 UI 재렌더, 선언적이며 동적 시나리오엔 덜 유연. 명령형: @AuraEnabled 메서드를 수동 호출, 더 많은 제어·동적 매개변수 지원.
**팁:** 예로 두 방법 시연 / 각각이 선호되는 시나리오 논의.

## 6. LWC에서 큰 데이터셋을 효율적으로 어떻게 처리·설정하나?
페이지네이션(청크로 조회·표시), Apex 청킹(SOQL OFFSET으로 제한된 레코드), 커스텀 Apex 없는 효율적 CRUD엔 LDS.
**팁:** 중첩 루프 회피 같은 성능 최적화 베스트 프랙티스 / 더 큰 데이터 시각화엔 Einstein Analytics 제안.

---

# INFLOOENS

## 1. Custom 오브젝트와 Standard 오브젝트의 차이
Standard 오브젝트: Salesforce 제공 사전 정의(Account, Contact, Opportunity). Custom 오브젝트: 특정 비즈니스 요구를 위한 사용자 생성, "__c" 접미사로 식별.
**팁:** 표준(Account)·커스텀(Employee__c) 예 / 커스텀 오브젝트 생성 사용 사례 설명.

## 2. 커스텀 오브젝트로 Master-Detail 관계를 만드는 방법
(1) 두 오브젝트 생성(Parent__c, Child__c), (2) 자식에 "Master-Detail Relationship" 타입 필드 생성, (3) 부모 오브젝트를 master로 선택, (4) 필드 수준 보안 정의·레이아웃 추가.
**팁:** 부모 삭제 시 자식 자동 삭제 / 소유권·sharing rule 상속 개념 강조.

## 3. Profile과 Role의 차이
Profile: 사용자가 할 수 있는 것(CRUD·탭·앱 권한) 제어. Role: 사용자가 볼 수 있는 것(레코드 수준 접근) 제어.
**팁:** 예: "Sales 사용자가 Sales Profile(opportunity 편집)을 갖되 role이 지역 내 레코드만 보도록 제한".

## 4. Lookup과 Master-Detail 관계의 차이
Lookup: 느슨한 관계, 자식이 부모와 독립. Master-Detail: 강한 관계, 자식이 부모에 의존하고 소유권/sharing 상속.
**팁:** 각각 선호되는 시나리오(선택적 관계엔 lookup) / master-detail의 cascading delete 강조.

## 5. Record Type이란? 예를 들어라
Record Type은 같은 오브젝트에 다른 비즈니스 프로세스, picklist 값, 페이지 레이아웃을 허용한다. 예: Opportunity에 "B2B"·"B2C" record type으로 다른 영업 프로세스 정의.
**팁:** record type이 다양한 사용 사례의 데이터 처리를 개선 / 프로필이 record type 접근을 제어하는 방법 언급.

## 6. 거버너 한도를 피하는 트리거 작성 베스트 프랙티스
(1) 트리거 프레임워크로 로직 분리, (2) 루프 안 SOQL/DML 회피, (3) 벌크 처리에 컬렉션, (4) 확장성을 위해 벌크 데이터로 테스트.
**팁:** 오브젝트당 트리거 하나·트리거 핸들러 클래스 논의.

## 7. Salesforce의 Governor Limit이란?
멀티테넌시 보장을 위해 리소스 제약을 강제한다. 예: 단일 트랜잭션 SOQL 5만 행, 트랜잭션당 DML 100개.
**팁:** 한도 도달 예와 코드 최적화 방법 제시.

## 8. SOQL과 SOSL의 차이
SOQL: 특정 오브젝트·필드의 구조화된 쿼리. SOSL: 여러 오브젝트·필드에 걸친 텍스트 검색.
**팁:** SOQL(SELECT Name FROM Account)·SOSL(FIND 'Test' IN ALL FIELDS) 예.

## 9. Account 관련 Opportunity를 가져오는 SOQL
```apex
SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = '001XXXXXXXXXXXXXXX'
```
**팁:** 부모-자식 관계 쿼리 설명.

## 10. 테스트 클래스를 작성하는 것이 왜 중요한가?
코드 품질 보장·버그 조기 발견, 배포를 위한 75% 커버리지 요구사항 충족.
**팁:** 엣지 케이스·벌크 데이터 시나리오 테스트 중요성 언급.

## 11. 테스트 클래스 작성을 어떻게 접근하나?
@isTest 어노테이션 사용, 테스트 클래스 안에서 테스트 데이터 생성, System.assert로 assertion 검증.
**팁:** 테스트 setup·실행·검증 분리 언급.

## 12. Aura에 없고 LWC에 포함된 것은?
현대 웹 표준(LWC는 ES6+ 기반으로 경량·빠름), Shadow DOM(스타일·DOM 요소 캡슐화), 반응형 데이터 바인딩(Aura보다 단순·효율적).
**팁:** LWC가 독점 프레임워크 의존을 줄이고 성능을 개선하는 방법 언급.

## 13. Aura 컴포넌트에서 LWC 컴포넌트를 호출할 수 있나?
예, `<lightning:container>` 태그나 `<c:componentName>` 태그로 Aura 안에 LWC를 임베드.
**팁:** Aura→LWC 점진적 마이그레이션을 가능하게 함 강조.

## 14. LWC 컴포넌트를 다른 LWC 안에서 호출할 수 있나?
예, 자식 컴포넌트의 태그(`<c-child-component>`)를 쓴다. 데이터 전달 시 자식을 @api로 노출.
**팁:** 부모-자식·자식-부모 통신 전략 언급.

## 15. @track, @wire, @api의 차이
@track: 내부 상태 변경에 쓰는 반응형 속성. @api: 부모 컴포넌트에 속성/메서드 노출. @wire: 데이터를 가져오거나 Salesforce 데이터에 선언적 연결.
**팁:** 각각의 사용 사례 제시, LWC에서의 역할 강조.

## 16. Wire와 명령형 Apex 호출이란?
Wire: UI를 자동 갱신하는 선언적 데이터 조회. 명령형: 동적·이벤트 기반 데이터 조회의 수동 호출.
**팁:** 버튼 클릭·조건부 데이터 조회엔 명령형 선호 언급.

## 17. 버튼 클릭에 wire를 쓸 수 있나?
아니다, wire는 선언적이라 버튼 클릭에 직접 쓸 수 없다. 버튼 클릭 기능엔 명령형 Apex 사용.
**팁:** wire가 반응형이고 액션 주도가 아닌 이유 설명.

## 18. @AuraEnabled(cacheable=true)의 용도는?
wire 호출의 성능 개선을 위해 메서드 결과를 캐싱하게 한다. 서버 요청 최소화를 위해 읽기 전용 데이터에 사용.
**팁:** cacheable 메서드는 데이터 수정 불가 강조.

## 19. LWC의 부모-자식·자식-부모 관계
부모-자식: 자식의 @api 속성으로 데이터 전달. 자식-부모: 자식에서 이벤트(CustomEvent)를 쓰고 부모에서 처리.
**팁:** 예: 부모→자식 record ID 전달, 이벤트로 변경을 부모에 알림.

## 20. Data Loader 사용 사례
Data Loader는 insert·update·delete·export 같은 벌크 데이터 작업에 사용. 예: 1만 건 가져오기, 대량 리드 상태 갱신.
**팁:** Data Import Wizard의 행 한도와 Data Loader가 필수가 되는 시점 언급.

## 21. Account의 총 Opportunity 금액을 계산하는 트리거를 작성하라
```apex
trigger CalculateOpportunityAmount on Opportunity (after insert, after update, after delete) {
Set<Id> accountIds = new Set<Id>();
for (Opportunity opp : Trigger.isInsert || Trigger.isUpdate ? Trigger.new : Trigger.old) {
accountIds.add(opp.AccountId);
}
List<Account> accountsToUpdate = [SELECT Id, (SELECT Amount FROM Opportunities) FROM Account WHERE Id IN :accountIds];
for (Account acc : accountsToUpdate) {
acc.Total_Opportunity_Amount__c = 0;
for (Opportunity opp : acc.Opportunities) {
acc.Total_Opportunity_Amount__c += opp.Amount;
}
}
update accountsToUpdate;
}
```
**팁:** 벌크화 기법 논의 / 여러 시나리오(opportunity 추가·제거)로 테스트.

---

# Cloudbyz

## 1. @AuraEnabled(cacheable=true) 어노테이션이란?
wire 서비스와 함께 쓸 때 결과를 클라이언트 측에 캐싱해 동일 데이터의 반복 서버 호출을 피해 성능을 개선한다.
```apex
@AuraEnabled(cacheable=true)
public static List<Account> getAccounts() {
return [SELECT Id, Name FROM Account];
}
```
**팁:** 읽기 전용 메서드용 강조 / DML 작업 미지원 언급.

## 2. Wire 메서드로 데이터를 삽입하려면?
wire 메서드는 읽기 전용이라 데이터 삽입 불가. 대신 명령형 Apex 메서드를 쓴다.
```js
import { createRecord } from 'lightning/uiRecordApi';
const fields = { Name: 'New Account' };
const recordInput = { apiName: 'Account', fields };
createRecord(recordInput)
.then(account => console.log('Account created', account));
```
**팁:** DML 작업엔 명령형 호출 사용 사례 설명.

## 3. 속성 전달 시 $의 용도
$ 기호는 wire 어댑터나 자식 컴포넌트에 전달되는 속성을 반응형으로 만든다. 속성 갱신 시 데이터 새로고침을 트리거한다.
```js
@wire(getAccountDetails, { accountId: '$recordId' }) account;
```
**팁:** $는 반응형 변수에만 동작 언급.

## 4. Wire 메서드를 어떻게 새로고침하나?
@salesforce/apex 모듈의 refreshApex 함수를 쓴다.
```js
import { refreshApex } from '@salesforce/apex';
refreshApex(this.wiredData);
```
**팁:** 클라이언트 데이터를 서버와 동기화하는 새로고침의 중요성 설명.

## 5. LWC의 Lifecycle Hook이란?
컴포넌트 생애주기의 특정 단계에서 코드 실행: connectedCallback()(DOM 삽입 시), renderedCallback()(모든 렌더 후), disconnectedCallback()(DOM 제거 시).
**팁:** 초기 데이터 조회에 connectedCallback() 사용하는 실제 예 제시.

## 6. Wire 메서드에서 data와 error 외 다른 변수를 쓸 수 있나?
예, wire 응답 구조 분해에 커스텀 변수명 사용 가능.
```js
@wire(getAccountDetails, { accountId: '$recordId' }) response({ customData, customError });
```
**팁:** 의미 있는 변수명이 코드 가독성 향상 언급.

## 7. event.stopPropagation()과 event.preventDefault()의 차이
stopPropagation(): 이벤트가 DOM 계층으로 버블링되는 것을 멈춤. preventDefault(): 이벤트의 기본 동작(submit 시 폼 제출 등) 방지.
**팁:** 중첩 div의 클릭 이벤트 중지나 링크 내비게이션 방지 예 제시.

## 8. Sharing Rule이란?
역할·public group·territory의 사용자에게 레코드 수준 접근을 확장한다. 예: 큐의 모든 case를 고객 지원팀과 공유.
**팁:** sharing rule은 더 넓은 접근을 부여하나 기존 접근을 제한할 수 없음 강조.

## 9. Salesforce의 Flow 유형
(1) Screen Flow(사용자 상호작용 필요), (2) Record-Triggered Flow(레코드 변경 시 자동화), (3) Scheduled Flow(지정 시간 실행), (4) Autolaunched Flow(사용자 상호작용 없이 자동 실행).
**팁:** 각각의 예(온보딩엔 screen flow) 언급.

## 10. Autolaunched Flow와 Record-Triggered Flow의 차이
Autolaunched Flow: Apex·버튼·다른 flow로 수동 트리거. Record-Triggered Flow: 레코드 생성·갱신·삭제 시 자동 실행.
**팁:** record-triggered flow가 Apex 트리거의 대안 언급.

## 11. Apex 대신 Flow는 언제 쓰나?
선언적 자동화엔 Flow 선호. 복잡한 로직, 대용량 처리, 통합엔 Apex.
**팁:** Flow가 개발이 빠르고 유지보수가 쉬움 강조.

## 12. Apex 클래스 베스트 프랙티스
(1) 단일 책임 원칙, (2) 벌크화 코드, (3) ID 하드코딩 회피, (4) 100% 커버리지 테스트 메서드.
**팁:** 하드코딩 대신 custom label 사용 같은 예 제시.

## 13. 비동기와 동기 Apex의 차이
동기: 즉시 실행(예: 트리거). 비동기: 나중에/백그라운드 실행(예: Batch Apex).
**팁:** 장시간 작업 같은 비동기 시나리오 설명.

## 14. Salesforce의 Batch Job이란?
큰 데이터셋을 비동기 처리한다. 레코드를 관리 가능한 청크(기본 200)로 나눈다.
**팁:** 거버너 한도 처리에서의 중요성 논의.

## 15. Database.Stateful과 Stateless의 차이
Stateful: 상태 유지(변수가 배치 실행 간 지속). Stateless: 상태 미유지.
**팁:** stateful의 사용 사례(배치 간 합계 집계) 제시.

## 16. CPU 시간 한도를 어떻게 해결하나?
SOQL 최적화(선택적 필터), 루프 감소·컬렉션 사용, 처리를 비동기 작업으로 오프로드.
**팁:** 인덱싱·query plan 사용 언급.

---

# PhonePe (REST API 통합)

## 1. REST API란? SOAP API와 어떻게 다른가?
REST API는 통신에 HTTP 메서드(GET, POST, PUT, DELETE)를 쓰는 아키텍처 스타일. 경량·무상태·주로 JSON. SOAP API는 엄격한 XML 메시징과 보안·트랜잭션 표준이 내장된 프로토콜. REST보다 무겁고 경직.
**팁:** REST의 단순성·유연성 vs SOAP의 엄격한 계약·표준화 강조.

## 2. RESTful 아키텍처의 핵심 원칙은?
무상태(각 요청에 모든 정보), 클라이언트-서버 분리, 응답 캐시 가능, 균일 인터페이스(URI로 리소스 식별), 계층 시스템(중개자 가능), code on demand(선택).
**팁:** 이 원칙을 확장성·단순성 같은 이점과 연결.

## 3. Salesforce REST API는 외부 시스템 통합을 어떻게 가능하게 하나?
sObject·쿼리·메타데이터 같은 리소스를 HTTP 엔드포인트로 노출한다. 외부 시스템이 JSON 페이로드의 HTTP 호출로 CRUD, 데이터 쿼리, SOQL 실행 가능.
**팁:** 안전한 접근에 OAuth 토큰·경량 데이터 형식 JSON 언급.

## 4. Salesforce REST API의 흔한 사용 사례는?
CRM 데이터 모바일 앱 통합, 서드파티 동기화(ERP, 마케팅 도구), Salesforce 데이터에 접근하는 커스텀 웹 포털, IoT 기기의 이벤트 전송.
**팁:** 외부 주문 시스템에서 Opportunity 상태 갱신 같은 구체적 예 제시.

## 5. Salesforce REST API에 사용 가능한 인증 메커니즘은?
OAuth 2.0(Authorization Code, JWT, Username-Password 흐름), Session ID(덜 권장). Connected App이 인증·scope 관리.
**팁:** OAuth 2.0이 업계 표준·베스트 프랙티스 강조.

## 6. Salesforce REST API 인증을 위한 OAuth 2.0 흐름을 설명하라
사용자가 인가 URL로 권한 부여 → 앱이 auth code 수신 → 앱이 code를 액세스 토큰으로 교환 → 토큰을 REST API 호출에 사용 → refresh token으로 세션 유지.
**팁:** 토큰 만료·매끄러운 인증을 위한 refresh token 사용 언급.

## 7. 외부 시스템 통합 시 보안을 어떻게 보장하나?
최소 권한 scope의 OAuth 2.0, IP 제한·connected app 정책 강제, Salesforce 외부 호출엔 Named Credentials, 전송·저장 데이터 암호화, 모니터링 도구로 API 사용 감사.
**팁:** 보안 계층·컴플라이언스 요구사항 논의.

## 8. Salesforce REST API로 CRUD 작업을 어떻게 수행하나?
Create: POST /services/data/vXX.X/sobjects/ObjectName/, Read: GET .../sobjects/ObjectName/Id, Update: PATCH .../sobjects/ObjectName/Id, Delete: DELETE .../sobjects/ObjectName/Id. create/update엔 JSON 페이로드.
**팁:** 오류 처리·상태 코드(create 성공엔 201) 언급.

## 9. REST API로 대용량 데이터를 다룰 때 고려사항은?
nextRecordsUrl로 쿼리 페이지네이션, API 한도 존중, 대용량엔 Bulk API, 큰 페이로드 회피, 재시도·부분 실패 설계.
**팁:** REST API 용량 초과 시 Bulk API 강조.

## 10. Salesforce REST API로 벌크 데이터 작업을 어떻게 하나?
수천 건을 비동기 배치 처리하는 Bulk API 2.0 REST 엔드포인트를 쓴다. 단순화된 작업 관리.
**팁:** Bulk API 1.0(XML 기반)과 2.0(JSON 기반, 단순)의 차이 설명.

## 11. Salesforce REST API의 흔한 오류 코드와 처리 방법은?
400 Bad Request(페이로드/매개변수 수정), 401 Unauthorized(인증 토큰 확인), 403 Forbidden(권한 이슈), 404 Not Found(잘못된 리소스/ID), 500 Server Error(지수 백오프 재시도). 오류 응답 본문에서 상세 확인.
**팁:** 오류 로깅·재시도 메커니즘 구현 권고.

## 12. Salesforce REST API의 rate limit을 어떻게 처리하나?
REST 엔드포인트로 한도 모니터링, 호출 최적화(벌크 쿼리·캐싱), 이벤트 기반 아키텍처(platform event), 정당하면 한도 증가 요청.
**팁:** 통합 코드에 rate limit 헤더 파싱 포함.

## 13. Salesforce와 외부 시스템 간 실시간 통합을 어떻게 구현하나?
Streaming API나 Platform Events로 외부 시스템에 데이터 푸시, 또는 이벤트 시 외부가 Salesforce REST API 호출. 이벤트 기반 동기화엔 Webhook이나 미들웨어.
**팁:** 신뢰성을 위해 MuleSoft나 Kafka 같은 미들웨어 언급.

## 14. REST API 성능을 최적화하는 전략은?
필터가 있는 선택적 SOQL, 가능한 응답 캐싱, 대용량엔 Bulk API, 필요 필드만 선택해 페이로드 크기 최소화, 클라이언트 측 스로틀링·재시도.
**팁:** 인덱싱·쿼리 최적화가 API 속도에 미치는 영향 설명.

## 15. 운영 환경에서 API 실패를 어떻게 디버깅·트러블슈팅하나?
디버그 로그·이벤트 모니터링 사용, API 사용·오류 응답 상세 확인, 외부 시스템 로그 확인, 인증 토큰·권한 검증, 샌드박스나 Postman에서 요청 재현.
**팁:** 사전 모니터링·알림 설정 권고.

---

# American Express

## 1. Sharing & Security가 API 접근에 어떤 영향을 주나?
Salesforce는 API 호출에도 sharing rule·profile·permission set을 강제한다. API로도 사용자는 권한이 있는 레코드·필드만 접근. OWD·role hierarchy·sharing rule·FLS를 존중한다.
**팁:** 모든 수준의 보안 강제 강조 / sharing 컨텍스트 유지를 위해 Apex에 "with sharing".

## 2. LWC에서 부모-자식·자식-부모 통신을 어떻게 처리하나?
자식-부모: 자식이 발생시킨 custom event를 부모에서 처리. 부모-자식: public @api 속성으로 데이터 전달. 레코드 관계엔 부모/자식을 조회하는 @wire SOQL.
**팁:** 계층을 넘는 통신엔 LMS 언급.

## 3. Queueable Apex vs Future Method vs Batch Apex — 언제 무엇을?
Future: 단순, 체이닝 없음, 작은 비동기 작업(콜아웃). Queueable: 작업 체이닝·더 나은 제어·복잡한 비동기. Batch: 거버너 한도 내 대용량 청크 처리·진행 모니터링.
**팁:** 중간 복잡도엔 Queueable, 대용량엔 Batch Apex.

## 4. 외부 시스템 통합 시 보안을 어떻게 보장하나?
OAuth 2.0 인증, 최소 권한 강제, 모든 입력 검증, 민감 데이터 암호화, IP 제한, 감사 로그 모니터링, 외부 호출엔 Named Credentials.
**팁:** 지속 모니터링·Salesforce 보안 컴플라이언스 가이드라인 강조.

## 5. Salesforce REST API에 사용 가능한 인증 메커니즘은?
OAuth 2.0 흐름(Authorization Code, JWT, Username-Password), Session ID(덜 선호), SAML 기반 SSO.
**팁:** 안전한 접근엔 OAuth 2.0을 업계 표준으로 권장.

## 6. Salesforce와 외부 시스템 간 실시간 통합을 어떻게 구현하나?
Platform Events나 Streaming API로 이벤트 발행, 외부가 구독. 또는 outbound messaging이나 미들웨어로 실시간 양방향 동기화.
**팁:** 이벤트 기반 아키텍처 이점·확장성 강조.

## 7. RESTful 아키텍처의 핵심 원칙은?
무상태, 클라이언트-서버 분리, 캐시 가능, 균일 인터페이스(URI 기반 리소스), 계층 시스템, 선택적 code on demand.
**팁:** 이 원칙이 확장성·유지보수성을 개선하는 방법 설명.

## 8. 여러 DML 작업 시 Salesforce는 트랜잭션을 어떻게 처리하나?
모든 DML을 단일 트랜잭션으로 실행. Database 메서드로 부분 처리를 다루지 않는 한 어느 DML이라도 실패하면 전체 롤백. 거버너 한도가 전체 트랜잭션에 적용.
**팁:** 부분 트랜잭션 관리에 Savepoint·Rollback 언급.

## 9. Platform Event 기반 통합이란? 실시간 시나리오에서 어떻게 동작하나?
변경을 비동기 통신하는 커스텀 이벤트 메시지. 구독자(내부/외부)가 폴링 없이 준실시간 처리를 위해 수신.
**팁:** 사용 사례: 외부 시스템 동기화, 알림, 복잡한 비즈니스 워크플로우.

## 10. CPU 시간 한도·heap size 이슈를 어떻게 디버깅·트러블슈팅하나?
한도 활성화된 디버그 로그, SOQL 최적화, 코드 벌크화, 루프 감소, 재귀 트리거 회피, 무거운 처리를 Batch Apex로 리팩터.
**팁:** Developer Console로 프로파일링·거버너 한도 모니터링 권장.

## 11. Salesforce REST API 인증을 위한 OAuth 2.0 흐름을 설명하라
사용자가 앱 접근 부여 → 앱이 auth code 획득 → 액세스 토큰으로 교환 → API 헤더에 토큰 사용 → refresh token으로 세션 유지.
**팁:** basic auth 대비 OAuth의 보안 이점 강조.

## 12. Salesforce API 호출에서 오류 응답·재시도 메커니즘을 어떻게 처리하나?
오류 코드(400, 401, 403, 500) 파싱, 일시적 오류엔 지수 백오프 재시도, 모니터링용 오류 로깅, 지속 실패 시 지원팀 알림.
**팁:** 재시도 시 중복 처리를 피하려 멱등 호출 설계.

## 13. LWC의 데코레이터(@api, @track, @wire)란? 어떻게 동작하나?
@api: 부모에 public 속성/메서드 노출. @track: 속성을 UI 갱신용 반응형으로(대부분 자동). @wire: Salesforce 데이터나 Apex 메서드에 반응형 연결.
**팁:** 통신엔 @api, 데이터 조회엔 @wire.

## 14. LWC 성능 최적화 베스트 프랙티스는?
DOM 업데이트 최소화, 데이터 캐싱, 효율적 이벤트 처리, 컴포넌트 지연 로딩, getter 내 복잡 계산 회피, 적절한 캐싱으로 서버 호출 제한.
**팁:** 서버 왕복 감소엔 LDS.

## 15. Database.Savepoint & Rollback이란? 언제 써야 하나?
Savepoint는 트랜잭션의 한 지점을 표시하고, rollback은 그 지점으로 되돌린다. 복잡한 트랜잭션에서 DML을 부분 취소하거나 Apex 오류 처리에 사용.
**팁:** 한도를 피하려 과도한 savepoint 회피.

## 16. Lightning Message Service(LMS)란? 사용 사례는?
같은 페이지의 LWC·Aura·Visualforce 간 pub-sub 메시징 통신을 가능하게 한다.
**팁:** DOM 트리 간 통신에 좋음.

## 17. LWC에서 LDS는 어떻게 동작하나?
Apex 없이 Salesforce 데이터에 선언적 접근. 캐싱·sharing·갱신을 자동 처리해 성능을 최적화.
**팁:** 단순 CRUD엔 LDS로 Apex 회피.

## 18. Salesforce REST API로 CRUD 작업을 어떻게 하나?
리소스 엔드포인트에 HTTP 메서드: POST(create), GET(read), PATCH(update), DELETE(delete), JSON 페이로드와 함께.
**팁:** API 버전·오류 코드 확인.

## 19. Salesforce REST API의 흔한 오류 코드와 처리는?
400(bad request), 401(unauthorized), 403(forbidden), 404(not found), 500(server error). 응답 본문 검사·로깅·일시적 오류 재시도로 처리.
**팁:** 재시도엔 지수 백오프.

## 20. Salesforce REST API의 rate limit을 어떻게 처리하나?
사용량 모니터링, 호출 최적화, 작업 배치, 결과 캐싱, 필요시 한도 증가 요청.
**팁:** 한도 도달 시 graceful degradation 구현.

## 21. LWC에서 Apex 메서드를 어떻게 호출하나?
@AuraEnabled(cacheable=true/false) 메서드를 import해 @wire(반응형)나 명령형 호출로 호출.
**팁:** 성능 개선을 위해 읽기 전용 메서드엔 cacheable=true.

## 22. Aura와 LWC의 차이는?
Aura는 더 오래되고 독점 프레임워크, 무겁고 느림. LWC는 현대적, 네이티브 웹 표준, 빠르고 유지보수 쉬움.
**팁:** 신규 개발엔 LWC 권장.

## 23. LWC에서 조건부 렌더링을 어떻게 처리하나?
`<template if:true={condition}>`나 `<template if:false={condition}>` 같은 template 디렉티브로 조건부 렌더.
**팁:** template 표현식에 무거운 로직 회피.

## 24. REST API 성능을 최적화하는 전략은?
선택적 SOQL, 페이로드 크기 최소화, 대용량엔 Bulk API, 캐싱, 실패엔 재시도 로직.
**팁:** 가능하면 여러 호출 결합.

## 25. Apex는 동시성 이슈를 어떻게 처리하나? 데이터 충돌 방지 메커니즘은?
SOQL의 FOR UPDATE로 레코드 잠금, LastModifiedDate 체크의 optimistic concurrency, 충돌 방지에 플랫폼 트랜잭션.
**팁:** 교착을 줄이려 장시간 트랜잭션 회피.

## 26. 통합을 위한 오류 로깅·모니터링을 어떻게 구현하나?
커스텀 오브젝트로 오류 로깅, platform event 로그, 디버그 로그, 외부 모니터링 도구(Splunk, New Relic). 중요 실패엔 알림.
**팁:** 로그 정리·보존 정책 자동화.

---

# ASCENDION

## 1. Salesforce의 핵심 거버너 한도는?
멀티테넌트 환경의 효율적 처리·리소스 할당을 위해 강제: SOQL 쿼리 동기 100·비동기 200, DML 트랜잭션당 150, Heap Size 동기 6MB·비동기 12MB, 콜아웃 트랜잭션당 최대 100, CPU 시간 동기 10초·비동기 60초, Batch Apex org당 최대 5개 큐/활성 작업.
**팁:** 거버너 한도를 효율 관리한 시나리오 / SOQL 최적화·"Too many SOQL queries" 회피 경험 강조.

## 2. 역할·프로필·사용자 설정을 구성한 경험이 있나?
예, role·profile·user 설정 구성 실무 경험이 있다. 조직 구조에 맞춘 role hierarchy 구현, 오브젝트·필드 접근 제어 프로필 구성, locale·이메일 알림 등 사용자별 설정.
**팁:** role·profile 구성 프로젝트 예 / 프로필 난립을 피하려 permission set 사용 같은 베스트 프랙티스 강조.

## 3. Validation Rule이란? 예를 들어라
저장 전 입력 데이터가 지정 기준을 충족하도록 보장한다. 예: Discount__c가 20%를 초과하지 않도록 `Discount__c > 0.2` 공식과 "Discount cannot exceed 20%" 오류 메시지.
**팁:** validation rule이 데이터 품질을 개선하는 방법 강조 / 전화번호 형식 강제 같은 비즈니스 예 준비.

## 4. Role과 Profile의 차이는?
Role: sharing rule·role hierarchy로 데이터 가시성 제어. Profile: 오브젝트·필드 수준 권한 정의. 예: 영업 담당자의 role이 볼 수 있는 account를 결정하고, profile이 편집/삭제 가능 여부를 결정.
**팁:** 차이를 명확히 할 비유 준비 / role·profile이 함께 동작하는 사용 사례 강조.

## 5. Salesforce에 sharing 메커니즘이 몇 개 있나?
(1) OWD(기본 접근 제어), (2) Role Hierarchy(계층 상위로 공유), (3) Sharing Rules(기준·소유권 기반 확장), (4) Manual Sharing(개별 공유), (5) Apex Sharing(Apex 커스텀 공유), (6) Territory Management(영역 기반 공유).
**팁:** 프로젝트에서 구현한 메커니즘 / Apex Sharing이 필요한 상황 강조.

## 6. Queue와 Public Group이란? 차이는?
Queue: 레코드(Case, Lead) 소유권을 사용자 그룹에 할당, 멤버가 큐에서 소유권 가져옴. Public Group: 사용자·역할·하위 포함 역할의 모음으로 sharing rule·리포트/대시보드/폴더 접근 정의에 사용. 차이: Queue는 레코드 소유권, Public Group은 공유·협업.
**팁:** Lead 분배에 queue 사용 같은 예 / 둘이 함께 동작하는 방법(public group 기반 큐 레코드 할당) 설명.

## 7. 두 독립 컴포넌트가 어떻게 통신할 수 있나?
(1) 부모-자식: 속성으로 값 직접 전달, (2) 자식-부모: Lightning Event나 Custom Event, (3) 형제: pub-sub 모델이나 공유 서비스 모듈.
**팁:** 리스트-디테일 컴포넌트 통신 같은 실제 예 / 느슨한 결합 시스템엔 pub-sub 모델 이점 강조.

## 8. Lightning Component 프레임워크의 이벤트 유형은?
(1) Application Events(앱의 모든 컴포넌트에 브로드캐스트), (2) Component Events(부모·조상 컴포넌트가 처리), (3) System Events(Salesforce 사전 정의: init, render, unrender).
**팁:** LWC로의 전환·DOM 이벤트 사용 언급 / 각 이벤트 유형이 적절한 경우 예.

## 9. SLDS(Salesforce Lightning Design System)란?
Salesforce 앱 전반에 일관된 UI 디자인을 보장하는 CSS 프레임워크. 버튼·폼·그리드 같은 사전 설계 컴포넌트를 제공.
**팁:** 반응형 디자인·통합 용이성 같은 이점 / 커스텀 컴포넌트에 SLDS 통합 경험 공유.

## 10. LWC의 통신 유형은?
(1) 부모-자식: 속성, (2) 자식-부모: custom event, (3) 형제: pub-sub 모델이나 공유 JS 모듈, (4) 컴포넌트-서버: Apex 메서드나 wire 서비스.
**팁:** 각 통신 유형 예 / 통신이 LWC 베스트 프랙티스와 맞는 방법 언급.

## 11. Wire Service로 desktop account 리포트를 어떻게 가져와 표시하나?
@wire 데코레이터를 Apex 메서드나 LDS와 함께 쓴다.
```javascript
import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
export default class AccountList extends LightningElement {
@wire(getAccounts) accounts;
}
```
그다음 HTML에서 template 루프로 데이터 표시.
**팁:** 가능하면 LDS의 성능 이점 강조 / 반응형 UI 예 제시.

## 12. LWC에서 텍스트를 어떻게 호출하나?
JavaScript 속성에 바인딩해 동적으로 표시:
```javascript
textValue = 'Hello, World!';
```
```html
<template>{textValue}</template>
```
**팁:** "텍스트 호출"의 맥락(동적 값 전달/조회) 명확히.

## 13. Screen Flow 외 Salesforce의 Flow 유형은?
(1) Record-Triggered Flow(레코드 생성·갱신·삭제 시), (2) Schedule-Triggered Flow(특정 간격/시간), (3) Platform Event-Triggered Flow(platform event 수신 시), (4) Autolaunched Flow(Apex·다른 flow·process builder에서 호출).
**팁:** 각 flow 유형 사용 사례 / 로우코드 자동화에 flow 사용 이점 강조.

## 14. Aura 컴포넌트를 동적으로 어떻게 생성하나?
$A.createComponent 메서드로 생성.
```javascript
$A.createComponent(
"c:childComponent",
{
"attributeName": value
},
function(newCmp, status, errorMessage){
if (status === "SUCCESS") {
var body = cmp.get("v.body");
body.push(newCmp);
cmp.set("v.body", body);
}
}
);
```
**팁:** 유연·동적 UI에 createComponent 사용 강조 / 동적 생성이 정적 선언보다 나은 시나리오 설명.

## 15. Apex에서 @AuraEnabled 어노테이션을 왜 쓰나?
Apex 메서드·속성을 Lightning 컴포넌트(Aura·LWC)에 노출한다. (1) 메서드를 Lightning 컴포넌트에서 호출 가능, (2) 속성을 프레임워크에서 접근 가능.
**팁:** LWC 성능 최적화엔 cacheable=true / Apex에서 데이터 조회 같은 샘플 사용 사례.

## 16. Account billing address가 갱신되면 관련 contact의 billing address를 갱신하는 트리거를 작성하라
```apex
trigger UpdateContactBillingAddress on Account (after update) {
List<Contact> contactsToUpdate = new List<Contact>();
for (Account acc : Trigger.new) {
Account oldAcc = Trigger.oldMap.get(acc.Id);
if (acc.BillingAddress != oldAcc.BillingAddress) {
for (Contact con : [SELECT Id FROM Contact WHERE AccountId = :acc.Id]) {
con.MailingAddress = acc.BillingAddress;
contactsToUpdate.add(con);
}
}
}
if (!contactsToUpdate.isEmpty()) {
update contactsToUpdate;
}
}
```
**팁:** 적절한 null 체크·벌크 안전 작업 / 필드명 하드코딩 회피 같은 베스트 프랙티스 강조.

## 17. 통합 경험이 있나? 있다면 어떤 통합을 했나?
예, 다양한 통합 경험: (1) REST API(REST 엔드포인트로 외부 시스템 통합), (2) SOAP API(레거시용 SOAP 서비스 설정·소비), (3) Outbound Messaging(외부 시스템 알림), (4) Apex Callout(서드파티 HTTP 요청). 예: REST API로 결제 게이트웨이와 실시간 거래 처리 통합.
**팁:** 통합 테스트에 Postman 같은 도구 / rate limit·인증 이슈 처리 같은 도전·극복 강조.

---

# Tech Mahindra

## 1. LWC에서 for:each와 iterator의 차이는?
for:each: 리스트를 순회하는 단순 디렉티브, 효율적·간단한 순회에 적합.
```html
<template for:each={items} for:item="item">
<p key={item.id}>{item.name}</p>
</template>
```
iterator: 리스트의 first·last 같은 추가 컨텍스트 제공.
```html
<template iterator:it={items}>
<p key={it.value.id}>{it.value.name} {it.first ? '(First)' : ''}</p>
</template>
```
**팁:** 대부분 for:each, first/last 컨텍스트가 필요하면 iterator / 페이지네이션 리스트 같은 iterator 필수 시나리오 강조.

## 2. LWC의 lifecycle hook이란? 어떻게 동작하나?
컴포넌트 생애주기 중 호출되는 콜백: (1) constructor()(생성 시), (2) connectedCallback()(DOM 추가 시), (3) renderedCallback()(렌더 후), (4) disconnectedCallback()(DOM 제거 시), (5) errorCallback(error, stack)(자식 컴포넌트 오류 처리).
**팁:** connectedCallback()에 데이터 설정 같은 실제 사용 사례 / lifecycle hook 내 무거운 작업의 성능 고려.

## 3. Salesforce에서 벌크 데이터 작업을 어떻게 처리하나?
(1) 대용량 청크 처리에 Batch Apex, (2) 거버너 한도 회피를 위한 SOQL 최적화, (3) 가져오기/내보내기에 Data Loader나 Bulk API, (4) 효율을 위한 인덱스·선택적 필터, (5) 소규모 가져오기엔 Data Import Wizard.
**팁:** 관리한 대용량 작업 예 / 루프 안 DML 감소 같은 베스트 프랙티스 강조.

## 4. Lightning Message Service(LMS)를 예와 함께 구현하려면?
LMS는 같은 페이지 컴포넌트 간 통신을 가능하게 한다. (1) Message Channel 생성(force-app/main/default/messageChannels/ExampleChannel.messageChannel에 정의), (2) 메시지 발행:
```javascript
import { publish, MessageContext } from 'lightning/messageService';
import EXAMPLE_CHANNEL from '@salesforce/messageChannel/ExampleChannel__c';
publish(this.messageContext, EXAMPLE_CHANNEL, { value: 'Hello' });
```
(3) 메시지 구독:
```javascript
import { subscribe, MessageContext } from 'lightning/messageService';
import EXAMPLE_CHANNEL from '@salesforce/messageChannel/ExampleChannel__c';
this.subscription = subscribe(this.messageContext, EXAMPLE_CHANNEL, (message) => {
console.log(message.value);
});
```
**팁:** 컴포넌트 간 통신의 효율적 솔루션으로 LMS 강조 / 대시보드 업데이트·크로스 컴포넌트 알림 사용 사례.

## 5. Lightning Data Service(LDS)란? 어떻게 쓰나?
LDS는 Apex 없이 Salesforce 데이터를 다룬다: 자동 캐시 관리, 서버 호출 감소, 쉬운 CRUD.
```html
<lightning-record-view-form record-id="001XXXXXXXXXXXXXXX" object-api-name="Account">
<lightning-output-field field-name="Name"></lightning-output-field>
</lightning-record-view-form>
```
**팁:** LDS가 성능을 개선하는 방법 강조 / LWC의 선언적 컴포넌트·wire 서비스에 LDS 사용 언급.

## 6. "with sharing"과 "without sharing"의 차이는?
With Sharing: 현재 사용자의 sharing rule 강제. Without Sharing: sharing rule 우회, 레코드 무제한 접근.
```apex
public with sharing class WithSharingExample { ... }
public without sharing class WithoutSharingExample { ... }
```
**팁:** "without sharing" 사용 시 보안 중요성 강조 / 내부 클래스의 기본 동작(부모 클래스 sharing 상속) 언급.

## 7. Salesforce에서 CI/CD 구현 베스트 프랙티스는?
(1) Git 같은 버전 관리, (2) Jenkins·Copado·Gearset로 배포 자동화, (3) 개발·테스트용 scratch org, (4) 품질 보장을 위한 코드 리뷰, (5) Apex Test Suite로 테스트 자동화, (6) 충돌 방지를 위한 환경 동기화.
**팁:** 쓴 도구와 이점(메타데이터 배포에 Copado) 강조 / 자동 배포 중 충돌 해결 예.

## 8. Copado로 배포 과정을 설명하라
(1) Salesforce org를 Copado에 연결, (2) 변경을 버전 관리 브랜치에 커밋, (3) 한 환경에서 다른 환경으로 배포 생성·검증, (4) 메타데이터 충돌 해결, (5) 검증된 변경을 타겟 org에 배포.
**팁:** 추적성·자동 승급 이점 / Copado가 배포를 간소화한 실제 시나리오 공유.

## 9. Salesforce 프로젝트에서 Git 머지 충돌을 어떻게 해결하나?
(1) 충돌 식별(pull/merge 시 Git이 충돌 파일 표시), (2) Git 클라이언트나 텍스트 에디터로 변경 머지, (3) scratch/샌드박스 org에 배포해 로컬 테스트, (4) 해결 후 커밋·푸시.
**팁:** VS Code·GitHub Desktop 같은 도구 / 충돌 최소화를 위한 적절한 브랜칭 전략 강조.

## 10. 관리한 어려운 프로젝트와 성공을 보장한 방법의 예는?
레거시 ERP 통합 프로젝트를 관리했다. 도전: (1) 데이터 매핑(불일치 형식 해결), (2) 실시간 동기화(Platform Events), (3) 테스트(엔드투엔드). 명확한 마일스톤, Agile, 팀 간 철저한 소통으로 성공.
**팁:** 도전·해결책·측정 가능한 결과에 집중 / 팀워크·소통을 성공 핵심 요인으로 언급.

## 11. Salesforce 배포의 치명적 이슈를 트러블슈팅한 경험은?
배포 중 커스텀 트리거가 CPU 타임아웃을 유발했다. (1) 디버그 로그 분석으로 비효율적 SOQL 식별, (2) 트리거를 벌크화 리팩터, (3) 성능 개선 확인 테스트.
**팁:** STAR 방법(상황·작업·행동·결과)으로 답변 구조화 / 빠른 사고·기술 전문성 강조.

## 12. 최신 Salesforce 기능을 어떻게 따라가고 팀이 적응하게 하나?
릴리스 노트 정독, 웨비나 참석, Trailhead 모듈 완료. 팀 적응: (1) 지식 공유 세션, (2) Trailhead 과제 할당, (3) 내부 해커톤.
**팁:** SalesforceBen·Dreamforce 세션 같은 리소스 / 팀 참여 전략 강조.

## 13. 여러 Salesforce 개발 프로젝트를 관리할 때 작업 우선순위를 어떻게 정하나?
(1) 영향(최고 비즈니스 가치), (2) 마감(시간 민감 항목 우선), (3) 의존성(블로킹 작업 해결). Jira·Asana로 추적·관리.
**팁:** 경쟁 우선순위를 다룬 실제 예 / 적응성·의사결정 능력 강조.

---

# Accenture & LTI-Mindtree

## 1. Managed와 Unmanaged Package의 차이는?
Managed: 제공자가 제어, 네임스페이스 포함, 발행자가 업그레이드 처리, AppExchange 배포에 유용. Unmanaged: 오픈소스, 네임스페이스 없음, 업그레이드 불가, 템플릿·코드 공유에 적합.
**팁:** Managed의 사용 사례로 AppExchange / Unmanaged는 설치 후 편집 가능 강조.

## 2. Master-Detail 관계란? 언제 쓰나?
두 오브젝트를 강하게 연결: master가 레코드 소유권·sharing 제어, detail은 master의 보안·삭제 규칙 상속. 사용 시점: Account(Master)에 연결된 Invoice(Detail) 같은 밀결합 데이터.
**팁:** roll-up summary는 Master에만 생성 가능 / cascading deletion이 핵심 기능.

## 3. Salesforce의 system context와 user context란?
System Context: 사용자 권한·sharing rule 무시(트리거, workflow). User Context: 사용자 권한·sharing rule 존중(Lightning 컴포넌트).
**팁:** Apex 컨텍스트 제어에 "with sharing"·"without sharing" / 각각 유용한 시나리오 설명.

## 4. screen flow에 현재 record ID를 어떻게 전달하나? 전체 레코드 전송이 가능한가?
flow를 시작하는 버튼/액션으로 recordId 전달. 전체 레코드는 직접 전달 불가하나 flow에서 recordId로 쿼리 가능.
**팁:** screen flow에서 recordId 변수 사용 중요성 / 추가 데이터엔 Get Record 요소.

## 5. 다른 오브젝트를 참조하는 formula 필드를 roll-up summary 계산에 쓸 수 있나?
아니다. 다른 오브젝트를 참조하는 formula 필드는 roll-up summary에 쓸 수 없다. roll-up은 같은 오브젝트에서 동작하기 때문.
**팁:** 대안으로 트리거나 DLRS(Declarative Lookup Rollup Summaries) 제안.

## 6. 기본값이 있으나 페이지 레이아웃에 없는 커스텀 필드. 레코드 복제 시 새 레코드의 필드 값은?
원본 레코드의 값을 유지한다. 기본값은 복제 중 적용되지 않기 때문.
**팁:** 기본값은 레코드 생성 중에만 적용 설명.

## 7. formula·validation rule에서 15자리 record ID를 18자리로 어떻게 변환하나?
CASESAFEID(Id)를 formula나 SOQL에 사용.
**팁:** Data Loader 같은 데이터 도구에서 CASESAFEID() 사용 강조.

## 8. 소유권 변경 시 manual sharing 레코드는 어떻게 되나?
새 소유자가 수동 재공유하지 않는 한 manual sharing 레코드는 제거된다.
**팁:** 자동화로 sharing rule 재생성 언급.

## 9. Apex 쿼리에서 FLS를 동적으로 어떻게 강제하나?
Security.stripInaccessible() 메서드로 동적 강제. 사용자가 접근 권한 없는 필드를 걸러낸다.
```apex
Schema.SObjectType accType = Schema.SObjectType.Account;
SObject acc = Security.stripInaccessible(AccessType.READABLE, [SELECT Name FROM Account WHERE Id = :someId]).get(0);
```
**팁:** 보안 베스트 프랙티스 준수 강조 / 다른 CRUD 접근 수준(readable, updateable 등)과 사용 설명.

## 10. validation rule과 트리거로 필드를 필수로 만들면 무엇이 먼저 실행되나?
validation rule이 먼저 실행된다. 시스템 내장 검증 프레임워크의 일부이고 트리거는 이후 DML 중 실행되기 때문.
**팁:** 명확성을 위해 Salesforce 실행 순서 설명.

## 11. 사용자가 primary contact를 둘 이상 할당하지 못하게 하려면?
validation rule이나 Apex 트리거로 제한 강제.
```
AND(
IsPrimary__c = TRUE,
Id <> TEXT(PRIORVALUE(Id))
)
```
**팁:** 단순한 경우 validation rule, 복잡한 경우 트리거 강조.

## 12. LDS란? 장단점은?
Lightning Components에서 Salesforce 데이터를 관리하는 프레임워크. 장점: 서버 호출 감소, CRUD 단순화, 자동 캐시 관리. 단점: Apex 대비 제한된 커스터마이징, 고급 데이터 조작 부적합.
**팁:** lightning-record-form이나 lightning-record-view-form 실제 예 제시.

## 13. before 트리거에서 DML을 실행할 수 있나? 왜?
가능하나 비권장. before 트리거에선 변경이 이미 DB 컨텍스트에 저장되어 추가 DML이 중복·재귀를 유발할 수 있다.
**팁:** before·after 트리거의 적절한 사용 베스트 프랙티스 강조.

## 14. future 메서드에 List를 전달할 수 있나?
아니다. future 메서드는 primitive 타입이나 primitive 컬렉션(List<String> 등)만 매개변수로 받는다.
**팁:** 복잡한 데이터 타입 전달엔 Queueable Apex 같은 대안 언급.

## 15. Cross Object Formula Field란?
Master-Detail이나 Lookup 관계에서 부모 레코드의 데이터를 가져오는 필드. 예: Opportunity에 Account의 이름 표시 — `Account.Name`.
**팁:** 단순 사례엔 Apex 불필요 강조.

## 16. formula 필드와 summary 필드의 차이는?
Formula Field: 같은/부모 레코드의 필드 기반 동적 계산. Roll-Up Summary Field: 관련 자식 레코드의 집계 데이터(SUM, AVG, MIN, MAX) 계산.
**팁:** 용도를 강조하는 예 제시.

## 20. System.runAs()의 용도는?
테스트 클래스에서 지정 사용자의 컨텍스트로 코드를 실행해 사용자 권한·프로필을 테스트.
```apex
User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
System.runAs(u) {
// Execute code here
}
```
**팁:** 테스트 클래스에서만 적용 가능 강조.

## 21. queueable 클래스가 future 메서드를 호출할 수 있나? 어떻게?
아니다. Salesforce가 비동기 작업 혼합을 제한하므로 queueable 클래스는 future 메서드를 호출할 수 없다.
**팁:** 그런 시나리오엔 Queueable 체이닝이나 Batch Apex 제안.

## 22. AuraEnabled 어노테이션의 용도는?
Apex 메서드·변수를 Lightning 컴포넌트와 flow에 노출.
```apex
@AuraEnabled
public static String getAccountName(String accountId) {
return [SELECT Name FROM Account WHERE Id = :accountId].Name;
}
```
**팁:** 백엔드 로직과 프런트엔드 컴포넌트를 연결하는 역할 강조.

## 23. View All, Modify All, View All Data, Modify All Data의 차이는?
View All: sharing 설정과 무관하게 특정 오브젝트의 모든 레코드 조회. Modify All: 특정 오브젝트의 모든 레코드 조회·편집. View All Data: org의 모든 오브젝트 레코드 조회. Modify All Data: 모든 오브젝트 레코드 조회·편집·삭제 무제한.
**팁:** 강력한 권한이므로 관리자·신뢰 사용자에게만 부여 강조.

## 24. Account 관련 모든 Opportunity를 가져오는 Apex 클래스를 작성하라
```apex
public class OpportunityFetcher {
public static List<Opportunity> getOpportunitiesByAccount(Id accountId) {
return [SELECT Id, Name, Amount FROM Opportunity WHERE AccountId = :accountId];
}
}
```
**팁:** 확장성을 위해 쿼리 벌크화 중요성 언급.

## 25. 최고 금액 Opportunity의 이름으로 Account description을 갱신하는 트리거를 작성하라
```apex
trigger UpdateAccountDescription on Opportunity (after insert, after update) {
Map<Id, Opportunity> highestOppMap = new Map<Id, Opportunity>();
for (Opportunity opp : Trigger.new) {
if (opp.AccountId != null) {
if (!highestOppMap.containsKey(opp.AccountId) ||
opp.Amount > highestOppMap.get(opp.AccountId).Amount) {
highestOppMap.put(opp.AccountId, opp);
}
}
}
List<Account> accountsToUpdate = new List<Account>();
for (Id accountId : highestOppMap.keySet()) {
Account acc = new Account(Id = accountId, Description = highestOppMap.get(accountId).Name);
accountsToUpdate.add(acc);
}
if (!accountsToUpdate.isEmpty()) {
update accountsToUpdate;
}
}
```
**팁:** 대용량 처리에 벌크화 로직 / 다양한 시나리오의 테스트 클래스로 동작 검증.

## 26. before 트리거에서 DML 작업을 할 수 있나? 왜?
가능하나 비권장. before 트리거에선 레코드가 아직 DB에 커밋되지 않고 메모리에 있어 DML 없이 직접 변경 가능. DML은 재귀나 불필요한 거버너 한도 소비를 유발할 수 있다.
**팁:** before 트리거에서 DML을 피하려 Trigger.new를 직접 갱신 강조.

## 27. future 메서드에 List를 전달할 수 있나?
아니다. 비-primitive list는 전달 불가. future 메서드는 primitive 타입이나 primitive 컬렉션(List<String>)만 받는다.
**팁:** 복잡한 데이터 전달의 유연성엔 Queueable Apex 제안.

## 28. Apex의 System.runAs()의 용도는?
특정 사용자 컨텍스트로 코드를 실행해 권한 세트·프로필을 테스트. FLS·sharing rule은 강제하지 않는다.
```apex
User standardUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
System.runAs(standardUser) {
// Code executed as Standard User
}
```
**팁:** 테스트 클래스 전용 강조.

## 29. Queueable 클래스가 Future 메서드를 호출할 수 있나? 가능하면 어떻게?
아니다. stack overflow나 거버너 한도 위반 방지를 위해 비동기 작업 혼합을 허용하지 않는다.
**팁:** 순차 처리엔 Queueable 체이닝이나 Batch Apex 제안.

## 30. Apex의 @AuraEnabled 어노테이션의 용도는?
Apex 메서드·변수를 Lightning 컴포넌트·flow에 노출. 클라이언트 컨트롤러에 데이터 반환·UI 상호작용 지원.
```apex
@AuraEnabled
public static List<Account> getAccounts() {
return [SELECT Id, Name FROM Account LIMIT 10];
}
```
**팁:** LWC·Aura와 백엔드 로직 연결 중요성 언급.

## 31. Account 관련 모든 Opportunity를 가져오는 Apex 클래스를 작성하라
```apex
public class OpportunityService {
@AuraEnabled
public static List<Opportunity> getOpportunitiesByAccount(Id accountId) {
return [SELECT Id, Name, Amount FROM Opportunity WHERE AccountId = :accountId];
}
}
```
**팁:** 운영 준비를 위해 쿼리 벌크화.

## 32. 최고 Amount Opportunity 이름으로 Account Description을 갱신하는 트리거를 작성하라
```apex
trigger UpdateAccountDescription on Opportunity (after insert, after update) {
Map<Id, Opportunity> highestOpp = new Map<Id, Opportunity>();
for (Opportunity opp : Trigger.new) {
if (opp.AccountId != null && (highestOpp.get(opp.AccountId) == null
|| opp.Amount > highestOpp.get(opp.AccountId).Amount)) {
highestOpp.put(opp.AccountId, opp);
}
}
List<Account> accountsToUpdate = new List<Account>();
for (Id accountId : highestOpp.keySet()) {
accountsToUpdate.add(new Account(Id = accountId, Description = highestOpp.get(accountId).Name));
}
if (!accountsToUpdate.isEmpty()) {
update accountsToUpdate;
}
}
```
**팁:** 엣지 케이스를 테스트 클래스로 강조 테스트.

## 33. Salesforce에서 REST와 SOAP API의 차이는? 각각 언제 쓰나?
REST API: 경량, JSON, 모바일·웹 앱에 최선. SOAP API: 무거움, XML, 엄격한 데이터 계약이 필요한 레거시 통합에 최선.
**팁:** REST의 단순성 vs 엔터프라이즈용 SOAP의 견고함 강조.

## 34. 외부 시스템이 Salesforce에 접근하도록 인증·인가하는 방법은?
OAuth 2.0으로 안전한 인증·인가. 흐름: Authorization Code Flow(서버 간), JWT Bearer Flow(사용자 상호작용 없는 통합 사용자), Username-Password Flow(비-UI, 보안 우려로 비권장).
**팁:** API 통합 간소화·보안을 위해 Named Credentials 중요성 설명.

## 35. Salesforce의 Named Credential이란? 왜 쓰나?
엔드포인트 URL, 인증 타입, 자격 증명을 Salesforce에 안전하게 저장해 외부 서비스 통합 설정·관리를 단순화한다. 민감 정보 하드코딩 없이 사용.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyNamedCredential/resource');
req.setMethod('GET');
Http http = new Http();
HttpResponse res = http.send(req);
```
**팁:** 하드코딩 자격 증명 회피로 보안 위험 감소 강조.

## 36. Apex에서 콜아웃 예외와 응답 파싱을 어떻게 처리하나?
try-catch로 콜아웃 예외(타임아웃, 잘못된 URL) 처리, JSON.deserialize나 JSON.deserializeUntyped로 JSON 응답 파싱.
```apex
try {
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.example.com/data');
req.setMethod('GET');
Http http = new Http();
HttpResponse res = http.send(req);
if (res.getStatusCode() == 200) {
Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
}
} catch (Exception e) {
System.debug('Callout failed: ' + e.getMessage());
}
```
**팁:** HttpCalloutMock 인터페이스로 콜아웃 테스트.

## 37. Platform Events란? 통합에 어떻게 쓰나?
Salesforce와 외부 시스템이 비동기 통신하는 이벤트 기반 메커니즘. 알림, 데이터 동기화, 로깅에 이상적.
```apex
EventName__e event = new EventName__e(Field__c = 'value');
EventBus.publish(event);
```
외부 시스템은 CometD, Salesforce는 트리거로 구독.
**팁:** 시스템 분리를 위한 비동기 특성 강조.

## 38. Salesforce와 다른 시스템 간 양방향 동기화를 어떻게 하나?
복잡한 통합엔 미들웨어(MuleSoft, Informatica), 직접 통신엔 REST API나 Platform Events, 외부 변경 추적엔 external ID, 실시간 업데이트엔 CDC.
**팁:** 충돌 처리·데이터 일관성 유지 중요성 강조.

## 39. 통합 중 대용량 데이터를 어떻게 처리하나?
대용량엔 Bulk API, 거버너 한도 회피를 위한 작은 청크 분할, REST API 페이지네이션, Salesforce 처리엔 Batch나 Scheduled Apex.
**팁:** 성능 개선을 위해 SOQL 최적화·인덱싱.

## 40. Apex에서 Named Credentials를 쓸 수 있나?
예, API 콜아웃을 단순화·보안한다. 엔드포인트 URL·인증 정보를 추상화한다.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyNamedCredential/resource');
req.setMethod('POST');
Http http = new Http();
HttpResponse res = http.send(req);
```
**팁:** Named Credentials가 수동 인증 토큰 처리를 없앤다 언급.

---

# Cognizant

> 형식: 질문 / 정답(인터뷰 후 정정된 답) / 팁

## 1. "Grant Access Using Hierarchy" 설정은 어디서 바꾸나?
커스텀 오브젝트 수준의 sharing 설정에서 가능: Setup → Object Manager → [커스텀 오브젝트] → Edit → 'Grant Access Using Hierarchies' 체크 해제. 표준 오브젝트는 항상 활성화되어 변경 불가.
**팁:** 이 설정은 커스텀 오브젝트에만 적용. 해당 커스텀 오브젝트의 role hierarchy 기반 공유를 멈추고 싶을 때 사용.

## 2. 같은 role·profile의 두 사용자 중 User A만 레코드 소유자를 변경하게 하려면?
"Transfer Record" 권한이 있는 Permission Set을 만들어 User A에게만 할당.
**팁:** "Transfer Record"가 소유권 변경의 핵심 권한. 같은 프로필의 두 사용자를 프로필로 구별할 수 없으므로 Permission Set이 답.

## 3. Salesforce에서 레코드를 공유하는 방법은 몇 가지?
(1) Role Hierarchy, (2) Owner-based Sharing Rule, (3) Criteria-based Sharing Rule, (4) Manual Sharing, (5) Apex Managed Sharing, (6) Territory-based Sharing, (7) Team Sharing(Account Team, Opportunity Team), (8) Implicit Sharing, (9) Flow를 통한 공유.
**팁:** 선언적(point & click)·프로그래밍 공유 방법 모두 언급.

## 4. Salesforce의 Territory Sharing이란?
Enterprise Territory Management(ETM)의 일부. 조직이 영업 영역을 모델링하고 역할이 아닌 영역 할당 기반으로 레코드 접근을 제어한다.
**팁:** 주로 지리·조직 경계 기반 Opportunity·Account·Contact 접근에 사용.

## 5. 중복 Account Name을 찾는 SOQL을 작성하라
```sql
SELECT Name FROM Account GROUP BY Name HAVING COUNT(Id) > 1
```
**팁:** 필드로 그룹화하고 HAVING COUNT() > 1로 중복 찾기.

## 6. 한 번도 수정되지 않은 Contact를 찾는 SOQL
```sql
SELECT Id, Name FROM Contact WHERE LastModifiedDate = CreatedDate
```
**팁:** 미수정 레코드 식별엔 LastModifiedDate = CreatedDate.

## 7. 같은 오브젝트에 여러 트리거를 실행할 수 있나?
예, 같은 오브젝트에 여러 트리거 가능. 단 실행 순서를 보장하지 않으므로 오브젝트당 트리거 하나로 로직을 핸들러 클래스에 위임하는 것이 베스트 프랙티스.
**팁:** 트리거 프레임워크로 "오브젝트당 트리거 하나" 패턴.

## 8. 트리거 실행이 오류를 던지면 어떻게 되나?
오류 시 전체 DML 작업이 롤백되고 예외가 던져진다. 적절히 처리하지 않으면 workflow·process builder 액션도 포함.
**팁:** 트리거 로직에 try-catch로 예외 관리.

## 9. Batch Apex vs Queueable Apex
Batch Apex: 수백만 건 처리, 3개 메서드(start, execute, finish), 스케줄·체이닝. Queueable Apex: 경량, 복잡 로직·체이닝 지원하나 대용량엔 부적합.
**팁:** 청킹 + 재시도 로직이 필요하면 Batch Apex.

## 10. Future 메서드 vs Queueable 클래스
Future: 값 반환 불가, 체이닝 불가, 커스터마이징 제한. Queueable: 작업 체이닝, 비-primitive 타입 접근, 더 나은 제어.
**팁:** @future(callout=true)가 필요한 외부 통합이 아니면 항상 Queueable 선호.

## 11. LWC의 Lifecycle Hook을 설명하라
constructor()(초기화, DOM 사용 회피), connectedCallback()(DOM 삽입 시), renderedCallback()(매 렌더 후), disconnectedCallback()(DOM 제거 시), errorCallback(error, stack)(자식 컴포넌트 오류 시).
**팁:** 순서 constructor → connected → rendered / 무한 루프 위험이 있으니 renderedCallback에 데이터 조회 로직 회피.

## 12. LWC의 render 메서드 vs 조건부 렌더링
조건부 렌더링은 template if:true/if:false로 로직 기반 DOM 제어. render() 메서드는 동적으로 템플릿 파일을 선택할 때 사용.
```js
render() {
return this.customCondition ? templateOne : templateTwo;
}
```
**팁:** 여러 템플릿 전환엔 render(), 단일 템플릿 내 블록 가시성엔 if:true/false.

## 13. 트리거에서 호출한 future 메서드가 SOQL 오류가 나면?
future 메서드가 실패해도 메인 트랜잭션(트리거)은 실패하지 않는다. future는 별도 컨텍스트에서 실행.
**팁:** 위험한 로직을 future에 격리해 메인 트랜잭션 롤백 방지.

## 14. Batch Apex에서 트리거를 호출할 수 있나?
명시적으로 호출하진 않지만 execute() 안에서 DML을 수행하면 트리거가 자동 발생.
**팁:** 배치 컨텍스트의 DML 중 트리거 발생, 한도 주의·컨텍스트 변수 사용.

## 15. Batch Apex는 Stateful인가 Stateless인가?
기본 Stateless. Database.Stateful을 구현하면 배치 실행 간 변수 상태를 유지.
**팁:** 배치 간 데이터 집계·누적 시 Stateful.

## 16. Batch Apex의 execute 안에 SOQL을 쓸 수 있나?
예. 단 거버너 한도 내 유지를 위해 하드코딩·비효율 쿼리 회피.
**팁:** 항상 벌크화·대용량엔 Database.QueryLocator / start()에서 전달된 데이터 선호.

## 17. future 메서드가 안 되면 Batch Apex에서 콜아웃을 어떻게 하나?
Batch 클래스에 Database.AllowsCallouts 인터페이스 사용.
```apex
global class MyBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
global void execute(Database.BatchableContext bc, List<SObject> scope) {
// perform callout here
}
}
```
**팁:** execute 컨텍스트당 콜아웃 하나만 허용. 루프 안 콜아웃 체이닝 회피.

## 18. 필터 후에도 5천만 건 초과면?
Salesforce는 배치 작업당 5천만 건 하드 한도. 초과 시 실패.
**팁:** 기준이나 중간 오브젝트로 데이터 사전 처리·세분화.

## 19. Flow에서 Apex 클래스를 호출할 수 있나?
예. @InvocableMethod로 어노테이션하면 Flow에서 사용 가능.
```apex
public class MyFlowClass {
@InvocableMethod
public static void myMethod(List<String> input) {
// logic
}
}
```
**팁:** 구조화 입출력엔 @InvocableVariable.

## 20. Modify All 외 모든 권한이 있는데 Opportunity를 삭제 못 한다
Full Access로 공유되어도 삭제하려면 "Modify All"이나 레코드 소유권이 필요. 공유 접근이 Delete 권한을 오버라이드하지 않는다.
**팁:** Owner·Admin·Modify All만 삭제 가능. Full Access ≠ Delete.

## 21. 부모(Master) 레코드를 휴지통에서 복원하면 자식도 복원되나?
예. master를 undelete하면 Salesforce가 자식 레코드와 Master-Detail 관계를 자동 복원.
**팁:** undelete 중 참조 무결성 유지.

## 22. 왜 Batch Apex에서 future 메서드를 호출할 수 없나?
둘 다 비동기라 Salesforce가 비동기 작업 중첩을 금지. future는 다른 비동기 컨텍스트(Batch, Queueable, Schedulable)에서 호출 불가.
**팁:** Queueable에서 Queueable 호출이나 Database.AllowsCallouts로 배치에서 외부 호출.

## 23. LWC에서 Apex를 호출하는 방법은 몇 가지?
(1) @AuraEnabled(cacheable=true)(읽기 전용, wire), (2) @AuraEnabled(cacheable=false)(명령형), (3) Apex가 있는 Wire Adapter, (4) LMS나 이벤트 내 Apex 사용.
**팁:** 읽기 전용엔 cacheable=true, 그 경우 DML 회피.

## 24. LWC를 Account에만 표시하려면?
meta.xml에 targets·targetConfigs 설정:
```xml
<target>lightning__RecordPage</target>
<targetConfigs>
<targetConfig targets="lightning__RecordPage">
<objects>
<object>Account</object>
</objects>
</targetConfig>
</targetConfigs>
```
**팁:** 런타임 로직만이 아니라 메타데이터 설정으로 오브젝트 타게팅.

## 25. Permission Set엔 없고 Profile에만 있는 것은?
Profile만 가능: 로그인 시간·IP 범위, 기본 Record Type, 페이지 레이아웃 할당(간접), 비밀번호 정책, 오브젝트 탭 설정(Hidden/Default On).
**팁:** Permission Set은 가산적. 기본 접근엔 Profile, 모듈식 접근엔 Permission Set.

## 26. 보안 모델을 설명하라
오브젝트 수준 보안(Profile·Permission Set), 필드 수준 보안(Profile·Permission Set), 레코드 수준 보안(OWD, Role Hierarchy, Sharing Rule, Manual Sharing, Apex Sharing).
**팁:** 3계층(Object, Field, Record) 언급. "건물 → 방 → 사물함" 같은 비유.

## 27. Profile과 Role이란?
Profile: 오브젝트·필드·앱·탭·시스템 권한 제어. Role: 계층으로 레코드 수준 접근 제어.
**팁:** 사용자 1명 → 프로필 1개·역할 1개. Permission Set은 가산적, Role은 가시성용.

## 28. Lookup을 Master-Detail로 변환할 수 있나?
예, 가능 조건: 모든 자식 레코드에 부모가 있을 것, 부모가 삭제되지 않을 것, 관계가 roll-up summary에 이미 사용되지 않을 것.
**팁:** 변환 전 항상 백업. 특정 조건에선 변환이 불가역.

## 29. 표준 오브젝트를 Master-Detail의 자식으로 쓸 수 있나?
아니다. 표준 오브젝트는 Master-Detail의 자식이 될 수 없다. 커스텀 오브젝트만 자식 가능.
**팁:** 표준 오브젝트는 lookup 자식은 가능하나 master-detail 자식은 불가.

## 30. Master-Detail에서 자식 레코드를 삭제하면?
자식 삭제는 master에 영향 없음. 단 master 삭제는 자식을 cascade 삭제.
**팁:** 부모-자식 의존성이 엄격할 때 Master-Detail 설계.

## 31. Record-Triggered Flow와 Auto-Launched Flow의 차이
Record-Triggered Flow: 레코드 생성·갱신·삭제 시 자동 실행. Auto-Launched Flow: Apex·Process Builder·REST·다른 flow로 트리거.
**팁:** 자동화엔 record-triggered, 재사용성엔 auto-launched.

## 32. Flow에서 오류를 처리하는 방법은?
flow 요소의 Fault path(Get, Update 등), Apex Action(Invocable Apex)의 try-catch, Display Text의 커스텀 오류 화면, 커스텀 오브젝트 로깅.
**팁:** 항상 fault path로 설계. 예상치 못한 실패 추적엔 디버그 로그.

## 33. Salesforce의 Edition 종류는?
Essentials, Professional, Enterprise, Unlimited, Developer, Performance(대부분 org에서 폐지).
**팁:** Enterprise 이상이 Apex·API 지원. Developer는 테스트용 무료.

## 34. Invocable Method란?
@InvocableMethod로 어노테이션된 Apex 메서드로 Flow나 Process Builder에서 호출 가능.
```apex
public class MyUtility {
@InvocableMethod
public static void doSomething(List<String> input) {
// logic
}
}
```
**팁:** 구조화 입출력엔 @InvocableVariable. 클래스당 메서드 하나만 지원.

## 35. Flow로 레코드를 undelete할 수 있나?
아니다. Flow는 레코드를 undelete할 수 없다. Apex만 undelete DML 사용 가능.
**팁:** Apex 액션이나 휴지통 수동 undelete. 복원 후 동작 자동화엔 after undelete 트리거.

## 36. Flow의 Scheduled Path가 초기 값을 잃는다
Scheduled Path는 자체 컨텍스트에서 현재 레코드 상태를 참조한다. 생성 후 값이 갱신되면 초기 값을 잃는다. 해결: 생성 시 커스텀 필드에 초기 값 저장.
**팁:** 나중에 필요한 값은 assignment element로 스냅샷.

## 37. Flow가 HTTP 콜아웃을 할 수 있나?
예. "Action" → "Apex Action"으로 콜아웃을 수행하는 @InvocableMethod 호출.
**팁:** Named Credentials 사용. flow를 autolaunched·비동기 실행.

## 38. Compound Field란?
Name, Address, Location 같은 필드의 논리적 그룹. 예: BillingAddress는 street·city·postal code의 compound.
**팁:** REST API에서 사용, SOQL에선 접근 불가.

## 39. Data Loader의 도전은?
lookup 의존성이 있는 대용량 파일 처리, validation rule로 인한 실패, foreign key 오류 해결 어려움, CSV의 UTF-8 인코딩 이슈.
**팁:** External ID 사용, validation/workflow 임시 비활성화.

## 40. Refresh Interval이란?
Dashboard에선 데이터 자동 새로고침 빈도를 정의. LWC에선 데이터 재조회 간격(refreshApex()로 수동).
**팁:** 기본은 수동, 핵심 이해관계자를 위해 스케줄.

## 41. Batch Apex에서 콜아웃을 할 수 있나?
예. Database.AllowsCallouts 인터페이스를 클래스 선언에 추가.
```apex
global class MyBatch implements Database.Batchable<SObject>, Database.AllowsCallouts
```
**팁:** execute당 콜아웃 하나만 허용. 체이닝엔 Continuation.

## 41-b. 실행 중 변수 값 유지
Database.Stateful 인터페이스로 배치 청크 간 변수 값 유지.
**팁:** 신중히. 요약 데이터나 카운터에만.

## 42. System.CalloutException이란?
콜아웃 실패(타임아웃, 잘못된 엔드포인트, 인증서 이슈, 미등록 도메인) 시 던져진다.
**팁:** try-catch로 처리. 디버깅을 위해 오류 응답 본문 로깅.

## 43. Batch가 5천만 건 초과 반환하면?
Database.QueryLocator는 결과가 5천만 건 초과 시 실패. 대용량엔 Iterable 사용.
**팁:** 필터로 로직 분할이나 배치 작업 체인.

## 44. 왜 Future에 sObject를 전달할 수 없나?
@future 메서드는 primitive 타입, primitive 컬렉션, serializable 객체만 받는다. sObject는 직렬화 한계로 불허.
**팁:** 대신 Queueable 사용. sObject를 받는다.

## 45. Imperative와 Wire의 차이
Wire: 선언적·반응형·캐시됨, 데이터 변경 시 자동 조회. Imperative: 수동, .then() 사용, 조건부 로직이나 함수 내 호출에 적합.
**팁:** 반응형 UI엔 @wire, 제어된 흐름·복잡 매개변수엔 imperative.

## 46. 독립 컴포넌트 간 데이터 전달
LMS의 pub-sub 모델, 무관 컴포넌트엔 LMS, 관련 컴포넌트(부모-자식)엔 props나 custom event.
**팁:** 큰 앱엔 LMS. @salesforce/messageChannel/... import 후 등록.

## 47. Event Propagation이란?
세 단계: Capture phase, Target phase, Bubble phase. LWC는 shadow DOM 경계를 넘기 위해 bubbling·composed event 지원.
**팁:** 이벤트 발생 시 적절한 전파를 위해 bubbles: true, composed: true.

## 48. LWC의 인라인 편집 동적 데이터 테이블
`<lightning-datatable>`에 컬럼 editable: true. 셀 변경 시 oncellchange로 변경을 캡처하고 Apex로 저장.
```html
<lightning-datatable
data={data}
columns={columns}
key-field="Id"
onsave={handleSave}
draft-values={draftValues}>
</lightning-datatable>
```
**팁:** draftValues 사용, optimistic UI vs 서버 결과를 적절히 처리.

## 49. Named Credential이란?
콜아웃용 엔드포인트 URL과 인증 정보를 안전하게 저장하는 방법. Apex에 시크릿 하드코딩 회피.
**팁:** 외부 서비스에 사용. OAuth2·비밀번호 기반·인증서 기반 인증 지원.

## 50. Connected App이란?
외부 시스템이 OAuth2로 Salesforce와 통합하게 한다. Client ID/Secret, callback URL을 제공하고 scope를 제어.
**팁:** JWT, Web Server, Username-Password OAuth 흐름에 필요.

## 51. Account에 총 Opportunity 금액을 표시하는 트리거
```apex
trigger UpdateAccountTotal on Opportunity (after insert, after update, after delete, after undelete) {
Set<Id> accountIds = new Set<Id>();
if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
for(Opportunity opp : Trigger.new){
if(opp.AccountId != null) accountIds.add(opp.AccountId);
}
}
if(Trigger.isDelete){
for(Opportunity opp : Trigger.old){
if(opp.AccountId != null) accountIds.add(opp.AccountId);
}
}
Map<Id, Decimal> accountTotalMap = new Map<Id, Decimal>();
for(AggregateResult ar : [
SELECT AccountId, SUM(Amount) totalAmount
FROM Opportunity
WHERE AccountId IN :accountIds
GROUP BY AccountId
]){
accountTotalMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalAmount'));
}
List<Account> accountsToUpdate = new List<Account>();
for(Id accId : accountIds){
accountsToUpdate.add(new Account(
Id = accId,
Total_Opportunity_Amount__c = accountTotalMap.get(accId)
));
}
update accountsToUpdate;
}
```
**팁:** 루프 안 SOQL을 피하려 aggregate 쿼리 / 정확성을 위해 delete·undelete 처리 / Account에 Total_Opportunity_Amount__c 필드 생성.

---

# PwC India (통합)

## 1. Salesforce의 Integration Pattern이란?
Salesforce와 외부 시스템 간 흔한 통합 문제의 표준화된 해법. 유형: Request and Reply, Fire and Forget, Batch Data Synchronization, Remote Call-In, UI Update Based on Data Changes.
**팁:** 실시간 vs 배치, 방향(인바운드/아웃바운드), 동기 vs 비동기에 따라 패턴 선택.

## 2. 다양한 Integration Pattern 유형을 설명하라
(1) Remote Process Invocation – Request and Reply: Salesforce가 외부 응답을 기다리는 실시간 동기(예: 결제 API 콜아웃). (2) Fire and Forget: 응답 없는 비동기 아웃바운드(예: 외부 시스템 활동 로그). (3) Batch Data Synchronization: API·ETL로 주기적 대규모 데이터 교환. (4) Remote Call-In: 외부가 Salesforce API 호출(REST/SOAP). (5) UI Update Based on Data Changes: Platform Events·Streaming API로 백엔드 변경을 UI에 반영.
**팁:** 거버너 한도·지연·볼륨을 이해해 올바른 패턴 선택.

## 3. Remote Site Settings란? 왜 중요한가?
Apex의 외부 콜아웃을 허용한다. 도메인을 추가하지 않으면 보안상 Salesforce가 HTTP 요청을 차단.
**팁:** 타겟 서비스의 도메인 추가(전체 URL 아님). Spring '21+엔 Named Credentials로 이 수동 단계 회피.

## 4. Connected App이란?
외부 애플리케이션이 OAuth 프로토콜로 통합하게 한다. client ID, client secret, scope, callback URL, 정책을 정의.
**팁:** JWT, Web Server, Mobile OAuth 흐름 시 Connected App 사용.

## 5. OAuth란? Salesforce 통합에서 어떻게 동작하나?
인가의 개방형 표준으로, 애플리케이션이 비밀번호 공유 없이 사용자 대신 Salesforce 리소스에 접근하게 한다. JWT, Web Server, Username-Password 같은 OAuth 2.0 흐름 지원.
**팁:** 구현 단순화·시크릿 저장 회피를 위해 OAuth가 있는 Named Credentials.

## 6. 사용 가능한 OAuth 2.0 흐름은?
(1) Authorization Code(Web Server) Flow, (2) Username-Password Flow, (3) JWT Bearer Token Flow, (4) Client Credentials Flow, (5) Device Flow, (6) SAML Bearer Assertion Flow.
**팁:** 백엔드엔 JWT, 사용자 상호작용 앱엔 Web Server, 고정 사용자 시스템 통합엔만 username-password(더 이상 비권장).

## 7. Salesforce의 JWT Flow란?
사용자 상호작용이 없는 서버 간 통합에 사용. connected app이 JWT에 서명하고 Salesforce에 토큰을 요청.
**팁:** 백그라운드 작업이나 고정 서비스 계정 통합에 사용.

## 8. Salesforce의 Web Server Flow란?
브라우저 로그인을 통해 사용자 대신 Salesforce에 접근해야 하는 앱에 사용. authorization code와 client credential을 사용.
**팁:** callback URL·사용자 로그인 필요. 고객 대면 앱에 좋음.

## 9. Named Credentials란? 어떻게 쓰나?
엔드포인트 URL과 자격 증명을 추상화해 코드에 민감 정보 없이 콜아웃을 가능하게 한다. OAuth 설정 포함 가능.
**팁:** Spring '21부터 Named Credentials 사용 시 Remote Site Settings 불필요.

## 10. OpenID Connect란? OAuth와 어떤 관계인가?
OAuth 2.0 위의 아이덴티티 계층. 사용자 아이덴티티(id_token)를 반환해 SSO를 가능하게 한다.
**팁:** Google, Okta 같은 ID 제공자와 통합 시 사용.

## 11. Streaming API란? 어떤 메커니즘을 쓰나?
외부 시스템이 PushTopic, Platform Events, Generic Events로 Salesforce 데이터의 실시간 변경을 구독하게 한다. 지속 연결 유지를 위해 CometD(Bayeux 프로토콜) long polling 사용. 메커니즘: PushTopic Events(커스텀 SOQL 기반), Platform Events(커스텀 이벤트 버스), CDC(오브젝트 변경 시스템 이벤트), Generic Events(앱 수준 메시지).
**팁:** 실시간 대시보드·동기화 엔진·알림에 사용. 현대 사례엔 PushTopic 대신 Platform Events/CDC.

## 12. Change Data Capture(CDC)란?
표준·커스텀 오브젝트의 변경(Insert, Update, Delete, Undelete)에 대한 이벤트 스트림을 발행한다. 시스템 간 실시간 동기화를 보장.
**팁:** CDC 이벤트는 72시간 저장 / 놓친 이벤트 리플레이엔 ReplayId / 보장된 전달·감사 추적이 필요한 통합에 사용.

## 13. Tooling API란? 언제 쓰나?
커스텀 개발 도구·IDE 구축에 사용. 메타데이터 컴포넌트, Apex 클래스, Visualforce 페이지, 디버그 로그, 테스트 결과에 접근. 사용 사례: Apex 테스트 실행, 디버그 로그 조회, Apex 클래스 생성, 배포·코드 커버리지 추적.
**팁:** Metadata API가 너무 무겁거나 실시간 개발 활동 시 Tooling API.

## 14. Salesforce Connect란? 언제 써야 하나?
외부 데이터를 Salesforce에 저장 없이 실시간 접근한다. external object를 쓰며 OData 2.0/4.0, Apex Connector Framework, 커스텀 어댑터 지원. 사용: 데이터가 외부 저장(ERP, 레거시 DB), 복제 없는 실시간 접근 필요 시.
**팁:** 거버너 한도 회피. 안전한 통합엔 External Services나 Named Credentials와 결합.

## 15. REST API Composite Resource란? 어떻게 동작하나?
여러 REST 호출을 단일 HTTP 요청으로 결합해 성능 개선·왕복 감소. 유형: Composite(한 호출에 여러 하위 요청, 최대 25), Composite Batch(독립 실행), Composite Tree(부모-자식 레코드를 한 호출에 생성).
**팁:** 요청 순서 유지·요청 간 reference ID 전달엔 composite / API 한도 회피에 도움 / account + 관련 contact 생성 같은 복잡 작업에 사용.

---

# WrapDrive

## 1. 어떤 Salesforce 클라우드에서 일했나?
Sales Cloud(리드·Opportunity 관리, 예측, 자동화), Service Cloud(케이스 관리, Omni-Channel, Knowledge base), Experience Cloud(파트너·고객 포털 구축) 실무 경험.
**팁:** 역할에 관련된 클라우드 언급. 작업한 핵심 기능·구성 설명 준비.

## 2. OWD란? 레코드 가시성에 어떤 영향?
레코드를 소유하지 않은 사용자의 기본 레코드 접근 수준. Private, Public Read Only, Public Read/Write, Controlled by Parent(Master-Detail).
**팁:** OWD는 시작점, 접근 확장엔 Role·Sharing Rule·Manual Sharing·Apex Sharing.

## 3. 사용자 동결(freeze) vs 비활성화(deactivate)?
Freeze: 라이선스 제거 없이 로그인 방지. Deactivate: 접근 제거·라이선스 반환·로그인 방지.
**팁:** 활성 스케줄 작업·배치 클래스에 관여한 사용자를 비활성화하기 전 freeze가 유용.

## 4. SOQL의 OFFSET과 LIMIT의 차이는?
LIMIT: 반환 레코드 수 제한. OFFSET: 지정 레코드 수 건너뛰기.
```sql
SELECT Name FROM Account ORDER BY CreatedDate DESC LIMIT 10 OFFSET 20
```
**팁:** OFFSET은 대용량에 비권장(최대 2000건 skip 한도).

## 5. SOQL의 'FOR UPDATE' 키워드란?
현재 트랜잭션이 완료될 때까지 선택된 레코드를 다른 트랜잭션이 편집하지 못하게 잠근다. Apex의 동시성 제어에 유용.
```apex
SELECT Name FROM Account WHERE Name LIKE 'A%' FOR UPDATE
```
**팁:** 경합 감소를 위해 레코드 잠금 후 장시간 프로세스 회피.

## 6. Custom Metadata와 Custom Settings의 차이
Custom Settings: 레코드처럼 저장되는 앱 수준 데이터, 변경과 함께 배포 불가. Custom Metadata Types: 메타데이터로 저장된 구성, 배포·패키징·테스트 가능.
**팁:** 버전 관리·org 간 배포가 필요한 구성엔 Custom Metadata.

## 7. Apex의 Interface란?
구현 없는 메서드 시그니처의 모음. 클래스가 implements 키워드로 인터페이스를 구현.
**팁:** 다형성·재사용 로직(Batchable, Schedulable)에 사용.

## 8. List Exception이란? (예시 시나리오)
존재하지 않는 인덱스 접근, 빈 리스트에 .get() 사용, 비호환 타입 할당 시 발생.
```apex
List<String> names = new List<String>();
System.debug(names.get(0)); // throws List index out of bounds
```
**팁:** 요소 접근 전 항상 list.size() 확인.

## 9. 트리거에서 Apex 콜아웃을 할 수 있나? 왜?
트리거는 동기 콜아웃을 할 수 없다. @future나 Queueable 메서드에 콜아웃을 위임해야 한다.
**팁:** DML 컨텍스트에서 외부 시스템 직접 호출 회피. 필요시 Platform Events나 Flow Orchestration.

## 10. Queueable Apex에서 Batch Apex를 호출할 수 있나?
예, Queueable에서 Batch Apex 호출 가능, 그 반대는 불가. Queueable은 로직 체이닝·필요시 배치 작업 호출에 좋음.
**팁:** 배치 작업 거버너 한도 준수.

## 11. Account와 관련 Opportunity 중 Amount 기준 상위 5개를 가져오는 SOQL
```sql
SELECT Name,
(SELECT Name, Amount FROM Opportunities ORDER BY Amount DESC LIMIT 5)
FROM Account
```
**팁:** 부모-자식 서브쿼리는 중첩 쿼리 안에서만 ORDER BY + LIMIT 지원.

## 12. 기존 Contact와 중복되는 Lead를 찾는 SOQL
```sql
SELECT Id, Name, Email
FROM Lead
WHERE Email IN (SELECT Email FROM Contact WHERE Email != null)
```
**팁:** 중복은 보통 Email·Phone·커스텀 필드로 매칭. 실시간 중복 제거엔 Matching Rule.

---

# Salesforce Developer (종합)

## 1. 로드가 너무 오래 걸리는 복잡한 리포트를 어떻게 최적화하나?
구체적 필터로 데이터셋 축소, 불필요하면 Joined Report에서 Tabular/Summary로 전환, 커스텀보다 표준 report type, "All Time" 날짜 필터 회피, 미사용 필드/컬럼 제거, 온디맨드 대신 리포트 실행 스케줄.
**팁:** 너무 많은 관련 오브젝트·복잡한 bucket 필드로 리포트 과부하 회피. 대용량 추적엔 reporting snapshot.

## 2. before 트리거와 after 트리거의 핵심 차이는?
Before: 삽입/갱신되는 레코드의 검증이나 필드 값 갱신. After: 레코드 ID가 필요할 때(관련 레코드 삽입).
**팁:** 같은 오브젝트의 대부분 DML엔 before, ID가 필요하거나 관련 레코드 작업엔 after.

## 3. Salesforce는 대용량 데이터(LDV)를 어떻게 처리하나? 전략은?
Skinny Table(커스텀 필드), SOQL 필터에 인덱스 필드, 레코드 처리에 Batch Apex, 데이터 아카이빙, 외부 저장엔 External Object.
**팁:** LDV에 비선택적 필터의 리포트·list view·쿼리 회피. 비동기 처리·페이지네이션 설계.

## 4. External Object란? 커스텀 오브젝트와 어떻게 다른가?
Custom Object: 데이터를 Salesforce 내 저장. External Object: 데이터를 Salesforce 외부에 저장하되 OData 프로토콜로 실시간 접근.
**팁:** 외부 DB 실시간 접근이 필요하고 데이터 중복을 피하고 싶을 때 external object.

## 5. 대용량 데이터셋 작업 시 거버너 한도를 어떻게 처리하나?
루프 안 SOQL/DML 회피, Map·Set으로 쿼리 감소, Batch Apex나 Queueable, Limit Apex 메서드로 사용량 모니터링.
**팁:** 동적으로 한도 내 유지하려 Limits.getDmlStatements(), Limits.getLimitDmlStatements().

## 6. 여러 비동기 프로세스(Batch, Future, Queueable) 사용의 복잡성은?
future에서 future 호출 불가, batch에서 batch 호출 불가. Queueable은 다른 Queueable 호출 가능(1단계). Batch는 대용량 지원하나 실시간 부적합. 공유 상태·데이터 의존성 처리가 복잡.
**팁:** 오케스트레이션을 신중히 계획. 이벤트 기반 체인엔 Platform Events나 Flow Orchestrator.

## 7. Salesforce 보안 관리(특히 민감 데이터) 베스트 프랙티스는?
OWD·Role·Sharing Rule, Apex에 FLS 체크, 저장 데이터 암호화(Shield Platform Encryption), Event Monitoring으로 접근 로깅·모니터링.
**팁:** SSN 같은 민감 정보를 평문 저장 회피. 필요한 곳 필드 암호화.

## 8. 런타임에 오브젝트/필드를 모를 때 dynamic Apex를 어떻게 구현하나?
Dynamic SOQL과 Schema.Describe 메서드 사용:
```apex
String objectName = 'Account';
SObjectType objType = Schema.getGlobalDescribe().get(objectName);
Map<String, Schema.SObjectField> fieldsMap = objType.getDescribe().fields.getMap();
```
**팁:** Dynamic Apex는 도구·유틸리티·범용 데이터 프로세서에 유용. 견고한 null·타입 처리 보장.

## 9. 이벤트 기반 아키텍처에 Platform Events를 어떻게 쓰나?
분리된 컴포넌트가 통신하게 한다. Apex·Flow·API로 발행. 구독자는 트리거·Flow·외부 시스템(CometD 경유).
**팁:** 레코드 변경 후 다운스트림 시스템 알림 같은 실시간 통합에 사용.

## 10. Custom Metadata Type과 Custom Settings의 차이는?
Custom Metadata Types: 메타데이터로 저장된 구성, org 간 배포 가능. Custom Settings: org/사용자 수준 데이터, 배포 쉽지 않음. 버전 관리가 필요한 구성엔 Custom Metadata, 사용자/org별 값엔 Custom Settings.
**팁:** 둘 다 SOQL 없이 접근 가능하나 Custom Metadata는 코드처럼 패키징·배포 가능.

## 11. SOQL vs SOSL — 차이와 각각 언제 쓰나?
SOQL은 단일 오브젝트에서 레코드 조회, SOSL은 여러 오브젝트 검색.
**팁:** 오브젝트·필드를 알면 SOQL, 오브젝트 전반 텍스트 검색 같은 글로벌 검색엔 SOSL.

## 12. Database.insert() vs insert — DML 처리에서 어떻게 다른가?
Database.insert는 allOrNone 플래그로 부분 성공 허용.
**팁:** 배치의 세밀한 오류 처리·부분 삽입엔 Database.insert(records, false).

## 13. @future 어노테이션 — 목적과 한계?
비동기 콜아웃·프로세스용.
**팁:** 값 반환 불가, 체이닝 불가, 다른 future나 batch에서 호출 불가.

## 14. Apex의 예외 처리 — 유형과 처리?
특정 예외 타입의 try-catch-finally 블록.
**팁:** 항상 예외 로깅, finally로 정리, 필요시 custom exception 생성.

## 15. 트리거 실행 순서 — 순서는?
before 트리거 → 검증 규칙 → after 트리거 같은 표준 순서.
**팁:** 전체 순서(assignment rule, auto-response, escalation rule) 이해. 크로스 오브젝트 갱신 신중히 테스트.

## 16. 재귀 트리거 — 방지 기법?
핸들러 클래스의 static 변수.
**팁:** 재귀 플래그 구현이나 Trigger Handler 패턴 같은 프레임워크.

## 17. REST API 콜아웃 — 통합 방법?
Apex의 Http, HttpRequest, HttpResponse 클래스.
**팁:** 하드코딩 엔드포인트 회피엔 Named Credentials. 항상 예외 처리.

## 18. REST vs SOAP API — 언제 무엇을?
REST는 경량, SOAP은 엄격한 계약용.
**팁:** 모바일/웹 앱엔 REST, WSDL이 필요한 레거시 통합엔 SOAP.

## 19. Named Credentials — 인증 단순화?
엔드포인트·인증 정보를 안전하게 저장.
**팁:** 하드코딩 회피. OAuth·basic auth 지원. 콜아웃·flow와 사용.

## 20. OAuth 2.0 Flow — Salesforce는 어떻게 쓰나?
서드파티 인증용.
**팁:** Web Server Flow, JWT, Username-Password flow 이해. 사용 사례 기반 선택.

## 21. Apex의 콜아웃 — 외부 서비스 처리?
Http 클래스와 @future(callout=true)나 Queueable.
**팁:** 메서드 적절히 어노테이션. Remote Site Settings에 엔드포인트 추가나 Named Credential.

## 22. Flow vs Process Builder vs Workflow Rule?
Flow가 가장 강력. PB는 폐기. Workflow는 기본적.
**팁:** 모든 신규 자동화엔 Flow. 오래된 로직은 Workflow/Process Builder에서 마이그레이션.

## 23. Apex 트리거 벌크화 — 왜, 어떻게?
컬렉션·map 사용, 루프 안 SOQL/DML 회피.
**팁:** 항상 200건 가정. 헬퍼 클래스·벌크 지원 구조.

## 24. Apex 베스트 프랙티스 — 최적화 팁?
코드 벌크화, 예외 처리, 테스트 작성.
**팁:** 중첩 루프 회피, Limits 클래스 사용, 명명 규칙, 트리거 프레임워크.

## 25. SOQL 최적화 — 한도 회피?
선택적 필터·인덱스 필드.
**팁:** SELECT * 회피, LIMIT 사용, 관계 쿼리 신중히, 루프 안 쿼리 회피.

## 26. Custom Metadata vs Custom Settings — 언제?
Metadata는 배포 가능, Settings는 런타임 구성.
**팁:** 버전 관리/배포 구성엔 Custom Metadata, 사용자/앱별 데이터엔 Settings.

## 27. Platform Cache — 사용과 이점?
자주 쓰는 데이터를 저장해 SOQL 사용 감소.
**팁:** 세션/사용자/org 데이터에 사용. 캐시 할당·비싼 쿼리 결과 저장.

## 28. Flow에서 Apex 호출 — 어떻게?
예, Invocable Method로.
**팁:** 메서드는 static, @InvocableMethod 어노테이션. 입출력은 List.

## 29. Record-Triggered Flow vs Apex Trigger?
단순 로직엔 Flow, 복잡 로직엔 Trigger.
**팁:** 가능하면 Flow 선호. 재귀·콜아웃·무거운 계산엔 Trigger.

## 30. Flow 디버깅 & 최적화?
Flow Debug Log와 사용자용 Debug Mode 사용.
**팁:** fault path 사용, 오류엔 이메일 알림, 루프 안 요소 최소화로 성능 최적화.
