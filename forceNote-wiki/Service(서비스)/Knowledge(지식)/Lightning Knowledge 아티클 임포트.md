---
tags: [Service, Knowledge, LightningKnowledge, 임포트, Import, CSV, ZIP, properties, ImportParameters, ImportStatus, Admin, Migration]
source: lightning_knowledge_guide.pdf (Spring '26, p.52–62)
created: 2026-06-17
aliases: [Knowledge 임포트, Article Import, .csv 임포트, .zip 임포트, Import Parameters, .properties 파일, Import Export Status, Import External Content, 아티클 임포트 csv, csv로 아티클 올리기, 외부 콘텐츠 가져오기, 아티클 대량 임포트, 아티클 마이그레이션, Knowledge 아티클 csv 양식, 임포트 상태 확인, bulk import articles]
---

# Lightning Knowledge 아티클 임포트

> 외부 콘텐츠를 Salesforce Knowledge로 임포트하기 — .csv·.properties·.zip 파일 구성, 임포트 파라미터, 그리고 import/export 상태 추적까지.

---

## Import External Content 개요

**Title (본문 H1):** Import External Content into Salesforce Knowledge *(TOC 레이블은 "Import Articles"로 다름)*

> **Editions:** standard block (Classic and Lightning).

외부 아티클이나 정보 데이터베이스를 임포트한다. Classic에서 Lightning으로 콘텐츠를 옮기려면 migration tool을 쓴다.

> [!note] Note (verbatim)
> localization vendor에게 보낸 번역 아티클을 임포트하는 방법을 찾고 있다면, Import Translated Articles를 참조하라. (→ [[Lightning Knowledge 다국어 & 번역]])

**Best practices / requirements (전수):**

- 작은 아티클 집합으로 임포트를 테스트하라.
- 아티클을 정보 유형별로 정렬하라. Classic에서는 각 article type을 개별적으로 임포트한다. Lightning에서는 여러 record type의 아티클을 한 번에 임포트할 수 있다.
- 각 정보 유형이 그 구조·콘텐츠에 맞는 record type(또는 Classic에서는 article type)을 갖도록 보장하라. 각 유형에서 사용 가능한 필드 목록을 만들고 아티클 콘텐츠가 일치하는지 검증하라.
- 아티클의 field-level security 설정이 필드 편집을 허용하는지 검증하라.
- HTML 콘텐츠를 임포트하려면 rich text 필드를 쓴다. 각 rich text area 필드에 대해 `.html` 파일을 준비하라. HTML이 rich text area 필드에서 지원되는 태그/속성을 준수하는지 보장하라.
- 아티클 importer는 **subfield를 지원하지 않는다.** 필드 안에 필드가 있으면, 임포트 전에 구조를 조정하라.

하위 단계: Create a .csv File for Article Import; Set Article Import Parameters; Create an Article .zip File for Import; Article and Translation Import and Export Status.

---

## .csv 파일 만들기

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS:** 아티클 임포트 — **Manage Salesforce Knowledge AND Manage Articles AND Manage Knowledge Article Import/Export AND Read, Create, Edit, and Delete on the article type.**

> [!important] Important (verbatim)
> Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

### Step 1 — .zip/.csv 제약 (전수, 핵심 한도)

> Note: Classic에서는 각 article type을 별도로 임포트한다(타입당 .csv 1개). Lightning에서는 한 .csv에 여러 타입을 임포트하고 임포트 중에 record type을 설정한다.

- **.csv 파일 1개와 .properties 파일 1개만** 있을 수 있다.
- .csv와 .properties 파일은 **root directory**에 있어야 한다.
- 압축 프로세스는 folder와 subfolder 구조를 보존해야 한다.
- .zip 파일 이름에 특수 문자를 포함할 수 없다.
- **.zip 파일은 20 MB를 초과할 수 없다**; zip 내 개별 비압축 파일은 **10 MB를 초과할 수 없다**.
- **.csv 파일은 header 행 포함 10,000 행을 초과할 수 없다.** 따라서 최대 **9,999 articles and translations**.
- **.csv 파일 행은 400,000 characters를 초과할 수 없다.**
- **.csv 파일 셀은 32 KB를 초과할 수 없다.**
- .csv의 각 아티클은 **49 translations를 초과할 수 없다.**

### Step 2 — 첫 행 필드/메타데이터 (Field or data / Description) — 전수

| Field or data | Description |
|---|---|
| isMasterLanguage | Identifies the article as a primary (1) or translation (0). Required to import articles with translations; however, **isMasterLanguage can't be in a .csv file to import articles without translations.** A translation must follow its primary article so it's associated with the preceding primary article. |
| Title | The article or translation's title. **Required for all imports.** |
| Record Type | Indicates an article's record type (e.g., FAQ). Article import requires the **15-character, case-sensitive ID format**. |
| Standard and custom fields | Refer to standard fields using field names and custom fields using API names. If a related mandatory field is left empty, articles can be skipped. |
| Rich text area field | Use rich text area custom fields to import .html files or images. Refer using its API name. |
| File field | Use file custom fields to import any file type (.doc, .pdf, .txt). Refer using its API name. |
| Data category groups | To categorize imported articles, use category groups. Refer to a category group using its unique name prefixed with `datacategorygroup.`. E.g., `datacategorygroup.Products` for the category group Products. |
| Channel | To specify where imported articles are available, use the keyword **Channels**. |
| Language | Specify the articles' language. Required to import articles with translations. Optional without translations. If omitted, articles belong to the default knowledge base language and you can't import translations with the primary articles. |

### Step 3 — 후속 행 (아티클당 1행)

> [!important] Important (verbatim)
> All file names are case-sensitive and must exactly match what is in the .csv file.

**Consideration / Notes 표 (전수):**

| Consideration | Notes |
|---|---|
| Standard or custom fields | Enter the articles' data for each field, except for rich text area fields where you must enter the **relative path to the corresponding .html file** in your .zip file. The article importer does not support subfields. |
| Rich text area field | Always enter the .html file path **relative** to the location of the .csv file. Never enter raw text. If the path doesn't exist, the related article isn't imported. • Recommend one folder for .html files (e.g., `/data`) and another for images (e.g., `/data/images`). • To import images, include them in an .html file using the `<img>` tag and `src` attribute; `src` value must be a **relative path** from the .html file to the image folder. • Images must be **.png, .gif, or .jpeg** files. • Each image file **can't exceed 1 MB**. • If you have multiple rich text area fields, create a separate .html file for each. • .html file contents can't exceed the maximum size for its field. • If a date doesn't match the date format specified in the property file, the related article isn't imported. • If an .html file references a file that isn't allowed, the related article isn't imported. • If an .html file references an image that's missing, the related article is imported without the image. |
| File field | In Lightning Knowledge, custom file fields are replaced with **Salesforce Files**. Enter the path relative to the file's location. If the path doesn't exist, the article isn't imported. • Recommend a folder for your files (e.g., `/files`). • Each file **must not exceed 5 MB**. |
| Category groups | Use unique category names to categorize articles. Use the plus symbol (+) to specify more than one (e.g., `Laptop+Desktop`). • Leaving the cell empty sets the article to **No Categories**. • If you specify a category and its parent (e.g., `Europe+France`), the import skips the child (France) and keeps the parent (Europe), because applying a parent implicitly includes children. • When importing articles with translations and data categories, **only the primary article retains the data categories**; translations have none upon import. |
| Channels | Specify channels using keywords: • **`application`** for Internal App (default if no channel specified). • **`sites`** for Public Knowledge Base. • **`csp`** for Customer. • **`prm`** for Partner. Use `+` for more than one (e.g., `application+sites+csp` for all channels). When importing with translations and channels, **only the primary article retains channels**; translations have none upon import. |

### .csv 예시 (PDF verbatim)

`articlesimport.csv` (without translations):

```
Title,summary__c,description__c,datacategorygroup.Products,Channels,RecordTypeId
Free Digital Camera Offer, Get the new Digital Camera.,data/freecam.html,Consumer_Electronics,application+csp,012RM0000002Q5M
Best Desktop Computer Deals,,data/bestdeals.html,Desktop,application+csp,012RM0000002Q5g
Free Shipping on Laptop and Desktops,,data/freeship.html,Laptop+Desktops,application+csp,012RM0000002Q5M
```

`articlestranslationsimport.csv` (with translations):

```
isMasterLanguage,Title,summary__c,description__c,datacategorygroup.Products,Channels,Language,RecordTypeId
1,Free Digital Camera Offer,Get the new Digital Camera,data/freecam.html,Consumer_Electronics,application+csp,en,012RM0000002Q5M
0,Libérer l'Offre d'Appareil photo digital,Obtenir le nouvel Appareil photo digital.,data/freecam/fr.html,,,fr,012RM0000002Q5M
0,Liberte Oferta Digital de Cámara,Consiga la nueva Cámara Digital.,data/freecam/es.html,,,es,012RM0000002Q5M
1,Best Desktop Computer Deals,,data/bestdeals.html,Desktops,application+csp,en,012RM0000002Q5g
0,Meilleures Affaires d'ordinateurs de bureau,,data/bestdeals/fr.html,,,fr,012RM0000002Q5g
0,Mejores Tratos de ordenadores,,data/bestdeals/es.html,,,es,012RM0000002Q5g
1,Free Shipping on Laptop and Desktops,,data/freeship.html,Laptops+Desktops,application+csp,en,012RM0000002Q5M
0,Libérer Affranchissement sur Portables et Ordinateurs,,data/freeship/fr.html,,,fr,012RM0000002Q5M
0,Liberte Franqueo en Laptops y Ordenadores,,data/freeship/es.html,,,es,012RM0000002Q5M
```

> Example context (verbatim): "The description__c field is a rich text area and only supports paths to .html files. The summary__c field is a text field and only supports raw text. The summary field is optional… The RecordTypeId sets the Product Offer record type for two of the articles, and the 'Best Desktop Computer Deals' article is an FAQ."
>
> **불일치 주의:** sheet 62는 이 데이터를 layout 표로도 렌더링하는데, 그 표에서는 언어 코드가 `en_US`로 나타나는 반면 위 raw .csv는 `en`을 보여준다. (둘은 같은 데이터의 다른 렌더링이며, 코드 표기가 `en` vs `en_US`로 다르게 인쇄됨.)

---

## 임포트 파라미터 설정 (.properties)

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS:** 아티클 임포트 — **Manage Salesforce Knowledge AND Manage Articles AND Manage Knowledge Article Import/Export AND Read, Create, Edit, and Delete on the article type.**

property 파일에 key 이름과 값으로 임포트 파라미터를 지정한다.

| Key | Description | Default Value |
|---|---|---|
| DateFormat | Format of the date to read in the .csv file | `yyyy-MM-dd` |
| DateTimeFormat | Format of the date and time to read in the .csv file | `yyyy-MM-dd HH:mm:ss` |
| CSVEncoding | Character encoding used to read the .csv file | `ISO8859_15_FDIS` |
| CSVSeparator | .csv field separator | `,` (comma) |
| RTAEncoding | Default encoding used for the HTML files (if not specified in the charset attribute from the HTML meta tag). Salesforce does not support UTF-32 character encoding. We recommend using UTF-8. If you specify UTF-16, ensure your HTML files specify the right byte-order mark. | `ISO8859_15_FDIS` |

> [!note] Note (verbatim)
> Specify only Java date formats. Make sure the date format is not misleading. E.g., format `yyyy-M-d` could interpret `2011111` as `2011-01-11` or `2011-11-01`. Specify at least: Two digits for month and day format (MM, dd); Four digits for year format (yyyy). If a date in the .csv doesn't match the format in the property file, the related article isn't imported.

**Steps:** 1. 필수 파라미터로 파일을 만든다. 2. **`.properties`** 확장자로 저장.

**예시 (verbatim `offerarticlesimport.properties`):**

```
DateFormat=yyyy-MM-dd
DateTimeFormat=yyyy-MM-dd HH:mm:ss
CSVEncoding=ISO8859_15_FDIS
CSVSeparator=,
RTAEncoding=UTF-8
```

---

## .zip 파일 만들기

> **USER PERMISSIONS:** 아티클 임포트 — **Manage Salesforce Knowledge AND Manage Articles AND Manage Knowledge Article Import/Export AND Read, Create, Edit, and Delete on the article type.**

**Steps (전수):**

1. 다음을 포함하는 .zip 파일을 만든다: .csv 파일; .html 파일을 담은 폴더; .html이 참조하는 이미지 파일을 담은 폴더; .properties 파일.
   > [!important] Important (verbatim — 4.2와 동일 제약)
   > .csv 1개와 .properties 1개; 둘 다 root directory에; folder/subfolder 구조 보존; .zip 이름에 특수 문자 없음; .zip ≤ 20 MB이고 개별 비압축 파일 ≤ 10 MB; .csv ≤ 10,000 행(header 포함, 최대 9,999 articles+translations); .csv 행 ≤ 400,000 characters; .csv 셀 ≤ 32 KB; 각 아티클 ≤ 49 translations.
2. From Setup, Quick Find 박스에 `Import Articles`를 입력하고 `Import Articles`를 선택.
3. 그다음:
   a. Lightning Knowledge에서는 드롭다운에서 **Knowledge Base**를 선택.
   b. Salesforce Classic에서는 해당 article type을 선택.
4. .zip 파일을 선택하려면 **Browse**를 클릭한 뒤 **OK**.
5. 임포트에 translation이 포함되면 **Contains translations?**를 선택.
   > Note: 선택하면, .csv는 **isMasterLanguage, Title, Language** 컬럼을 포함해야 한다. 선택하지 않으면, .csv는 isMasterLanguage를 포함할 수 없지만 Title 컬럼은 포함해야 한다; Language 컬럼은 translation 없이 선택적이다.
6. **Import Now**를 클릭. 완료되면 log가 첨부된 이메일을 받는다. **Article Imports** 페이지에서 상태를 확인.

---

## Import / Export 상태

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. Essentials and Unlimited Editions with Service Cloud; 추가 비용 others.

상태를 확인하려면, From Setup에서 `Article Imports`를 Quick Find에 입력하고 `Article Imports`를 선택. 여러 언어를 활성화했다면, article과 translation import용 표 하나와 export for translation용 표 하나를 본다.

- **Import information에 포함:** Possible actions; .zip filenames; who submitted and when; Status; Started and completed dates; Article types.
- **Export information에 포함:** Possible actions; .zip filenames; who submitted and when; Status; Started and completed dates.

| Status | Description | Possible Action |
|---|---|---|
| Pending | The import or export starts as soon as the current import or export completes. | You can click **Cancel** to cancel the pending import or export. |
| Processing | The import or export is processing. | If you want to stop the process, or if it's been stopped, call Salesforce Support. Salesforce can stop an import/export if a maintenance task has to be performed or it exceeds one hour. |
| Stopping/Stopped | Salesforce Support is stopping or has already stopped the import or export. | Contact Salesforce Support to restart, or click **Cancel** to cancel an entry. |
| Aborted | The import or export has been canceled. Articles already imported/exported successfully are available in Salesforce. | You can restart, delete an entry by clicking **Del**, or receive the completion email and check details by clicking **Email Log**. |
| Completed | The import or export is complete. (This status doesn't mean it was successful. Click **Email Log** to check details.) Successfully imported articles are shown on the Article Management tab on the Articles subtab; successfully imported translations on the Translations subtab. | Click the exported .zip file to save or open the file on your system. |

---

## 관련 노트

- [[Knowledge REST API — Actions & Manage]]
- [[Lightning Knowledge 다국어 & 번역]]
