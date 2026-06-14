---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Sales Cloud]
---

# Salesforce Sales Cloud

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했으며, 일부 텍스트가 불완전하여 핵심 내용 위주로 정리했습니다.)

## Campaign과 Campaign Member

**Campaign이란?**
- 비즈니스가 제품·서비스를 홍보하기 위해 채택하는 전략입니다.
- 회사에는 여러 캠페인이 있을 수 있습니다.
- 캠페인은 마케팅 이니셔티브를 상세히 추적하도록 돕습니다.
- 캠페인 레코드는 관련 자산과 관심 고객을 함께 묶어두어, 회사가 계획을 추적하거나 성과를 되돌아볼 수 있게 합니다. 광고·권유, 이메일, 세미나·컨퍼런스 같은 전문 마케팅 이벤트를 포함할 수 있습니다.
- 각 이니셔티브별로 Lead와 Contact, 그리고 그들의 응답을 추적합니다.
- 관리자(Admin)는 Marketing User 프로필을 활성화해야 캠페인을 생성할 수 있습니다.

**Campaign Member란?**

각 캠페인에서 타겟팅하는 잠재 고객(Lead, Contact, Person Account 추가).

**Campaign Hierarchy:**

부모 멤버에 연결되는 관련 캠페인.

**Campaign Report가 유용한 이유:**

내장 리포트가 캠페인 성과와 강도 추적에 매우 유용. 비즈니스·마케팅 분석가가 리포트 기반으로 의사 결정. 과거 데이터가 새 캠페인에 도움.

## Lead(리드)

- Lead는 제품·서비스에 관심을 보이는 잠재 고객입니다. 브랜드가 타겟/잠재 고객을 끌어들이도록 제품을 마케팅할 수 있습니다.
- 웹사이트에 Web-to-Lead 양식을 둡니다.
- 고객이 양식을 작성하면 Lead로 수신합니다.
- Lead 생성은 비즈니스에 중요합니다.
- Lead는 Lead라는 오브젝트에 모든 레코드를 저장합니다.

**Lead 캡처:**

Setup → Web-to-Lead. reCAPTCHA(스팸 방지)를 활성화해야 합니다. Lead 양식 생성 시 코드가 생성되며, 이를 복사해 웹 페이지에 저장합니다.

**중요 포인트:**
- Lead 생성 시 모든 universally required 필드에 값이 있어야 함.
- reCAPTCHA는 라이브 웹사이트에서 작동.
- Web-to-Lead 요청의 데이터 한도는 500.
- 검증 규칙은 양식 제출 시 적용됨.

## Lead 관리 라이프사이클

- Lead 캡처 → Lead 스코어링(영업 준비 여부 식별) → Lead 우선순위 지정·적절한 영업 담당자에게 라우팅 → 자격 있는 Lead를 영업 Opportunity로 전환 → 아직 구매 준비가 안 된 Lead 육성 → Lead 참여 진행 평가.

## Lead Conversion(리드 전환)

- Lead Conversion은 영업 프로세스의 첫 단계이자 CRM 애플리케이션의 핵심 구성 요소입니다.
- 자격 있는 Lead의 정보를 Account, Contact, Opportunity로 전환할 수 있습니다.
- 3개의 전환 레코드 생성: Account, Contact(표준 오브젝트), Opportunity.
- Opportunity의 마감 데이터는 Lead 전환 시 계산됩니다. Opportunity가 마감되면 마감 데이터가 자동으로 마지막 날과 회계 분기로 변환됩니다.

**Lead 매핑:**

커스텀 필드를 Account의 커스텀 필드에 매핑하려면 새 필드를 생성합니다.
