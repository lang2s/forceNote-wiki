---
tags: [lwc, reference, salesforce-modules, apex, schema, label, resource-url, user, permissions]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Reference > @salesforce Modules; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-salesforce-modules.html
created: 2026-07-04
aliases: [@salesforce modules, salesforce modules, @salesforce/apex, @salesforce/schema, @salesforce/label, @salesforce/resourceUrl, @salesforce/contentAssetUrl, @salesforce/i18n, @salesforce/user, @salesforce/userPermission, @salesforce/customPermission, @salesforce/client/formFactor, @salesforce/community, @salesforce/site, @salesforce/messageChannel, getSObjectValue, refreshApex, formFactor]
---

# @salesforce Modules 레퍼런스

> LWC에 런타임 기능(Apex 호출·스키마 참조·라벨·정적 리소스·사용자/권한 정보 등)을 추가하는 `@salesforce`-스코프 모듈 19종의 import 문법과 파라미터 전수.

---

## 개요

- `@salesforce`로 스코프된 모듈은 **런타임에 LWC에 기능을 추가**한다.
- `@salesforce` 없이 import하는 모듈(예: `lightning/uiRecordApi`)은 변하지 않는 **범용 리소스**다.
- 일부 모듈은 **고정 식별자 세트**를 노출한다. 예: `@salesforce/i18n` → `@salesforce/i18n/dir`, `@salesforce/i18n/lang`.
- 일부 모듈은 **동적 식별자 세트**를 노출한다. 즉 org 메타데이터로 정의된다. 예: `@salesforce/schema`.
- **Namespace:** 조직이 기본 네임스페이스(`c`)를 쓰면 `namespace`를 **생략**한다. 아니면 지정한다.

---

## 대표 import 예시

```javascript
// 실제 문법 — @salesforce 모듈 대표 import 예시 (developer.salesforce.com 발췌)

// Apex 메서드 (기본 네임스페이스이므로 Namespace 생략)
import getContactList from '@salesforce/apex/ContactController.getContactList';

// 스키마 — 오브젝트·필드 참조
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';

// 커스텀 라벨 (namespace.labelName 형식)
import greeting from '@salesforce/label/c.greeting';

// 정적 리소스
import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';

// 현재 사용자 ID
import userId from '@salesforce/user/Id';
```

---

## 모듈 전수 (19종)

| 모듈 | import 문법 | 파라미터 / 값 | 비고 |
|---|---|---|---|
| `@salesforce/apex` | `import apexMethodName from '@salesforce/apex/Namespace.Classname.apexMethodReference';` | `apexMethodName`·`apexMethodReference`·`Classname`·`Namespace`(기본 네임스페이스면 생략)·`apexMethodParams` | @wire 또는 imperative 호출 |
| `getSObjectValue` | `import { getSObjectValue } from '@salesforce/apex';` | `sObject`·`fieldApiName` | Apex 반환 sObject의 필드 값 |
| `refreshApex` | `import { refreshApex } from '@salesforce/apex';` | `{valueProvisionedByApexWireService}` | ⚠️ 비-Apex는 deprecated |
| `@salesforce/apexContinuation` | `import apexMethodName from '@salesforce/apexContinuation/Namespace.Classname.apexMethodReference';` | `apexMethodName`·`apexMethodReference`·`Classname`·`Namespace`(같은 네임스페이스면 생략) | 장시간 콜아웃(Continuations) |
| `@salesforce/client/formFactor` | `import formFactorPropertyName from '@salesforce/client/formFactor';` | 값: `Large`·`Medium`·`Small` | 하드웨어 폼 팩터 |
| `@salesforce/community/Id` | `import communityId from '@salesforce/community/Id';` | — | 현재 Experience Builder 사이트 network ID |
| `@salesforce/community/basePath` | `import basePath from '@salesforce/community/basePath';` | — | 사이트 base URL |
| `@salesforce/contentAssetUrl` | `import myContentAsset from '@salesforce/contentAssetUrl/contentAssetReference';` | `contentAssetReference`·`namespace`(managed package면) | 콘텐츠 에셋 파일 |
| `@salesforce/i18n` | `import internationalizationPropertyName from '@salesforce/i18n/internationalizationProperty';` | 예: `dir`·`lang` (고정 세트) | 국제화 프로퍼티 |
| `@salesforce/label` | `import labelName from '@salesforce/label/labelReference';` | `labelReference` 형식 `namespace.labelName` | 커스텀 라벨 |
| `@salesforce/messageChannel` | `import channelName from '@salesforce/messageChannel/channelReference';` | `channelReference`·`namespace`(managed package면) | Lightning Message Service 채널 |
| `@salesforce/resourceUrl` | `import myResource from '@salesforce/resourceUrl/resourceReference';` | `resourceReference`·`namespace`(managed package면) | 정적 리소스 |
| `@salesforce/schema` | `import objectName from '@salesforce/schema/objectReference';` | `objectReference`·`fieldReference`·`namespace`(managed package면) | 오브젝트·필드 참조 (동적 세트) |
| `@salesforce/site/Id` | `import siteId from '@salesforce/site/Id';` | — | 현재 Experience Builder 사이트 ID |
| `@salesforce/site/activeLanguages` | `import activeLanguages from '@salesforce/site/activeLanguages';` | — | 사이트 활성 언어 목록 |
| `@salesforce/user/Id` | `import userId from '@salesforce/user/Id';` | — | 현재 사용자 ID |
| `@salesforce/user/isGuest` | `import isGuestUser from '@salesforce/user/isGuest';` | 게스트면 `true`, 아니면 `false` | 게스트 사용자 여부 |
| `@salesforce/userPermission/<Permission>` | `import hasPermission from '@salesforce/userPermission/PermissionName';` | 권한 있으면 `true`, 없으면 `undefined` | 표준 사용자 권한 체크 |
| `@salesforce/customPermission/<Permission>` | `import hasPermission from '@salesforce/customPermission/PermissionName';` | `true` / `undefined` | 커스텀 권한 체크 |

