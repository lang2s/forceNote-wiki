---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [ASYNCHRONOUS APEX CHEATSHEET]
---

# 비동기 Apex 치트시트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 소개
비동기 Apex는 메인 UI와 분리된 백그라운드에서 프로세스를 실행한다. 장기 실행 작업을 사용자 경험 방해 없이 처리. Future 메서드, Batch Apex, Queueable Apex, Scheduled Apex 포함.

## 장점
- **성능 향상**: 무거운 처리를 백그라운드로 옮겨 메인 앱 반응성 유지.
- **확장성**: 대량 데이터·복잡한 작업을 성능 영향 없이 처리.
- **사용자 경험**: 백그라운드 작업 중에도 앱 계속 사용 가능.
- **오류 처리**: 재시도·로깅을 사용자 영향 없이 효과적으로 처리.
- **리소스 관리**: 시스템 리소스 가용 시 작업 실행으로 사용 최적화.

## Future 메서드
즉시 결과가 필요 없는 백그라운드 작업. 값을 반환할 필요 없는 작업에 적합.
**사용 사례**: 이메일 전송, 외부 API 콜아웃, 즉시 완료 불필요한 레코드 처리.

## Batch Apex
대량 레코드를 관리 가능한 작은 배치로 처리.
**사용 사례**: 데이터 마이그레이션, 대량 레코드 업데이트.

## Queueable Apex
작업을 비동기로 실행하며 작업 체이닝 제공.
**사용 사례**: 초기 작업 후 추가 처리 필요 시(예: 관련 레코드 업데이트 후 알림 전송 체이닝).

## Schedulable Apex
특정 시간·간격에 Apex 클래스 실행.
**사용 사례**: 리포트 생성, 외부 시스템과 데이터 동기화.
