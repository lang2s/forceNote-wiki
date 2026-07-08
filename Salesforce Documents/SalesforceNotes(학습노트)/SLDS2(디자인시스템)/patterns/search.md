# Search (Global Search)

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/727af5-global-search)
> 하위: Global Search · In-Context Search

쿼리·제안·결과로 콘텐츠·레코드·기능·목적지를 빠르게 탐색하는 주요 탐색/발견 엔진.

## 기본 상태
- 글로벌 검색은 **앱 헤더에 상시 배치**(항상 발견·접근 가능), 입력창은 기본 노출.
- **Placeholder는 위치에 따라 동적**: Setup="Search Setup", Groups 탭="Search Groups and more...", 코어 앱="Search Salesforce".

## 포커스 시 (입력 전)
- **Recent Items**: 최근 사용 레코드·앱 5개 드롭다운.
- **메타데이터 명확성**: 각 항목에 객체 아이콘 + 레코드명 + 객체 유형(예: Account)로 동명 구분.

## Instant Results (타이핑 중)
- 실시간 상위 5개 매치 표시(Enter 불필요).
- **Disambiguation 필드**(예: "Opportunity - Prospecting")로 맥락 제공, 첫 글자 입력 시 **clear(X) 아이콘**.
- **검색 단축(shortcuts)**: 드롭다운 상단 최대 3개. 첫 단축=Enter 기본 동작, 보조 단축=현재 객체로 사전 스코프/카테고리 전환.
- **유연한 매칭**: 어간(stemming)·동의어·인라인 철자교정 지원(정확 일치 불요).

## 관련성 표시
- 객체 아이콘, **매칭 문자 하이라이트(볼드)**, 객체 유형 텍스트 라벨, 보조 필드 하이라이트.
- 느린 네트워크에선 입력창 우측 **로딩 스피너**.

## Pre-Scoping / Pre-Filtering
- **Object Selector Combobox**(입력창 좌측): 선택 시 해당 객체로 검색 한정, 빈 상태도 그 객체 최근 항목만.
- **Advanced Search Popover**: 다중선택 필터(언어·게시상태·레코드타입·검증상태·지역). "N Filters" 표시 pill로 활성 필터 수 상시 표시.

## 결과 페이지 / 빈 결과
- **Top Results**: Enter 시 개인화·예측 모델 기반 전체화면 대시보드, 객체 유형별 가로 블록(Accounts/People/Groups)으로 그룹화.
- **No Results**: 막다른 길 금지 — 친근한 일러스트 + 검색어 넓히기/재구성 제안 + 새 레코드 생성 버튼 + 문서/Trailhead 링크.
