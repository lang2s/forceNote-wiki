---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Exception Handling in Apex]
---

# Apex의 예외 처리(Exception Handling)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Apex에서 예외 처리는 코드 실행 중 오류를 관리하는 것입니다. 예기치 못한 상황을 능숙하게 처리하는 견고한 코드 작성에 필수적입니다.

## 1. Try-Catch 블록

try-catch 블록으로 예외를 처리합니다. try 블록에는 예외가 발생할 수 있는 코드, catch 블록에는 예외 발생 시 취할 조치를 작성합니다.
```apex
try {
    // 예외가 발생할 수 있는 코드
} catch (ExceptionType e) {
    // 예외 처리 코드
}
```

## 2. Finally 블록

finally 블록은 예외 발생 여부와 관계없이 실행됩니다. 보통 리소스 해제 같은 정리 작업에 사용합니다.
```apex
try {
    // 코드
} catch (ExceptionType e) {
    // 예외 처리
} finally {
    // 항상 실행되는 코드
}
```

## 3. 커스텀 예외 던지기

특정 오류 시나리오를 더 세밀하게 처리하기 위해 커스텀 예외를 만들고 던질 수 있습니다.
```apex
public class CustomException extends Exception {}
try {
    if (someCondition) {
        throw new CustomException('Custom error message');
    }
} catch (CustomException e) {
    // 커스텀 예외 처리
}
```

## 4. 로깅과 메시징

catch 블록에서 예외 정보를 기록하는 로깅 메커니즘을 포함하면 디버깅·모니터링에 도움이 됩니다.
```apex
try {
    // 코드
} catch (ExceptionType e) {
    System.debug('Exception caught: ' + e.getMessage());
}
```

## 예외 타입

시스템 제공 표준 예외(NullPointerException, DmlException 등)와 개발자 정의 커스텀 예외를 지원합니다. 예상되는 오류 유형에 따라 특정 예외를 잡을 수 있습니다.

## Exception 클래스의 메서드

Exception 클래스는 모든 예외의 기본 클래스입니다. 주요 메서드:
- `getMessage()`: 예외 설명 문자열 반환
- `getCause()`: 예외의 원인(다른 예외) 반환
- `getLineNumber()`: 예외가 발생한 코드 줄 번호 반환
- `getStackTraceString()`: 스택 트레이스 문자열(예외까지의 메서드 호출 순서) 반환
