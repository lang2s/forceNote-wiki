---
tags: [Apex, Namespace, Sfdc_Enablement, Enablement, Sales-Programs, Learning-Evaluation, Custom-Exercise]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-23
aliases: [Sfdc_Enablement, sfdc_enablement, LearningEvaluation, LearningEvaluationResult, LearningItemEvaluationHandler, LearningItemProgressStatus, LearningItemSerializeDeserializer, Enablement 프로그램 Apex]
---

# Sfdc_Enablement Namespace

> Enablement 프로그램에서 커스텀 학습 항목(Custom Exercise)의 진행도 평가·직렬화를 위한 Apex 클래스 모음

---

## 개념 설명

`sfdc_enablement` 네임스페이스는 **Salesforce Enablement(Sales Programs 및 Partner Tracks)** 기능에서 커스텀 학습 항목(Custom Exercise)을 구현할 때 사용한다.

LWC로 커스텀 Exercise UI를 렌더링하고, Apex 클래스(`LearningItemEvaluationHandler` 확장)로 진행도를 평가한다. `LearningItemType` 메타데이터 레코드의 `ApexEvaluationHandler` 필드에 클래스 이름을 등록하면 Enablement 프레임워크가 호출한다.

---

## 클래스 목록

| 클래스/인터페이스 | 설명 |
|---|---|
| `LearningEvaluation` | 학습 평가 인스턴스 — 학습 항목 ID와 세부 정보 포함 |
| `LearningEvaluationResult` | 커스텀 Exercise의 진행도와 상태 표현 |
| `LearningItemEvaluationHandler` | 학습 항목 평가 프로세스 커스터마이징용 추상 클래스 |
| `LearningItemProgressStatus` | 학습 항목 진행 상태 Enum |
| `LearningItemSerializeDeserializer` | 커스텀 Exercise 콘텐츠 직렬화·역직렬화 (Org 간 마이그레이션용) |

---

## LearningEvaluation Class

학습 평가 인스턴스로, `LearningItemEvaluationHandler.evaluate()`의 입력 파라미터로 사용된다.

**네임스페이스:** `sfdc_enablement`

### 메서드

| 메서드 | 시그니처 | 반환 타입 | 설명 |
|---|---|---|---|
| `getDetails()` | `public Map<String,Object> getDetails()` | `Map<String,Object>` | 학습 평가 인스턴스에 연결된 세부 정보 조회 |
| `getLearningItemId()` | `public String getLearningItemId()` | `String` | 학습 항목 레코드 ID 조회 |
| `setDetails(details)` | `public void setDetails(Map<String,Object> details)` | `void` | 학습 항목 레코드 세부 정보 설정/업데이트 |
| `setLearningItemId(learningItemId)` | `public void setLearningItemId(String learningItemId)` | `void` | 학습 항목 레코드 ID 설정/업데이트 |

---

## LearningEvaluationResult Class

커스텀 Exercise에서 사용자의 진행도와 진행 상태를 표현한다.

**진행도 → 상태 매핑:**

| 진행도(percentage) | LearningItemProgressStatus |
|---|---|
| `0.00` | `NotStarted` |
| `0.01` ~ `99.99` | `InProgress` |
| `100.00` | `Completed` |

### 메서드

| 메서드 | 시그니처 | 반환 타입 | 설명 |
|---|---|---|---|
| `getLearningItemProgress()` | `public Double getLearningItemProgress()` | `Double` | 진행도 퍼센트 (소수점 2자리) 반환 |
| `getLearningItemProgressStatus()` | `public sfdc_enablement.LearningItemProgressStatus getLearningItemProgressStatus()` | `LearningItemProgressStatus` | 진행 상태 반환 |
| `setLearningItemProgress(learningItemProgress)` | `public void setLearningItemProgress(Double learningItemProgress)` | `void` | 진행도 퍼센트 설정 |
| `setLearningItemProgressStatus(learningItemProgressStatus)` | `public void setLearningItemProgressStatus(sfdc_enablement.LearningItemProgressStatus learningItemProgressStatus)` | `void` | 진행 상태 설정 |

---

## LearningItemEvaluationHandler Class

학습 항목 평가 프로세스를 커스터마이징하기 위한 추상 클래스. 이 클래스를 확장하여 커스텀 평가 로직을 구현한다.

**등록 방법:** `LearningItemType` 메타데이터 레코드의 `ApexEvaluationHandler` 필드에 클래스 이름 등록

### 메서드

#### evaluate(learningEvaluation)

커스텀 학습 항목 평가 로직을 포함한다.

```apex
// 시그니처
public Sfdc_enablement.LearningEvaluationResult evaluate(
    Sfdc_enablement.LearningEvaluation learningEvaluation
)
```

**파라미터:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `learningEvaluation` | `sfdc_enablement.LearningEvaluation` | 평가할 학습 항목 레코드 세부 정보 |

**반환값:** `sfdc_enablement.LearningEvaluationResult` — 진행도와 상태 세부 정보

### 구현 예시 — Screen Flow Exercise 진행도 평가

