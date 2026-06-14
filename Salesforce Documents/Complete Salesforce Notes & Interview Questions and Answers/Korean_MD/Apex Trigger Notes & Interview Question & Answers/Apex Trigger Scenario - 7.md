# Apex 트리거 시나리오 7

**시나리오: 사용자가 Account를 삭제하지 못하게 하는 트리거. System Admin만 삭제 권한을 가짐.** (Custom Metadata Type으로 허용 프로필 관리)

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

**Custom Metadata Type 설정:** 1) Custom Metadata Type 생성, 2) 커스텀 필드(Active__c Checkbox, Profile_Access__c) 생성, 3) Manage > New로 값 입력(System Admin, Marketing User).
