---
tags: [admin, ui-customization, lightning-app-builder, lightning-pages, flexipage]
source: help.salesforce.com (Salesforce Help — Lightning App Builder Overview; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.lightning_app_builder_overview.htm&type=5
created: 2026-07-03
aliases: [Lightning App Builder, 라이트닝 앱 빌더, Lightning Pages, 라이트닝 페이지, FlexiPage, App Page, Record Page, Home Page]
---

# Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)

> Lightning Experience·모바일 앱용 커스텀 페이지(App·Home·Record)를 컴포넌트 드래그로 조립하는 point-and-click 도구. 만든 페이지는 활성화(activate)해 사용자에게 배정한다.

---

## 개념

**Lightning App Builder**는 **Salesforce 모바일 앱과 Lightning Experience용 커스텀 페이지**를 만드는 **point-and-click 도구**다. 코드 없이 표준·커스텀 Lightning 컴포넌트를 페이지에 드래그하는 방식으로 페이지를 조립한다.

## 페이지 유형 (FlexiPage)

Lightning App Builder로 만드는 세 가지 페이지 유형은 통칭 **FlexiPage**라고 부른다.

| 페이지 유형 | 설명 |
|---|---|
| **App Page** | 앱 홈 페이지. Lightning Experience에 추가하면 데스크톱과 모바일 앱 모두에서 사용 가능 |
| **Home Page** | 홈 페이지 |
| **Record Page** | 레코드 상세 페이지 |

## 구성 방법

- 표준·커스텀 Lightning 컴포넌트를 페이지의 **region**에 드래그해 배치한다.
- **Tabs 컴포넌트**로 record·app·Home 페이지의 탭을 만들고 순서를 바꾼다. 탭 추가는 Tabs 컴포넌트 속성의 **Add Tab**으로 한다.

```
// 구조 예시 — Lightning App Builder(실제 동작 코드 아님)
Lightning App Builder(point-and-click)
  페이지 유형: App Page · Home Page · Record Page (FlexiPage)
  region에 컴포넌트 드래그 + Tabs 컴포넌트(탭 추가·순서)
  → Activate: 앱/프로파일/레코드타입에 배정 (데스크톱+모바일)
```

## 활성화 (Activate)

커스텀 페이지를 사용자에게 제공하려면 **활성화(Activate)** 해야 한다. 활성화 과정에서 다음을 설정할 수 있다.

- 페이지 **탭 이름** 변경
- **가시성(visibility)** 조정
- **네비게이션 위치** 설정

app page를 Lightning Experience에 추가하면 **데스크톱과 모바일 앱 모두에서** 사용 가능하다.

## 관련 노트
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — 페이지·액션 바에 얹는 액션
- [[Compact Layouts (컴팩트 레이아웃)]] — 레코드 페이지 하이라이트 패널
- [[Page Layouts (페이지 레이아웃)]] — 클래식/필드 배치(Lightning 페이지와 병존)
- [[Lightning Apps & Tabs (라이트닝 앱·탭)]] — 이 페이지들을 담아 노출하는 앱·탭
