# Formatted Date Time

`lightning-formatted-date-time`  ·  카테고리: **Output**

날짜/시간을 로케일 형식으로 표시.

## 기본 예제 (Example)

```html
<lightning-formatted-date-time value={timestamp} year="numeric" month="long" day="2-digit"></lightning-formatted-date-time>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-formatted-date-time` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 13개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `date-style` | string |  |  | The date formatting style to use. Allowed values are short, medium, or long. Use with the time-zone, time-zone-name, or hour12 attributes … |
| `day` | DayType |  |  | Allowed values are numeric or 2-digit. |
| `era` | EraType |  |  | Allowed values are narrow, short, or long. |
| `hour` | HourMinuteSecondType |  |  | Allowed values are numeric or 2-digit. |
| `hour12` | boolean |  |  | Determines whether time is displayed as 12-hour. If false, time displays as 24-hour. The default setting is determined by the user's local… |
| `minute` | HourMinuteSecondType |  |  | Allowed values are numeric or 2-digit. |
| `month` | MonthType |  |  | Allowed values are 2-digit, numeric, narrow, short, or long. |
| `second` | HourMinuteSecondType |  |  | Allowed values are numeric or 2-digit. |
| `time-zone` | string |  |  | The time zone for date and time display. Use this attribute only if you want to override the default, which is the time zone set on the us… |
| `time-zone-name` | TimeZoneNameType |  |  | Allowed values are short or long. For example, the Pacific time zone would display as 'PST' if you specify 'short', or 'Pacific Standard T… |
| `value` | DateValueType |  |  | The value to be formatted, which can be a Date object, timestamp, or an ISO8601 formatted string. |
| `weekday` | WeekdayType |  |  | Specifies how to display the day of the week. Allowed values are narrow, short, or long. |
| `year` | YearType |  |  | Allowed values are numeric or 2-digit. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-date-time/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-date-time/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-date-time/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-formatted-date-time.html

---
[← 전체 목록으로 돌아가기](../components.html)
