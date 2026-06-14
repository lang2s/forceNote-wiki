# Salesforce Workbench

무료 웹 기반 도구로 Salesforce 데이터·메타데이터와 상호작용: 데이터 관리, 메타데이터 관리, 테스트·트러블슈팅, API 테스트.

1. 무료지만 Salesforce 공식 제품은 아님. PHP로 제작. URL: https://workbench.developerforce.com/login.php
2. Production·Sandbox 연결 가능.
3. 최신 API 버전 지정(기본 선택). 구 버전 org 사용자에게 유용.
4. 메타데이터 타입·컴포넌트 조회(info > Metadata Types and Components).
5. 세션 정보·사용자 상세 조회.
6. SOQL·SOSL 쿼리, 레코드 필터, Bulk CSV·XML 다운로드.
7. Streaming Push Topics로 알림 전송(REST·Streaming API 활성화 필요). queries > Streaming Push Topics.
8. 데이터 작업: insert·update·upsert·delete·undelete·purge(정리). data > insert.
9. 파일 배포·검색(마이그레이션은 XML). migration > Retrieve.
10. REST Explorer로 REST 통합 활동. utilities > REST Explorer.
11. 익명 창처럼 코드 실행. utilities > Apex Execute.
12. Bulk API Job 상태 모니터링(Job ID 전달). utilities > BULK API JOB Status.
13. Metadata API 프로세스 상태 모니터링(비동기 작업 ID). utilities > Metadata API Process Status.