---

## 모듈별 상세

### @salesforce/apex — Apex 메서드 import

```javascript
import apexMethodName from '@salesforce/apex/Namespace.Classname.apexMethodReference';
```

- `apexMethodName` — Apex 메서드를 식별하는 심볼.
- `apexMethodReference` — import할 Apex 메서드 이름.
- `Classname` — Apex 클래스 이름.
- `Namespace` — 조직 네임스페이스. 기본 네임스페이스면 생략.
- `apexMethodParams` — Apex 메서드 파라미터와 매칭되는 프로퍼티를 가진 객체(필요 시). 파라미터 값이 `null`이면 `undefined`로 전달된다. 대상 메서드는 `@AuraEnabled`여야 한다.

**호출 방식:** **@wire** 또는 **imperative**. wire 시 `propertyOrFunction`(private 프로퍼티 또는 함수)이 데이터 스트림을 수신한다.

- `@wire` 프로퍼티 → 결과가 프로퍼티의 `data` / `error`로 전달된다.
- `@wire` 함수 → 결과가 `data`·`error` 프로퍼티를 가진 객체로 전달된다.
- `data`·`error`는 API의 **하드코딩 값**이다 — 반드시 이 이름을 그대로 사용해야 한다.

> 호출 패턴 상세는 [[Wire 패턴]]·[[Imperative 호출 패턴]] 참조.

### getSObjectValue — Apex 반환 sObject의 필드 값

```javascript
import { getSObjectValue } from '@salesforce/apex';
```

- `sObject` — Apex 메서드가 반환한 객체.
- `fieldApiName` — 필드 API 이름. 문자열 또는 `@salesforce/schema`에서 import한 필드 참조.
  - relationship 필드는 **최대 3단계**로 지정: `<SObjectName>.<relationship-1>.<relationship-2>.<relationship-3>.<fieldName>`

### refreshApex — Apex 데이터 새로고침

```javascript
import { refreshApex } from '@salesforce/apex';
```

- 서버에 갱신 데이터를 재쿼리한 뒤 캐시를 refresh한다. 인자는 `{valueProvisionedByApexWireService}`(Apex `@wire` 데코레이트된 프로퍼티, 또는 함수를 데코레이트한 경우 그 함수가 받은 인자).
- ⚠️ **비-Apex wire 어댑터의 refresh에 `refreshApex`를 쓰는 것은 deprecated**다. record 데이터는 `notifyRecordUpdateAvailable(recordIds)`를 사용한다.
- imperative Apex로 레코드를 업데이트한 경우: Apex 메서드 호출 후 `notifyRecordUpdateAvailable()`로 캐시를 업데이트한다(`refreshApex()` 대신).

### @salesforce/apexContinuation — 장시간 콜아웃(Continuations)

```javascript
import apexMethodName from '@salesforce/apexContinuation/Namespace.Classname.apexMethodReference';
```

- `apexMethodName`·`apexMethodReference`·`Classname`·`Namespace`(같은 네임스페이스면 생략).

### @salesforce/client/formFactor — 하드웨어 폼 팩터

```javascript
import formFactorPropertyName from '@salesforce/client/formFactor';
```

- 값(3종): **`Large`**(desktop)·**`Medium`**(tablet)·**`Small`**(phone).
- `getRecordCreateDefaults` wire에 폼 팩터를 전달할 수 있다.

### @salesforce/community/Id — 현재 Experience Builder 사이트 network ID

```javascript
import communityId from '@salesforce/community/Id';
```

