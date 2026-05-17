---
tags: [flow, error-handling, fault, best-practice, pattern]
source: Salesforce-Flow-Best-Practices-White-Paper-June-2025
created: 2026-05-17
aliases: [Flow 오류 처리, faultConnector, FaultMessage, Flow 에러, Flow fault]
---

# Flow 에러 처리

> Flow의 DML·Action 요소에는 반드시 Fault 경로를 연결한다. `{!$Flow.FaultMessage}`로 오류 내용을 캡처하고, Flow 타입에 따라 사용자 노출 방식을 다르게 처리한다.

---

## 핵심 원칙

**모든 DML·Action 요소에 faultConnector를 연결한다.** Fault가 없으면 Flow가 조용히 실패하고 사용자는 원인을 알 수 없다.

```
[Get Records]  ──→  (성공)  ──→  [다음 요소]
      └──────────→  (fault) ──→  [에러 처리 요소]
```

오류 메시지 변수:
```
{!$Flow.FaultMessage}   → 오류 전체 내용 (자동 설정, 읽기 전용)
```

---

## Flow 타입별 에러 처리 전략

| Flow 타입 | 권장 처리 방법 |
|---|---|
| Screen Flow | 오류 화면 표시 (`{!$Flow.FaultMessage}` 포함) |
| Record-Triggered | Chatter 게시 또는 이메일 발송 |
| Scheduled | 이메일 발송 또는 에러 로그 레코드 생성 |
| Autolaunched (호출됨) | 호출 측으로 오류 전파 (faultConnector → 종료) |

---

## Screen Flow — 오류 화면 패턴

```
[DML Create Records]
  └── fault ──→ [오류 화면 (SC_Error)]
                  - DisplayText: {!$Flow.FaultMessage}
                  - allowBack: false
                  - allowFinish: true   (닫기만 가능)
```

오류 화면 XML 구조:
```xml
<screens>
    <name>SC_Error</name>
    <label>오류가 발생했습니다</label>
    <allowBack>false</allowBack>
    <allowFinish>true</allowFinish>
    <fields>
        <name>txt_ErrorDisplay</name>
        <fieldText>{!$Flow.FaultMessage}</fieldText>
        <fieldType>DisplayText</fieldType>
    </fields>
</screens>
```

---

## Record-Triggered / Scheduled Flow — Chatter 게시 패턴

Screen이 없는 Flow는 Chatter 또는 이메일로 관리자에게 알린다.

```
[DML Update Records]
  └── fault ──→ [Chatter Post Action]
                  target: 관리자 사용자 Id 또는 그룹
                  body: "Flow 에러: {!$Flow.FaultMessage}"
```

Text Template 활용:
```
Flow 실행 오류 발생

Flow: Contact-AI-Set Default Fields
레코드 Id: {!$Record.Id}
오류 내용: {!$Flow.FaultMessage}

즉시 확인이 필요합니다.
```

---

## 에러 로그 레코드 생성 패턴

조직에 에러 로그 오브젝트가 있다면 Fault 경로에서 직접 생성한다.

```
[Action: APEX_ProcessData]
  └── fault ──→ [Insert Error_Log__c]
                  Flow_Name__c = "Contact-AI-Set Default Fields"
                  Error_Message__c = {!$Flow.FaultMessage}
                  Record_Id__c = {!$Record.Id}
                  Occurred_At__c = {!$Flow.CurrentDateTime}
```

---

## 이메일 발송 패턴

```
[DML Delete Records]
  └── fault ──→ [Email Alert Action: EMAIL_FlowError]
                  또는
              [Send Email Action]
                  To: admin@company.com
                  Subject: "Flow 에러 — {!$Flow.CurrentDateTime}"
                  Body: {!txt_ErrorTemplate}
```

---

## 비교표

| 상황 | 처리 방법 |
|---|---|
| 사용자가 보는 Screen Flow | 오류 화면 + `{!$Flow.FaultMessage}` 표시 |
| 백그라운드 자동화 Flow | Chatter 게시 또는 이메일 발송 |
| 에러 추적 시스템이 있는 조직 | Error Log 레코드 생성 |
| 서브플로우로 호출됨 | faultConnector → 종료 (호출자에 전파) |

---

## 주의 사항

> [!warning] DML·Action 요소마다 Fault 연결
> Get Records, Create Records, Update Records, Delete Records, Action(Apex/Email) 등 모든 DML·Action 요소에 faultConnector를 연결한다. 빠뜨리면 해당 요소 실패 시 사용자는 아무 정보도 얻지 못한다.

> [!tip] $Flow.FaultMessage는 읽기 전용
> `{!$Flow.FaultMessage}`는 Fault 경로에서 자동으로 채워진다. 별도 변수에 복사하려면 Assignment 요소를 사용한다.

---

## 관련 노트

- [[Screen Flow 설계]] — 오류 화면 포함 다단계 Flow 구조
- [[Flow 종류와 변수]] — `$Flow.FaultMessage` 전역 변수
- [[Flow 설계 베스트 프랙티스]] — 에러 처리 외 설계 원칙
- [[ConnectApi Chatter 패턴]] — Apex에서 Chatter 게시
