---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [Mastering LWC Scenario Based Questions]
---

# LWC 마스터 — 실전 시나리오 Q&A 질문

> [!warning] 제3자 학습노트(LWC 면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 LWC/플랫폼 기능 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요. (외부 AI·블록체인·생체인증 등은 Salesforce 네이티브 기능이 아니라 **외부 API 통합**으로만 가능하다는 점에 유의.)

> 원본은 이미지 PDF로 OCR 추출했습니다.

> 형식: **Q** = 시나리오·세부 질문, **A** = 표준 해법.

---

**두 사용자가 같은 레코드 동시 편집**
- **Q:** 한 사용자가 다른 변경을 덮어쓰지 않게 방지? Optimistic vs Pessimistic locking 차이? 충돌 변경 알림?
- **A:** **Optimistic locking**(권장) — 저장 전 `LastModifiedDate`/버전 필드를 비교해 stale이면 거부·재조회 안내. **Pessimistic locking**은 `SELECT ... FOR UPDATE`로 레코드를 잠가 동시 편집 자체를 막음(트랜잭션 한정, 드물게 사용). 충돌 시 CDC/Platform Event로 변경 알림.

**모든 관련 레코드를 한 번에 로드해 페이지 느림**
- **Q:** 지연 로딩? 렌더링 최적화 라이프사이클 훅? requestAnimationFrame?
- **A:** 필요한 데이터만 조회하는 **지연 로딩**(무한 스크롤·페이지네이션), `renderedCallback`은 가볍게(무거운 DOM 조작 금지·가드 플래그). 부드러운 UI는 `requestAnimationFrame`으로 배치 렌더. 필요 필드만 SOQL.

**사용자 상호작용 기반 동적 탭**
- **Q:** 동적 탭 시스템? 접근성·모바일 친화? 페이지 이동 시 선택 유지?
- **A:** `lightning-tabset`/`lightning-tab` 동적 구성, `aria-*`로 접근성, SLDS 반응형으로 모바일 대응. 활성 탭을 `localStorage`/URL 파라미터에 저장해 이동 후 복원.

**일정 시간 후 자동 액션**
- **Q:** setTimeout·setInterval 효과적 사용? 세션 타임아웃과 간섭 방지?
- **A:** `setTimeout`/`setInterval` 사용 후 **`disconnectedCallback`에서 반드시 정리**(누수 방지). 세션 타임아웃과 별개 타이머로 관리하고, 사용자 활동 감지 시 리셋.

**로그인 없이 공개 접근하나 안전한 LWC**
- **Q:** 게스트 사용자 보안? 게스트의 with/without sharing 영향?
- **A:** Experience Cloud **게스트 사용자**는 권한을 최소화(객체·필드·Apex 클래스 명시 허용). Apex는 반드시 **`with sharing`** — `without sharing`이면 게스트가 모든 레코드를 볼 위험. 게스트 공유 규칙·`Secure guest user record access` 설정 확인.

**WhatsApp 메시지 발송**
- **Q:** WhatsApp API 통합? 메시지 상태(sent·delivered·read) 추적?
- **A:** **Messaging for WhatsApp**(Digital Engagement) 또는 WhatsApp Business API를 **Named Credential + Apex 콜아웃**으로 연동. 상태는 제공자 **webhook**(Platform Event/REST 수신)으로 sent/delivered/read 업데이트.

**오프라인 동작 LWC**
- **Q:** 오프라인 모드 구현? 연결 복원 시 동기화?
- **A:** **Salesforce Mobile SDK / Offline**(모바일 앱) 또는 LWR 사이트의 **Service Worker** + 로컬 캐시(IndexedDB). 변경은 큐에 적재했다가 `navigator.onLine` 복원 시 동기화(충돌은 버전 비교).

**AI 챗봇(Dialogflow·OpenAI)**
- **Q:** LWC 통합? 실시간 대화 효율 처리?
- **A:** **Einstein Bots**(네이티브) 또는 외부 LLM/Dialogflow를 **Named Credential + Apex 콜아웃**(키는 서버측). 실시간성은 비동기 호출 + 스트리밍(가능 시), 대화 히스토리는 커스텀 오브젝트/세션에 저장.

**라이트·다크 모드 전환**
- **Q:** 동적 테마 전환? 사용자 선호 저장? 색 대비·접근성?
- **A:** 루트 `classList` 토글 + **CSS 변수**로 색상 일괄 전환, 선호는 `localStorage`/사용자 설정 레코드 저장. 대비는 **WCAG AA**(4.5:1) 충족 확인.

**예측 분석으로 제품 추천**
- **Q:** AI/ML 모델 통합? 과거 데이터 처리?
- **A:** **Einstein/Data Cloud** 예측 모델 또는 외부 ML API(Named Credential 콜아웃). 과거 데이터는 Salesforce/Data Cloud에 적재해 모델 학습·추론, 결과를 LWC에 표시.

**이력서 파싱**
- **Q:** AI 이력서 파서 API 통합? 구조화 데이터 저장?
- **A:** 외부 이력서 파서 API에 **Apex 콜아웃**(파일은 Base64) → 반환된 구조화 JSON을 커스텀 오브젝트(Candidate/Skill 등)에 저장. 파일은 `ContentVersion`.

**생체 인증(지문·얼굴)**
- **Q:** 생체 인증 통합? 안전 저장·검증? 대체 인증?
- **A:** 브라우저 **WebAuthn**(공개키 기반, 생체정보는 기기에만 저장) 또는 외부 인증 서비스. 생체 원본을 Salesforce에 저장하지 않음(개인정보·규제). 실패 시 비밀번호·OTP **대체 인증**.

**실시간 주식 시세**
- **Q:** 외부 주식 API 통합? 라이브 스트리밍? 과거 추세 차트?
- **A:** 외부 시세 API를 Apex 콜아웃으로 폴링하거나, 서버가 수신한 가격을 **Platform Event**로 발행 → LWC가 `empApi`로 구독(라이브). 과거 추세는 Chart.js로 차트.

**현장 팀 지오펜싱 알림**
- **Q:** 위치 추적? Google Maps 지오펜싱?
- **A:** 모바일 LWC의 **Geolocation**(getLocationService 또는 navigator) + Google Maps Geofencing API(콜아웃). 경계 진입/이탈 시 Platform Event/푸시 알림.

**블록체인 디지털 서명**
- **Q:** 블록체인 API 통합? 법적 구속력?
- **A:** 외부 블록체인/e-sign 서비스 API에 **Apex 콜아웃**으로 해시·서명 기록(Salesforce는 블록체인 네이티브 아님). 법적 구속력은 전자서명 규정(eIDAS·ESIGN 등) 준수 서비스 사용 + 법무 검토.

**얼굴 인식 출퇴근**
- **Q:** 얼굴 인식 API? 스푸핑 방지?
- **A:** 외부 얼굴 인식 API(콜아웃), **liveness detection**으로 스푸핑(사진·영상) 방지. 생체 원본은 외부에서 처리, Salesforce엔 출퇴근 결과만 저장.

**드래그앤드롭 워크플로우 디자이너**
- **Q:** 드래그앤드롭 UI? 커스텀 워크플로우 저장·실행?
- **A:** HTML5 드래그앤드롭(또는 라이브러리)로 노드 배치, 워크플로우 정의를 **JSON으로 직렬화해 저장**(커스텀 오브젝트/CMDT). 실행은 Apex/Flow 엔진이 정의를 해석.

**실시간 협업 화이트보드**
- **Q:** 실시간 화이트보드? 다중 사용자 동기화? Undo/Redo?
- **A:** `<canvas>` 드로잉 + 변경을 **Platform Event/외부 WebSocket**으로 브로드캐스트해 다중 사용자 동기화. Undo/Redo는 클라이언트 명령 스택(command pattern).

**게임화 직원 교육**
- **Q:** 리더보드·배지·보상? 진행 추적? 소셜·동료 챌린지?
- **A:** 커스텀 오브젝트(Points/Badge/Leaderboard) + Flow로 점수 적립, 진행 대시보드. 소셜 챌린지는 Chatter/그룹 연동. (Salesforce **Trailhead/myTrailhead** 게임화 참고.)

**SSO 경험**
- **Q:** OAuth 2.0·SAML SSO? 안전 인증·세션 관리? 다중 시스템 역할·권한?
- **A:** **SAML**(엔터프라이즈 IdP) 또는 **OAuth 2.0/OpenID Connect** SSO. Salesforce를 SP 또는 IdP로 구성, 세션 보안(타임아웃·IP 제한), 권한은 SAML 속성→Permission Set 매핑(JIT 프로비저닝).

**실시간 리스크 관리**
- **Q:** 동적 리스크 스코어링? 실시간 리스크 데이터?
- **A:** 리스크 스코어를 Flow/Apex로 동적 계산, 실시간 입력은 **Platform Events/CDC**로 수신해 대시보드·알림 갱신. 고급 분석은 CRM Analytics/Data Cloud.

**Salesforce 내 CMS**
- **Q:** 커스텀 CMS? 콘텐츠 분류·태깅·검색?
- **A:** **Salesforce CMS**(네이티브 헤드리스 CMS) 활용, 또는 커스텀 오브젝트(Content/Tag) + 태깅. 검색은 **SOSL**(전문 검색), Experience Cloud로 게시.

**직원 성과 관리**
- **Q:** 성과 관리 시스템? 목표 설정·진행·피드백?
- **A:** 커스텀 오브젝트(Goal/Review/Feedback) 또는 **Work.com**(성과 관리) 기능. 목표 설정·진행 추적·1:1 피드백을 LWC 대시보드로, 알림은 Flow.
