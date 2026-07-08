---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Trigger interview Question imp]
---

# 중요 트리거 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. 트리거를 일시적으로 비활성화할 수 있나요?

네, 여러 방법:
1. **직접 비활성화:** Setup → Apex Triggers → 비활성화할 트리거 선택 → IsActive 체크 해제 → 저장.
2. **Custom Settings로 우회:** 특정 오브젝트/사용자에 대해 우회. Custom Setting에 "Disable Trigger" 체크박스를 만들고, 트리거에 이 설정을 확인하는 로직 추가. Setup → Custom Settings → Manage → New로 값 설정.
3. **static boolean 변수:** static boolean 플래그를 가진 Apex 클래스 생성. 특정 작업에서 `triggerControl.disableTrigger = true`로 비활성화.

## 2. Before vs After 트리거 사용 시점

- **Before 트리거:** 저장 전 데이터 검증·수정. 예: Account industry가 banking이면 rating을 "HOT"으로 채움, 삽입 전 pincode 채움.
- **After 트리거:** 관련 레코드 업데이트, 커밋된 레코드에 의존하는 작업. 예: Account 생성 시 관련 Contact 생성, 이메일 전송.

## 3. Trigger Handler 패턴

코드 재사용성·유지보수성·확장성을 높이고 벌크 처리 실패·재귀 같은 문제를 방지합니다.
```apex
public class AccountTriggerHandler {
    public static void handleBeforeInsert(List<Account> newacclist){ }
    public static void handleBeforeUpdate(List<Account> newacclist, Map<Id,Account> newaccmap, List<Account> oldacclist, Map<Id,Account> oldaccmap){ }
    public static void handleBeforeDelete(List<Account> oldacclist, Map<Id,Account> oldaccmap){ }
    public static void handleAfterInsert(List<Account> newacclist, Map<Id,Account> newaccmap){ }
    public static void handleAfterUpdate(...) { }
    public static void handleAfterDelete(...) { }
    public static void handleAfterUndelete(...) { }
}
```

## 4. addError 메서드의 용도

Before 트리거에서 데이터 검증·잘못된 데이터 방지에 사용. 레코드 저장 전 커스텀 오류 메시지를 표시하고 저장을 중단합니다.

## 5. 트리거에서 다른 트리거 호출

트리거에서 트리거를 직접 호출할 수 없습니다. Apex 핸들러 패턴과 헬퍼 클래스로 깔끔하게 실행합니다. 트리거는 DML 작업 기반으로 실행되므로, Account 트리거가 Contact에 DML을 수행하면 Contact 트리거가 자동 실행됩니다.
