# Salesforce 라이선스(License)

라이선스는 사용자에게 다양한 기능, 기능성, 특정 Salesforce 환경에 대한 접근을 부여하는 방법입니다. 다양한 유형이 있으며 각각 사용자 요구와 비즈니스 사례에 맞춰져 있습니다.

## Salesforce 라이선스 유형

- User License(사용자 라이선스)
- Feature License(기능 라이선스)
- Permission Set License(권한 집합 라이선스)

## User License

Salesforce 환경 내에서 사용자가 갖는 기준 접근 수준으로, 어떤 Salesforce 제품·기능을 사용할 수 있는지 결정합니다.

- **Salesforce License:** Sales Cloud, Service Cloud 기능(Lead, Account, Case, Campaign 등)을 포함한 전체 CRM 플랫폼 접근.
- **Salesforce Platform License:** Salesforce 플랫폼의 커스텀 앱 접근. 단, Lead·Opportunity·Case 같은 표준 CRM 기능 제외.
- **Chatter Free/Chatter External:** Chatter 접근 가능, 다른 CRM 기능 제한.
- **Force.com - One App License:** 플랫폼에서 개발한 단일 커스텀 앱 접근(핵심 기능 제한).
- **Service Cloud License:** Case, 고객 서비스, 지원 작업을 처리하는 사용자용 Service Cloud 접근.

## Feature License

사용자 라이선스에 포함되지 않은 추가 기능을 부여하는 애드온입니다.

- **Knowledge User License:** Salesforce Knowledge에서 지식 문서 관리·생성.
- **Marketing User License:** 캠페인과 고급 마케팅 기능 관리.
- **CRM Content User License:** Salesforce CRM Content로 비즈니스 콘텐츠 관리·공유.

## Permission Set License

기본 라이선스를 업그레이드·변경하지 않고 기존 라이선스 위에 추가 권한을 할당합니다.

- **Einstein Analytics:** Einstein Analytics 플랫폼(BI·분석) 접근.
- **Identity Connect:** SSO와 ID 관리를 가능하게 하는 Identity 기능 접근.
- **CPQ (Configure Price Quote):** Salesforce CPQ 도구 접근.

## 비교

| 항목 | User License | Feature License | Permission Set License |
|---|---|---|---|
| 정의 | Salesforce 기능·앱에 기준 접근 부여 | User License에 없는 특정 기능 접근 부여 | User License 변경 없이 추가 권한 할당 |
| 주 목적 | 사용자의 핵심 역량·접근 수준 정의 | 애드온 기능 제공 | 기존 라이선스 위에 추가 권한 부여 |
| 할당 대상 | 모든 활성 사용자에게 필수 | 추가 기능이 필요한 사용자 | 권한 집합을 통해 사용자별로 유연하게 |
| 접근 범위 | 핵심 CRM·플랫폼 기반 광범위 접근 | 특정 기능 접근 | 기능별 점진적 접근 추가 |
| 비용 영향 | 높음(전체 접근) | 중간(기능에 따라) | 낮음(기존에 특정 기능 추가) |
| 결합 | Feature·Permission Set와 결합 가능 | User License와 결합 필요 | 항상 User License 위에 적용(독립 불가) |

**핵심 팁:** User License는 기본 접근(필수), Feature License는 그 위의 특정 기능 애드온, Permission Set License는 기본 라이선스 변경 없이 추가 기능·권한 부여.
