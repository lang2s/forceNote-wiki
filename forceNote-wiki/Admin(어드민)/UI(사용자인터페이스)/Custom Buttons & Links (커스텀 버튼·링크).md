---
tags: [admin, ui-customization, custom-buttons, custom-links, url-buttons]
source: help.salesforce.com (Salesforce Help — Custom Buttons and Links; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.defining_custom_links.htm&type=5
created: 2026-07-03
aliases: [Custom Buttons, 커스텀 버튼, Custom Links, 커스텀 링크, URL Button, Visualforce Button]
---

# Custom Buttons & Links (커스텀 버튼·링크)

> 레코드 페이지·리스트 뷰·관련 목록에 커스텀 동작 버튼·링크를 추가하는 기능. URL·Visualforce로 만들며(자바스크립트 버튼은 레거시), page layout에 배치한다.

---

## 개요

**커스텀 버튼(custom button)** 과 **커스텀 링크(custom link)** 는 레코드 detail 페이지, list view, related list에 **커스텀 동작**을 추가하는 UI 커스터마이징 기능이다. 대표적인 동작은 외부 URL 열기, Visualforce 페이지 호출 등이며, 표준 버튼(New·Edit·Delete 등)만으로 커버되지 않는 워크플로우를 사용자에게 노출할 때 쓴다.

버튼과 링크는 동작상 유사하지만 **표시 위치·형태**가 다르다 — 버튼은 페이지 상단/관련 목록의 버튼 영역이나 list view에, 링크는 detail 페이지의 링크 영역에 배치된다.

## 콘텐츠 소스 유형

버튼·링크가 수행할 동작의 소스는 다음 유형으로 지정한다.

| 콘텐츠 소스 | 설명 | 비고 |
|---|---|---|
| **URL** | 외부 또는 내부 URL을 연다 | 병합 필드로 레코드 값 삽입 가능(세부는 공식 위임) |
| **Visualforce 페이지** | Visualforce 페이지를 호출한다 | 커스텀 로직/화면 연결 |
| **JavaScript** | 클라이언트 측 스크립트 실행 | **레거시** — Lightning Experience에서 **지원 안 됨**. URL/Visualforce/Quick Action으로 대체 권장 |

> JavaScript 버튼은 레거시다. Lightning Experience에서 지원되지 않으므로, 신규로는 URL·Visualforce·Quick Action을 사용한다.

## 표시 동작 (Behavior)

버튼·링크를 눌렀을 때 콘텐츠가 어디에 열릴지를 지정한다.

- **새 창** 에서 열기
- **기존 창** 에서 열기
- **사이드바** 등 지정된 표시 방식

## 설정·배치

1. **Object Manager** → 대상 오브젝트 선택
2. **Buttons, Links, and Actions** 에서 버튼/링크 생성
3. 생성한 버튼/링크를 **page layout**(레코드 detail 페이지 또는 related list)에 추가해야 사용자에게 노출된다

생성만 하고 page layout에 배치하지 않으면 화면에 나타나지 않는다.

```
// 구조 예시 — Custom Buttons & Links(실제 동작 코드 아님)
Object Manager → Buttons, Links, and Actions → New
   콘텐츠 소스: URL | Visualforce  (JavaScript = 레거시, LEX 미지원)
   표시: 새 창 / 기존 창 / 사이드바
   → page layout(레코드 detail·related list)에 배치
```

> URL·Visualforce 세부 구성과 병합 필드(merge field) 문법 등은 이 노트 범위 밖이며 [공식 문서](https://help.salesforce.com/s/articleView?id=sf.defining_custom_links.htm&type=5)를 참조한다.

## 관련 노트
- [[Page Layouts (페이지 레이아웃)]] — 버튼·링크를 배치하는 레이아웃
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — JavaScript 버튼의 현대적 대체
- [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]] — Display Type·Behavior·Content Source 등 생성 심화 가이드
