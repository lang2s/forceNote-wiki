---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [TCS LWC Scenario based Question]
---

# TCS — Lightning Web Component 시나리오 질문

> [!warning] 제3자 학습노트(LWC 시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 LWC/Salesforce 기능 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **Q** = 시나리오·세부 질문, **A** = 표준 해법.

---

**1. Apex 메서드 예외 처리**
- **Q:** 의미 있는 피드백? imperative vs @wire 오류 처리 차이? 오류 시 컴포넌트 반응성 유지?
- **A:** Apex에서 `AuraHandledException`을 던져 의미 있는 메시지를 전달. **imperative**는 `try/catch`(async-await) 또는 `.then().catch()`에서 `error.body.message` 추출 → 토스트/인라인. **@wire**는 `{ data, error }` 프로퍼티의 `error`를 템플릿에서 처리. 데이터 영역만 에러 표시하고 나머지 UI는 계속 동작시켜 반응성 유지.

```js
// 구조 예시 — 실제 동작 코드 아님
import findAccounts from '@salesforce/apex/AccountController.findAccounts';
// imperative
try {
  this.accounts = await findAccounts({ key: this.searchKey });
} catch (e) {
  this.errorMsg = e.body?.message ?? '알 수 없는 오류';
}
```

**2. 이름으로 Account 검색바(동적 결과)**
- **Q:** 디바운싱으로 과도 Apex 호출 방지? 대용량 검색 최적화? "결과 없음" 표시?
- **A:** 키 입력마다 호출하지 않도록 **디바운스**(setTimeout ~300ms). Apex는 인덱스 필드 `LIKE` 검색 + `LIMIT` + 서버측 페이지네이션. 결과 0건이면 `template lwc:if`로 "결과 없음" 메시지 렌더.

```js
// 구조 예시 — 실제 동작 코드 아님
handleKeyup(event) {
  window.clearTimeout(this.delay);
  const key = event.target.value;
  this.delay = setTimeout(() => { this.searchKey = key; }, 300);
}
```

**3. Platform Event 실시간 알림**
- **Q:** LWC에서 이벤트 구독? Platform Event 제약·처리? 새 이벤트마다 토스트?
- **A:** `lightning/empApi`의 `subscribe`로 `/event/My_Event__e` 채널 구독, 콜백에서 `ShowToastEvent` 발생. `disconnectedCallback`에서 `unsubscribe`. 제약: 전달은 best-effort, `replayId`로 재생 범위 관리, 구독·이벤트 발행 한도 유의.

**4. 차트로 판매 데이터 대시보드(필터)**
- **Q:** Chart.js/D3.js 통합? 사용자 입력에 차트 데이터 동적 바인딩? 반응형?
- **A:** Chart.js를 **Static Resource**로 올려 `loadScript`(platformResourceLoader)로 로드, `renderedCallback`에서 1회 초기화. 필터 변경 시 `chart.data` 갱신 후 `chart.update()`. `responsive: true` + 컨테이너 크기로 반응형.

**5. 다국어 지원(로케일 기반 라벨)**
- **Q:** Custom Labels 활용? 동적 라벨 조회·표시? RTL(아랍어·히브리어) 고려?
- **A:** `@salesforce/label/c.MyLabel` import로 **Custom Label**(자동 번역). 동적 라벨은 키→라벨 맵 사용. RTL은 `dir` 속성 + CSS logical properties(margin-inline 등)로 대응.

**6. 다중 선택 Contact 벌크 업데이트**
- **Q:** Lightning Data Table 다중 선택? 효율적 벌크 Apex? 성공·실패 피드백?
- **A:** `lightning-datatable`의 `selected-rows`/`getSelectedRows()`로 선택 수집 → Apex `@AuraEnabled` 메서드에 `List` 전달 → `Database.update(list, false)`로 부분 성공 허용 → `Database.SaveResult[]`로 행별 성공/실패 토스트.

**7. 데드라인 카운트다운 타이머**
- **Q:** LWC 타이머 구현? 성능 문제 없는 실시간 업데이트? 데드라인 변경 엣지 케이스?
- **A:** `setInterval(…, 1000)`로 갱신, `disconnectedCallback`에서 반드시 `clearInterval`(메모리 누수 방지). 데드라인이 `@api` setter로 바뀌면 기존 타이머를 리셋. 만료 시 인터벌 정리.

**8. Case 레코드에서 Chatter 게시**
- **Q:** Connect API로 게시? 첨부·리치 텍스트? 최근 게시 동적 새로고침?
- **A:** Apex에서 `ConnectApi.ChatterFeeds.postFeedElement`로 게시. 리치 텍스트·멘션은 `messageSegments`, 첨부는 `capabilities`(content/link). 게시 후 `refreshApex`로 피드 재조회해 갱신.

**9. 사용자 입력 기반 자식 컴포넌트 동적 렌더링**
- **Q:** 부모→자식 데이터 전달? 커스텀 이벤트로 자식→부모? 다중 자식 동시 업데이트?
- **A:** 부모→자식은 `@api` 프로퍼티(반응형). 자식→부모는 `dispatchEvent(new CustomEvent('change', { detail }))`. 다중 자식은 `template for:each` + `key`로 렌더, 부모 상태 변경 시 일괄 반영.

**10. 이벤트 관리 캘린더**
- **Q:** 데이터 기반 동적 표시? 드래그앤드롭 재스케줄? 시간대 차이 처리?
- **A:** `@wire` Apex로 이벤트 조회 후 그리드 렌더. 드래그앤드롭은 HTML5 `draggable` + `dragstart`/`drop` 핸들러 → Apex update. 시간대는 `Intl.DateTimeFormat` + 사용자 `TimeZoneSidKey`로 변환.

**11. 막대 클릭으로 필터링 바 차트**
- **Q:** Chart.js/D3.js 통합? 차트 상호작용 이벤트 핸들러? 접근성?
- **A:** Chart.js `onClick` 옵션으로 클릭된 요소 인덱스를 얻어 필터 적용. 접근성은 `aria-label` + 차트 대체용 데이터 테이블/키보드 조작 경로 제공.

**12. 컴포넌트 A→B 데이터 전송(독립 컴포넌트)**
- **Q:** Lightning Message Service(LMS)? 디커플링 유지? 메시지 디버깅?
- **A:** DOM 계층이 다른 형제 컴포넌트는 **LMS** 사용 — `lightning/messageService`의 `publish`/`subscribe` + Message Channel(.messageChannel-meta.xml). 컴포넌트는 서로를 직접 참조하지 않아 디커플드. 디버깅은 `MessageContext`·구독 콜백 로깅.

**13. 장기 작업 진행 바**
- **Q:** 작업 진행 상태 조회? 동적 업데이트? 실패·타임아웃 처리?
- **A:** Apex 폴링 또는 **Platform Event**로 진행률 수신 → `lightning-progress-bar`의 `value` 갱신. 실패·타임아웃은 에러 상태 표시 + 재시도 버튼, 폴링 최대 횟수 제한.

**14. 워크플로우 시각화 시뮬레이터**
- **Q:** 워크플로우 구조 동적 표현? 실행 경로 강조? 복잡 분기 확장성?
- **A:** 노드/엣지 데이터를 SVG 또는 중첩 HTML로 렌더, 실행 경로는 CSS 클래스로 강조. 복잡 분기는 접기/펼치기·가상 스크롤로 확장성 확보.

**15. 다중 사용자 실시간 협업**
- **Q:** Platform Events/Streaming API? 충돌 업데이트 처리? 변경 시각 표시?
- **A:** `empApi`로 **Platform Events** 또는 **CDC**(Change Data Capture) 구독. 충돌은 버전/`LastModifiedDate` 비교로 stale 감지(낙관적 잠금), 변경 시각은 `LastModifiedDate`·사용자 표시.

**16. 권한 기반 탭 인터페이스**
- **Q:** 탭 콘텐츠 동적 표시? 지연 로딩? 미인가 접근 차단?
- **A:** `@salesforce/userPermission/*` 또는 custom permission import로 `lightning-tab` 조건부 렌더. 탭 활성화 시점에 데이터 조회(지연 로딩). 미인가 탭은 렌더 자체를 막아 차단.

**17. 커스텀 데이터 테이블 인라인 편집**
- **Q:** 클라이언트 변경·배치 업데이트? 저장 전 검증? 다른 사용자 반영?
- **A:** `lightning-datatable`의 `draft-values`로 변경 수집, `onsave` 핸들러에서 검증 후 배치 Apex update → `refreshApex`로 갱신. 다른 사용자 변경 반영은 재조회 또는 CDC 구독.

**18. 다중 파일 업로드(진행 추적)**
- **Q:** 개별 진행 추적? 크기·타입 제한? 레코드 연결?
- **A:** `lightning-file-upload`(다중 + `accept`로 타입 제한, `record-id`로 자동 연결) 또는 커스텀 `input type=file` + XHR `progress` 이벤트로 개별 진행 추적. 연결은 `ContentDocumentLink`.

**19. 권한 기반 네비게이션 바**
- **Q:** 동적 관리? 미인가 메뉴 숨김? 외부·내부 링크?
- **A:** 권한 체크로 메뉴 항목 동적 구성, 미인가 항목 숨김. 내부 이동은 `NavigationMixin.Navigate`, 외부 링크는 `lightning-formatted-url`/`window.open`.

**20. 소셜 미디어 게시(Twitter·LinkedIn)**
- **Q:** OAuth 인증? 민감 데이터 노출 방지? API 한도·연결 오류?
- **A:** **Named Credential + External Credential**(OAuth 2.0)로 토큰을 코드 밖에서 관리, Apex 콜아웃으로 게시(클라이언트에 비밀 노출 금지). API 한도·재시도·에러 큐로 연결 오류 처리.

**21. Kanban 보드(드래그앤드롭)**
- **Q:** 레코드 분류? 드래그앤드롭? 이동 후 실시간 백엔드 업데이트?
- **A:** status 필드로 컬럼별 분류, HTML5 드래그앤드롭(`dragstart`/`drop`)으로 카드 이동 → `drop`에서 Apex update로 status 변경 → `refreshApex`. 낙관적 UI 갱신 후 실패 시 롤백.

**22. 선택 필드로 레코드 복제**
- **Q:** 필드 선택 UI? 종속 필드 로직? 권한 부족 오류?
- **A:** 체크박스 UI로 복제할 필드 선택, dependent picklist 등 종속 필드는 부모 선택에 따라 옵션 갱신. 권한 부족은 Apex `try/catch` + FLS 체크(`Security.stripInaccessible`).

**23. 자동완성 검색바**
- **Q:** 디바운스? 일치 없음 처리? 대용량 효율 표시?
- **A:** 디바운스(setTimeout)로 호출 제어, Apex `LIKE` 검색 + `LIMIT`, 0건이면 "일치 없음" 표시. 결과는 드롭다운으로 표시하고 키보드 탐색 지원.

**24. 동적 테마 선택(라이트·다크)**
- **Q:** CSS 클래스 동적 적용? 세션 간 유지? 테마별 자산(이미지·아이콘)?
- **A:** 루트 요소 `classList`로 테마 클래스 토글, 선택값을 `localStorage`(또는 사용자 설정 레코드)에 저장해 세션 간 유지. 테마별 자산은 조건부 `src`/CSS 변수로 전환.

**25. 레코드 복제 + 기본값 프리필**
- **Q:** 데이터 조회·폼 프리필? 역할·프로필 종속 값? 오류 처리?
- **A:** `getRecord`/Apex로 원본 조회 후 `lightning-record-edit-form`에 프리필. 역할·프로필 종속 기본값은 서버측에서 계산해 반환. 폼 `onerror`로 검증·저장 오류 처리.

**26. 선택 Contact 대량 이메일**
- **Q:** 이메일 템플릿 선택? 한도 내 throttling? 전달·실패 추적?
- **A:** 템플릿 선택 UI → Apex `Messaging.SingleEmailMessage`(+ `setTemplateId`) 조립 후 `Messaging.sendEmail`. 일일 이메일 한도 내 배치로 throttling, 반환 `SendEmailResult`로 전달·실패 추적.
