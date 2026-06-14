# Salesforce Apex 트리거 치트시트

> (원본은 이미지 PDF로 OCR 추출했습니다.)

## 1. 소개

Apex 트리거는 레코드 삽입·업데이트·삭제 같은 특정 이벤트 전후에 실행되는 코드입니다.

## 2. 기본 구조
```apex
trigger MyTrigger on ObjectName (trigger_events) {
    // 트리거 로직
}
```

## 3. 트리거 컨텍스트 변수

Trigger.new(새 버전 sObject), Trigger.old(이전 버전), Trigger.newMap(ID→새 버전 맵), Trigger.oldMap(ID→이전 버전 맵).

## 4. 트리거 이벤트

before insert, before update, before delete, after insert, after update, after delete, after undelete.

## 5. 트리거 처리

- 벌크화: 대용량 데이터를 효율적으로 처리하도록 코드 벌크화. 루프 안 SOQL·DML 최소화.
- 조건부 로직: if 문으로 특정 조건 기반 로직 적용.
- 예외 처리: try-catch 블록.

## 6. 모범 사례

벌크 안전 코드, 하드코딩 회피(상수·Custom Settings), 명명 규칙, 충분한 테스트 커버리지.

## 7. 거버너 한도

거버너 한도 인지, 코드 벌크화로 한도 회피.

## 8. 고급 개념

- 트리거 패턴: handler 프레임워크로 조직화.
- 재귀 방지: static 변수 사용.
