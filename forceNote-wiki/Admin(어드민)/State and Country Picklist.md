---
tags: [admin, metadata-api, metadata-types, address-settings, state-country-picklist, picklist, country, state, v67]
source: api_meta.pdf (Metadata API Developer Guide, v67.0 Summer '26 — AddressSettings) · help.salesforce.com Enable and Disable State and Country/Territory Picklists (admin_state_country_picklist_enable / _scan_metadata / _convert_data, Tier 2)
created: 2026-06-19
aliases: [State and Country Picklist, AddressSettings, 국가 주 피클리스트, 주소 설정, country picklist, state picklist, Address.settings, Settings Address, countriesAndStates, isoCode, integrationValue, 국가 영토 피클리스트, 주 도 피클리스트, State and Country/Territory Picklists]
---

# State and Country Picklist

> `AddressSettings` 메타데이터 타입은 country/territory·state 피클리스트를 구성한다. 텍스트 기반 주소 값을 표준 피클리스트 값으로 변환하기 위해 사용. 단일 파일 `Address.settings`(settings 폴더)에 저장되며, Metadata API로 기존 값을 **편집할 수 있지만 신규 생성·삭제는 불가**.

---

## AddressSettings 정의

`AddressSettings`는 조직의 country/territory·state 피클리스트 데이터를 구성하는 메타데이터 컴포넌트 타입이다. 텍스트 기반 값을 표준 피클리스트 값으로 변환하려면 Setup에서 Quick Find 박스에 **State and Country/Territory Picklists**를 입력하고 해당 항목을 선택한다.

| 항목 | 값 |
|---|---|
| 부모 타입 | `Metadata` 메타데이터 타입을 확장(extends)하며 `fullName` 필드를 상속 |
| 매니페스트 접근명 | 조직 settings 메타데이터 타입은 모두 `Settings` 이름으로 접근 (package manifest) |
| 선언적 파일 | `Address.settings` (단일 파일) — settings 디렉터리에 저장 |
| 파일 특성 | `.settings` 파일은 다른 named 컴포넌트와 달리 **settings 컴포넌트당 settings 파일이 하나뿐**이다 |
| 버전 | API 버전 **27.0 이상** |
| Salesforce CLI | 배포·검색 시 메타데이터 타입 `Settings:Address` 사용 |

---

## 하위 타입 — CountriesAndStates

`CountriesAndStates`는 피클리스트의 유효한 state·country/territory 정의를 표현하는 복합(complex) 메타데이터 타입이다.

> [!note] **편집 가능, 생성·삭제 불가**
> Metadata API를 사용해 state·country/territory 피클리스트의 **기존** state, country, territory를 **편집할 수 있다.** 그러나 Metadata API로 새 state, country, territory를 **생성하거나 삭제할 수는 없다.**

| 필드 | 필드 타입 | 설명 |
|---|---|---|
| `countries` | `Country[]` | 피클리스트에서 사용 가능한 country·territory 목록 |

---

## 하위 타입 — Country (8필드)

피클리스트의 country/territory 정의를 제공한다.

| 필드 | 필드 타입 | 설명 |
|---|---|---|
| `active` | `boolean` | 값이 API에서 사용 가능한지 결정. **중요:** 조직에서 state·country/territory 피클리스트를 활성화한 후에는 `active` 상태를 `false`로 설정할 수 없다. |
| `integrationValue` | `string` | state 또는 country/territory 코드에 연결된 커스터마이즈 가능한 텍스트 값. 표준 state·country·territory의 integration value는 기본적으로 전체 ISO 표준 명칭이다. integration value는 커스텀 필드·오브젝트의 API 이름과 유사하게 작동한다. 피클리스트 활성화 전에 integration value를 구성하면, 활성화 전에 설정한 integration이 계속 작동한다. **중요:** 조직에서 피클리스트를 활성화하기 전에 integration value를 지정하지 않으면 레코드는 Salesforce가 제공하는 기본값을 사용한다. 나중에 integration value를 변경하면, 그 시점 이후 생성·업데이트되는 레코드는 편집된 값을 사용한다. |
| `isoCode` | `string` | `retrieve()` 호출을 실행하면 ISO 표준 코드가 이 필드를 채운다. 이 필드는 **API에서 읽기 전용**이지만 Setup에서 label은 편집할 수 있다. 표준 state·country·territory의 `isoCode`는 편집할 수 없다. |
| `label` | `string` | 사용자가 Salesforce 피클리스트에서 보는 값. 이 필드는 **API에서 읽기 전용**이지만 Setup에서 label을 편집할 수 있다. |
| `orgDefault` | `boolean` | Salesforce 조직에서 새 레코드의 기본값으로 country 또는 territory를 설정한다. |
| `standard` | `boolean` | 표준 state·country는 Salesforce에 포함되어 제공되는 값이다. `standard` 속성은 편집할 수 없다. |
| `states` | `State[]` | country 또는 territory에 속한 state 또는 province |
| `visible` | `boolean` | state, country, territory를 Salesforce 사용자에게 표시한다. visible한 state, country, territory는 반드시 `active`여야 한다. |

---

## 하위 타입 — State (6필드)

피클리스트의 state 정의를 제공한다. (`Country`의 부분집합 — `orgDefault`·`states` 없음)

| 필드 | 필드 타입 | 설명 |
|---|---|---|
| `active` | `boolean` | 값이 API에서 사용 가능한지 결정. **중요:** 조직에서 state·country/territory 피클리스트를 활성화한 후에는 `active` 상태를 `false`로 설정할 수 없다. |
| `integrationValue` | `string` | state 또는 country/territory 코드에 연결된 커스터마이즈 가능한 텍스트 값. 표준 값의 integration value는 기본적으로 전체 ISO 표준 명칭이다. 피클리스트 활성화 전 integration value 구성·변경 동작은 `Country`와 동일하다. |
| `isoCode` | `string` | `retrieve()` 호출 시 ISO 표준 코드가 이 필드를 채운다. **API에서 읽기 전용**이지만 Setup에서 label을 편집할 수 있다. |
| `label` | `string` | 사용자가 Salesforce 피클리스트에서 보는 값. **API에서 읽기 전용**이지만 Setup에서 label을 편집할 수 있다. |
| `standard` | `boolean` | 표준 state·country는 Salesforce에 포함되어 제공되는 값이다. `standard` 속성은 편집할 수 없다. |
| `visible` | `boolean` | state, country, territory를 Salesforce 사용자에게 표시한다. visible한 값은 반드시 `active`여야 한다. |

---

## 선언적 메타데이터 샘플 정의

아래는 미국과 캐나다의 state·country 피클리스트를 구성하고, Greenland를 **API에서만** 사용 가능하게 만드는 샘플 XML이다. 이 예제는 **API 버전 66.0에서 지원**된다. (PDF 원문 발췌)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<AddressSettings xmlns="http://soap.sforce.com/2006/04/metadata">
<countriesAndStates>
<countries>
<country>
<active>true</active>
<integrationValue>United States</integrationValue>
<isoCode>US</isoCode>
<label>United States</label>
<orgDefault>true</orgDefault>
<standard>true</standard>
<states>
<state>
<active>true</active>
<integrationValue>Alabama</integrationValue>
<isoCode>AL</isoCode>
<label>Alabama</label>
<standard>true</standard>
<visible>true</visible>
</state>
<state>
<active>true</active>
<integrationValue>Alaska</integrationValue>
<isoCode>AK</isoCode>
<label>Alaska</label>
<standard>true</standard>
<visible>true</visible>
</state>
</states>
<visible>true</visible>
</country>
<country>
<active>true</active>
<integrationValue>Canada</integrationValue>
<isoCode>CA</isoCode>
<label>Canada</label>
<orgDefault>false</orgDefault>
<states>
<state>
<active>true</active>
<integrationValue>Alberta</integrationValue>
<isoCode>AB</isoCode>
<label>Alberta</label>
<standard>true</standard>
<visible>true</visible>
</state>
<state>
<active>true</active>
<integrationValue>British Columbia</integrationValue>
<isoCode>BC</isoCode>
<label>British Columbia</label>
<standard>true</standard>
<visible>true</visible>
</state>
</states>
<visible>true</visible>
</country>
<country>
<active>true</active>
<integrationValue>Greenland</integrationValue>
<isoCode>GL</isoCode>
<label>Greenland</label>
<standard>true</standard>
<visible>false</visible>
</country>
</countries>
</countriesAndStates>
</AddressSettings>
```

- US (`orgDefault=true`, `visible=true`) → 하위 state AL·AK
- Canada (`orgDefault=false`, `visible=true`) → 하위 state AB·BC
- Greenland → `visible=false`로 **API에서만** 사용 가능 (사용자에게 비표시)

---

## 매니페스트에서의 Wildcard 지원

package.xml 매니페스트 파일에서 wildcard 문자 `*`(asterisk)는 **feature settings 메타데이터 타입에는 적용되지 않는다.** wildcard는 **모든 settings를 검색(retrieve)할 때만 적용**되며, 개별 setting에는 적용되지 않는다. 자세한 내용은 `Settings` 및 매니페스트 파일 사용 관련 문서(Deploying and Retrieving Metadata with the Zip File)를 참조한다.

---

## ⚠️ 전제조건 — Setup 활성화 워크플로 (4단계)

위 `AddressSettings` 메타데이터 필드는 **피클리스트를 이미 활성화(enable)한 조직에서만** 실효를 가진다. 텍스트 기반 주소 값을 표준 피클리스트로 전환하려면 Setup에서 **State and Country/Territory Picklists**로 이동해 아래 4단계를 순서대로 밟는다.

| 단계 | 이름 | 하는 일 |
|---|---|---|
| 1 | **Configure** | 각 state·country/territory의 `integrationValue`(integration value)를 설정한다. 활성화 **전에** integration value를 구성하면 활성화 후에도 그 값이 계속 작동한다. (지정하지 않으면 Salesforce 기본값 사용 — 위 `Country.integrationValue` 참조) |
| 2 | **Scan** | 기존 데이터와 커스터마이제이션(워크플로 field update·이메일 템플릿·Visualforce·리포트 등)에서 state·country/territory 텍스트 값을 스캔해, 변환 시 영향받는 항목을 파악한다. |
| 3 | **Convert** | 레코드에 저장된 텍스트 값을 표준 피클리스트 값으로 **변환**한다. (Convert 없이 Enable만 하면 기존 텍스트 레코드가 표준 값에 매핑되지 않는다.) |
| 4 | **Enable** | 피클리스트를 사용자에게 노출한다. 활성화 후에는 `active` 상태를 `false`로 되돌릴 수 없다(위 `active` 필드의 **중요** 주석과 동일). |

> [!warning] **Disable은 사실상 비가역**
> 피클리스트 활성화 후 state·country/territory 값이 저장된 레코드가 있는 상태에서 **Disable**하면, 그 값에 의존하던 커스터마이제이션 — **워크플로 field update·이메일 템플릿·Visualforce 페이지·리포트의 컬럼/필터** — 이 무효화된다. 데이터·커스터마이제이션 손실을 되돌릴 수 없으므로, 프로덕션 조직에서는 활성화를 사실상 비가역 결정으로 취급한다.

## 관련 노트

- [[Custom Address Fields]] — `Address` 타입 커스텀 필드는 state·country 주소 필드에 이 피클리스트를 사용 (활성화 전 구성 필요)
- [[Compound Fields]] — 표준 `Address` compound 필드와 그 컴포넌트(StateCode·CountryCode)
- [[Metadata Types — Integration & Platform]] — 동일 `api_meta.pdf` 기반 Settings 계열 메타데이터 타입
- [[Metadata API File-Based 호출]] — `Settings:Address`를 deploy·retrieve하는 package.xml·파일 기반 호출
