---
tags: [apex, process, plugin, flow-plugin, legacy, deprecated]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Process.Plugin, PluginDescribeResult, PluginRequest, PluginResult, Process namespace, 레거시 플로우 플러그인]
---

# Process Namespace

> Apex 클래스를 Flow에 플러그인으로 노출하는 레거시 인터페이스. **Salesforce는 `@InvocableMethod` 어노테이션 사용을 권장하며 이 인터페이스는 새 개발에 사용하지 않도록 권고.**

> [!warning] Legacy API
> `Process.Plugin`은 Blob·컬렉션·SObject 데이터 타입과 벌크 처리를 지원하지 않습니다. `@InvocableMethod`가 모든 타입과 벌크 처리를 지원하므로 신규 개발에는 `@InvocableMethod`를 사용하세요.
> 또한 레거시 Apex 액션은 Flow Builder 자동 레이아웃에서 지원되지 않습니다.

---

## Process.Plugin 인터페이스 구현

```apex
global class ChatterPostPlugin implements Process.Plugin {

    // Flow에서 호출될 때 실행되는 메인 메서드
    global Process.PluginResult invoke(Process.PluginRequest request) {
        // 입력 파라미터 수신
        String subject = (String) request.inputParameters.get('subject');
        String body    = (String) request.inputParameters.get('body');

        // 비즈니스 로직
        FeedItem fi = new FeedItem(
            ParentId = UserInfo.getUserId(),
            Body     = subject + ': ' + body
        );
        insert fi;

        // 출력 파라미터 반환
        Map<String, Object> output = new Map<String, Object>();
        output.put('feedItemId', fi.Id);
        return new Process.PluginResult(output);
    }

    // 플러그인 메타데이터 반환
    global Process.PluginDescribeResult describe() {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name        = 'chatterpostplugin';
        result.Tag         = 'Chatter';
        result.description = 'Posts a message to the current user feed';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(
                'subject',
                Process.PluginDescribeResult.ParameterType.STRING,
                true  // required
            ),
            new Process.PluginDescribeResult.InputParameter(
                'body',
                'Optional message body',
                Process.PluginDescribeResult.ParameterType.STRING,
                false
            )
        };

        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            new Process.PluginDescribeResult.OutputParameter(
                'feedItemId',
                Process.PluginDescribeResult.ParameterType.ID
            )
        };

        return result;
    }
}
```

---

## 테스트 클래스

```apex
@IsTest
private class ChatterPostPluginTest {
    @IsTest
    static void testInvoke() {
        ChatterPostPlugin plugin = new ChatterPostPlugin();

        Map<String, Object> inputs = new Map<String, Object>{
            'subject' => 'Test Subject',
            'body'    => 'Test Body'
        };
        Process.PluginRequest request = new Process.PluginRequest(inputs);
        Process.PluginResult  result  = plugin.invoke(request);

        System.assertNotEquals(null, result.outputParameters.get('feedItemId'));
    }
}
```

---

## 클래스 및 인터페이스 목록

### Process.Plugin 인터페이스

| 메서드 | 서명 | 설명 |
|---|---|---|
| `describe()` | `→ Process.PluginDescribeResult` | 플러그인 메타데이터 반환 |
| `invoke(request)` | `Process.PluginRequest → Process.PluginResult` | 비즈니스 로직 실행 |

---

### Process.PluginDescribeResult 클래스

Flow Builder가 플러그인을 표시할 때 사용하는 메타데이터 컨테이너.

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `name` | `String` | 플러그인 고유 이름 (최대 40자) |
| `tag` | `String` | Flow Builder 카테고리 태그 |
| `description` | `String` | 설명 (최대 255자, 선택) |
| `inputParameters` | `List<InputParameter>` | 입력 파라미터 목록 |
| `outputParameters` | `List<OutputParameter>` | 출력 파라미터 목록 |

---

### PluginDescribeResult.InputParameter 클래스

```apex
// 생성자 1: 이름 + 파라미터 타입 + 필수 여부
new Process.PluginDescribeResult.InputParameter(
    String name,
    Process.PluginDescribeResult.ParameterType parameterType,
    Boolean required
)

// 생성자 2: 이름 + 설명 + 파라미터 타입 + 필수 여부
new Process.PluginDescribeResult.InputParameter(
    String name,
    String description,
    Process.PluginDescribeResult.ParameterType parameterType,
    Boolean required
)
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `Name` | `String` | 파라미터 이름 |
| `Description` | `String` | 파라미터 설명 (선택) |
| `ParameterType` | `ParameterType` | 데이터 타입 |
| `Required` | `Boolean` | 필수 여부 |

---

### PluginDescribeResult.OutputParameter 클래스

```apex
// 생성자 1: 이름 + 파라미터 타입
new Process.PluginDescribeResult.OutputParameter(
    String name,
    Process.PluginDescribeResult.ParameterType parameterType
)

// 생성자 2: 이름 + 설명 + 파라미터 타입
new Process.PluginDescribeResult.OutputParameter(
    String name,
    String description,
    Process.PluginDescribeResult.ParameterType parameterType
)
```

---

### PluginDescribeResult.ParameterType Enum

| 값 | Apex 타입 |
|---|---|
| `BOOLEAN` | Boolean |
| `DATE` | Date |
| `DATETIME` | DateTime |
| `DECIMAL` | Decimal |
| `DOUBLE` | Double |
| `FLOAT` | Float |
| `ID` | Id |
| `INTEGER` | Integer |
| `LONG` | Long |
| `STRING` | String |
| `TIME` | Time |

---

### Process.PluginRequest 클래스

Flow에서 플러그인으로 전달되는 입력 파라미터 컨테이너.

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `inputParameters` | `Map<String, Object>` | Flow가 전달한 입력 파라미터 |

```apex
// 읽기
String val = (String) request.inputParameters.get('myParam');
```

---

### Process.PluginResult 클래스

플러그인이 Flow로 반환하는 출력 파라미터 컨테이너.

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `outputParameters` | `Map<String, Object>` | Flow에 반환할 출력 파라미터 |

```apex
// 반환
Map<String, Object> out = new Map<String, Object>{ 'resultId' => someId };
return new Process.PluginResult(out);
```

---

## @InvocableMethod 비교 (마이그레이션 가이드)

| 항목 | `Process.Plugin` | `@InvocableMethod` |
|---|---|---|
| 상태 | **레거시 (지원 중단 예정)** | **권장 현행** |
| 지원 타입 | Primitive만 (Blob·컬렉션·SObject ❌) | 모든 타입 ✅ |
| 벌크 처리 | ❌ | ✅ (`List<>` 파라미터) |
| 자동 레이아웃 | ❌ | ✅ |
| Process Builder | ✅ | ✅ |
| Flow | ✅ (레거시 방식) | ✅ |
| REST API | ❌ | ✅ (Custom Invocable Actions API) |

---

## 관련 노트

- [[@InvocableMethod 패턴]] — 현행 권장 방식, 모든 타입·벌크 처리 지원
- [[Invocable Namespace]] — Apex에서 Invocable Action 동적 호출
