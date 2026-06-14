---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger Scenario - 7]
---

# Apex 트리거 시나리오 7

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**시나리오: 사용자가 Account를 삭제하지 못하게 하는 트리거. System Admin만 삭제 권한을 가짐.**

(Custom Metadata Type으로 허용 프로필 관리)

핸들러:
```apex
public class AccountTriggerHandler {
    List<Account> triggerOld;
    Map<Id, Account> triggerOldMap;
    public AccountTriggerHandler() {
        triggerOld = (List<Account>)Trigger.old;
        triggerOldMap = (Map<Id, Account>)Trigger.OldMap;
    }
    public void doAction() {
        switch on trigger.OperationType {
            when BEFORE_DELETE { onBeforeDelete(); }
        }
    }
    public void onBeforeDelete() {
        List<Profile__mdt> profilesList = Profile__mdt.getAll().values();
        Set<String> allowedProfiles = new Set<String>();
        for (Profile__mdt profile : profilesList) {
            if(profile.Active__c == true) allowedProfiles.add(profile.Profile_Access__c);
        }
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        for(Profile record : profileList) {
            if(!allowedProfiles.contains(record.Name)) {
                for(Account accRecord : triggerOld) accRecord.addError('Only system admin can delete the record');
            }
        }
    }
}
```

트리거:
```apex
trigger AccountTrigger on Account (before delete) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    handler.doAction();
}
```

**Custom Metadata Type 설정:**

1) Custom Metadata Type 생성, 2) 커스텀 필드(Active__c Checkbox, Profile_Access__c) 생성, 3) Manage > New로 값 입력(System Admin, Marketing User).
