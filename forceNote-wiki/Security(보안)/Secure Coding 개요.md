---
tags: [Security, SecureCoding, Flow, ExecutionContext, 보안가이드, 위협모델]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Secure Coding Guide, 시큐어코딩 개요, Flow 보안, 플로우 실행컨텍스트, User Mode System Mode 플로우]
---

# Secure Coding 개요

> Lightning Platform 위에 빌드·통합된 앱에서 Salesforce가 식별한 가장 흔한 보안 이슈와, 플로우 설계 시 적용할 핵심 보안 원칙.

---

## 가이드 범위 (Ch1)

이 시큐어 코딩 가이드는 **Lightning Platform 위에서 빌드되거나 통합된 앱**을 감사하며 Salesforce가 식별한 가장 흔한 보안 이슈를 다룬다. Java, ASP.NET, PHP, Ruby on Rails 등 타 웹 플랫폼 예제도 포함한다.

> 원문: *"The Lightning Platform provides full or partial protection against many of these issues. It is noted when this is the case."*

즉 각 챕터(위협 영역)마다 **플랫폼이 제공하는 보호 여부**가 표시된다. 이 가이드는 모든 웹앱 보안 결함의 완전한 문서가 아니라 **쉬운 레퍼런스(easy reference)**로 의도되었으며, 상세 자료는 OWASP 사이트를 참조한다.

본 위키의 `Security(보안)/` 폴더는 이 가이드의 15개 챕터를 위협 영역별 노트로 나눈 것이다. 위협별 진입은 아래 [관련 노트](#관련-노트)를 따른다.

---

## 플로우 설계 시 보안 고려사항 (Ch2)

핵심 보안 원칙을 플로우 설계·구현·관리에 반영한다. 전수 항목:

| 항목 | 내용 |
|---|---|
| **Develop Flows Securely** | 플로우는 global class처럼 동작하며 flow code에 IP(지식재산) 보호가 없다. subscriber org의 어떤 코드든 어떤 컨텍스트에서도 플로우를 호출할 수 있으므로 신중히 작성한다. |
| **Use Subflows** | 서브플로우로 프로세스를 모듈화하고 실행 컨텍스트를 제어한다. 메인 플로우는 User Mode, 권한이 필요한 작업은 System Mode 서브플로우에서 실행한다. 예: User Mode로 opportunity 생성, 서브플로우가 System Mode로 소유권 할당. **Unprivileged 부분 → User Mode, Privileged 부분 → System Mode(서브플로우로 분리)** 권장. 예: 중복 방지를 위해 duplicate detection search는 privileged 서브플로우에서, lead insertion은 User Mode에서. |
| **Use an Appropriate Execution Context** | 아래 3모드 중 적절한 것을 선택한다. |
| **Use Apex for Custom Access Control Logic** | 절차적 접근 제어를 Apex로 구현한다. user mode, `stripInaccessible` 등 유틸 함수를 사용한다. org 사용자는 Apex Security and Sharing, Experience Cloud(특히 guest user)는 Guest User Record Access Development Best Practices 참조. |
| **Set User Mode for UI Flows** | Screen flow는 User Mode로 실행해야 사용자 권한·org 보안 정책을 준수한다. |
| **Validate Flow Inputs** | "available for inputs"로 표시된 모든 변수를 다른 코드의 user input과 동일하게 검증한다. |
| **Handle Record-Triggered Flows** | record-triggered flow는 system mode로 실행되며 데이터 검증·자동화에 흔히 쓰인다. Apex에서 시작된 플로우는 호출 Apex의 실행 컨텍스트를 상속한다. record-triggered flow의 기능을 제한하고 무관한 레코드를 수정하지 않는다 — 무관 레코드 수정 시 사용자 권한 제어가 강제된다. |
| **Document Flow Functionality** | 플로우/서브플로우에 명확·정보성 이름을 부여하고, 실행 컨텍스트·모드를 식별하는 일관된 명명 규칙을 쓴다. |
| **Implement Regular Reviews** | 변경·신규 배포 후 정기 검토를 수행한다. |

### 실행 컨텍스트 3모드 (전수)

- **User Mode** — 사용자에게 권한이 있는 레코드만 반환. **CRUD/FLS 규칙이 자동 적용**된다.
- **System Mode With Sharing** — 사용자와 공유된 레코드 반환(sharing rule 적용). **CRUD/FLS 규칙은 미적용.**
- **System Mode Without Sharing** — 모든 레코드 반환. guest user 시나리오 등 특정 use case 전용(추가 보안 검증 필요).

### 기본 컨텍스트

미설정 시 default가 적용된다.
- **UI로 호출되는 플로우의 default = User Mode.**
- 그 외 플로우의 default = **System Mode Without Sharing.**

> **Note (원문):** 실행 컨텍스트를 명시 설정할 것을 권장한다. 컨텍스트는 "Run in Mode" 고급 설정과 호출 방식으로 결정된다. Apex class에서 호출되면 플로우는 호출 Apex 코드의 실행 컨텍스트를 상속한다(보통 system mode). 그 외에는 설정된 flow settings를 따른다.

```
// 구조 예시 — 실제 동작 코드 아님 (Ch2 권장 패턴의 개념 흐름)
[Main Flow: User Mode]
  └─ opportunity 생성 (User Mode — 사용자 권한 검증)
  └─ call Subflow [System Mode]
         └─ duplicate detection search (privileged)
         └─ 소유권 할당 (privileged)
```

여기서 메인 플로우(unprivileged 부분)는 User Mode로, 권한이 필요한 부분만 System Mode 서브플로우로 분리하는 것이 핵심이다.

---

## 관련 노트
- [[SOQL Injection 위협]]
- [[XSS 방어]]
- [[권한과 접근 제어 위협]]
- [[Lightning Security 모델]]
- [[세션 ID와 브라우저 통신 위협]]
- [[Platform Security FAQ]]
- [[WITH USER_MODE]]
- [[CanTheUser]]
- [[StripInaccessible]]
- [[Flow MOC]]
