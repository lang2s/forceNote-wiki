---
tags: [agent-skill, sf-skills, samples, react, ui-bundle, graphql, frontend]
source: forcedotcom/sf-skills (samples/ui-bundle-template-app-react-sample-b2e/, 공식 Salesforce)
created: 2026-06-27
aliases: [샘플 앱 React UI, UI Bundle React 구조, GraphQL 데이터 접근, Salesforce GraphQL 쿼리, tsx 컴포넌트 구조, ui-bundle frontend]
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