### @salesforce/community/basePath — Experience Builder 사이트 base URL

```javascript
import basePath from '@salesforce/community/basePath';
```

- base path는 도메인 뒤 구간이다. 예: 도메인 `UniversalTelco.force.com` + 사이트 `myPartnerSite` → URL `UniversalTelco.force.com/myPartnerSite/s` → basePath는 `myPartnerSite/s`.
- ⚠️ `@salesforce/community`를 import하면 그 컴포넌트는 **Experience Builder 페이지만** 타깃할 수 있다.

### @salesforce/contentAssetUrl — 콘텐츠 에셋 파일

```javascript
import myContentAsset from '@salesforce/contentAssetUrl/contentAssetReference';
```

- `contentAssetReference` — 에셋 파일 이름(underscore·영숫자만, org 내 고유).
- `namespace` — managed package인 경우.

### @salesforce/i18n — 국제화 프로퍼티 (고정 식별자 세트)

```javascript
import internationalizationPropertyName from '@salesforce/i18n/internationalizationProperty';
```

- 예: `@salesforce/i18n/dir`·`@salesforce/i18n/lang`.
- 전체 프로퍼티 목록은 공식 문서 "Access Internationalization Properties"에 위임된다(본 노트 범위 밖).

### @salesforce/label — 커스텀 라벨

```javascript
import labelName from '@salesforce/label/labelReference';
```

- `labelReference` 형식은 `namespace.labelName`(예: `myns.labelName`) — Apex에서 라벨을 참조하는 형식과 같다.

### @salesforce/messageChannel — Lightning Message Service 채널

```javascript
import channelName from '@salesforce/messageChannel/channelReference';
```

- `channelReference` — 메시지 채널 API 이름.
- `namespace` — managed package인 경우.

### @salesforce/resourceUrl — 정적 리소스

```javascript
import myResource from '@salesforce/resourceUrl/resourceReference';
```

- `resourceReference` — 정적 리소스 이름(underscore·영숫자만·고유).
- `namespace` — managed package인 경우.

### @salesforce/schema — 오브젝트·필드 참조 (동적 식별자 세트)

```javascript
import objectName from '@salesforce/schema/objectReference';
import fieldName from '@salesforce/schema/objectReference.fieldReference';
```

- `objectReference` — Salesforce 오브젝트 이름.
- `fieldReference` — 필드 이름. 부모 오브젝트·필드를 참조할 때 **최대 3개의 relationship**을 지정: `<SObjectName>.<relationship-1>.<relationship-2>.<relationship-3>.<fieldName>`
- `namespace` — managed package인 경우.

### @salesforce/site/Id — 현재 Experience Builder 사이트 ID

```javascript
import siteId from '@salesforce/site/Id';
```

### @salesforce/site/activeLanguages — Experience Builder 사이트 활성 언어 목록

```javascript
import activeLanguages from '@salesforce/site/activeLanguages';
```

- 기본 사이트 언어 등의 메타데이터를 포함한다(Settings > Languages).
- ⚠️ `@salesforce/community` 또는 `@salesforce/site`를 import하면 그 컴포넌트는 **Experience Builder 페이지만** 타깃할 수 있다.

### @salesforce/user/Id — 현재 사용자 ID

```javascript
import userId from '@salesforce/user/Id';
```

### @salesforce/user/isGuest — 게스트 사용자 여부

```javascript
import isGuestUser from '@salesforce/user/isGuest';
```

- `isGuestUser` — 게스트 사용자면 `true`, 아니면 `false`.

### @salesforce/userPermission/<Permission> — 표준 사용자 권한 체크

```javascript
import hasPermission from '@salesforce/userPermission/PermissionName';
```

- `hasPermission` — 현재 사용자에게 권한이 있으면 `true`, 없으면 `undefined`.
- `Permission`은 Salesforce 사용자 권한 이름.

### @salesforce/customPermission/<Permission> — 커스텀 권한 체크

```javascript
import hasPermission from '@salesforce/customPermission/PermissionName';
```

- `hasPermission` — 권한이 있으면 `true`, 없으면 `undefined`.
- `Permission`은 커스텀 권한 이름.

---

## 관련 노트
- [[Wire 패턴]] — `@salesforce/apex`를 @wire로 호출.
- [[Imperative 호출 패턴]] — `@salesforce/apex`를 imperative로 호출.
- [[uiRecordApi]] — `@salesforce` 없는 `lightning/*` 데이터 모듈(범용 리소스).
- [[getRecord 패턴]] — record 데이터 조회(`notifyRecordUpdateAvailable`와 연계).
- [[HTML 템플릿 Directives 레퍼런스]] — Reference 형제 노트.
- [[LWC MOC]] — LWC 섹션 목차.
