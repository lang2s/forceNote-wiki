---
tags: [apex, cache, platform-cache, performance, pattern]
source: apex-recipes/PlatformCacheRecipes.cls
created: 2026-05-17
aliases: [Platform Cache, Cache.Org, Cache.Session, 플랫폼 캐시]
---

# Platform Cache

> 세션/조직 수준의 인메모리 캐시. 반복 SOQL 쿼리, 설정값, 외부 API 응답을 캐싱해 Governor Limit과 응답 속도를 개선.

---

## Org Cache vs Session Cache

| | Org Cache | Session Cache |
|---|---|---|
| 범위 | 전체 조직 (모든 사용자) | 현재 사용자 세션 |
| TTL | 최대 172,800초 (48시간) | 세션 만료까지 |
| 사용 | 설정값, 공통 참조 데이터 | 사용자별 임시 데이터 |
| 클래스 | `Cache.Org` | `Cache.Session` |

---

## 기본 사용법

```apex
// Org Cache 파티션 가져오기
Cache.OrgPartition partition = Cache.Org.getPartition('local.MyPartition');

// 값 저장 (TTL: 3600초 = 1시간)
partition.put('accountSettings', mySettings, 3600);

// 값 조회
Object cached = partition.get('accountSettings');
if (cached != null) {
    AccountSettings settings = (AccountSettings) cached;
}

// 키 존재 여부
Boolean exists = partition.contains('accountSettings');

// 삭제
partition.remove('accountSettings');
```

---

## 캐시-어사이드 패턴 (Cache-Aside)

```apex
// 조회 → 없으면 로드 → 저장
public static AccountSettings getSettings() {
    Cache.OrgPartition part = Cache.Org.getPartition('local.AppCache');
    final String CACHE_KEY = 'accountSettings';

    AccountSettings settings = (AccountSettings) part.get(CACHE_KEY);
    if (settings == null) {
        // 캐시 미스 → 소스에서 로드
        settings = loadSettingsFromSoql();
        part.put(CACHE_KEY, settings, 3600); // 1시간 캐싱
    }
    return settings;
}

private static AccountSettings loadSettingsFromSoql() {
    AppSettings__c raw = [
        SELECT ... FROM AppSettings__c LIMIT 1
    ];
    return new AccountSettings(raw);
}
```

---

## 캐시 무효화 패턴

```apex
// 설정 변경 시 캐시 제거
public static void invalidateSettingsCache() {
    Cache.OrgPartition part = Cache.Org.getPartition('local.AppCache');
    part.remove('accountSettings');
}

// 또는 Trigger에서 자동 무효화
trigger AppSettingsTrigger on AppSettings__c (after insert, after update, after delete) {
    CacheService.invalidateSettingsCache();
}
```

---

## @CacheBuilder 인터페이스 (자동 갱신)

```apex
// 더 선언적인 캐시 패턴
public class AccountSettingsBuilder implements Cache.CacheBuilder {
    public Object doLoad(String key) {
        return loadSettingsFromSoql(); // 캐시 미스 시 자동 호출
    }
}

// 사용 — get() 호출 시 자동으로 doLoad() 실행
AccountSettings settings = (AccountSettings)
    Cache.Org.get(AccountSettingsBuilder.class, 'accountSettings');
```

---

## TTL 전략

| 데이터 유형 | 권장 TTL |
|---|---|
| 설정값 (잘 변하지 않음) | 3600–86400초 (1시간~1일) |
| 참조 데이터 | 1800–3600초 |
| API 응답 | 300–900초 (5~15분) |
| 사용자 세션 데이터 | Session Cache 사용 |

---

## Cache Partition 설정

> [!warning] 사전 설정 필요
> Platform Cache 사용 전 Setup → Platform Cache에서 Partition을 생성해야 함.
> - 이름: `local.MyPartition`
> - Developer Edition: 0MB (코드 컴파일만, 실제 캐싱 불가)
> - Sandbox/Production: 설정한 용량만큼 사용 가능

---

## 관련 노트

- [[SOQL 패턴]] — 반복 쿼리 최적화
- [[비동기 컨텍스트 선택]]

