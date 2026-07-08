---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Asynchrounous Apex types ( Future Methods)]
---

# 비동기 Apex 유형 (Future 메서드)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 유형
- **Future 메서드** (@future): 코드 비동기 실행.
- **Batch Apex**: 대량 데이터셋을 배치로 처리.
- **Queueable Apex**: 유연성·체이닝 제공.
- **Scheduled Apex**: 예약된 시간에 실행.

## Future 메서드 (@future)

사용 시점:
- 장기 실행 메서드로 Apex 트랜잭션 지연을 방지할 때
- 외부 웹서비스로 콜아웃할 때
- DML 작업을 분리해 Mixed DML 오류를 우회할 때

Future 메서드는 백그라운드에서 비동기 실행된다. 외부 웹서비스 콜아웃 등 자체 스레드에서 실행하고 싶은 장기 작업에 사용. 서로 다른 sObject 유형의 DML을 분리해 Mixed DML 오류를 방지할 수 있다. 각 Future 메서드는 큐에 등록되어 시스템 리소스 가용 시 실행. SOQL 쿼리 한도·힙 크기 한도 같은 일부 거버너 한도가 더 높다는 장점이 있다.

> Salesforce에서는 동일 트랜잭션 내에서 setup 오브젝트와 non-setup 오브젝트에 DML을 동시에 할 수 없다.
> - **Setup 오브젝트**: 시스템 자체 구성용(User, Profile, Role, Permission Set).
> - **Non-setup 오브젝트**: 핵심 비즈니스 데이터(Account, Contact, Opportunity).

Future 메서드 어노테이션 메서드는 반드시 static이며 void만 반환 가능. sObject를 인수로 전달할 수 없는 이유는, 호출 시점과 실행 시점 사이에 sObject가 변경될 수 있어 Future 메서드가 옛 값을 가져와 덮어쓸 수 있기 때문이다.

### 작성 방법
1. 메서드 앞에 @future 어노테이션 사용
2. static이며 void 반환만 가능
3. 값 반환 불가

### 제한 사항
1. sObject나 객체를 인수로 받을 수 없음(위 이유)
2. Future 메서드에서 다른 Future 메서드 호출 불가
3. 단일 트랜잭션당 최대 50개 생성
4. 24시간당 최대 호출 = 250,000회 또는 조직 사용자 라이선스 수 × 200

### 모니터링
UI(Setup → Apex Jobs) 또는 코드(AsyncApexJob 쿼리)로 모니터링.
