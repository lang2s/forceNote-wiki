---
tags: [lwc, base-component, input, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2) + lightning-file-upload documentation Usage Considerations (developer.salesforce.com, Tier 2)
created: 2026-06-13
aliases: [lightning-file-upload, File Upload]
---

# lightning-file-upload

> 레코드에 파일을 업로드. · 카테고리: Input

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-file-upload label="첨부" record-id={recordId} accept={acceptedFormats} onuploadfinished={handleFinished}></lightning-file-upload>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-file-upload` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `accept` | string[] |  |  | Comma-separated list of file extensions that can be uploaded in the format ['.ext'], such as ['.pdf', '.jpg', '.png']. |
| `aria-invalid` | boolean |  |  | A Boolean value for aria-invalid. |
| `disabled` | boolean |  | false | Specifies whether this component should be displayed in a disabled state. Disabled components can't be clicked. The default is false. |
| `file-field-name` | string |  |  | Name of a custom field on the ContentVersion object. Set its value with the file-field-value attribute. |
| `file-field-value` | string |  |  | Value to store in the custom field specified by file-field-name for the uploaded file. |
| `label` | string | ✔ |  | The text label for the file uploader. |
| `multiple` | boolean |  | false | Specifies whether a user can upload more than one file simultaneously. The default is false. |
| `name` | string | ✔ |  | Specifies the name of the input element. |
| `record-id` | string |  |  | The record Id of the record that the uploaded file is associated to. |
| `required` | boolean |  | false | If present, the file-upload field is set to required as true |

### 메서드 (Methods) — 3개

| 메서드 | 설명 |
|---|---|
| `focus` | Focuses on the lightning-input when called. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when a form is submitted. |


## 사용 시 주의 (Usage Considerations)

### ⚠️ 전제조건 — 게스트 사용자(Experience Cloud 비인증) 업로드

Experience Cloud 사이트의 게스트(비인증) 사용자 업로드는 **기본적으로 비활성**이다. 켜지 않으면 게스트 사용자에게는 파일 업로드가 동작하지 않는다.

1. **Setup → Salesforce Files → General Settings** 에서 **'Allow site guest users to upload files'** 를 먼저 활성화한다.
2. **LWR 사이트**는 여기에 더해 **'Use the File Upload Lightning web component for LWR sites'** 설정도 켜야 한다.

### 한도·주의

| 항목 | 값 |
|---|---|
| 동시 업로드 파일 수 | 기본 **10개**, org에서 **1~25개** 범위로 조정 가능 |
| Experience Builder 사이트 파일당 크기 한도 (`my.site.com` URL) | **128MB** |
| Experience Builder 사이트 파일당 크기 한도 (커스텀 도메인) | **500MB** |

- Experience Builder 사이트에서는 위처럼 파일당 크기 한도가 낮아진다(도메인 유형에 따라 128MB/500MB).
- **`record-id` 없이 업로드하면** 파일이 어떤 레코드에도 연결되지 않고 **업로더 본인에게만 private** 으로 남는다 — 다른 사용자가 파일을 볼 수 없어지는 흔한 함정이므로, 레코드에 연결하려면 반드시 `record-id`를 지정한다.

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-file-upload/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-file-upload/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-file-upload/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-file-upload.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
