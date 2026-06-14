---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Report Scheduling & Subscriptions in Salesforce]
---

# Salesforce의 리포트 예약(Scheduling)과 구독(Subscriptions)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. 리포트 예약이란?

특정 시간과 빈도(매일·매주·매월)로 사용자에게 이메일로 리포트 전달을 자동화합니다.

**사용 예:** 영업 관리자가 모든 열린 Opportunity 리포트를 매일 이메일로 받음, 지원 팀장이 미해결 Case 주간 요약을 받음.

**주요 기능:** 리포트 전달 자동화(수동 실행 불필요), 이메일로 전송, 여러 수신자 지원(팀·개인), Tabular·Summary·Matrix 리포트 지원(Joined 리포트는 불가).

**예약 단계:**
1. Reports → 예약할 리포트 열기
2. 상단 Subscribe 클릭 → 수신자 선택(User, Role, Public Group) → 빈도 선택(매일·매주·매월) → 전달 시간 설정 → 형식 선택(Excel, CSV, 인라인 이메일)
3. (선택) 조건 추가(예: 열린 Case가 10개 초과일 때만 전송)
4. Save → 자동 전송 시작

## 2. 리포트 구독이란?

사용자가 자신의 이메일 받은편지함으로 리포트를 자동으로 받을 수 있게 합니다.

**구독 단계:**
1. 리포트 열기 → 상단 Subscribe 클릭
2. 구독 설정 구성: 빈도(매일·매주·매월), 시간대, 알림 유형(이메일, 인앱 등)
3. (선택) 조건부 경고 설정(예: "Cases Open > 20"이면 알림), 액션 설정(이메일, 인앱 알림)
4. Save → 설정에 따라 리포트 수신 시작

## 모범 사례

- 비혼잡 시간대에 리포트 예약(시스템 부하 회피)
- 경고에 구독 사용(중요 알림 트리거 조건 설정)
- 큰 리포트 전송 피하기(이메일은 짧고 관련성 있게)
- 폴더로 리포트 정리
- 팀에 보내기 전 테스트(정확한 데이터 확인)
