# Salesforce에서 트리거 생성하기

## 문제

Salesforce 오브젝트의 필드는 다른 오브젝트를 참조할 수 있습니다(예: Case는 Account·Contact 참조, CaseComment·Attachment와 자식 관계). 이 데이터들은 별개 엔티티라 참조가 변경되어도 부모의 업데이트 날짜가 바뀌지 않습니다. 예: Case에 Attachment를 추가하거나 CaseComment를 생성·업데이트해도 Case의 업데이트 날짜는 변하지 않습니다.

동기화 도구가 "SystemModifiedTimeStamp"를 확인할 때, 참조 오브젝트 변경 시 이 값이 바뀌지 않으므로, 참조 오브젝트가 변경되면 레코드를 업데이트할 방법이 필요합니다.

## 해결책

Apex 트리거를 사용합니다. 참조 오브젝트가 수정될 때 부모 레코드의 "Reverse Update"를 수행합니다.

**CaseComment 오브젝트 트리거 예시:**
```apex
trigger ReverseUpdateCaseFromCaseComment on CaseComment (after update, after insert, after delete){
    for(CaseComment comment : Trigger.new){
        String caseId = comment.ParentId;
        Datetime updateDate = comment.SystemModstamp;
        Case caseOb = [SELECT Id, Description FROM Case WHERE Id = :caseId];
        update caseOb;
    }
}
```

## 표준 오브젝트(예: Account)에 트리거 생성

1. Setup 클릭
2. Build → Customize
3. 트리거를 만들 오브젝트 선택 → triggers 링크 클릭
4. New 버튼 클릭
5. 트리거 코딩 후 저장
6. "Show Dependencies"로 변경 사항 확인

## 커스텀 오브젝트에 트리거 생성

1. Setup → Build → Create → Objects
2. 기존 오브젝트 선택 또는 새 오브젝트 생성
3. 커스텀 오브젝트 Label 클릭 → Triggers 섹션
4. New 클릭 후 동일 단계 진행

## Attachment에 트리거 (Developer Console)

```apex
trigger ReverseAttachmentUpdateOnCase on Attachment (after insert, after update, after delete) {
    for(Attachment att : Trigger.new){
        String parentId = att.ParentId;
        Case caseOb = [SELECT Id FROM Case WHERE Id = :parentId];
        if(caseOb != null){
            update caseOb;
        }
    }
}
```
Developer Console → File → New → Apex Trigger → 이름·오브젝트 선택 → 코드 입력 → 저장.
