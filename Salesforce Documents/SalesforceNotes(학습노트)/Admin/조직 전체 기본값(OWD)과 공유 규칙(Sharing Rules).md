---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [OWD & Sharing Rules]
---

# 조직 전체 기본값(OWD)과 공유 규칙(Sharing Rules)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

조직 전체 기본값(OWD)은 Salesforce 레코드에 대한 사용자의 기본 접근 수준을 결정합니다. 특정 오브젝트의 모든 레코드에 대한 기준 접근을 정의합니다.

공유 규칙은 Public Group을 통해 레코드를 수평적으로, 즉석으로 공유하는 방법을 제공합니다.

## 조직 전체 기본값(OWD)

Salesforce는 레코드 가시성에 대한 여러 기본 접근 수준을 제공합니다.

**OWD 유형:**
- **Public Read/Write:** 모든 사용자가 오브젝트의 레코드를 보고 편집 가능. 데이터 프라이버시가 문제되지 않을 때.
- **Public Read Only:** 모든 사용자가 레코드를 볼 수 있지만 레코드 소유자(또는 역할 계층상 상위 사용자)만 편집 가능. 폭넓은 가시성 보장.
- **Private:** 레코드 소유자(또는 역할 계층상 상위 사용자)를 제외하고 다른 사용자는 보거나 편집 불가. 최대 데이터 프라이버시.
- **Controlled by Parent:** 자식 레코드 접근이 부모 레코드의 공유 설정에 의해 제어됨(자식 레코드에서 사용 가능).

## 공유 규칙(Sharing Rules)

**유형:**
- **소유권 기반 공유 규칙(Ownership based):** 역할, 역할-및-하위, Public Group 소유권에 따라 레코드 공유.
- **기준 기반 공유 규칙(Criteria based):** 소유자에 관계없이 레코드 필드 값에 따라 레코드 접근.
- **게스트 기반 공유 규칙(Guest based):** 미인증 게스트 사용자에게 읽기 전용 접근 부여(특수한 기준 기반 공유 규칙).

## 핵심 정리

공유 규칙은 OWD를 넘어 접근을 확장하여, 사전 정의된 기준에 따라 특정 사용자나 그룹에 레코드 접근을 부여합니다.

레코드 수준 보안: OWD → Role Hierarchy → Sharing Rules 순으로 가시성이 열립니다(점점 넓어짐). 공유 규칙은 데이터 접근을 제어하면서 보안을 유지하고 협업을 촉진하여, 적절한 사용자가 관련 레코드에 적절한 가시성을 갖도록 보장합니다.