```apex
// Screen Flow를 사용하는 커스텀 Exercise의 진행도 평가 예시
// (Salesforce Developer Guide: Sales Programs and Partner Tracks 기반)
global class ScreenFlowEvaluationHandler extends sfdc_enablement.LearningItemEvaluationHandler {
    
    global override sfdc_enablement.LearningEvaluationResult evaluate(
        sfdc_enablement.LearningEvaluation learningEvaluation
    ) {
        sfdc_enablement.LearningEvaluationResult result = new sfdc_enablement.LearningEvaluationResult();
        Double percentage = 100.0d;
        
        Map<String, Object> details = learningEvaluation.getDetails();
        String currentScreen = (String) details.get('currentScreen');
        String allScreensString = (String) details.get('allScreens');
        List<String> allScreens = allScreensString.split(',');
        String status = (String) details.get('status');
        
        if (status == 'FINISHED') {
            percentage = 100;
        } else {
            Integer index = 0;
            for (Integer i = 0; i < allScreens.size(); i++) {
                if (allScreens.get(i).equals(currentScreen)) {
                    index = i + 1;
                    break;
                }
            }
            if (index == allScreens.size()) {
                percentage = 99.0d;
            } else {
                percentage = (Double.valueOf(index) / Double.valueOf(allScreens.size())) * 100.0d;
            }
        }
        
        result.setLearningItemProgress(percentage);
        
        if (percentage == 100.0d) {
            result.setLearningItemProgressStatus(sfdc_enablement.LearningItemProgressStatus.Completed);
        } else if (percentage == 0.0d) {
            result.setLearningItemProgressStatus(sfdc_enablement.LearningItemProgressStatus.NotStarted);
        } else {
            result.setLearningItemProgressStatus(sfdc_enablement.LearningItemProgressStatus.InProgress);
        }
        
        return result;
    }
}
```

---

## LearningItemProgressStatus Enum

사용자의 학습 항목 진행 상태를 나타낸다.

| 값 | 설명 |
|---|---|
| `NotStarted` | 사용자가 커스텀 Exercise를 아직 시작하지 않음 |
| `InProgress` | 사용자의 커스텀 Exercise 진행 중 |
| `Completed` | 사용자가 커스텀 Exercise 완료 |

---

## LearningItemSerializeDeserializer Class

Enablement 프로그램을 다른 org로 마이그레이션(Change Set 또는 패키지)할 때 커스텀 Exercise 콘텐츠를 직렬화·역직렬화한다.

**등록 방법:** `LearningItemType` 메타데이터 레코드의 `ApexSerializerDeserializer` 필드에 클래스 이름 등록

### 메서드

| 메서드 | 시그니처 | 반환 타입 | 설명 |
|---|---|---|---|
| `deserialize(serializedOutput)` | `public String deserialize(String serializedOutput)` | `String` | 직렬화된 문자열을 역직렬화하여 대상 org에 학습 항목 레코드 ID 반환 |
| `serialize(learningItemId)` | `public String serialize(String learningItemId)` | `String` | 학습 항목의 커스텀 콘텐츠를 직렬화 (250자 이하 문자열) |

### 구현 예시 — Screen Flow Exercise 직렬화/역직렬화

```apex
global class ScreenFlowSerializerDeserializer extends Sfdc_enablement.LearningItemSerializeDeserializer {
    
    // 원본 org에서 커스텀 콘텐츠 직렬화
    global override String serialize(String learningItemId) {
        LearningItem learningItem = [
            SELECT ScreenFlow_Field__c FROM LearningItem WHERE Id = :learningItemId LIMIT 1
        ];
        String screenFlowRecordId = learningItem.ScreenFlow_Field__c;
        
        ScreenFlow_Object__c screenFlowRecord = [
            SELECT FlowVersionId__c FROM ScreenFlow_Object__c WHERE Id = :screenFlowRecordId LIMIT 1
        ];
        String flowVersionId = screenFlowRecord.FlowVersionId__c;
        
        FlowDefinitionView flowDef = [
            SELECT ApiName FROM FlowDefinitionView WHERE ActiveVersionId = :flowVersionId LIMIT 1
        ];
        // Flow API Name을 직렬화 문자열로 반환 (250자 이하)
        return flowDef.ApiName;
    }
    
    // 대상 org에서 커스텀 콘텐츠 역직렬화 + 새 레코드 ID 반환
    global override String deserialize(String serializedOutput) {
        FlowDefinitionView flowDef = [
            SELECT ActiveVersionId FROM FlowDefinitionView 
            WHERE ApiName = :serializedOutput LIMIT 1
        ];
        String flowActiveVersionId = flowDef.ActiveVersionId;
        
        ScreenFlow_Object__c screenFlowRecord = new ScreenFlow_Object__c();
        screenFlowRecord.Name = serializedOutput;
        screenFlowRecord.FlowVersionId__c = flowActiveVersionId;
        insert screenFlowRecord;
        
        return screenFlowRecord.Id;
    }
}
```

---

## 관련 노트
- [[Flow Namespace]]
- [[ConnectApi Namespace 개요]]
- [[Flowtesting Namespace]]
