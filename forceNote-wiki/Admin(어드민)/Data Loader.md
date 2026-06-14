---
tags: [admin, data-loader, data-migration, bulk-api, csv, etl]
source: salesforce_data_loader.pdf (Data Loader Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [Data Loader, 데이터 로더, 데이터 적재, CSV 임포트, bulk import, Data Loader CLI, process-conf.xml]
---

# Data Loader (데이터 로더)

> CSV·DB 연결로 Salesforce 레코드를 **대량 insert/update/upsert/delete/export**하는 클라이언트 앱. UI 마법사 + CLI 배치(Windows). **최대 1.5억(150M) 건**(Bulk API 2.0), 모든 표준·커스텀 오브젝트 지원.

---

## 개념 + 주요 기능

Data Loader는 데이터의 대량 가져오기/내보내기용 **클라이언트 애플리케이션**이다. CSV 파일이나 데이터베이스 연결에서 데이터를 읽어 적재하고, 내보낼 때는 CSV로 출력한다. **MacOS·Windows** 모두 지원. (Enterprise·Performance·Unlimited·Developer 에디션)

- 대화형 **마법사 UI**
- 자동 배치 처리용 **CLI**(Windows 전용)
- **Bulk API 2.0** 사용 시 최대 **150,000,000건** 지원
- 드래그앤드롭 필드 매핑
- 모든 오브젝트(커스텀 포함) 지원
- CSV 성공/오류 로그 파일 + 내장 CSV 뷰어

**두 가지 사용 방식:**
- **UI** — 설정 파라미터·CSV·필드 매핑을 화면에서 지정
- **CLI(Windows 전용)** — 설정·데이터소스·매핑·동작을 파일로 지정해 자동화

---

## 언제 쓰나 — Data Loader vs Data Import Wizard

Data Loader는 Setup의 웹 기반 Import Wizard를 **보완**한다.

| 기준 | Data Loader | Data Import Wizard |
|---|---|---|
| 레코드 수 | 50,000 초과 ~ **최대 1.5억** | **50,000 미만** |
| 오브젝트 | 모든 오브젝트(커스텀 포함), Import Wizard 미지원 오브젝트 | 마법사가 지원하는 오브젝트만 |
| 복합 필드 매핑·정기 반복 | ✅ (매핑 저장·재사용) | — |
| 정기 예약 적재(야간 등) | ✅ (CLI 배치) | — |
| 백업용 export | ✅ | — |
| 중복 제어(매칭 규칙) | — | ✅ |

> 1.5억 건을 넘겨야 하면 Salesforce 파트너나 AppExchange 제품을 권장.

---

## Bulk API 설정

기본값은 **SOAP 기반 API**다. 대량 처리는 **Bulk API**가 병렬 처리·네트워크 왕복 감소로 더 빠르다. **Settings > Settings > Use Bulk API** 체크로 활성화(insert/update/upsert/delete/hard delete에 적용).

- **Enable serial mode for Bulk API** — 병렬 처리는 DB 경합(contention)을 일으켜 심하면 적재 실패. 직렬 모드는 배치를 하나씩 처리(느리지만 안전).
- **Bulk API 2.0** — 별도 활성화, 대용량(150M)에 사용.
- > [!warning] **Hard Delete 주의:** Use Bulk API 설정 시 hard delete 가능 — 하드 삭제된 레코드는 **휴지통(Recycle Bin)에서 복구 불가**, 즉시 삭제된다.

---

## 작업과 필요 권한

upsert 마법사는 insert+update를 결합한다 — 파일 레코드가 기존 레코드와 매칭되면 갱신, 없으면 신규 생성.

| 작업 | 필요 권한 |
|---|---|
| Insert | Create on the record |
| Update | Edit on the record |
| Upsert | Create **또는** Edit |
| Delete | Delete on the record |
| Hard Delete | Delete on the record (+ 권한·라이선스) |
| Mass Delete | **Modify All Data** |

### 필드 매핑
- **Auto-Match Fields to Columns** — 필드·컬럼명 유사도로 자동 매핑(delete는 ID 필드만 자동 매칭)
- 수동: Salesforce 필드를 CSV 컬럼 헤더로 드래그
- **Save Mapping** — `.sdl` 매핑 파일로 저장해 재사용

---

## CLI 배치 모드 (Windows 전용)

> [!note] Data Loader CLI는 **Windows 전용**이다. **JRE**와 Data Loader 설치 필요. 샘플은 `C:\Users\{userName}\dataloader\version\samples\conf`에 설치된다.

UI가 없으므로 모든 정보를 텍스트 파일 `process-conf.xml`에 넣는다. Quick Start 5단계:

1. **암호화 키 파일 생성** (`encrypt.bat -k`)
2. **암호화된 비밀번호 생성** (로그인 username용)
3. **필드 매핑 파일(.sdl) 생성**
4. **`process-conf.xml` 생성** — import 설정
5. **프로세스 실행** → 데이터 import

```xml
<!-- 구조 예시 — Data Loader Guide의 process-conf.xml 구성을 표현 (PDF 원문 전체 코드 아님) -->
<!-- process-conf.xml: CLI 배치의 동작·접속·매핑을 정의 -->
<bean id="csvAccountUpsert"
      class="com.salesforce.dataloader.process.ProcessRunner"
      singleton="false">
  <property name="name" value="csvAccountUpsert"/>
  <property name="configOverrideMap">
    <map>
      <entry key="sfdc.endpoint"      value="https://login.salesforce.com"/>
      <entry key="sfdc.username"      value="admin@example.com"/>
      <entry key="sfdc.password"      value="&lt;암호화된 비밀번호&gt;"/>
      <entry key="process.encryptionKeyFile" value="C:\dl\key.txt"/>
      <entry key="sfdc.entity"        value="Account"/>
      <entry key="process.operation"  value="upsert"/>
      <entry key="dao.type"           value="csvRead"/>
      <entry key="dao.name"           value="C:\dl\accounts.csv"/>
      <entry key="process.mappingFile" value="C:\dl\accountMap.sdl"/>
    </map>
  </property>
</bean>
```

```bat
REM 키 생성 → 비밀번호 암호화 → 프로세스 실행
encrypt.bat -k C:\dl\key.txt
encrypt.bat -e myPassword C:\dl\key.txt
process.bat "C:\dl\conf" csvAccountUpsert
```

---

## 출력 파일

- import 후 **success / error 로그**(CSV)가 생성된다.
- **Data Loader 로그 파일** 조회·설정 가능(`View/Configure the Data Loader Log File`).

---

## 관련 노트

- [[Salesforce 네비게이션]] — Admin 도구·Setup 탐색
- [[Object Relationships]] — upsert 외부 ID·관계 적재 시 참고
- [[Salesforce 플랫폼 개요]] — 에디션·환경
- [[Data Skew]] — 대량 적재 시 부모 잠금·스큐 회피(ParentId 정렬)
