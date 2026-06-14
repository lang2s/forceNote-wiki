# LWC 시나리오 기반 면접 질문

## 시나리오: 데드라인 카운트다운 타이머가 있는 Task Manager

**필수:**
1. **Task 오브젝트:** 표준 Task 또는 커스텀 오브젝트.
2. **필드:** Subject(작업명), DueDateTime(데드라인).
3. **데이터 접근:** 프로필·권한 집합으로 필드·오브젝트 접근 보장.

**실행:**
1. **Apex 컨트롤러(TaskController):** 데드라인이 있는 Task 조회.
2. **LWC JS(taskManager.js):** Task 조회·각 작업 카운트다운 타이머 계산.
3. **LWC HTML(taskManager.html):** 타이머와 함께 작업 목록 표시.
4. **LWC CSS(taskManager.css):** 기본 스타일링.

**핵심 기능:**
1. **카운트다운 타이머:** setInterval로 매초 동적 업데이트, 마감 지난 작업은 "Expired".
2. **동적 데이터:** Apex 컨트롤러로 Task 조회.
3. **사용자 친화 UI:** 데드라인·타이머가 있는 목록.
4. **반응성:** 새로고침 없이 타이머 업데이트.

**배포:** TaskController 배포 → taskManager LWC(.html·.js·.css) 배포 → App Builder로 Lightning 페이지에 추가.
