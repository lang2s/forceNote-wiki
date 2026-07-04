---
tags: [lwc, lds, graphql, mutation, executeMutation, create, update, delete, lightning-graphql, uiapi]
source: lwc-recipes-main/force-app/main/default/lwc/graphqlMutationCreate·graphqlMutationUpdate·graphqlMutationDelete (실전 예시, Tier 1) + developer.salesforce.com/docs/platform/lwc/guide/reference-graphql-mutation.html (executeMutation 레퍼런스, 라이브 공식 문서, Tier 2, 접속 2026-07-04)
created: 2026-07-04
aliases: [executeMutation, GraphQL mutation LWC, lightning/graphql mutation, gql mutation, AccountCreate, ContactUpdate, ContactDelete, uiapi mutation, RecordDelete, 그래프QL 뮤테이션, GraphQL 레코드 생성, GraphQL 레코드 수정, GraphQL 레코드 삭제, Apex 없이 CRUD]
---

# GraphQL 뮤테이션 (executeMutation) — Create·Update·Delete

> `lightning/graphql`의 `executeMutation`으로 LWC에서 **명령형(imperative)** 레코드 생성·수정·삭제를 한다. `graphql` wire adapter가 조회(read) 전용인 것과 짝을 이루는 쓰기(write) 경로 — Apex 없이 GraphQL API로 CRUD를 완성한다. (Spring '26 GA)

---

## 개요

`lightning/graphql`은 두 개의 export를 제공한다.

| export | 용도 | 호출 방식 |
|---|---|---|
| `graphql` | 데이터 **조회(read)** — 반응형 쿼리 | `@wire(graphql, { query, variables })` |
| `executeMutation` | 데이터 **변경(write)** — 생성·수정·삭제 | 명령형 `await executeMutation({ query })` |
| `gql` | GraphQL 쿼리 문자열을 파싱하는 template literal tag | 두 경우 모두 `query`에 넘길 값을 만든다 |

- ⚠️ **`executeMutation`은 `@wire`로 쓸 수 없다.** wire는 반응형 조회 전용이며, 뮤테이션은 사용자 액션(버튼 클릭 등)에 반응해 명령형으로 호출해야 한다.
- 뮤테이션은 `graphql` wire adapter와 **동일한 Salesforce GraphQL API 리소스**를 사용한다 — `uiapi` 스키마 아래의 `<Object>Create` / `<Object>Update` / `<Object>Delete` 필드.
- Lightning Data Service(LDS) 위에서 동작하므로, 뮤테이션 성공 후 LDS 캐시에 반영되어 다른 컴포넌트의 wire 결과가 갱신될 수 있다.

```js
import { gql, executeMutation } from 'lightning/graphql';
// 조회도 함께 쓰면:
import { gql, graphql, executeMutation } from 'lightning/graphql';
```

---

## executeMutation 레퍼런스 (Tier 2 — 공식 문서)

### 메서드 시그니처

```js
// 구조 예시 — 파라미터 형태
const result = await executeMutation({
    query,          // (필수) gql로 파싱한 뮤테이션
    variables,      // (선택) GraphQL 변수 객체 — input 인자 포함
    operationName   // (선택) 한 쿼리에 여러 오퍼레이션이 있을 때 실행할 이름
});
```

### 파라미터

| 파라미터 | 필수 | 설명 |
|---|---|---|
| `query` | ✅ | `gql` template literal 함수로 파싱한 GraphQL 뮤테이션. `gql`이 문자열을 `executeMutation`이 쓸 수 있는 형태로 파싱한다. **`gql`은 반응형이 아니다.** |
| `variables` | ⬜ | 쿼리에 넘길 GraphQL Variables 객체. 뮤테이션의 `input` 인자(레코드 `Id` 필드 + 생성/수정할 필드)를 담는다. 값을 인라인 문자열로 넣는 대신 `$input` 같은 변수로 분리할 때 사용. |
| `operationName` | ⬜ | 한 쿼리 문서 안에 여러 오퍼레이션이 있을 때 실행할 오퍼레이션 이름. `mutation CreateCase`처럼 이름을 붙인다. |

### 반환값

`executeMutation`은 Promise를 반환하며, resolve된 객체는 다음을 담는다.

| 프로퍼티 | 설명 |
|---|---|
| `data` | GraphQL API 응답. 뮤테이션 경로를 따라 접근한다 (예: `result.data.uiapi.AccountCreate.Record.Id`). |
| `errors` | GraphQL API 에러 **배열**. (GraphQL 스펙 준수를 위해 `error`가 아니라 `errors` — 복수형). 에러가 있으면 `data`는 부분적이거나 비어 있을 수 있다. |

> ⚠️ **에러 처리 이중 패턴:** 네트워크/파싱 예외는 `try/catch`로, GraphQL API 레벨 에러는 반환 객체의 `result.errors`로 잡는다. 둘 다 처리해야 한다 (아래 실전 코드 참조).

---

## 뮤테이션 쿼리 구조 (uiapi 스키마)

모든 뮤테이션은 `uiapi` 아래에 위치하며, 오퍼레이션마다 `input` 인자를 받고 특정 출력 필드를 반환한다.

| 오퍼레이션 | input 형태 | 반환 필드 | 규칙 |
|---|---|---|---|
| **Create** `<Object>Create` | `{ <Object>: { 필드... } }` | `Record { ... }` | **필수 필드 전부** 포함, **createable 필드만** 포함. Reference(조회) 필드는 대상 레코드의 **Id**를 그 필드 API명에 할당. |
| **Update** `<Object>Update` | `{ Id: "...", <Object>: { 필드... } }` | `Record { ... }` | 레코드 **Id 필수**, **updateable 필드만** 포함. Reference 필드는 Id 할당. |
| **Delete** `<Object>Delete` | `{ Id: "..." }` | `Id` | **레코드 Id만** 포함. |

- `<Object>`는 SObject API명 (예: `Account`, `Contact`, 커스텀 오브젝트 `Foo__c`).
- Create/Update의 `Record` 하위에서 원하는 필드를 조회하면, 뮤테이션 성공 후 최신 값을 그대로 돌려받는다. 필드 값은 `{ value }` 형태로 감싸져 온다 (GraphQL API의 필드 래핑 규칙 — read wire와 동일).

```graphql
# 구조 예시 — Create 뮤테이션 골격
mutation CreateAccount {
    uiapi {
        AccountCreate(input: { Account: { Name: "Acme" } }) {
            Record { Id  Name { value } }
        }
    }
}
```

---

## 실전 예시 1 — Create (lwc-recipes: graphqlMutationCreate)

계정 이름을 입력받아 `AccountCreate` 뮤테이션으로 새 Account를 생성하고, 반환된 `Record.Id`를 표시한다. 아래 코드는 lwc-recipes 원본 그대로다.

```js
import { LightningElement } from 'lwc';
import { gql, executeMutation } from 'lightning/graphql';

export default class GraphqlMutationCreate extends LightningElement {
    accountName = '';
    accountId;
    errors;
    isLoading = false;

    getCreateQuery(name) {
        return gql`
            mutation CreateAccount {
                uiapi {
                    AccountCreate(input: { Account: { Name: "${name}" } }) {
                        Record {
                            Id
                            Name {
                                value
                            }
                        }
                    }
                }
            }
        `;
    }

    handleNameChange(event) {
        this.accountName = event.target.value;
        this.accountId = undefined;
        this.errors = undefined;
    }

    async handleCreateAccount() {
        if (!this.accountName) {
            this.errors = ['Account Name is required'];
            return;
        }

        this.isLoading = true;
        this.errors = undefined;
        this.accountId = undefined;

        try {
            const result = await executeMutation({
                query: this.getCreateQuery(this.accountName)
            });

            if (result.errors) {
                this.errors = result.errors;
            } else {
                this.accountId = result.data.uiapi.AccountCreate.Record.Id;
                this.accountName = '';
            }
        } catch (error) {
            this.errors = error;
        } finally {
            this.isLoading = false;
        }
    }
}
```

마크업 핵심 (원본 발췌):

```html
<lightning-input label="Account Name" value={accountName}
    onchange={handleNameChange}></lightning-input>
<lightning-button label="Create Account" variant="brand"
    onclick={handleCreateAccount} disabled={isLoading}></lightning-button>
<lightning-spinner lwc:if={isLoading} alternative-text="Creating..."></lightning-spinner>
<!-- 성공 시 -->
Account created with Id: {accountId}
<!-- 에러 시 -->
<c-error-panel errors={errors}></c-error-panel>
```

> 포인트: `gql`을 게터(`getCreateQuery`)로 감싸 동적으로 만든다. 뮤테이션은 반응형이 아니므로 클릭 핸들러에서 매번 새로 생성한다.

---

## 실전 예시 2 — Update (lwc-recipes: graphqlMutationUpdate)

`graphql` wire로 첫 Contact를 조회 → 폼에 바인딩 → `ContactUpdate`로 수정 → **`refresh`로 wire 결과 갱신**. read wire와 write mutation을 한 컴포넌트에서 결합하는 정석 패턴이다.

```js
import { LightningElement, wire } from 'lwc';
import { gql, graphql, executeMutation } from 'lightning/graphql';

export default class GraphqlMutationUpdate extends LightningElement {
    contact;
    firstName = '';
    lastName = '';
    email = '';
    errors;
    successMessage;
    isLoading = true;
    refreshGraphQL;

    @wire(graphql, {
        query: gql`
            query getContact {
                uiapi {
                    query {
                        Contact(first: 1, orderBy: { Name: { order: ASC } }) {
                            edges {
                                node {
                                    Id
                                    FirstName { value }
                                    LastName { value }
                                    Email { value }
                                }
                            }
                        }
                    }
                }
            }
        `
    })
    wiredContact(result) {
        this.isLoading = false;
        this.errors = undefined;
        this.contact = undefined;

        const { errors, data, refresh } = result;

        if (refresh) {
            this.refreshGraphQL = refresh;   // wire가 노출하는 refresh 함수 저장
        }

        if (data) {
            const contacts = data.uiapi.query.Contact.edges;
            if (contacts.length > 0) {
                const node = contacts[0].node;
                this.contact = {
                    Id: node.Id,
                    FirstName: node.FirstName?.value || '',
                    LastName: node.LastName?.value || '',
                    Email: node.Email?.value || ''
                };
                this.firstName = this.contact.FirstName;
                this.lastName = this.contact.LastName;
                this.email = this.contact.Email;
            } else {
                this.errors = ['No contacts found'];
            }
        }

        if (errors) {
            this.errors = errors;
        }
    }

    getUpdateQuery(contactId, firstName, lastName, email) {
        return gql`
            mutation UpdateContact {
                uiapi {
                    ContactUpdate(input: {
                        Id: "${contactId}",
                        Contact: {
                            FirstName: "${firstName}",
                            LastName: "${lastName}",
                            Email: "${email}"
                        }
                    }) {
                        Record {
                            Id
                            FirstName { value }
                            LastName { value }
                            Email { value }
                        }
                    }
                }
            }
        `;
    }

    async handleUpdateContact() {
        if (!this.lastName) {
            this.errors = ['Last Name is required'];
            return;
        }

        this.isLoading = true;
        this.errors = undefined;
        this.successMessage = undefined;

        try {
            const result = await executeMutation({
                query: this.getUpdateQuery(
                    this.contact.Id, this.firstName, this.lastName, this.email
                )
            });

            if (result.errors) {
                this.errors = result.errors;
            } else {
                const updated = result.data.uiapi.ContactUpdate.Record;
                this.successMessage =
                    `Contact updated: ${updated.FirstName?.value || ''} ${updated.LastName?.value}`;
                await this.refreshGraphQL?.();   // wire 결과 갱신
            }
        } catch (error) {
            this.errors = error;
        } finally {
            this.isLoading = false;
        }
    }
    // handleFirstNameChange / handleLastNameChange / handleEmailChange 는
    // 각 lightning-input의 onchange에서 로컬 상태를 갱신 (원본 참조)
}
```

> 포인트: wire result의 `refresh` 함수를 `refreshGraphQL`에 저장해 뒀다가, 뮤테이션 성공 후 `await this.refreshGraphQL?.()`로 호출한다. 이렇게 해야 수정된 값이 wire 결과(폼 소스)에 반영된다.

---

## 실전 예시 3 — Delete (lwc-recipes: graphqlMutationDelete)

Contact 목록을 wire로 조회 → 각 행의 삭제 버튼 → `ContactDelete`로 삭제 → `refresh`로 목록 갱신.

```js
import { LightningElement, wire } from 'lwc';
import { gql, graphql, executeMutation } from 'lightning/graphql';

export default class GraphqlMutationDelete extends LightningElement {
    contacts;
    errors;
    successMessage;
    isLoading = true;
    refreshGraphQL;

    @wire(graphql, {
        query: gql`
            query getContacts {
                uiapi {
                    query {
                        Contact(first: 5, orderBy: { Name: { order: ASC } }) {
                            edges {
                                node {
                                    Id
                                    Name { value }
                                }
                            }
                        }
                    }
                }
            }
        `
    })
    wiredContacts(result) {
        this.isLoading = false;
        this.errors = undefined;
        this.contacts = undefined;

        const { errors, data, refresh } = result;

        if (refresh) {
            this.refreshGraphQL = refresh;
        }

        if (data) {
            this.contacts = data.uiapi.query.Contact.edges.map((edge) => ({
                Id: edge.node.Id,
                Name: edge.node.Name.value
            }));
        }

        if (errors) {
            this.errors = errors;
        }
    }

    get noContacts() {
        return !this.contacts || this.contacts.length === 0;
    }

    getDeleteQuery(contactId) {
        return gql`
            mutation DeleteContact {
                uiapi {
                    ContactDelete(input: { Id: "${contactId}" }) {
                        Id
                    }
                }
            }
        `;
    }

    async handleDeleteContact(event) {
        const contactId = event.target.dataset.id;
        const contactName = event.target.dataset.name;

        this.isLoading = true;
        this.errors = undefined;
        this.successMessage = undefined;

        try {
            const result = await executeMutation({
                query: this.getDeleteQuery(contactId)
            });

            if (result.errors) {
                this.errors = result.errors;
            } else {
                this.successMessage = `Contact "${contactName}" deleted successfully`;
                await this.refreshGraphQL?.();
            }
        } catch (error) {
            this.errors = error;
        } finally {
            this.isLoading = false;
        }
    }
}
```

목록·삭제 버튼 마크업 (원본 발췌):

```html
<template for:each={contacts} for:item="contact">
    <lightning-layout key={contact.Id}>
        <lightning-layout-item flexibility="grow">{contact.Name}</lightning-layout-item>
        <lightning-layout-item>
            <lightning-button-icon icon-name="utility:delete"
                onclick={handleDeleteContact}
                data-id={contact.Id} data-name={contact.Name}></lightning-button-icon>
        </lightning-layout-item>
    </lightning-layout>
</template>
```

> 포인트: Delete는 `input`에 `Id`만, 반환도 `Id`만이다 (`Record` 없음). `data-*` 어트리뷰트로 어느 행을 지웠는지 핸들러에 전달한다.

---

## GraphQL Variables로 인젝션 방지 (권장)

위 recipe들은 `${...}` template literal 보간으로 값을 인라인 삽입한다. 사용자 입력에 `"` 같은 특수문자가 있으면 쿼리가 깨지거나 인젝션 위험이 있다. 공식 문서는 값을 **GraphQL Variables**로 분리하는 방식을 권장한다.

```js
// 구조 예시 — variables로 input 분리 (인라인 문자열 대신)
const result = await executeMutation({
    query: gql`
        mutation UpdateAccount($input: AccountUpdateRepresentation!) {
            uiapi {
                AccountUpdate(input: $input) {
                    Record { Id  Name { value } }
                }
            }
        }
    `,
    variables: {
        input: { Id: recordId, Account: { Name: userInput } }
    }
});
```

> `variables`로 넘기면 값이 쿼리 문자열에 문자 그대로 끼어들지 않아 이스케이프/인젝션 문제를 피한다. 프로덕션에서는 이 방식을 선호한다. (recipe의 인라인 방식은 학습용 단순화)

---

## 뮤테이션 후 데이터 갱신 (refresh) — 오퍼레이션별 차이

| 오퍼레이션 | 기존 wire 결과 자동 반영? | 조치 |
|---|---|---|
| **Create** | ❌ 필터·캐시 상태에 따라 새 레코드가 기존 쿼리 결과에 **바로 안 나타남** | wire result의 `refresh()` 호출 필요 |
| **Update** | ❌ 갱신값이 기존 wire 결과에 자동 반영 안 될 수 있음 | `refresh()` 호출 필요 |
| **Delete** | ✅ LDS wire 결과에서 삭제 레코드가 **정상 제거됨** (문서상 refresh 불필요) | recipe는 안전하게 `refresh()` 호출 |

- `refresh`는 `graphql` **wire result 객체가 노출하는 함수**다 (`const { data, errors, refresh } = result`). 이를 저장해 뒀다가 뮤테이션 성공 후 호출한다.
- 참조: [[RefreshView API]] — 컴포넌트 전체 데이터 그래프를 갱신하는 상위 개념. GraphQL wire의 `refresh`는 해당 wire 하나를 갱신한다.

---

## 제약 / 한계 (공식 문서)

| 항목 | 내용 |
|---|---|
| `@wire` 미지원 | `executeMutation`은 wire로 못 쓴다. 항상 명령형 호출. |
| Mobile Offline 미지원 | 뮤테이션은 오프라인 유스케이스를 지원하지 않는다 (`lightning/graphql` 자체가 Mobile Offline 미지원). |
| child relationship 조회 불가 | 뮤테이션의 일부로 자식 관계를 조회할 수 없다. |
| createable/updateable만 | Create는 createable 필드, Update는 updateable 필드만 넣어야 한다. Reference 필드는 대상 레코드의 Id를 API명에 할당. |
| 필드 값 래핑 | 반환 `Record`의 스칼라 필드는 `{ value }`로 감싸져 온다 (read wire와 동일 규칙). |
| FLS/CRUD | UI API 기반이므로 실행 사용자의 FLS·CRUD·공유 규칙이 자동 적용된다 (Apex의 `without sharing` 우회 불가). |

---

## 언제 무엇을 쓰나 — executeMutation vs uiRecordApi vs Apex

| 방식 | 쓰기 API | 조회와의 통합 | 선택 기준 |
|---|---|---|---|
| **GraphQL `executeMutation`** | `lightning/graphql` | 같은 `graphql` wire와 캐시 공유, `refresh` 연동 | 이미 GraphQL wire로 조회 중이거나, 다중 오브젝트/복잡한 쿼리를 GraphQL로 통일하고 싶을 때 |
| **`uiRecordApi`** (createRecord/updateRecord/deleteRecord) | `lightning/uiRecordApi` | `getRecord` wire와 LDS 캐시 공유 | 단일 레코드 CRUD, RecordInput/필드맵 방식이 익숙할 때 → [[uiRecordApi]] |
| **Apex `@AuraEnabled` DML** | Apex | 수동 (refreshApex) | 서버 트랜잭션 로직·복잡한 검증·벌크 처리·`with sharing` 제어가 필요할 때 |

> read 경로는 [[GraphQL Wire Adapter]], write 경로가 이 노트. 둘을 합치면 Apex 없이 GraphQL만으로 완전한 CRUD가 된다.

---

## 관련 노트
- [[GraphQL Wire Adapter]] — `graphql` wire로 데이터 조회 (read 짝, 같은 `lightning/graphql`)
- [[uiRecordApi]] — `lightning/uiRecordApi`의 createRecord/updateRecord/deleteRecord (대안 CRUD 경로)
- [[RefreshView API]] — 컴포넌트 데이터 갱신 (뮤테이션 후 refresh 상위 개념)
- [[ldsUtils reduceErrors]] — 뮤테이션 `errors`/예외를 `string[]`으로 정규화해 표시
- [[UI API 개요]] — `uiapi` 스키마의 기반 UI API
