---
tags: [admin, ui, custom-buttons, custom-links, examples, javascript-button, reference]
source: help.salesforce.com (Custom Button and Link Samples[platform.links_useful_custom_buttons] 및 하위 예제 아티클 · Add Default Custom Links[platform.adding_default_custom_links]; 라이브 공식 문서·브라우저 렌더, Tier 2, 접속 2026-07-19)
created: 2026-07-19
aliases: [Custom Button Samples, Custom Link Samples, 버튼 링크 샘플, Link to Documents, Link to Reports, Mass Delete 버튼, Clone Records, Default Custom Links, JavaScript 버튼 예제]
---

# Custom Button & Link 샘플 예제

> 문서·Chatter 파일·리포트 링크, 대량 삭제·복제·레코드 ID·케이스 재오픈 등 공식 커스텀 버튼/링크 샘플 11종 + 기본 커스텀 링크(Default Custom Links) 추가 방법.

---

## 개요

Salesforce 공식 문서(Custom Button and Link Samples)는 **복사·수정해서 그대로 쓸 수 있는** 커스텀 버튼·링크 예제 11종을 제공한다. 이 노트는 그 11종의 샘플과, 사전 정의된 커스텀 링크를 추가하는 **Add Default Custom Links** 절차를 정리한다. 생성 절차·필드·URL 구성 일반론은 [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]]를, 개념 개요는 [[Custom Buttons & Links (커스텀 버튼·링크)]]를 참조한다.

**타입 구분 주의:**

- **링크 타입(URL)** — 문서·파일·리포트 링크처럼 도메인을 제거한 상대 URL을 Content Source=URL로 넣는 방식. Lightning Experience에서도 대체로 동작한다.
- **버튼 타입(OnClick JavaScript)** — Mass Delete·Display Alerts·Get Record IDs 등 다수 샘플이 사용하는 방식. **OnClick JavaScript 커스텀 버튼은 Salesforce Classic 전용 레거시로, Lightning Experience와 Salesforce 모바일 앱에서 지원되지 않는다.**

**공통 Edition / 권한** (모든 샘플 공통):

- Available in: **Salesforce Classic**
- Custom buttons and links are available in: **All Editions**
- Visualforce pages and s-controls are available in: **Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, and Developer Editions**
- User Permissions Needed — To create or change custom buttons or links: **Customize Application**

> ⚠️ **정직성 명시:** 아래 **완전 예제 3종**(Link to Documents / Link to Files in Chatter / Link to Reports)만 이번 추출에서 절차 전문이 확보되었다. **나머지 8종은 본문(특히 JavaScript 코드)이 이번 추출에서 확보되지 않아**(콘텐츠 필터), 각 예제의 설명 1줄 + 공식 문서 링크로만 안내한다. 8종의 실제 코드는 반드시 공식 문서에서 직접 확인할 것 — 이 노트는 그 코드를 지어내지 않는다.

---

## 완전 예제 3종 (절차 전수)

### Link to Documents

> Use custom links to reference documents from a Salesforce record detail page. (Salesforce 레코드 상세 페이지에서 Documents 탭의 문서를 참조하는 커스텀 링크.)

1. Create a folder on the Documents tab to which all users have access. (모든 사용자가 접근 가능한 폴더를 Documents 탭에 생성.)
2. Upload the document to that folder.
3. From the Documents tab, choose the folder and click **Go**.
4. Click **View** next to the document.
5. Copy the document's URL from the browser. For example:

```
https://MyDomainName.my.salesforce.com/servlet/servlet.FileDownload?file=015300000000xvU
```

6. Use everything after the domain portion of the URL to create your custom link. Using the example in the previous step, your link would point to:

```
/servlet/servlet.FileDownload?file=015300000000xvU
```

### Link to Files in Chatter

> Use custom links to reference files from Chatter. (Chatter의 Files를 참조하는 커스텀 링크.)

1. Upload a file to the Files tab.
2. When the upload is finished, from the Upload dialog box, click **Share settings**.
3. Click **Anyone with link**.
4. Copy the document's URL from the Share via Link dialog box. For example:

```
https://MyDomainName.my.salesforce.com/sfc/p/D0000000JsES/a/D000000001dd/aiq8UPJ5q5i6Fs4Sz.IQLKUERsWYdbAm320cjqWnkfk=
```

5. Use everything after the domain portion of the URL to create your custom link. Using the example in the previous step, your link would point to:

```
/sfc/p/D0000000JsES/a/D000000001dd/aiq8UPJ5q5i6Fs4Sz.IQLKUERsWYdbAm320cjqWnkfk=
```

### Link to Reports

> Use custom links to run reports with filtered results from a Salesforce record detail page. For example, let's say you frequently run a mailing list report for the contacts related to an account. You can create a custom link for accounts that links directly to a report that is automatically filtered to the account that you're viewing. In this case, your custom link must pass the account's unique record ID to the report. (레코드 상세 페이지에서, 현재 보고 있는 레코드로 자동 필터된 리포트를 실행하는 커스텀 링크. 계정의 고유 레코드 ID를 리포트에 전달해야 한다.)

