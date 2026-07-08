---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Pause & Resume Scheduled Jobs Made Easy]
---

# 예약 작업 일시정지·재개 쉽게 하기 (Spring '25)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

🚀 **Salesforce Spring '25 업데이트:** 이제 예약 작업을 프로그래밍으로 일시정지·재개할 수 있어 예약 작업에 대한 유연성·제어력이 향상됨.

## 새로운 기능
1. **예약 작업 일시정지** 🛑 — `System.pauseScheduledJob(jobId)`로 작업을 임시 중지.
2. **예약 작업 재개** 🔄 — `System.resumeScheduledJob(jobId)`로 일시정지된 작업 재시작.

작업을 삭제·재예약할 필요 없이 필요할 때 일시정지·재개.

## 장점
- **더 나은 제어**: 유지보수·디버깅 중 작업 효과적 관리.
- **시간 절약**: 수동 재예약 불필요.
- **쉬운 유지보수**: 바쁜 시간에 비핵심 작업을 일시정지해 성능 최적화.

## 예제 코드
```apex
String jobId = 'YOUR_JOB_ID_HERE';
try {
    System.pauseScheduledJob(jobId);
    System.debug('✅ Scheduled job paused successfully.');
    System.resumeScheduledJob(jobId);
    System.debug('✅ Scheduled job resumed successfully.');
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
}
```

## 사용 방법
1. `YOUR_JOB_ID_HERE`를 실제 작업 ID로 교체. CronTrigger 오브젝트 쿼리나 System.scheduleJobs로 확인.
2. Developer Console, Apex 클래스, 트리거에서 실행.

## 주의 사항
- 일시정지 전 작업이 활성 상태여야 함.
- 재개는 빠르며 재예약 불필요.
- 예약 작업 관리 권한 필요.
