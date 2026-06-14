---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [15 Asynchronous Apex Interview Questions and Answers]
---

# 비동기 Apex Q&A 질문 15선

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. 비동기 Apex란?**

사용자 트랜잭션과 분리되어 백그라운드에서 실행되는 Apex 코드. 대량 데이터 처리·이메일 전송 등 장기 작업을 UI 지연 없이 실행해 플랫폼 반응성·효율 유지.

**2. 비동기 Apex 유형?**

Future 메서드(@future), Batch Apex, Queueable Apex, Scheduled Apex.

**3. @future 메서드란?**

백그라운드 비동기 메서드. 이메일·웹서비스 콜아웃 등 현재 트랜잭션과 독립적인 작업에 사용. void만 반환, 복합 객체 매개변수 불가.

**4. 단일 트랜잭션당 @future 최대 호출 수?**

50개.

**5. Queueable vs @future?**

Queueable은 더 유연·강력. 작업 체이닝, 진행 모니터링, 복합 객체 전달 가능. @future보다 고급 작업 제어.

**6. 단일 트랜잭션당 Queueable 큐 추가 최대?**

50개.

**7. Batch Apex와 사용 시점?**

대량 데이터셋을 비동기 처리. 데이터를 청크로 나눠 각각 별도 트랜잭션 처리. 수백만 건 작업(정리·대량 업데이트)에 이상적.

**8. Batch의 대량 데이터 처리?**

관리 가능한 청크(기본 200건)로 처리해 거버너 한도 회피. 배치 크기 지정으로 성능 최적화.

**9. Batch 클래스 핵심 구성?**

Database.Batchable 구현, start(범위 정의)·execute(배치 처리)·finish(후처리).

**10. 동시 실행 가능 Batch 작업 최대?**

5개.

**11. Scheduled Apex와 동작?**

지정 간격(매일·매주)에 Apex 클래스 실행. 리포트·데이터 유지보수 자동화. UI 또는 System.schedule()로 설정.

**12. 동시 활성 Scheduled 작업 최대?**

100개.

**13. Future/Queueable 작업 실패 시?**

자동 재시도 없음. AsyncApexJob으로 상태 모니터링, 수동 재큐잉·로깅으로 오류 처리.

**14. @future에서 DML 가능?**

가능(insert/update/delete). 거버너 한도 고려, 대량 시 배치 처리.

**15. System.schedule로 매일 실행?**
```apex
String cronExp = '0 0 12 * * ?'; // 매일 정오
String jobName = 'DailyApexJob';
System.schedule(jobName, cronExp, new MyScheduledClass());
```
