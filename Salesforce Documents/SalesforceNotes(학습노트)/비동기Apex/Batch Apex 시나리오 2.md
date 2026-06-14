---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Batch Apex Scenario -2]
---

# Batch Apex 시나리오 2

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. 배치 작업이 몇 시간씩 걸린다. 진단·최적화 방법은?

**진단**
- **로그 확인**: 배치 작업 로그·디버그 로그에서 오류·느린 지점 파악.
- **Apex Jobs 모니터링**: Apex Jobs 페이지에서 상태·소요 시간 확인.

**최적화**
- **쿼리**: 필터·인덱스 필드로 반환 레코드 수 제한.
- **효율적 코드**: 불필요한 작업 제거.
- **배치 크기**: 적절히 조정(작은 배치는 한도 회피, 큰 배치는 한 번에 더 많이 처리).
- **비동기 처리**: 복잡 작업은 Queueable Apex로 분리해 효율적으로 실행.

## 2. 거버너 한도 내에서 5천만 건 처리 방법은?

**Batch Apex 사용**
- 레코드를 작은 청크로 처리해 한도 없이 대량 데이터 처리.
- 필터·인덱스 필드로 효율적 쿼리.
- 불필요한 작업 제거.

**또는 Queueable Apex 사용**
- 복잡 작업을 작은 작업으로 나눠 별도로 효율 실행.