1. Copy the ID for the type of record by which you want to filter your report. This example uses an account record. To do so, view the record and copy the 15-character ID from the last part of the URL. For example, from `https://MyDomainName.my.salesforce.com/001200030012j3J`, copy `001200030012j3J`.
2. From the Reports tab, create the report you want by either customizing a standard report or creating a custom report.
3. Filter the report by the record ID you copied. For example, **Account ID equals 001200030012j3J**.
4. Run the report and verify that it contains the data you expect.
5. Click **Customize**.
6. To save the report to a public folder where it's accessible by the appropriate users, click **Save** or **Save As**. Save doesn't create a custom report, whereas Save As does.
7. Run the report and copy the report's URL from the browser.
8. Begin creating your custom link. Set the **Content Source** field to **URL**. In the large formula text area, paste the report URL that you copied. Remember to omit the domain portion `https://MyDomainName.my.salesforce.com`.
9. Add the custom link to the appropriate page layouts.
10. Verify that the new custom link works correctly.

> **Tip:** When creating a report for use in a custom link, set date ranges and report options generically so that report results include data that can be useful for multiple users. For example, if you set a date range using a record's Created Date, set the Start Date far enough in the past to not exclude any relevant records and leave the End Date blank. If you scope the report to just My records, the report doesn't always include all records that a user can see. Try setting the report options to **All visible records**.

---

## 나머지 8종 (설명 + 공식 문서 링크)

> 아래 8종은 이번 추출에서 **본문·JavaScript 코드가 콘텐츠 필터로 확보되지 않았다.** 방식은 혼재한다 — OnClick JavaScript 버튼(Classic 레거시: Mass Delete·Display Alerts·Get Record IDs·Clone·Reopen Cases 등), Visualforce 페이지 호출(Pass Record IDs), URL 버튼(Record Create with DFV — LEX), 링크(International Maps). 실제 코드·상세 절차는 각 공식 문서 링크에서 직접 확인한다. (아래 설명은 상위 "IN THIS SECTION" 목록에서 발췌한 공식 요약이며, 코드는 이 노트에서 창작하지 않는다.)

| 예제명 | 설명 (공식 요약) | 공식 링크 |
|---|---|---|
| Mass Delete (버튼) | This example creates a JavaScript custom button for Salesforce Classic that can be added to activity-related lists and list views and allows users to delete selected records at the same time. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_mass_delete.htm&type=5` |
| Display Alerts (버튼) | This example creates a button that opens a window with a welcome message containing the user's first name. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_displaying_alerts.htm&type=5` |
| Clone Records (버튼) | The clone button is available for most standard objects. When a clone button is not available by default for a standard or custom object, you can create a custom clone button or link. This example creates a button that passes the field values of the record you're on to a record create page. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_clone_records.htm&type=5` |
| Get Record IDs (버튼) | This example creates a button that opens a window listing record IDs for user selected records. Getting record IDs is useful when testing to ensure that you have the correct records before processing them further. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_record_ids.htm&type=5` |
| Pass Record IDs to an External System (버튼) | You can use Salesforce record IDs as unique identifiers for integrating with an external system. This example creates a button that calls a Visualforce page to determine the record IDs of selected records and passes them in a URL query parameter to an external Web page called www.yourwebsitehere.com. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_passing_record_ids.htm&type=5` |
| Record Create Page with Default Field Values (버튼) | Construct custom buttons and links that pass default field values to a record create page. This feature applies to Lightning Experience in all editions. This feature doesn't apply to Lightning Out, Experience Builder sites, or the Salesforce mobile app. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_create_record_dfv.htm&type=5` |
| Reopen Cases (버튼) | This example creates a button that can be added to cases related lists so that users can reopen several cases on an opportunity at once. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_reopening_cases.htm&type=5` |
| International Maps (링크) | This example creates a link that displays a country-specific Google map. | `https://help.salesforce.com/s/articleView?id=platform.links_useful_custom_buttons_international_maps.htm&type=5` |

> Record Create Page with Default Field Values는 위 요약대로 **Lightning Experience(all editions)** 에 적용되며, Lightning Out·Experience Builder 사이트·Salesforce 모바일 앱에는 적용되지 않는다. OnClick JavaScript 방식 샘플(Mass Delete·Display Alerts·Get Record IDs·Clone·Reopen Cases 등)은 Salesforce Classic 전용 레거시다.

---

## Add Default Custom Links (기본 커스텀 링크 추가)

> Update predefined custom links for account, contact, lead, campaign, and solution detail pages. (account·contact·lead·campaign·solution 상세 페이지의 사전 정의된 커스텀 링크를 추가·수정.)

**Required Editions**

- Available in: **Salesforce Classic**
- Available in: **All Editions except Database.com**

**User Permissions Needed** — To create or change custom links: **Customize Application**

1. From the management settings for the appropriate object, go to **Buttons, Links, and Actions** or to **Buttons and Links**.
2. Click **Default Custom Links**.
3. Next to a sample link you want to add, click **Add Now!**.
4. Change the default data for the link, as necessary.
5. Save your changes.
6. To display the new link, edit the page layout for the appropriate tab.

---

## 관련 노트

- [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]] — 생성 절차·필드·URL 구성
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 개요
- [[Formula 필드 예제 카탈로그]] — HYPERLINK 수식 예제와 유사
