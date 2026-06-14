# Pub-Sub 통신

> 원본은 이미지 PDF로 OCR 추출했습니다.

관계 없는 컴포넌트 간 통신을 위한 Pub-Sub 모델 예시.

**구성:**
- **Parent Block:** 부모-자식 작업, 자식-부모 작업 처리.
- **Child Block 1:** Account 상세 검색 박스. 검색 → 필터된 Account 목록. AccountID를 전달해 Contact(SOQL) 조회.
- **Block 3 (관계 없음):** Contacts. Pub-Sub 모델로 통신.

**동작:**
- Account 클릭 → 관련 Contact 표시.
- Contact 없으면 false(else 블록) 표시.
- wire 어댑터를 통해 채널로 두 블록 간 통신.
- 검색 후 서로 다른 블록에 데이터 전달.

> Pub-Sub 모델은 직접 부모-자식 관계가 없는 컴포넌트들이 채널(이벤트 버스)을 통해 데이터를 주고받게 한다.
