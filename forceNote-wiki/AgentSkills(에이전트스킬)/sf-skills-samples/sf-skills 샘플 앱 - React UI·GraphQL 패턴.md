---
tags: [agent-skill, sf-skills, samples, react, ui-bundle, graphql, frontend]
source: forcedotcom/sf-skills (samples/ui-bundle-template-app-react-sample-b2e/, 공식 Salesforce) | multiframework-recipes/force-app/main/react-recipes/uiBundles/reactRecipes/src/recipes/ (React Recipes — CRUD·alias·cursor·sdk.fetch 실전 예시)
created: 2026-06-27
aliases: [샘플 앱 React UI, UI Bundle React 구조, GraphQL 데이터 접근, Salesforce GraphQL 쿼리, tsx 컴포넌트 구조, ui-bundle frontend, sdk.fetch, DataSDK fetch, UI API REST, Connect REST React, Apex REST React, GraphQL Create Delete 뮤테이션, RecordDeleteInput, GraphQL alias 멀티오브젝트, 커서 페이지네이션, Relay pagination React]
---

# sf-skills 샘플 앱 — React UI·GraphQL 패턴

> `sf-skills`의 `ui-bundle-template-app-react-sample-b2e`(Property Management App)를 정본으로, Salesforce **UI Bundle** 안에 들어가는 Vite + React + TypeScript SPA가 어떻게 구조화되고 조직 데이터를 **GraphQL(Data SDK)** 로 조회하는지 정리한 노트.

> 이 노트는 React/UI Bundle 프론트엔드 **앱 구조와 GraphQL 데이터 접근 패턴**에 한정한다. 같은 샘플의 Apex·sObject(데이터 모델)는 별도 노트가 소관이다. UI Bundle을 생성·배포하는 스킬 자체의 동작은 `[[experience-ui-bundle-frontend-generate]]`·`[[experience-ui-bundle-salesforce-data-access]]` 참조.

---

## UI Bundle 구조 (force-app 내 React 앱 레이아웃)

이 샘플은 **SFDX 프로젝트**이고, React 앱은 메타데이터의 한 종류인 **UI Bundle**로 패키징된다. 앱 코드는 `objects/`·`classes/`와 형제 위치인 `uiBundles/<appName>/`에 통째로 들어간다.

```
force-app/main/default/
├── objects/          # 커스텀 오브젝트·필드 (Property__c, Tenant__c, Lease__c ...)
├── classes/          # Apex (선택)
├── permissionsets/
├── cspTrustedSites/  # 외부 도메인 허용 목록 (앱이 호출하는 도메인마다 1개)
├── applications/
└── uiBundles/
    └── propertymanagementapp/        ← React UI Bundle (주 작업 공간)
        ├── propertymanagementapp.uibundle-meta.xml   # 배포 디스크립터
        ├── ui-bundle.json            # 런타임 설정 (outputDir, routing)
        ├── index.html
        ├── package.json              # UI Bundle 전용 (루트 package.json과 별개)
        ├── vite.config.ts / tsconfig.json
        ├── vitest.config.ts / playwright.config.ts
        ├── codegen.yml               # GraphQL → TS 타입 생성 설정
        └── src/                      # 모든 앱 코드
```

배포 디스크립터(`propertymanagementapp.uibundle-meta.xml`)는 다음을 선언한다 — 앱은 `CustomApplication`을 타깃으로 한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UIBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>propertymanagementapp</masterLabel>
    <description>A Salesforce UI Bundle.</description>
    <isActive>true</isActive>
    <version>1</version>
    <target>CustomApplication</target>
