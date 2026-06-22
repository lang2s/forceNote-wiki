---
tags: [visualforce, vf, static-resource, custom-component, override, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [Visualforce 오버라이드, Static Resource, apex:component, 커스텀 Visualforce 컴포넌트, $Resource URLFOR]
---

# Visualforce — 버튼·링크·탭 오버라이드 · Static Resource · 커스텀 컴포넌트

> 표준 버튼/링크/탭을 Visualforce 페이지로 오버라이드하는 방법, 정적 콘텐츠를 `$Resource`로 참조하는 Static Resource, 그리고 재사용 가능한 `<apex:component>` 커스텀 컴포넌트를 다룬다. (Visualforce Developer Guide Ch9–Ch11 전수)

> 레거시 안내: Visualforce는 Salesforce Classic 시대의 마크업 프레임워크이며, 신규 UI 개발은 일반적으로 LWC/Aura를 사용한다. 이 노트는 기존 VF 자산 유지·이해를 위한 레퍼런스다.

---

## 1. 표준 버튼·링크·탭 오버라이드 (Ch9)

New, View, Edit 같은 표준 버튼의 동작을, 그리고 표준/커스텀/외부 오브젝트 탭을 클릭할 때 표시되는 탭 홈 페이지를 Salesforce Classic, Lightning Experience, Salesforce 모바일 앱에서 오버라이드할 수 있다.

### Setup 절차

1. Setup에서 **Object Manager**를 클릭하고, 오버라이드를 설정할 오브젝트를 클릭한다.
2. **Buttons, Links, and Actions**를 클릭하고, 오버라이드할 버튼 또는 탭 홈 페이지의 드롭다운에서 **Edit**를 선택한다.
3. Salesforce Classic에서 동작을 오버라이드하려면, 오버라이드 타입으로 **Visualforce page**를 선택하고, 사용자가 버튼이나 탭을 클릭할 때 실행할 Visualforce 페이지를 선택한다.
   > [sic] 원문: *"To override the behavior in Salesforce Classic, select Visualforce page as the override type, **and the select** the Visualforce page that you want to run when users click the button or tab."* — "and the select"는 PDF 원문의 오타이며 그대로 보존한다. ("Visualforce page" 단수 표기도 원문 그대로.)
4. 동일하게 선택된 Visualforce 페이지를 Lightning Experience 또는 Salesforce 모바일 앱에 적용하려면, **Use the Salesforce Classic override**를 선택한다.
5. 변경 사항을 저장한다.

### 오버라이드 시 고려사항 (General Considerations)

`standardController`가 **오버라이드 대상 오브젝트와 일치해야** 한다. 예를 들어 account의 Edit 버튼을 오버라이드하려면 페이지 마크업의 `<apex:page>` 태그에 `standardController="Account"` 속성이 포함되어야 한다.

```xml
<apex:page standardController="Account">
<!-- page content here -->
</apex:page>
```

- **탭 오버라이드:** Visualforce 페이지로 탭을 오버라이드할 때는, 해당 탭의 연관 오브젝트에 대한 standard list controller를 사용하는 페이지, custom controller를 사용하는 페이지, 또는 controller가 없는 페이지만 선택할 수 있다.
  - Tip: 오버라이드로 사용하는 Visualforce page에 기능을 추가하려면 controller extension을 사용한다.
- **리스트 오버라이드:** Visualforce 페이지로 리스트를 오버라이드할 때는, standard list controller를 사용하는 Visualforce 페이지만 선택할 수 있다.
- **New 버튼 오버라이드:** New 버튼을 오버라이드할 때, record type 선택 페이지를 건너뛰도록 선택할 수 있다. 그렇게 하면 생성하는 새 레코드가 record type 선택 페이지로 전달되지 않으며, Salesforce는 Visualforce 페이지가 이미 record type을 처리하고 있다고 가정한다.
  - Important: Salesforce 모바일 앱 사용자가 product를 생성하기 위해 New를 클릭하면, Setup에서 **Skip record type selection page** 옵션이 선택되어 있더라도 사용자는 record type을 선택해야 한다.

### 특정 오버라이드 고려사항 (Specific Override Considerations)

Experience site의 ResetPassword 액션이 Visualforce 페이지로 설정된 경우, 비밀번호 변경을 트리거하는 페이지의 액션은 무한 비밀번호 재설정 루프를 피하기 위해 반드시 다른 페이지로 redirect해야 한다.

### Standard List Controller로 탭 오버라이드하기

Standard list controller를 사용하는 페이지로 탭을 오버라이드할 수 있다. 예를 들어 Account standard list controller와 연관된 `overrideAccountTab` 페이지를 만들면:

```xml
<apex:page standardController="Account" recordSetVar="accounts" tabStyle="account">
<apex:pageBlock >
<apex:pageBlockTable value="{!accounts}" var="a">
<apex:column value="{!a.name}"/>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```

그런 다음 Account 탭이 표준 Account 홈 페이지 대신 해당 페이지를 표시하도록 오버라이드한다.

1. accounts의 object management settings에서 **Buttons, Links, and Actions**로 이동한다.
2. **Accounts Tab**에 대해 **Edit**를 클릭한다.
3. **Visualforce Page** 드롭다운 목록에서 `overrideAccountTab` 페이지를 선택한다.
4. **Save**를 클릭한다.

---

## 2. 커스텀 버튼·링크 정의 (Ch9)

오브젝트에 Visualforce 페이지를 여는 커스텀 버튼이나 링크를 생성한다. 버튼/링크 생성 전, 사용자가 클릭할 때 어떤 액션이 발생할지 결정한다.

1. 적절한 오브젝트의 management settings에서 **Buttons, Links, and Actions**로 이동한다.
   - Note: 커스텀 버튼은 **User 오브젝트나 커스텀 홈 페이지에서는 사용할 수 없다.** 커스텀 버튼과 링크는 activities의 경우 tasks와 events 개별 오브젝트 management settings에서 사용할 수 있다. tasks와 events 양쪽에 적용되는 표준 버튼을 오버라이드하려면 activities의 object management settings로 이동한다.
2. **New Button or Link**를 클릭한다.
3. 다음 속성을 입력한다.

### 커스텀 버튼·링크 속성표 (8행, 전수)

| 속성 (Attribute Name) | 설명 (Description) |
|---|---|
| **Label** | 커스텀 버튼 또는 링크에 대해 사용자 페이지에 표시되는 텍스트. |
| **Name** | merge field에서 참조할 때 사용되는 버튼/링크의 고유 이름. 이 이름은 밑줄과 영숫자만 포함할 수 있고, org 내에서 고유해야 한다. 문자로 시작해야 하며, 공백을 포함하지 않고, 밑줄로 끝나지 않으며, 연속된 두 개의 밑줄을 포함하지 않아야 한다. |
| **Namespace Prefix** | 패키징 컨텍스트에서, namespace prefix는 1~15자 영숫자 식별자로, AppExchange의 다른 개발자 패키지와 사용자의 패키지·내용을 구분한다. Namespace prefix는 대소문자를 구분하지 않는다. 예를 들어 ABC와 abc는 고유한 것으로 인식되지 않는다. namespace prefix는 모든 Salesforce 조직에 걸쳐 전역적으로 고유해야 한다. 이는 managed package를 사용자의 독점적 통제 하에 둔다. |
| **Protected Component** | Protected component는 subscriber org에서 생성된 component에 의해 링크되거나 참조될 수 없다. 개발자는 설치 실패를 걱정하지 않고 향후 릴리즈에서 protected component를 삭제할 수 있다. 그러나 component가 unprotected로 표시되고 전역적으로 릴리즈된 후에는 개발자가 삭제할 수 없다. |
| **Description** | 버튼 또는 링크를 구별하는 텍스트로, 관리자가 버튼과 링크를 설정할 때 표시된다. |
| **Display Type** | 버튼 또는 링크가 page layout의 어디에서 사용 가능한지 결정한다. <br>• **Detail Page Link** — page layout의 Custom Links 섹션에 링크를 추가한다. <br>• **Detail Page Button** — 레코드의 detail 페이지에 커스텀 버튼을 추가한다. detail page button은 page layout의 Button 섹션에만 추가할 수 있다. <br>• **List Button** — list view, search result layout, related list에 커스텀 버튼을 추가한다. list button은 page layout의 Related List 섹션, 또는 List View 및 Search Result layout에만 추가할 수 있다. list button의 경우, Salesforce가 자동으로 **Display Checkboxes (for Multi-Record Selection)** 옵션을 선택하여 list의 각 레코드 옆에 체크박스를 포함시켜, 사용자가 list button 액션에 적용할 레코드를 선택할 수 있게 한다. 다른 페이지로 이동하는 버튼처럼 사용자가 레코드를 선택할 필요가 없으면 이 옵션을 해제한다. |
| **Behavior** | 버튼 또는 링크 클릭의 결과를 선택한다. 해당되는 경우 일부 설정에는 기본값이 있다. 예를 들어 **Display in new window**를 선택하면 새 창의 기본 높이는 600픽셀이다. |
| **Content Source** | 버튼 또는 링크의 콘텐츠로 Visualforce 페이지를 선택한다. **Visualforce 페이지는 홈 페이지의 커스텀 링크로는 사용할 수 없다.** |

4. 완료되면 **Save**를 클릭한다. (또는 계속 편집하며 저장하려면 **Quick Save**, 저장 없이 종료하려면 **Cancel**.)
5. 새 버튼이나 링크를 표시하려면, 해당 탭이나 search layout의 page layout을 편집한다.
6. 선택적으로, 사용자의 기본 브라우저 설정과 다른 설정으로 버튼/링크를 열도록 window properties를 설정한다.

> Note: 이 페이지를 모든 사용자가 사용할 수 있도록 page level security를 적절히 설정해야 한다.

---

## 3. Standard List Controller로 커스텀 List Button 추가 (Ch9)

표준 버튼/링크 오버라이드 외에도, standard list controller를 사용하는 페이지로 연결되는 커스텀 list button을 만들 수 있다. 이 list button은 list page, search results, 오브젝트의 모든 related list에서 사용할 수 있으며, 선택된 레코드 그룹에 대해 액션을 수행할 수 있다. 선택된 레코드 집합을 나타내려면 **`{!selected}`** 표현식을 사용한다.

예: opportunities related list에 선택된 레코드의 stage와 close date를 편집·저장하는 커스텀 버튼 추가.

1. 다음 Apex 클래스를 생성한다. ( `setPageSize(10)`으로 페이지 크기를 10으로 설정 )

```apex
public class tenPageSizeExt {
public tenPageSizeExt(ApexPages.StandardSetController controller) {
controller.setPageSize(10);
}
}
```

2. 다음 페이지를 만들고 `oppEditStageAndCloseDate`로 호출한다.

```xml
<apex:page standardController="Opportunity" recordSetVar="opportunities"
tabStyle="Opportunity" extensions="tenPageSizeExt">
<apex:form >
<apex:pageBlock title="Edit Stage and Close Date" mode="edit">
<apex:pageMessages />
<apex:pageBlockButtons location="top">
<apex:commandButton value="Save" action="{!save}"/>
<apex:commandButton value="Cancel" action="{!cancel}"/>
</apex:pageBlockButtons>
<apex:pageBlockTable value="{!selected}" var="opp">
<apex:column value="{!opp.name}"/>
<apex:column headerValue="Stage">
<apex:inputField value="{!opp.stageName}"/>
</apex:column>
<apex:column headerValue="Close Date">
<apex:inputField value="{!opp.closeDate}"/>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:form>
</apex:page>
```

3. 페이지를 모든 사용자가 사용할 수 있게 만든다. (Setup → Visualforce Pages → 해당 페이지의 **Security** → 적절한 profile을 Enabled Profiles 목록에 추가 → Save)
4. opportunities에 커스텀 버튼을 만든다. Label을 `Edit Stage & Date`, Display Type을 **List Button**, Content Source를 **Visualforce Page**, Content 드롭다운에서 `oppEditStageAndCloseDate`를 선택 → Save. (page layout을 업데이트하기 전까지 버튼이 표시되지 않는다는 경고가 표시됨)
5. account page layout에 커스텀 버튼을 추가한다. (Related List Section에서 Opportunities 편집 → Custom Buttons 섹션에서 `Edit Stage & Date`를 Selected Buttons로 추가 → OK → Save)

이제 account 페이지를 방문하면 opportunities related list에 새 버튼이 표시된다.

> PDF에 스크린샷(다이어그램) 있음 — "Example of New Button"과 "Example of Custom Edit Page" 두 이미지. 본 wiki에는 텍스트 설명만 포함한다.

---

## 4. Record Type 표시 (Ch9)

Salesforce API 버전이 **20.0 이상**인 Visualforce 페이지는 record type을 지원한다. Record type은 서로 다른 사용자에게 다른 비즈니스 프로세스, picklist 값, page layout을 제공한다.

Setup에서 record type을 생성한 후 Visualforce에서 지원을 활성화하는 데 추가 작업이 필요하지 않다. Record type을 사용하는 오브젝트의 Visualforce 페이지는 설정을 존중한다. **Record type 필드는 `RecordTypeId`로 명명**된다.

Record type 정의는 `<apex:inputField>` 태그의 렌더링에 다음과 같이 영향을 준다:

- `<apex:inputField>` 태그가 **record type에 의해 필터링되는 picklist 필드**를 참조하는 경우:
  - 렌더링된 `<apex:inputField>` component는 해당 record type과 호환되는 옵션만 표시한다.
  - `<apex:inputField>` component가 렌더링되고 편집 가능한 controlling field를 가진 dependent picklist에 바인딩된 경우, record type과 controlling field 값 모두와 호환되는 옵션만 표시된다.
- `<apex:inputField>` 태그가 **record type 필드**를 참조하는 경우:
  - 사용자가 필드의 record type을 변경할 수 있거나 새 필드에 대해 record type을 선택할 수 있으면, `<apex:inputField>` component는 drop-down list로 렌더링된다. 그렇지 않으면 read-only text로 렌더링된다.
  - list가 변경될 때 페이지를 새로 고치거나 필터링된 picklist를 rerender하는 것은 개발자의 책임이다.

또한 `<apex:outputField>` 태그의 record type 지원은 `<apex:inputField>` 동작의 read-only 구현과 동일하다.

> New 버튼을 Visualforce 페이지로 오버라이드할 때 record type 선택 페이지를 건너뛰도록 선택할 수 있다. 그렇게 하면 Salesforce는 Visualforce 페이지가 이미 record type을 처리하고 있다고 가정한다. (Ch9 §1 고려사항과 동일 내용 재게재)

---

## 5. 커스텀 오버라이드 제거 (Ch9)

표준 버튼과 탭의 기본 동작을 복원하는 방법.

1. Setup에서 **Object Manager**를 클릭하고 업데이트할 오브젝트를 클릭한다.
2. **Buttons, Links, and Actions**를 클릭하고, 원하는 버튼 또는 탭 홈 페이지의 드롭다운에서 **Edit**를 선택한다.
3. Salesforce Classic에서 동작을 제거하려면 **No override (default behavior)**를 선택한다. Lightning Experience 또는 Salesforce 모바일 앱에서 동작을 제거하려면 **Use the Salesforce Classic override**를 선택한다.
4. 변경 사항을 저장한다.

> Note: Salesforce Classic에서 Lightning Experience로 전환할 때, Salesforce Classic의 URL에 `nooverride=1`이 포함되어 있으면 Lightning Experience에서는 `nooverride=true`로 변경되며, 이동하는 레코드에 대한 오버라이드가 보이지 않는다.

---

## 6. Static Resource (Ch10)

Static resource를 사용하면 아카이브(`.zip`, `.jar` 파일 등), 이미지, style sheet, JavaScript 및 기타 파일을 업로드하여 Visualforce 페이지에서 참조할 수 있다. Static resource는 **Salesforce org 내에서만 사용**할 수 있으므로 다른 앱이나 웹사이트의 콘텐츠를 호스팅할 수 없다.

Documents 탭에 파일을 업로드하는 것보다 static resource 사용이 선호되는 이유:

- 관련 파일 컬렉션을 디렉토리 계층으로 패키징하여 `.zip` 또는 `.jar` 아카이브로 업로드할 수 있다.
- document ID를 하드코딩하는 대신 **`$Resource` global variable**을 사용하여 static resource를 이름으로 참조할 수 있다.

> Tip: JavaScript나 CSS를 참조할 때 마크업에 inline으로 포함하는 것보다 static resource 사용이 선호된다. 이를 통해 모든 페이지에서 일관된 look and feel과 공유된 JavaScript 기능 집합을 가질 수 있다.

### 한도 (Editions / Limits)

| 항목 | 값 |
|---|---|
| 단일 static resource 최대 크기 | **5 MB** |
| org당 static resource 총량 | **250 MB** |
| 사용 가능 환경 | Salesforce Classic (일부 org에서는 사용 불가)와 Lightning Experience 양쪽 |
| 사용 가능 Edition | Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, Developer Editions |
| 생성에 필요한 권한 | Customize Application |

> PDF 원문: *"A single static resource can be up to 5 MB, and an organization can have up to 250 MB of static resources, total."*

### Static Resource 생성 절차

1. Setup의 Quick Find 박스에 `Static Resources`를 입력하고 **Static Resources**를 선택한다.
2. **New**를 클릭한다.
3. Visualforce 마크업에서 리소스를 식별하는 이름을 입력한다. (밑줄과 영숫자만 포함, org 내 고유, 문자로 시작, 공백 없음, 밑줄로 끝나지 않음, 연속 밑줄 없음)
   - Note: Visualforce 마크업에서 static resource를 참조한 후 리소스 이름을 변경하면, Visualforce 마크업이 그 변경을 반영하도록 업데이트된다.
4. 필요하면 description을 지정한다.
5. static resource를 업로드하려면 **Browse**를 클릭하고 로컬 파일을 선택한다.
   - Warning: WinZip으로 static resource 파일을 압축하는 경우 최신 버전을 설치해야 한다. 구버전 WinZip은 데이터 손실을 유발할 수 있다.
6. user session(API 및 Experience Cloud user session 포함)에 대한 cache control을 설정한다.
   - **private**으로 설정하면, static resource는 모든 인증된 사용자에게 접근 가능하다. static resource는 session 기간 동안 사용자의 개별 캐시에 Salesforce 서버에 저장된다.
     - Note: Salesforce Site에 IP range나 login hours 기반의 guest user profile 제한이 있으면, static resource의 cache control은 private으로 설정된다. 제한이 있는 Salesforce Site는 브라우저 내에서만 static resource를 캐시한다. 이전에 제한이 없던 Salesforce Site가 제한되면, static resource가 Salesforce 캐시 및 중간 캐시에서 만료되는 데 최대 **45일**이 걸릴 수 있다.
   - **public**으로 설정하면, static resource는 캐시된 후 인증되지 않은 사용자를 포함한 모든 인터넷 트래픽에 접근 가능하다. 리소스는 공유 캐시에 Salesforce 서버에 저장되어 더 빠른 로드 시간을 제공한다.
7. 변경 사항을 저장한다.

### Visualforce 마크업에서 Static Resource 참조

참조 방식은 stand-alone 파일을 참조하는지, 아카이브(`.zip`/`.jar`) 내 파일을 참조하는지에 따라 다르다.

- **단독(standalone) 파일:** `$Resource.<resource_name>`을 merge field로 사용한다.

```xml
<apex:image url="{!$Resource.TestImage}" width="50" height="50"/>
```

또는

```xml
<apex:includeScript value="{!$Resource.MyJavascriptFile}"/>
```

- **아카이브 내 파일:** `URLFOR` 함수를 사용한다. 첫 번째 파라미터에 업로드 시 제공한 static resource 이름을, 두 번째에 아카이브 내 원하는 파일 경로를 지정한다.

```xml
<apex:image url="{!URLFOR($Resource.TestZip,
'images/Bluehills.jpg')}" width="50" height="50"/>
```

또는

```xml
<apex:includeScript value="{!URLFOR($Resource.LibraryJS, '/base/subdir/file.js')}"/>
```

- **아카이브 내 상대 경로:** static resource 아카이브 내 파일에서 상대 경로를 사용하여 아카이브 내 다른 콘텐츠를 참조할 수 있다. 예를 들어 `styles.css` CSS 파일에 다음 스타일이 있을 때:

```css
table { background-image: url('img/testimage.gif') }
```

`styles.css`와 `img/testimage.gif`를 포함하는 아카이브(zip 파일 등)를 만들어 경로 구조를 보존한 채 `style_resources`라는 static resource로 업로드한 뒤 페이지에 다음 component를 추가한다.

```xml
<apex:stylesheet value="{!URLFOR($Resource.style_resources, 'styles.css')}"/>
```

static resource가 style sheet와 image 모두를 포함하므로 style sheet의 상대 경로가 해석되고 이미지가 표시된다.

- **custom controller로 동적 참조:** custom controller를 통해 `<apex:variable>` 태그로 static resource 내용을 동적으로 참조할 수 있다. 먼저 custom controller를 만든다.

```apex
global class MyController {
public String getImageName() {
return 'Picture.gif';//this is the name of the image
}
}
```

그런 다음 `<apex:variable>` 태그에서 `getImageName` 메서드를 참조한다.

```xml
<apex:page renderAs="pdf" controller="MyController">
<apex:variable var="imageVar" value="{!imageName}"/>
<apex:image url="{!URLFOR($Resource.myZipFile, imageVar)}"/>
</apex:page>
```

zip 파일에서 이미지 이름이 변경되면 `getImageName`의 반환 값만 변경하면 된다.

### iframe으로 신뢰할 수 없는 서드파티 콘텐츠 참조

신뢰할 수 없는 소스에서 다운로드한 static resource는 격리하는 것이 좋다. iframe을 사용하여 서드파티 콘텐츠를 Visualforce 페이지에서 분리하면 추가 보안 계층을 제공하고 자산을 보호할 수 있다.

별도 도메인의 정적 HTML 파일을 참조하려면 `$IFrameResource.<resource_name>`을 merge field로 사용한다.

```xml
<apex:iframe src="{!$IFrameResource.TestHtml}" id ="theiframe" width="500" height="500"/>
```

iframe 태그는 parent document와 child iframe 양쪽에 JavaScript를 주입하여 두 요소 간의 안전한 통신을 설정한다. parent document는 여러 iframe을 가질 수 있다. 고유하게 명명된 각 static resource는 `force-user-content.com`의 자체 subdomain에 위치한다. iframe에 대한 접근은 인증되지 않으므로, 포함된 서드파티 콘텐츠는 사용자의 session ID에 접근할 수 없다.

**Parent Document에서 iframe과 통신** (`SfdcApp.iframe`):

```javascript
// theiframe에 메시지 보내기
SfdcApp.iframe.sendMessage('theiframe', {
key1: value1,
key2: value2
});
```

```javascript
// theiframe에서 메시지 받기
SfdcApp.iframe.addMessageHandler('theiframe', function(data) {
if(data.key1) {
…
}
});
```

```javascript
// theiframe에서 에러 잡기
SfdcApp.iframe.addErrorHandler('theiframe', function(error) {
console.log(error);
});
```

**iframe에서 Parent Document와 통신** (`LCC.onlineSupport`):

```javascript
// parent document에 메시지 보내기
LCC.onlineSupport.sendMessage('containerUserMessage', {
key1: value1,
key2: value2
});
```

```javascript
// parent document에서 메시지 받는 핸들러 설정
LCC.onlineSupport.addMessageHandler(function(message) {
if(data.key1) {
…
}
});
```

```javascript
// 위 핸들러 제거
LCC.onlineSupport.removeMessageHandler(function)
```

```javascript
// parent document에서 메시지 에러 핸들러 설정
LCC.onlineSupport.addMessageErrorHandler(function(message) {
if(data.key1) {
…
}
});
```

```javascript
// 위 핸들러 제거
LCC.onlineSupport.removeMessageErrorHandler(function)
```

```javascript
// 기타 타입 에러 핸들러 설정
LCC.onlineSupport.addErrorHandler(function(message) {
if(data.key1) {
…
}
});
```

```javascript
// 위 핸들러 제거
LCC.onlineSupport.removeErrorHandler(function)
```

---

## 7. 커스텀 컴포넌트 (Ch11)

Salesforce는 `<apex:relatedList>`, `<apex:dataTable>` 같은 표준 사전 빌드 component 라이브러리를 제공한다. 여기에 더해 자신만의 커스텀 component를 만들어 라이브러리를 보강할 수 있다.

### 커스텀 컴포넌트란?

메서드에 코드를 캡슐화하여 여러 번 재사용하듯, 공통 디자인 패턴을 커스텀 component에 캡슐화하여 하나 이상의 Visualforce 페이지에서 여러 번 재사용할 수 있다. 예를 들어 각 사진마다 테두리 색과 캡션이 있는 포토 앨범에서, 모든 사진에 대한 마크업을 반복하는 대신 image·border color·caption 속성을 가진 `singlePhoto` 커스텀 component를 정의하여 재사용한다.

마크업 재사용을 가능하게 하는 page template과 달리 커스텀 component가 더 강력하고 유연한 이유:

- 커스텀 component는 각 component에 전달할 수 있는 **attribute를 정의**할 수 있다. attribute 값은 최종 페이지에 표시되는 마크업과 해당 component 인스턴스에 대해 실행되는 controller 기반 로직을 변경할 수 있다. template은 template을 사용하는 페이지에서 template 정의 자체로 정보를 전달하는 방법이 없다.
- 커스텀 component 설명은 애플리케이션의 component reference dialog에 표준 component 설명과 함께 표시된다. 반면 template 설명은 페이지로 정의되므로 Setup 영역을 통해서만 참조할 수 있다.

### 커스텀 컴포넌트 정의 절차 (Defining)

1. Setup에서 Quick Find 박스에 `Components`를 입력하고 **Visualforce Components**를 선택한다.
2. **New**를 클릭한다.
3. **Label** 텍스트 박스에 Setup 도구에서 커스텀 component를 식별할 텍스트를 입력한다.
4. **Name** 텍스트 박스에 Visualforce 마크업에서 이 커스텀 component를 식별할 텍스트를 입력한다. (밑줄·영숫자만, org 내 고유, 문자로 시작, 공백 없음, 밑줄로 끝나지 않음, 연속 밑줄 없음)
5. **Description** 텍스트 박스에 설명을 입력한다. 저장하는 즉시 다른 표준 component 설명과 함께 component reference에 나타난다.
6. **Body** 텍스트 박스에 커스텀 component 정의를 위한 Visualforce 마크업을 입력한다. **단일 component는 최대 1 MB(약 1,000,000자)의 텍스트를 보유**할 수 있다.
7. **Version Settings**를 클릭하여 이 component와 함께 사용할 Visualforce 및 API 버전을 지정한다.
8. **Save**(저장 후 detail 화면) 또는 **Quick Save**(저장 후 계속 편집)를 클릭한다. 저장하려면 Visualforce 마크업이 유효해야 한다.

> Note (development mode quick fix): 아직 정의되지 않은 커스텀 component 참조를 페이지 마크업에 추가하고 저장하면 quick fix 링크가 나타나 새 component 정의를 생성할 수 있다. 예를 들어 `myNewComponent`가 정의되지 않은 상태에서 `<c:myNewComponent myNewAttribute="foo"/>`를 삽입하고 Save하면, 다음 default 정의로 `myNewComponent`를 정의하는 quick fix가 제공된다.

```xml
<apex:component>
<apex:attribute name="myattribute" type="String" description="TODO: Describe me"/>
<!-- Begin Default Content REMOVE THIS -->
<h1>Congratulations</h1>
This is your new Component: mynewcomponent
<!-- End Default Content REMOVE THIS -->
</apex:component>
```

생성 후 `http://yourSalesforceOrgURL/apexcomponent/nameOfNewComponent`에서 볼 수 있다. component가 attribute나 component 태그 body의 콘텐츠에 의존하면 이 URL은 예상치 못한 결과를 낼 수 있으므로, 더 정확한 테스트를 위해 Visualforce 페이지에 추가하여 페이지를 본다.

### 커스텀 컴포넌트 마크업

커스텀 component의 모든 마크업은 `<apex:component>` 태그 안에 정의된다. 이 태그는 커스텀 component 정의의 **top-level 태그**여야 한다.

```xml
<apex:component>
<b>
<apex:outputText value="This is my custom component."/>
</b>
</apex:component>
```

마크업은 다른 Visualforce 페이지처럼 Visualforce와 HTML 태그의 조합일 수 있다. 더 복잡한 예 — 여러 Visualforce 페이지에서 사용되는 form을 만드는 `recordDisplay` component:

```xml
<apex:component>
<apex:attribute name="record" description="The type of record we are viewing."
type="Object" required="true"/>
<apex:pageBlock title="Viewing {!record}">
<apex:detail />
</apex:pageBlock>
</apex:component>
```

이를 사용하는 `displayRecords` 페이지:

```xml
<apex:page >
<c:recordDisplay record="Account" />
</apex:page>
```

이 예가 제대로 렌더링되려면 URL에서 Visualforce 페이지를 유효한 account 레코드와 연결해야 한다. 예를 들어 `001D000000IRt53`이 account ID이면 결과 URL은 `https://MyDomain_login_URL/apex/displayRecords?id=001D000000IRt53`이다. `record="Contact"`로 교체하면 Contact 정보를 표시한다.

### Visualforce 페이지에서 커스텀 컴포넌트 사용

`<apex:component>` 태그의 body는 component가 포함될 때마다 표준 Visualforce 페이지에 추가되는 마크업이다. 예를 들어 `myComponent`라는 이름으로 저장된 component를 사용하는 페이지:

```xml
<apex:page standardController="Account">
This is my <i>page</i>. <br/>
<c:myComponent/>
</apex:page>
```

출력:

```
This is my page.
This is my custom component.
```

Visualforce 페이지에서 커스텀 component를 사용하려면 component 이름에 정의된 **namespace를 prefix로** 붙여야 한다. 예를 들어 `myComponent`가 `myNS` namespace에 정의되었으면 `<myNS:myComponent>`로 참조한다. 편의를 위해, 연관된 페이지와 같은 namespace에 정의된 component는 **`c` namespace prefix**도 사용할 수 있다 — 즉 같은 namespace이면 `<c:myComponent>`로 참조 가능하다.

커스텀 component에 콘텐츠를 삽입하려면 **`<apex:componentBody>`** 태그를 사용한다. 표준 component와 마찬가지로, 커스텀 component가 업데이트되거나 편집되면 이를 참조하는 Visualforce 페이지도 업데이트된다.

### 버전 설정 관리

Visualforce 페이지나 커스텀 component를 편집하고 **Version Settings**를 클릭 → Salesforce API의 **Version**(= 페이지/component에 사용되는 Visualforce 버전)을 선택 → **Save**.

> Note: 페이지나 커스텀 component의 version settings는 Setup에서 편집할 때 Version Settings 탭에서만 수정할 수 있다.

### 커스텀 컴포넌트 Attribute

표준 Visualforce 마크업 외에, `<apex:component>` 태그의 body는 component가 Visualforce 페이지에서 사용될 때 전달될 수 있는 attribute를 지정할 수 있다. 이러한 attribute 값은 component에서 직접, 또는 component의 controller(있는 경우)에서 사용될 수 있다. 단, **component controller의 constructor에서는 사용할 수 없다.**

Attribute는 `<apex:attribute>` 태그로 정의한다. 다음 커스텀 component 정의는 `value`와 `textColor`라는 두 개의 required attribute를 지정한다.

> [sic] 산문은 *"two required attributes named value and textColor"*라고 하지만, 아래 코드의 첫 attribute name은 실제로 `myValue`이다. PDF 원문의 본문↔코드 불일치이며 양쪽 모두 그대로 보존한다.

```xml
<apex:component>
<!-- Attribute Definitions -->
<apex:attribute name="myValue" description="This is the value for the component."
type="String" required="true"/>
<apex:attribute name="textColor" description="This is color for the text."
type="String" required="true"/>
<!-- Component Definition -->
<h1 style="color:{!textColor};">
<apex:outputText value="{!myValue}"/>
</h1>
</apex:component>
```

Visualforce 페이지에서 사용:

```xml
<c:myComponent myValue="My value" textColor="red"/>
```

`<apex:attribute>` 태그는 **`name`, `description`, `type`** attribute 값을 필수로 요구한다.

- **`name`** — 커스텀 attribute가 Visualforce 페이지에서 참조되는 방식을 정의한다. name은 component 간 고유해야 하며 **대소문자를 구분하지 않는다.** 예를 들어 "Model"과 "model"이라는 두 attribute가 있으면 패키지는 이를 동일하게 취급하여 예상치 못한 동작을 유발할 수 있다.
- **`description`** — 커스텀 component가 저장된 후 component reference library에 나타나는 attribute의 help text를 정의한다.
- **`type`** — attribute의 Apex 데이터 타입을 정의한다. type attribute 값으로 허용되는 데이터 타입은 다음뿐이다 (허용값 5종):
  1. **Primitives** — String, Integer, Boolean 등.
  2. **sObjects** — Account, My_Custom_Object__c, 또는 generic sObject 타입 등.
  3. **One-dimensional lists** — array-notation으로 지정, 예: `String[]`, `Contact[]`.
  4. **Maps** — `type="map"`으로 지정. map의 구체적 데이터 타입은 지정할 필요 없다.
  5. **Custom Apex classes**.

> 추가 `<apex:attribute>` attribute는 PDF의 *apex:attribute on page 423* (Standard Component Reference) 참조.

#### Default Custom Component Attributes (항상 생성, 2종)

커스텀 component에는 항상 두 attribute가 생성되며, component 정의에 포함할 필요가 없다.

- **`id`** — 커스텀 component가 페이지의 다른 component에 의해 참조될 수 있게 하는 식별자. 지정하지 않으면 고유 식별자가 자동 생성된다.
- **`rendered`** — 커스텀 component가 페이지에 렌더링되는지 여부를 지정하는 Boolean 값. 지정하지 않으면 기본값은 `true`이다.

### 커스텀 컴포넌트 Controller

표준 Visualforce 페이지처럼 커스텀 component도 Apex로 작성된 controller와 연결될 수 있다. 이 연결은 component에 **`controller` attribute**를 설정하여 이루어진다. controller를 사용해 component 마크업을 연관 페이지에 반환하기 전에 추가 로직을 수행할 수 있다.

**controller에서 커스텀 component attribute 접근:**

1. attribute 값을 저장할 property를 controller에 정의한다.
2. property에 대한 getter와 setter 메서드를 정의한다.

```apex
public class myComponentController {
public String controllerValue;
public void setControllerValue (String s) {
controllerValue = s.toUpperCase();
}
public String getControllerValue() {
return controllerValue;
}
}
```

setter가 값을 수정한다는 점에 유의한다.

3. component 정의의 `<apex:attribute>` 태그에서 **`assignTo`** attribute를 사용해 attribute를 위에서 정의한 class 변수에 바인딩한다.

```xml
<apex:component controller="myComponentController">
<apex:attribute name="componentValue" description="Attribute on the component."
type="String" required="required" assignTo="{!controllerValue}"/>
<apex:pageBlock title="My Custom Component">
<p>
<code>componentValue</code> is "{!componentValue}"
<br/>
<code>controllerValue</code> is "{!controllerValue}"
</p>
</apex:pageBlock>
Notice that the controllerValue has been upper cased using an Apex method.
</apex:component>
```

> Note: `assignTo` attribute를 사용할 때는 getter와 setter 메서드, 또는 get/set 값을 가진 property가 반드시 정의되어야 한다.

4. component를 페이지에 추가한다.

```xml
<apex:page>
<c:simpleComponent componentValue="Hi there, {!$User.FirstName}"/>
</apex:page>
```

> [sic] §7 controller 예제는 controller class를 `myComponentController`, attribute를 `componentValue`로 정의하지만, 마지막 페이지 마크업은 `<c:simpleComponent>`를 참조한다 — PDF 원문의 component 이름 불일치이며 그대로 보존한다.

Apex controller 메서드가 `controllerValue`를 변경하여 대문자 문자로 표시되도록 한다.

> PDF에 출력 스크린샷(다이어그램) 있음 — 본 wiki에는 텍스트 설명만 포함한다.

---

## 관련 노트

- [[Static Resource 로딩]] — LWC 관점의 static resource: 런타임 `loadScript`/`loadStyle`로 서드파티 JS/CSS를 로드 (VF의 마크업 시점 `$Resource`/`URLFOR`와 대비). 경로: `LWC/UIPatterns(UI패턴)/Static Resource 로딩.md`
- [[표준 컨트롤러·표준 리스트 컨트롤러]] — Visualforce 표준 컨트롤러
- [[커스텀 컨트롤러·컨트롤러 확장]] — Visualforce 컨트롤러 확장·커스텀 컨트롤러
- [[apex 컴포넌트 — 입력·폼]] — `apex:component`/`apex:attribute` 커스텀 컴포넌트 정의 태그 레퍼런스
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] — `apex:page`·`apex:pageBlock` 등 컨테이너 컴포넌트
