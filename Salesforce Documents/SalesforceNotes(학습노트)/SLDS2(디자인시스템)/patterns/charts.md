# Charts (Data Visualization)

> 카테고리: SLDS 2 디자인 패턴(Data Visualization) · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/7139a1-charts)

복잡한 정보를 시각화해 패턴·추세·비교·진행을 이해하기 쉽게. **의도(intent)에 맞는 차트 선택**이 핵심 — 잘못 고르면 데이터를 왜곡.

## 의도별 차트 선택

| 의도 | 설명 | 차트 |
|---|---|---|
| Comparison | 값 간 차이/유사 | Bar, Column, Stacked Bar/Column, Dot Plot |
| Trending | 시간에 따른 변화 | Line(값 4개 이하) |
| Relationship | 값 간 상관 | Scatter Plot |
| Composition | 상대적 구성비 | Pie(2~5개), Treemap(계층) |
| Distribution | 분포·이상치 | Heatmap(1변수), Matrix(2변수) |
| Metric | 한눈에 진행도 | Flat Gauge, Polar Gauge, Ratings |
| Location | 지리/좌표 | Map, Bubble Map, Geo Map |
| Pipeline | 프로세스 단계/흐름 | Funnel, Waterfall, Origami, Sankey |

## 핵심 Do/Don't
- 막대/컬럼: **0 기준선** 필수(다른 값 X), 순서대로(오름/내림), 같은 측정값은 단일 색. 장식용 음영 금지.
- Line: 관련 값 4개 이하, 같은 단위·일관된 스케일끼리만 비교.
- Scatter: x·y 모두 0에서 시작, 색·크기로 이상치 강조.
- Pie: 2~5개 값, 12시부터 시계방향 내림차순. Treemap: 크기순 정렬.
- Gauge/Ratings: **기준점(목표/평균)** 함께. 공간 좁으면 flat gauge.

## 차트 색상 팔레트 (공식)
- **Default**: `#52B7D8, #E16032, #FFB03B, #54A77B, #4FD2D2, #E287B2`
- **Color Safe**(WCAG 2.0 통과): `#529EE0, #D9A6C2, #08916D, #F59B00, #006699, #F0E442`
- 그 외 테마: Light / Dark / Bluegrass / Sunrise / Water / Watermelon (각 6색)

**색 원칙**: 같은 값=같은 색 일관 유지, 연속값은 단색/그라데이션, 색은 최대 ~5개(단기기억 한계), 색만으로 구분 말고 기호/텍스트 병행, 가능하면 color-safe 테마. 문화권 따라 색 의미 다름 주의.