</UIBundle>
```

런타임 설정(`ui-bundle.json`)은 SPA fallback 라우팅을 지정한다.

```json
{
  "outputDir": "dist",
  "routing": {
    "trailingSlash": "never",
    "fallback": "index.html"
  }
}
```

### src/ 내부 레이아웃

앱 코드는 전부 `src/` 안에 있고, AGENT.md가 명시한 역할 분리를 따른다.

```
src/
├── app.tsx              # 엔트리 — BrowserRouter 생성만 (UI는 추가하지 않음)
├── appLayout.tsx        # 셸 레이아웃 (header, nav, <Outlet/>, footer)
├── routes.tsx           # 앱 전체의 단일 라우트 레지스트리
├── navigationMenu.tsx
├── router-utils.tsx
├── api/                 # GraphQL 오퍼레이션(.graphql), client, 데이터 서비스
├── components/
│   ├── ui/              # shadcn 스타일 프리미티브 (button, card, input ... 25개)
│   ├── layout/          # PageHeader, PageContainer, FilterRow ...
│   └── <feature>/       # properties/, maintenanceRequests/ ... 기능별 컴포넌트
├── features/            # 기능 모듈 (object-search: 필터·정렬·페이지네이션)
├── hooks/               # 커스텀 훅 (useAsyncData)
├── lib/                 # utils, routeConfig, constants, filterUtils
├── pages/              # 라우트당 1개 페이지 컴포넌트 (default export)
├── styles/             # Tailwind global.css
└── types/
```

핵심 규약 (AGENT.md):

- **`app.tsx`** 는 `createBrowserRouter`만 만든다. 여기에 UI를 추가하지 않는다.
- **`routes.tsx`** 는 유일한 라우트 정의 장소. 모든 페이지는 layout 라우트의 자식이고 catch-all `path: '*'` 은 항상 마지막.
- 페이지 추가는 `routes.tsx`에 라우트 + 페이지 컴포넌트만 만들면 된다 — `appLayout.tsx`·`app.tsx`는 건드리지 않는다.
- **경로 별칭** `@/*` → `src/*`. 모든 import에 사용.
- React 앱은 플랫폼 모듈(`lightning/*`, `@wire`, LWC API)을 **import 하지 않는다**.

엔트리(`app.tsx`)는 Salesforce가 주입하는 `SFDC_ENV.basePath`로 라우터 basename을 정규화한다.

```tsx
import { createBrowserRouter, RouterProvider } from 'react-router';
import { routes } from '@/routes';
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles/global.css';

// 후행 슬래시 제거 — /lwr/application/ai/c-app 같은 URL과 매칭되도록 정규화
const rawBasePath = (globalThis as any).SFDC_ENV?.basePath;
const basename =
  typeof rawBasePath === 'string' ? rawBasePath.replace(/\/+$/, '') : undefined;
const router = createBrowserRouter(routes, { basename });

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
```

라우트 레지스트리(`routes.tsx`)는 단일 layout 라우트 아래 페이지를 트리로 둔다. 네비게이션 노출 여부는 라우트의 `handle.showInNavigation`로 구동된다 (verbatim 발췌).

```tsx
export const routes: RouteObject[] = [
  {
    path: "/",
    element: <AppLayout />,
    children: [
      { index: true, element: <Home />, handle: { showInNavigation: true, label: "Home" } },
      { path: '*', element: <NotFound /> },
      {
        path: "maintenance",
        children: [
          { index: true, element: <Navigate to={PATHS.MAINTENANCE_REQUESTS} replace /> },
          { path: "requests", element: <MaintenanceRequestSearch />, handle: { showInNavigation: true, label: "Maintenance Requests" } },
          { path: "workers", element: <MaintenanceWorkerSearch />, handle: { showInNavigation: true, label: "Maintenance Workers" } }
        ]
      },
      { path: "properties", element: <PropertySearch />, handle: { showInNavigation: true, label: "Properties" } },
      { path: "applications", element: <ApplicationSearch />, handle: { showInNavigation: true, label: "Applications" } }
    ]
  }
];
```

---

## React 컴포넌트 구성 (대표 컴포넌트 + 조직 패턴)

컴포넌트는 3계층으로 나뉜다.

| 계층 | 위치 | 예 | 역할 |
|---|---|---|---|
| **UI 프리미티브** | `components/ui/` | button, card, input, skeleton ... (25개) | shadcn/ui 스타일. raw HTML 대신 항상 이걸 쓴다 |
| **레이아웃** | `components/layout/` | PageHeader, PageContainer, FilterRow | 페이지 셸 |
| **기능 컴포넌트** | `components/<feature>/` | properties/PropertyCard, PropertyDetailsModal | 도메인 표현 |

규약: Tailwind만 사용(인라인 `style={{}}` 금지), 조건부 클래스는 `@/lib/utils`의 `cn()`, 아이콘은 Lucide React, 모든 컴포넌트는 `className?: string` prop을 받고 공유 상태는 `src/hooks/`의 커스텀 훅으로 추출, `any` 금지.

**페이지 컴포넌트 패턴** (`pages/PropertySearch.tsx`): 페이지는 (1) 필터/정렬 설정을 선언하고 (2) `useObjectSearchParams`로 URL ↔ GraphQL 변수를 동기화하며 (3) `useAsyncData`로 데이터 서비스를 호출하고 (4) loading/error/empty/grid 상태를 분기 렌더한다.

```tsx
export default function PropertySearch() {
	const [selectedProperty, setSelectedProperty] = useState<PropertySearchNode | null>(null);

	const { data: statusOptions } = useAsyncData(fetchDistinctPropertyStatus, []);
	const { data: typeOptions } = useAsyncData(fetchDistinctPropertyType, []);

	const { filters, query, pagination, resetAll } = useObjectSearchParams<
		Property__C_Filter,
		Property__C_OrderBy
	>(FILTER_CONFIGS, PROPERTY_SORT_CONFIGS, PAGINATION_CONFIG);

	const { data, loading, error } = useAsyncData(
		() =>
			searchProperties({
				where: query.where,
				orderBy: query.orderBy,
				first: pagination.pageSize,
				after: pagination.afterCursor,
			}),
		[query.where, query.orderBy, pagination.pageSize, pagination.afterCursor],
	);
	// ... loading && <Skeleton/> / error && <ErrorState/> / empty / <Grid/>
}
```

**대표 표현 컴포넌트** (`components/properties/PropertyCard.tsx`, verbatim) — GraphQL 노드의 `field.value`/`field.displayValue` 형태를 옵셔널 체이닝으로 안전하게 풀어 표현한다.

```tsx
import React, { useState } from "react";
import { Home } from "lucide-react";
import type { PropertySearchNode } from "../../api/properties/propertySearchService";

interface PropertyCardProps {
	property: PropertySearchNode;
	onClick?: (property: PropertySearchNode) => void;
}

export const PropertyCard: React.FC<PropertyCardProps> = ({ property, onClick }) => {
	const [imageError, setImageError] = useState(false);

	const handleClick = () => {
		if (onClick) onClick(property);
	};

	const name = property.Name?.value || "Unnamed Property";
	const address = property.Address__c?.value || "Address not available";
	const heroImage = property.Hero_Image__c?.value;
	const description = property.Description__c?.value;
	const createdYear = property.CreatedDate?.value
		? new Date(property.CreatedDate.value).getFullYear().toString()
		: undefined;

	const truncatedDescription = description
		? description.length > 150 ? description.substring(0, 150) + "..." : description
		: "No description available.";

	return (
		<div
			className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow cursor-pointer"
			onClick={handleClick}
		>
			<div className="relative h-48 bg-gray-200">
				{heroImage && !imageError ? (
					<img src={heroImage} alt={name} className="w-full h-full object-cover"
						onError={() => setImageError(true)} />
				) : (
					<div className="w-full h-full flex items-center justify-center text-gray-400">
						<Home size={64} strokeWidth={1.5} />
					</div>
				)}
			</div>
			<div className="p-6">
				<h3 className="text-xl font-bold text-gray-900 mb-2">{name}</h3>
				<p className="text-sm text-gray-600 mb-4">{address}</p>
				<p className="text-sm text-gray-700 mb-4 line-clamp-3">{truncatedDescription}</p>
				{createdYear && <p className="text-sm text-gray-500 font-medium">Since {createdYear}</p>}
			</div>
		</div>
	);
};
```

**데이터 페칭 훅** (`hooks/useAsyncData.ts`): 라이브러리(React Query 등) 없이 mount + deps 변경 시 fetcher를 실행하고 loading/error/data를 반환하는 경량 훅. 캐시하지 않으며, cleanup 플래그로 unmount/순서 역전된 응답에 의한 stale 업데이트를 막는다.

```ts
export function useAsyncData<T>(
  fetcher: () => Promise<T>,
  deps: React.DependencyList
): UseAsyncDataResult<T> {
  // data / loading / error 상태 + generation 카운터
  // deps 변경을 렌더 중 감지 → generation 증가 → effect 재실행
  // cancelled 플래그로 unmount 후 setState 방지
}
```

---

## GraphQL 데이터 접근 (대표 쿼리 + Salesforce 데이터 모델 연결)

### 레이어 구조

```
.graphql 파일 (오퍼레이션)  →  codegen  →  graphql-operations-types.ts (TS 타입)
        │                                              │
        └── ?raw 로 import ──→ 도메인 서비스(api/<entity>/*.ts) ──→ executeGraphQL() ──→ createDataSDK().graphql.query
```

- **모든 데이터 접근은 Data SDK** (`@salesforce/platform-sdk`)의 `createDataSDK()`를 거친다. `fetch()`/`axios` 직접 호출 금지.
- **레코드 연산은 GraphQL 우선** (`sdk.graphql`). `uiapi { }` 네임스페이스로 쿼리/뮤테이션. GraphQL이 못 다루는 경우에만 `sdk.fetch`(UI API REST, Apex REST, Connect REST, Einstein LLM).
- 차단 API: Enterprise REST `/query`(SOQL), `@AuraEnabled` Apex, Chatter API.

`api/graphqlClient.ts` 의 얇은 클라이언트 — 중앙 에러 처리를 담당한다 (HTTP 200이라도 `errors` 배열을 반드시 검사).

```ts
import { createDataSDK } from '@salesforce/platform-sdk';

export async function executeGraphQL<TData, TVariables>(
  query: string,
  variables?: TVariables
): Promise<TData> {
  const data = await createDataSDK();
  const result = await data.graphql!.query<TData, TVariables>({
    query: query,
    variables: variables,
  });

  if (result.errors?.length) {
    const msg = result.errors.map(e => e.message).join('; ');
    throw new Error(`GraphQL Error: ${msg}`);
  }
  if (result.data == null) {
    throw new Error('GraphQL response data is null');
  }
  return result.data;
}
```

### 대표 쿼리 — `uiapi.query` 패턴 (verbatim)

`api/properties/query/searchProperties.graphql`. 모든 레코드 쿼리는 `uiapi { query { <Object__c>(first, after, where, orderBy) { edges { node { ... } } pageInfo {...} totalCount } } }` 형태이고, **각 필드는 `{ value displayValue }` 스칼라 래퍼**로 온다 (UI API 필드 표현).

```graphql
query SearchProperties(
	$first: Int
	$after: String
	$where: Property__c_Filter
	$orderBy: Property__c_OrderBy
) {
	uiapi {
		query {
			Property__c(first: $first, after: $after, where: $where, orderBy: $orderBy) {
				edges {
					node {
						Id
						Name { value displayValue }
						Address__c { value displayValue }
						Status__c { value displayValue }
						Type__c { value displayValue }
						Monthly_Rent__c { value displayValue }
						Bedrooms__c { value displayValue }
						# ... Bathrooms__c, Description__c, Hero_Image__c, Sq_Ft__c,
						#     Year_Built__c, Deposit__c, Parking__c, Pet_Friendly__c,
						#     Available_Date__c, Lease_Term__c, Features__c, Utilities__c,
						#     Tour_URL__c, CreatedDate (모두 { value displayValue })
					}
				}
				pageInfo { hasNextPage hasPreviousPage endCursor startCursor }
				totalCount
			}
		}
	}
}
```

> 위 블록의 `# ...` 주석부는 가독성을 위한 축약이며, 실제 `.graphql` 파일에는 21개 필드가 모두 명시돼 있다 (각각 `{ value displayValue }`).

**관계 탐색**: 부모(parent) 관계는 `__r` suffix로 중첩한다. 예) `searchApplications.graphql`은 `Application__c`에서 `Property__r`·`User__r`를 함께 가져온다 — 이것이 데이터 모델의 lookup 관계(Application → Property, Application → User)와 직접 대응한다.

```graphql
Property__r {
	Name { value displayValue }
	Address__c { value displayValue }
}
User__r {
	Name { value displayValue }
}
```

### 뮤테이션 패턴

뮤테이션은 `uiapi { <Object__c>Update(input: $input) { Record {...} success } }` 형태. 입력은 codegen이 만든 `*UpdateInput!` 타입. FLS 내성을 위해 레코드 필드에 **`@optional` 디렉티브**를 붙인다 (필드 하나가 접근 불가여도 쿼리 전체가 실패하지 않게).

```graphql
mutation UpdateApplicationStatus($input: Application__cUpdateInput!) {
	uiapi {
		Application__cUpdate(input: $input) {
			Record {
				Id
				Status__c @optional { value }
			}
			success
		}
	}
}
```

현재 사용자 정보도 Chatter가 아니라 GraphQL로 (`getUserInfo.graphql` → `uiapi.query.User(first: 1)`, `Name @optional`).

> 아래 `### Create·Delete 뮤테이션 전체` · `### 별칭 멀티오브젝트 쿼리` · `### 커서 페이지네이션` · `## 명령형 REST 호출` 네 섹션은 같은 UI Bundle 계열의 자매 샘플 **React Recipes**(`multiframework-recipes` — `force-app/main/react-recipes/uiBundles/reactRecipes/src/recipes/`)에서 발췌한 실전 정본이다. 이 앱은 Data SDK를 `@salesforce/sdk-data`에서 import하고 `const sdk = await createDataSDK()` 후 `sdk.graphql?.<T>({query,variables})` / `sdk.fetch?.(url)`를 **명령형으로** 직접 호출한다(property 앱의 `graphqlClient.ts` 얇은 래퍼와 형태는 다르지만 동일한 Data SDK). CRUD/별칭/커서/REST 각 레시피는 대응 LWC(`lightning/uiRecordApi`·graphql wire) 매핑을 코드 상단 주석으로 명시한다.

### Create·Delete 뮤테이션 전체 (Recipes 정본)

위 `### 뮤테이션 패턴`은 Update(`<Object__c>Update` + `@optional`)만 보였다. 나머지 두 연산은 **입력 타입·중첩 위치가 서로 다르다**.

**Create** — 입력 타입은 `<Object>CreateInput!`, 필드는 오브젝트명 키(`Account`) 아래에 중첩(`CreateRecord.tsx`, verbatim).

```tsx
const CREATE_ACCOUNT = gql`
  mutation CreateAccount($input: AccountCreateInput!) {
    uiapi {
      AccountCreate(input: $input) {
        Record { Id  Name { value } }
      }
    }
  }
`;
// 호출 — 필드는 <Object> 키 아래 중첩, top-level Id 없음
const res = await sdk.graphql?.<CreateAccountResponse>({
  query: CREATE_ACCOUNT,
  variables: { input: { Account: { Name: name.trim() } } },
});
const record = res?.data.uiapi?.AccountCreate?.Record;   // { Id, Name:{value} }
```

**Delete** — 오브젝트별 타입이 아니라 **제네릭 `RecordDeleteInput!`**, 입력은 `{ Id }`뿐, 응답은 삭제된 `Id`만 반환(`Record` 없음)(`DeleteRecord.tsx`, verbatim).

```tsx
// Note: 입력 타입은 RecordDeleteInput (제네릭) — AccountDeleteInput 아님
const DELETE_MUTATION = gql`
  mutation DeleteAccount($input: RecordDeleteInput!) {
    uiapi {
      AccountDelete(input: $input) { Id }
    }
  }
`;
const res = await sdk.graphql?.<DeleteResponse>({
  query: DELETE_MUTATION,
  variables: { input: { Id: id } },
});
setAccounts(prev => prev.filter(a => a.Id !== id));   // 서버 재조회 없이 로컬 state에서 행 제거
```

**입력 형태 3종 대조** (셀별 매핑 — 이 형태 차이가 흔한 실수 지점):

| 연산 | 입력 타입 | `Id` 위치 | 필드 위치 |
|---|---|---|---|
| Create | `<Object>CreateInput!` | 없음 | `input.<Object>.<Field>` (예 `input.Account.Name`) |
| Update | `<Object>UpdateInput!` | **top-level** `input.Id` | `input.<Object>.<Field>` (예 `input.Account.Name`) |
| Delete | `RecordDeleteInput!` (제네릭) | **top-level** `input.Id` | 없음 |

Update 호출 verbatim(`UpdateRecord.tsx`) — `Id`는 `Account` 안이 아니라 최상위다.

```tsx
variables: { input: { Id: accountId, Account: { Name: name, Industry: industry } } }
```

**LWC `lightning/uiRecordApi` 매핑과 캐시 차이** (각 레시피 상단 주석 근거):

| Recipes (Data SDK GraphQL) | LWC 대응 | 캐시 동작 차이 |
|---|---|---|
| `AccountCreate` 뮤테이션 | `createRecord({apiName, fields})` | — |
| `AccountUpdate` 뮤테이션 | `updateRecord({fields})` | LWC: 해당 레코드를 참조하는 `@wire`가 **자동 갱신** |
| `AccountDelete` 뮤테이션 | `deleteRecord(recordId)` | LWC: `@wire` 자동 무효화 |

React 쪽은 `@wire` 자동 무효화가 **없다** → Create/Update/Delete 후 서버 응답으로 **로컬 `setState`를 수동 동기화**해야 한다(Update는 응답 Record로 patch, Delete는 `prev.filter(...)`로 행 제거).

**서버측 필수필드 누락 에러의 위치**(`ServerErrorHandling.tsx`) — 필수 `LastName`을 뺀 `ContactCreate`를 보내면 `REQUIRED_FIELD_MISSING`은 **field-level 검증이 아니라 top-level `result.errors[]`** 로 온다. HTTP는 여전히 성공일 수 있으므로 `result.errors?.length`를 반드시 검사한다.

```tsx
// LastName을 일부러 생략 → 서버가 top-level GraphQL 에러 반환
const result = await sdk.graphql?.<ContactCreateResult>({
  query: CREATE_CONTACT,
  variables: { input: { Contact: { Email: email || undefined, Phone: phone || undefined } } },
});
if (result?.errors?.length) {          // errors 는 throw 되지 않고 result.errors[] 에 담김
  setTopLevelError(result.errors.map(e => e.message).join('; '));
  return;
}
```

> LWC `createRecord()`는 반대로 promise를 **reject**하며 `error.body.message` + `error.body.output.fieldErrors`(field-level 상세)를 준다 — GraphQL의 flat `errors[]`와 형태가 다르다.

### 별칭 멀티오브젝트 쿼리 — 단일 라운드트립 (Recipes 정본)

`### 대표 쿼리`와 `[[experience-ui-bundle-salesforce-data-access]]`는 단일 오브젝트 쿼리만 다룬다. 한 요청에서 **여러 오브젝트를 GraphQL alias로 조회**하면 라운드트립을 줄일 수 있다(`AliasedMultiObjectQuery.tsx`, verbatim).

```graphql
query MultiObjectCounts {
  uiapi {
    query {
      # UIAPI 에는 COUNT() 집계가 없음 — edges.length 가 워크어라운드.
      # first: 50 캡이므로 그 이상이면 undercount 됨.
      accounts: Account(first: 50) { edges { node { Id } } }
      contacts: Contact(first: 50) { edges { node { Id } } }
    }
  }
}
```

- `accounts:` / `contacts:` **각 alias가 응답 `data.uiapi.query`의 독립 키**가 된다 → `query.accounts.edges`, `query.contacts.edges`로 따로 접근.
- **UIAPI에 `COUNT()` 집계가 없어** 카운트는 `edges.length ?? 0`으로 센다. 단 `first: 50` 캡 때문에 레코드가 50건을 넘으면 **undercount**되니 진짜 카운트가 필요하면 이 패턴을 쓰지 않는다.
- LWC 대응: 오브젝트 2개면 `@wire` 2개(또는 wrapper 반환 Apex 1개)가 필요 — alias 하나로 합치는 이 절감이 안 된다.

### 커서(Relay) 페이지네이션 — Load More 누적 (Recipes 정본)

`### 대표 쿼리`는 `pageInfo { hasNextPage endCursor }`를 스키마 형태로만 보였고 실제 페이지 이어받기는 제네릭 `searchObjects`에 위임했다. 명시적 **클라이언트 누적 루프**(`PaginatedList.tsx`, verbatim)는 다음과 같다.

```tsx
// 첫 페이지는 $after 생략(또는 null) — endCursor 를 다음 요청 $after 로 넘겨 이어받음
const QUERY = gql`
  query PaginatedContacts($after: String) {
    uiapi { query {
      Contact(first: 2, after: $after, orderBy: { Name: { order: ASC } }) {
        pageInfo { hasNextPage  endCursor }
        edges { node { Id  Name @optional { value }  Title @optional { value } } }
      }
    } }
  }
`;

async function fetchPage(after?: string | null) {
  const sdk = await createDataSDK();
  const variables = after ? { after } : {};        // 첫 페이지는 after 없이
  const result = await sdk.graphql?.<PaginatedContactsResponse>({ query: QUERY, variables });
  // ...errors 검사...
  const connection = result?.data?.uiapi?.query?.Contact;
  const nodes = (connection?.edges ?? [])
    .map(edge => edge?.node)
    .filter(Boolean)                               // UIAPI edges 는 null node 포함 가능 — 매핑 전 필터
    .map(node => ({ id: node.Id, name: node.Name?.value ?? 'Unknown', title: node.Title?.value ?? null }));
  return { contacts: nodes, hasNextPage: connection?.pageInfo?.hasNextPage ?? false,
           endCursor: connection?.pageInfo?.endCursor ?? null };
}

function loadMore() {
  if (!endCursor) return;
  fetchPage(endCursor).then(page => {
    setContacts(prev => [...prev, ...page.contacts]);   // 새 페이지를 기존 리스트에 누적
    setHasNextPage(page.hasNextPage);
    setEndCursor(page.endCursor);                        // 다음 커서로 갱신
  });
}
```

- **커서 전달**: `pageInfo.endCursor`(opaque 문자열)를 다음 요청의 `$after`로 넘긴다. 첫 페이지는 `$after` 생략.
- **누적**: `setContacts(prev => [...prev, ...page.contacts])` — 페이지를 교체하지 않고 로컬 state에 이어붙인다(Load More UX).
- **종료 판정**: `pageInfo.hasNextPage`가 `false`면 "Load More" 버튼을 숨긴다.
- LWC 대응: graphql `@wire`도 같은 커서 패턴을 쓰되 `endCursor`를 **reactive 변수**로 넘기면 adapter가 자동 재조회한다 — 여기서는 `fetchPage`를 수동 호출한다.

### 도메인 서비스 — `.graphql` → 타입드 함수

각 엔티티 폴더(`api/properties/`)는 `.graphql`을 `?raw`로 import하고 codegen 타입과 묶어 타입 안전한 함수를 노출한다. 페이지는 GraphQL을 직접 모르고 이 서비스만 호출한다.

```ts
import GET_PROPERTIES_PAGINATED from "./query/getProperties.graphql?raw";
import type { GetPropertiesQueryVariables, GetPropertiesQuery } from "../graphql-operations-types.js";
import { executeGraphQL } from "../graphqlClient.js";

export async function getProperties(first: number = 12, after?: string): Promise<PropertiesResult> {
	const variables: GetPropertiesQueryVariables = { first };
	if (after) variables.after = after;
	const response = await executeGraphQL<GetPropertiesQuery, GetPropertiesQueryVariables>(
		GET_PROPERTIES_PAGINATED, variables,
	);
	const edges = response?.uiapi?.query?.Property__c?.edges || [];
	// edge.node 만 추려 null 제거 후 반환
}
```

`propertySearchService.ts`는 한 발 더 나아가, `searchProperties.graphql`·`distinctPropertyStatus.graphql`·`distinctPropertyType.graphql`을 `features/object-search`의 제네릭 `searchObjects` / `fetchDistinctValues`에 위임한다 — 필터/정렬/페이지네이션이 모든 엔티티에서 재사용되는 구조.

> GraphQL 작성 비협상 규칙(스키마가 single source of truth, 모든 record 필드에 `@optional`, 모든 쿼리에 명시적 `first:` + `pageInfo`, SOQL 파생 실행 한도, HTTP 200 ≠ 성공)의 전체 목록과 스키마 조회 절차는 `[[experience-ui-bundle-salesforce-data-access]]` 소관. 이 노트는 샘플에 실제 구현된 형태만 보인다.

### Salesforce 데이터 모델 연결

GraphQL 쿼리의 `Property__c` / `Tenant__c` / `Lease__c` / `Application__c` 등은 `force-app/main/default/objects/`의 커스텀 오브젝트, 필드(`Monthly_Rent__c`, `Status__c` ...)는 그 `fields/` 메타데이터와 1:1로 대응한다. 즉 GraphQL 스키마는 배포된 메타데이터 + permission set 할당 후에야 커스텀 오브젝트를 노출한다. 오브젝트·필드·관계의 전모는 `[[sf-skills 샘플 앱 - 데이터 모델]]` 참조.

---

## 명령형 REST 호출 — `sdk.fetch` (GraphQL로 못 다루는 경우)

이 노트는 위에서 "GraphQL이 못 다루는 경우에만 `sdk.fetch`"라고 규칙만 명시했고 실사용을 보이지 않았다. 자매 샘플 **React Recipes**의 `salesforce-apis/` 레시피가 `sdk.fetch`의 정본이다. 세 엔드포인트 계열(Apex REST · UI API REST · Connect REST)을 모두 커버한다.

**공통 시그니처** — `createDataSDK()`로 sdk를 얻고 `sdk.fetch?.(url)`을 호출한다. 반환은 표준 `Response`류라 `res.ok` / `res.status` / `await res.json()`으로 처리한다(옵셔널 체이닝 `?.` — fetch 미지원 런타임 방어).

```ts
const sdk = await createDataSDK();
const res = await sdk.fetch?.(url);
if (!res?.ok) throw new Error(`... error: ${res?.status}`);
return (await res.json()) as T;
```

- 모든 REST 경로는 **버전 접두** `/services/data/v66.0/…`(Apex REST만 `/services/apexrest/…`)를 쓴다. 조직 API 버전이 바뀌면 이 경로 문자열을 갱신한다.
- **응답 JSON 형태 차이** — 아래처럼 엔드포인트마다 필드 래핑이 다르다.

| 엔드포인트 | 경로 | 응답 필드 형태 |
|---|---|---|
| Apex REST | `/services/apexrest/contacts?name=…` | **평문 JSON** (`{ id, name, title, ... }`) — `{ value }` 래퍼 없음 |
| Connect REST | `/services/data/v66.0/chatter/feeds/news/me/feed-elements` | **평문 JSON** (`{ elements: [{ actor, body:{text} }] }`) |
| UI API REST | `/services/data/v66.0/ui-api/list-records/{id}` | **`{ value }` 래퍼** (`fields.Name.value`) — UIAPI GraphQL과 동일 |

> UI API REST만 GraphQL과 같은 `{ value }`(+`displayValue`) 래퍼를 준다. Apex/Connect는 개발자가 반환 형태를 직접 정하는 평문 JSON이다.

**Apex REST**(`ApexRest.tsx`, verbatim) — 커스텀 `@RestResource` 엔드포인트 호출. LWC 대응은 imperative Apex import(`import { apexMethod } from '@salesforce/apex/...'`).

```ts
// Apex class: ContactsResource (@RestResource urlMapping='/contacts')
async function fetchContactsFromApex(nameFilter: string): Promise<ApexContact[]> {
  const sdk = await createDataSDK();
  const url = nameFilter
    ? `/services/apexrest/contacts?name=${encodeURIComponent(nameFilter)}`
    : '/services/apexrest/contacts';
  const res = await sdk.fetch?.(url);
  if (!res?.ok) throw new Error(`Apex REST error: ${res?.status}`);
  return (await res.json()) as ApexContact[];   // 평문 JSON — { value } 래퍼 없음
}
```

**UI API REST — 2단계 list view 탐색**(`UiApiRest.tsx`, verbatim). GraphQL이 노출하지 않는 locale-aware `displayValue`가 필요할 때 쓴다. `list-ui`로 list view를 찾아 그 `id`로 `list-records`를 조회한다.

```ts
async function fetchContactsViaUiApi(): Promise<UiApiRecord[]> {
  const sdk = await createDataSDK();
  // Step 1: Contact 의 list view 목록 조회 → AllContacts 찾기
  const listUiRes = await sdk.fetch?.('/services/data/v66.0/ui-api/list-ui/Contact');
  if (!listUiRes?.ok) throw new Error(`List UI fetch failed (${listUiRes?.status})`);
  const listUiData: ListUiResponse = await listUiRes.json();
  const allContactsList = listUiData.lists.find(l => l.apiName === 'AllContacts');
  if (!allContactsList) throw new Error('AllContacts list view not found');

  // Step 2: 그 list view 의 id 로 레코드 조회 (fields= 로 컬럼 지정)
  const listRecordsRes = await sdk.fetch?.(
    `/services/data/v66.0/ui-api/list-records/${allContactsList.id}?fields=Contact.Name,Contact.Title,Contact.Phone,Contact.Picture__c`
  );
  if (!listRecordsRes?.ok) throw new Error(`List records fetch failed (${listRecordsRes?.status})`);
  const listRecordsData: ListRecordsResponse = await listRecordsRes.json();
  return listRecordsData.records;   // records[i].fields.Name.value 형태
}
```

LWC 대응: `@wire(getListUi)` + `@wire(getListRecords)` — 같은 데이터를 **자동 캐싱**과 함께 준다(여기선 캐시 없음).

**Connect REST (Chatter)**(`ConnectApi.tsx`, verbatim) — 현재 사용자 뉴스 피드. `feed-elements` 엔드포인트, 평문 JSON.

```ts
async function fetchChatterFeed(): Promise<FeedElement[]> {
  const sdk = await createDataSDK();
  const res = await sdk.fetch?.(
    '/services/data/v66.0/chatter/feeds/news/me/feed-elements?pageSize=5'
  );
  if (!res?.ok) throw new Error(`Connect API error: ${res?.status}`);
  const data: FeedResponse = await res.json();
  return data.elements ?? [];        // { elements:[{ actor:{displayName,photo}, body:{text} }] }
}
```

> 사용자 정보의 경우 property 앱은 `users/me` 대신 GraphQL(`uiapi.query.User`)로 얻는다(위 `### 뮤테이션 패턴` 참조). Connect/Chatter 리소스는 일부만 LWC wire adapter가 있고, 나머지는 imperative Apex callout이 필요하다.

---

## 빌드·설정 (Vite/codegen/test 요지)

UI Bundle 디렉터리는 루트 SFDX `package.json`과 **별개의 `package.json`**을 가진다. 모든 dev/build/lint/test는 UI Bundle 디렉터리 안에서 실행한다 (루트에서 실행 금지).

| 스크립트 | 동작 |
|---|---|
| `npm run dev` | Vite dev 서버 (기본 :5173) |
| `npm run build` | `tsc -b && vite build` → `dist/` 생산 빌드 |
| `npm run lint` | ESLint (`@graphql-eslint` 포함) |
| `npm run test` | Vitest 유닛 테스트 |
| `npm run graphql:schema` | 조직에서 GraphQL 스키마 fetch (`schema.graphql`) |
| `npm run graphql:codegen` | 스키마+오퍼레이션 → `graphql-operations-types.ts` 타입 생성 |

주요 의존성: `@salesforce/platform-sdk`·`@salesforce/ui-bundle`(런타임), `react@19`·`react-router@7`, Tailwind v4·radix-ui·shadcn·lucide-react(UI), `@salesforce/agentforce-conversation-client`·recharts(앱 기능). dev: `@graphql-codegen/*`·`@graphql-eslint/eslint-plugin`·vitest·playwright. Node ≥22.

`vite.config.ts` 의 핵심 — Salesforce UI Bundle 플러그인 + 조건부 GraphQL codegen + `@/*` 별칭 + Vitest(jsdom, 85% 커버리지 임계).

```ts
import salesforce from '@salesforce/vite-plugin-ui-bundle';
import codegen from 'vite-plugin-graphql-codegen';

const schemaPath = resolve(__dirname, '../../../../../schema.graphql');
const schemaExists = existsSync(schemaPath);

export default defineConfig(({ mode }) => ({
  base: './',
  plugins: [
    tailwindcss(),
    react(),
    salesforce(),
    // schema 가 있을 때만 codegen 추가 (CI/스키마 미체크인 시 빌드 성공하도록 스킵)
    ...(schemaExists ? [codegen({ configFilePathOverride: resolve(__dirname, 'codegen.yml'),
        runOnStart: true, runOnBuild: true, enableWatcher: true, throwOnBuild: true })] : []),
  ],
  resolve: { alias: { '@': path.resolve(__dirname, './src'), /* @api @components ... */ } },
  // test: { environment: 'jsdom', coverage: { thresholds: { global: { lines: 85, ... } } } }
}));
```

`codegen.yml` 은 루트 `schema.graphql`(265K+ 줄, 직접 열지 말 것)과 `src/**/*.{graphql,ts,tsx}` 문서를 입력으로 `src/api/graphql-operations-types.ts`를 생성하며, Salesforce 스칼라(Currency/Percent/Picklist/DateTime ...)를 TS 타입으로 매핑한다. 메타데이터를 배포해 스키마가 바뀌면 `graphql:schema → graphql:codegen → build` 순으로 재생성한다.

---

## 관련 노트
- [[sf-skills 샘플 앱 - 개요]]
- [[sf-skills 샘플 앱 - 데이터 모델]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-salesforce-data-access]]
