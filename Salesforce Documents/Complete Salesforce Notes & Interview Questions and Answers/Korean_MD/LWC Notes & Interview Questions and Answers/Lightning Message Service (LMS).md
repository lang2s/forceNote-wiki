---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Lightning Message Service (LMS)]
---

# Lightning Message Service (LMS)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## LMS
DOM 전반에서 Aura 컴포넌트·Visualforce 페이지·LWC 간 통신. 새 메타데이터 유형인 Lightning Message Channel 기반.

## Lightning Message Channel
UI 기술(LWC·Visualforce·Aura) 간 안전한 통신 채널. 경량·패키지 가능 컴포넌트로 org에 생성, 런타임에 발행·구독.

## Message Channel 생성
1. SFDX 프로젝트 생성.
2. default 아래 `messageChannels` 디렉터리 생성.
3. `<name>.messageChannel-meta.xml` 파일 생성(예: SampleMessageChannel.messageChannel-meta.xml).
4. 참조 시 `SampleMessageChannel__c` 사용(__c는 커스텀 표시이나 커스텀 오브젝트는 아님).

VF·Aura·LWC에서 발행·구독으로 상호 통신.
