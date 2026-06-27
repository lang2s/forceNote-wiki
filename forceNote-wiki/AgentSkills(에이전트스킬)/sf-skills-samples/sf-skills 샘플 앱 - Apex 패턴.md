---
tags: [agent-skill, sf-skills, samples, apex, trigger-handler, headless-auth]
source: forcedotcom/sf-skills (samples/.../classes/, 공식 Salesforce)
created: 2026-06-27
aliases: [샘플 앱 Apex, MaintenanceRequestTriggerHandler, TenantTriggerHandler, WebAppLogin, 헤드리스 인증, headless auth Apex, 트리거 핸들러 패턴]
---

# sf-skills 샘플 앱 — Apex 패턴

> `forcedotcom/sf-skills`의 샘플 앱(`samples/`)이 담은 Apex 코드는 두 부류다 — (1) Maintenance/Tenant 데이터 모델용 **트리거 핸들러 2종**(자동 워커 배정·권한셋 자동 부여), (2) B2X experimental webapp 템플릿의 **헤드리스 인증 REST 엔드포인트 5종**(`Site` 클래스 기반 로그인/가입/비밀번호 재설정/변경).

> 참고: 트리거 핸들러 2종(`MaintenanceRequestTriggerHandler`, `TenantTriggerHandler`)과 그 `_Test`는 여러 샘플(`*-b2e`, `*-b2x`)에 **동일하게 중복 복사**되어 있다. 아래는 `ui-bundle-template-app-react-sample-b2e`의 정본 사본을 인용한다. `WebApp*` 인증 클래스는 `webapp-template-app-react-sample-b2x-experimental`에만 있다.

---

## 트리거 핸들러

샘플은 트리거 본문(`.trigger`)에서 거의 모든 로직을 핸들러 클래스로 위임하는 표준 **trigger handler 패턴**을 쓴다.

### MaintenanceRequestTriggerHandler

`Maintenance_Request__c`의 **before insert** 시점에 요청 유형(`Type__c`)에 맞는 활성 워커를 평점 높은 순으로 자동 배정하고, 상태를 `Assigned`로 바꾸며, 예정일(`Scheduled__c`)을 3일 뒤로 설정한다. 단일 `handleBeforeInsert(List<Maintenance_Request__c>)` static 메서드로 구성되며 `without sharing`이다.

핵심 동작:
- `Type__c` → 워커 `Type__c` 매핑 테이블(8종: Plumbing/Electrical/HVAC/Appliance/Carpentry/Landscaping/Cleaning/Pest)을 보유.
- 필요한 워커 타입만 모아 **단일 SOQL**로 활성 워커 조회(`IsActive__c = true`, `ORDER BY Rating__c DESC NULLS LAST, Name ASC`) — 벌크 세이프.
- `Status__c`가 `'New'` 또는 `null`인 요청만 처리. 이미 다른 상태면 자동 배정하지 않는다.
- 배정 후 해당 워커를 리스트 맨 뒤로 회전시켜 **라운드로빈** 분배.

```apex
public without sharing class MaintenanceRequestTriggerHandler {

    public static void handleBeforeInsert(List<Maintenance_Request__c> newRequests) {
        // Map to store request type to worker type mappings
        Map<String, String> requestTypeToWorkerType = new Map<String, String>{
            'Plumbing'    => 'Plumbing',
            'Electrical'  => 'Electrical',
            'HVAC'        => 'HVAC (Heating & Cooling)',
            'Appliance'   => 'Appliance Repair',
            'Carpentry'   => 'General Carpentry',
            'Landscaping' => 'Landscaping / Grounds',
            'Cleaning'    => 'Janitorial / Cleaning',
            'Pest'        => 'Pest Control'
        };

        // Collect unique worker types needed
        Set<String> workerTypesNeeded = new Set<String>();
        for (Maintenance_Request__c request : newRequests) {
            if (request.Type__c != null && requestTypeToWorkerType.containsKey(request.Type__c)) {
                workerTypesNeeded.add(requestTypeToWorkerType.get(request.Type__c));
            }
        }

        // Query for available workers by type
        Map<String, List<Maintenance_Worker__c>> workersByType = new Map<String, List<Maintenance_Worker__c>>();
        if (!workerTypesNeeded.isEmpty()) {
            for (Maintenance_Worker__c worker : [
                SELECT Id, Name, Type__c, Rating__c
                FROM Maintenance_Worker__c
                WHERE Type__c IN :workerTypesNeeded
                AND IsActive__c = true
                ORDER BY Rating__c DESC NULLS LAST, Name ASC
            ]) {
                if (!workersByType.containsKey(worker.Type__c)) {
                    workersByType.put(worker.Type__c, new List<Maintenance_Worker__c>());
                }
                workersByType.get(worker.Type__c).add(worker);
            }
        }

        // Assign workers to requests
        for (Maintenance_Request__c request : newRequests) {
            if ((request.Status__c == 'New' || request.Status__c == null) &&
                request.Type__c != null && requestTypeToWorkerType.containsKey(request.Type__c)) {
                String workerType = requestTypeToWorkerType.get(request.Type__c);

                if (workersByType.containsKey(workerType) && !workersByType.get(workerType).isEmpty()) {
                    // Assign the first available worker (highest rated)
                    Maintenance_Worker__c assignedWorker = workersByType.get(workerType).get(0);
                    request.Assigned_Worker__c = assignedWorker.Id;
                    request.Status__c = 'Assigned';

                    // Set scheduled date to 3 days from now
                    request.Scheduled__c = DateTime.now().addDays(3);

                    // Rotate worker to end of list for round-robin assignment
                    workersByType.get(workerType).remove(0);
                    workersByType.get(workerType).add(assignedWorker);
                }
            }
        }
    }
}
```

> 데이터 모델 객체(`Maintenance_Request__c`, `Maintenance_Worker__c`, 필드 정의)는 [[sf-skills 샘플 앱 - 데이터 모델]] 참조.

#### MaintenanceRequestTriggerHandler_Test 요지

`@testSetup`에서 6개 워커 생성(5개 활성 + 1개 `IsActive__c=false` 비활성 Plumbing). 9개 테스트:
- `testPlumbingRequestAssignment` — Plumbing 요청 → 평점 높은 활성 Plumber 배정, `Status__c='Assigned'`, `Scheduled__c`가 지금+3일(60초 오차 이내) 검증.
- `testElectricalRequestAssignment` / `testHVACRequestAssignment` / `testApplianceRequestAssignment` / `testPestRequestAssignment` — 각 타입별 정확 배정. (HVAC는 요청 `Type__c='HVAC'`가 워커 타입 `'HVAC (Heating & Cooling)'`로 매핑됨을 검증.)
- `testBulkRequestAssignment` — 5건 혼합 벌크 insert 시 전원 배정 검증.
- `testRequestWithoutType` — `Type__c` 없으면 배정 안 됨.
- `testInactiveWorkerNotAssigned` — 활성 Plumber 전부 삭제 후 비활성만 남으면 배정 안 됨.
- `testNonNewStatusNotProcessed` — `Status__c='In Progress'`로 생성 시 트리거가 처리하지 않음(`Assigned_Worker__c`·`Scheduled__c` 모두 null 유지).

### TenantTriggerHandler

`Tenant__c` 레코드에 `User__c`가 설정되면 그 사용자에게 `Tenant_Maintenance_Access` 권한 집합을 자동 부여한다. **insert/update 공용** `assignTenantMaintenanceAccess`가 변경 대상 사용자를 수집한 뒤, `@future` 메서드 `assignTenantMaintenanceAccessAsync`가 비동기로 권한셋을 부여한다(중복 부여 방지 포함). `with sharing`.

핵심 동작:
- insert(`oldMap == null`): `User__c`가 설정된 모든 레코드의 사용자 수집.
- update: `User__c`가 새로 설정되었거나 다른 값으로 바뀐 경우만 수집(`oldRec.User__c != t.User__c`).
- 권한셋 조회는 `Name = 'Tenant_Maintenance_Access' AND IsOwnedByProfile = false`로 한정. 없으면 무동작.
- 이미 `PermissionSetAssignment`가 있는 사용자는 건너뛰어 중복 부여 방지.
- 권한셋 부여는 setup/non-setup 객체 혼합 DML 제약 때문에 `@future`로 분리(트리거 컨텍스트에서 비동기 처리).

```apex
public with sharing class TenantTriggerHandler {

    private static final String PERMISSION_SET_NAME = 'Tenant_Maintenance_Access';

    public static void assignTenantMaintenanceAccess(List<Tenant__c> newList, Map<Id, Tenant__c> oldMap) {
        Set<Id> userIds = new Set<Id>();
        for (Tenant__c t : newList) {
            if (t.User__c == null) {
                continue;
            }
            if (oldMap == null) {
                userIds.add(t.User__c);
            } else {
                Tenant__c oldRec = oldMap.get(t.Id);
                if (oldRec == null || oldRec.User__c != t.User__c) {
                    userIds.add(t.User__c);
                }
            }
        }
        if (userIds.isEmpty()) {
            return;
        }
        assignTenantMaintenanceAccessAsync(new List<Id>(userIds));
    }

    @future
    private static void assignTenantMaintenanceAccessAsync(List<Id> userIdsList) {
        Set<Id> userIds = new Set<Id>(userIdsList);
        if (userIds.isEmpty()) {
            return;
        }
        List<PermissionSet> permSets = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = :PERMISSION_SET_NAME
            AND IsOwnedByProfile = false
            LIMIT 1
        ];
        if (permSets.isEmpty()) {
            return;
        }
        Id permSetId = permSets[0].Id;

        Set<Id> alreadyAssigned = new Set<Id>();
        for (PermissionSetAssignment psa : [
            SELECT AssigneeId
            FROM PermissionSetAssignment
            WHERE PermissionSetId = :permSetId
            AND AssigneeId IN :userIds
        ]) {
            alreadyAssigned.add(psa.AssigneeId);
        }

        List<PermissionSetAssignment> toInsert = new List<PermissionSetAssignment>();
        for (Id uid : userIds) {
            if (alreadyAssigned.contains(uid)) {
                continue;
            }
            toInsert.add(new PermissionSetAssignment(
                PermissionSetId = permSetId,
                AssigneeId = uid
            ));
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }
}
```

#### TenantTriggerHandler_Test 요지

4개 테스트(권한셋이 org에 없으면 assertion을 건너뛰는 방어적 패턴):
- `testAssignOnInsert` — `User__c`를 현재 사용자로 설정해 insert → 해당 권한셋 부여 1건 검증.
- `testAssignOnUpdateWhenUserSet` — `User__c` 없이 insert 후 update로 설정 → 부여 검증.
- `testNoAssignWhenUserNull` — `User__c` null이면 부여 안 됨(에러 없이 통과).
- `testNoDuplicateAssign` — 이미 부여된 사용자에 대해 `User__c` 변경 없는 update 시 부여 건수 불변(중복 없음) 검증.

---

## 헤드리스 인증 (WebApp* 클래스)

`webapp-template-app-react-sample-b2x-experimental` 샘플은 외부(B2X) 사용자용 **헤드리스 인증**을 Apex REST 엔드포인트로 구현한다. UI(LWR/Aura 로그인 페이지)를 거치지 않고 React 프런트엔드가 직접 `/services/apexrest/auth/*`를 호출하며, 내부적으로 Salesforce `Site` 클래스(`Site.login`, `Site.createExternalUser`, `Site.forgotPassword`, `Site.changePassword`, `Site.validatePassword`)에 위임한다. Experience Cloud 사이트의 게스트/인증 사용자 컨텍스트에서 동작한다.

엔드포인트 요약:

| 클래스 | URL 매핑 | 메서드(HTTP) | sharing | 동작 |
|---|---|---|---|---|
| `WebAppLogin` | `/auth/login` | `doLogin(email, password, startUrl)` (POST) | with sharing | `Site.login` 호출 → redirect URL 반환 |
| `WebAppRegistration` | `/auth/register` | `registerUser(RegistrationRequest)` (POST) | without sharing | 외부 사용자 생성 후 자동 로그인 |
| `WebAppForgotPassword` | `/auth/forgot-password` | `forgotPassword(username)` (POST) | with sharing | `Site.forgotPassword` 재설정 메일 발송 |
| `WebAppChangePassword` | `/auth/change-password` | `changePassword(newPassword, currentPassword)` (POST) | with sharing | 인증 사용자 본인 비밀번호 변경 |
| `WebAppAuthUtils` | (REST 아님) | `getSanitizedStartUrl`, `debugLog`, `AuthException` | without sharing | 공용 유틸·예외 |

> 모든 엔드포인트는 성공/오류 응답을 `global abstract` 베이스 + Success/Error 구현 클래스 쌍으로 직렬화하고, 오류 시 `RestContext.response.statusCode`로 HTTP 코드를 직접 지정한다.

### WebAppLogin — 로그인

`@RestResource(urlMapping='/auth/login')`, `global with sharing`. `doLogin`이 입력 검증 후 `WebAppAuthUtils.getSanitizedStartUrl`로 startUrl을 소독하고 `Site.login`을 호출. 로그인 예외는 400, `loginResult == null`이면 401, `AuthException`은 그 자체 statusCode, 그 외는 500으로 응답한다.

```apex
@RestResource(urlMapping='/auth/login')
global with sharing class WebAppLogin {

    @HttpPost
    global static LoginResponse doLogin(String email, String password, String startUrl) {
        try {
            validateInput(email, password);

            String username = email.trim().toLowerCase();
            String sanitizedStartUrl = WebAppAuthUtils.getSanitizedStartUrl(startUrl, Site.getPathPrefix());

            PageReference loginResult;
            try {
                loginResult = Site.login(username, password, sanitizedStartUrl);
            } catch (Exception loginEx) {
                RestContext.response.statusCode = 400;
                return new ErrorLoginResponse('Invalid username or password.');
            }

            if (loginResult != null) {
                return new SuccessLoginResponse(loginResult.getUrl());
            } else {
                RestContext.response.statusCode = 401;
                return new ErrorLoginResponse(
                    'Your login attempt has failed. Make sure the username and password are correct.'
                );
            }
        } catch (WebAppAuthUtils.AuthException ex) {
            RestContext.response.statusCode = ex.statusCode;
            return new ErrorLoginResponse(ex.messages);
        } catch (Exception ex) {
            WebAppAuthUtils.debugLog(ex, LoggingLevel.ERROR);
            RestContext.response.statusCode = 500;
            return new ErrorLoginResponse('An unexpected error occurred. Please contact your administrator.');
        }
    }

    private static void validateInput(String email, String password) {
        List<String> errors = new List<String>();
        if (String.isBlank(email)) {
            errors.add('Email is required.');
        }
        if (String.isBlank(password)) {
            errors.add('Password is required.');
        }
        if (!errors.isEmpty()) {
            throw new WebAppAuthUtils.AuthException(400, errors);
        }
    }

    global abstract class LoginResponse {}

    global class SuccessLoginResponse extends LoginResponse {
        global Boolean success = true;
        global String redirectUrl;
        global SuccessLoginResponse(String redirectUrl) { this.redirectUrl = redirectUrl; }
    }

    global class ErrorLoginResponse extends LoginResponse {
        global List<String> errors;
        global ErrorLoginResponse(List<String> errors) { this.errors = new List<String>(errors); }
        global ErrorLoginResponse(String error) { this.errors = new List<String>{ error }; }
    }
}
```

### WebAppRegistration — 자기 가입

`@RestResource(urlMapping='/auth/register')`, `global without sharing`(게스트가 username 중복 검사를 하려면 without sharing 필요). `Database.setSavepoint()`로 시작해 실패 시 `Database.rollback`. `RegistrationRequest`(email/firstName/lastName/password/startUrl)를 받아 검증·외부 사용자 생성·자동 로그인까지 수행한다.

핵심 메서드:
- `registerUser(RegistrationRequest)` `@HttpPost` — 검증 → `User` 빌드(CommunityNickname = 이름 첫 글자 + 성 최대 20자 + `Crypto.getRandomInteger()` 앞 4자리) → `validatePassword` → `createUser` → `Site.login`으로 자동 로그인.
- `RegistrationRequest.validate()` — 필드 trim/소문자화, 필수값·`Site.isValidUserName`·중복 검사. 실패 시 `AuthException(400, errors)`.
- `validatePassword(User, String)` — `Site.validatePassword`를 호출, `System.SecurityException`을 `AuthException(400, ...)`으로 변환.
- `createUser(User, String)` — `Site.createExternalUser(u, null, password)`. `Site.ExternalUserCreateException`을 `AuthException(500, getDisplayMessages())`로, null 결과를 500으로 변환.
- `isUserUnique(String)` — `[SELECT Id FROM User WHERE Username = :username LIMIT 1].isEmpty()`.

```apex
@RestResource(urlMapping='/auth/register')
global without sharing class WebAppRegistration {

    @HttpPost
    global static RegistrationResponse registerUser(RegistrationRequest request) {
        Savepoint sp = Database.setSavepoint();
        try {
            request.validate();

            User u = new User(
                Username = request.email,
                Email = request.email,
                FirstName = request.firstName,
                LastName = request.lastName,
                // first initial + up to 20 chars of last name + 4 random digits
                CommunityNickname = request.firstName.left(1) + request.lastName.left(20) +
                    String.valueOf(Crypto.getRandomInteger()).left(4)
            );

            validatePassword(u, request.password);
            createUser(u, request.password);

            String startUrl = WebAppAuthUtils.getSanitizedStartUrl(request.startUrl, Site.getPathPrefix());
            PageReference pageRef = Site.login(request.email, request.password, startUrl);

            return new SuccessRegistrationResponse(pageRef?.getUrl());
        } catch (WebAppAuthUtils.AuthException ex) {
            Database.rollback(sp);
            RestContext.response.statusCode = ex.statusCode;
            return new ErrorRegistrationResponse(ex.messages);
        } catch (Exception ex) {
            Database.rollback(sp);
            RestContext.response.statusCode = 500;
            return new ErrorRegistrationResponse(ex.getMessage());
        }
    }

    global class RegistrationRequest {
        global String email;
        global String firstName;
        global String lastName;
        global String password;
        global String startUrl;

        public void validate() {
            email = email?.trim()?.toLowerCase();
            firstName = firstName?.trim();
            lastName = lastName?.trim();
            startUrl = startUrl?.trim();

            List<String> errors = new List<String>();
            if (String.isBlank(firstName)) { errors.add('First name is required.'); }
            if (String.isBlank(lastName)) { errors.add('Last name is required.'); }
            if (String.isBlank(password)) { errors.add('Password is required.'); }
            if (!Site.isValidUserName(email)) { errors.add('Email is invalid.'); }
            else if (!isUserUnique(email)) {
                errors.add('A user with this email already exists.');
            }
            if (!errors.isEmpty()) {
                throw new WebAppAuthUtils.AuthException(400, errors);
            }
        }
    }

    private static void validatePassword(User user, String password) {
        try {
            Site.validatePassword(user, password, password);
        } catch (System.SecurityException ex) {
            throw new WebAppAuthUtils.AuthException(400, ex.getMessage());
        }
    }

    private static String createUser(User u, String password) {
        String userId;
        try {
            userId = Site.createExternalUser(u, null, password);
        } catch (Site.ExternalUserCreateException ex) {
            throw new WebAppAuthUtils.AuthException(500, ex.getDisplayMessages());
        }
        if (userId == null) {
            throw new WebAppAuthUtils.AuthException(500, 'Could not register new user.');
        }
        return userId;
    }

    private static Boolean isUserUnique(String username) {
        return [SELECT Id FROM User WHERE Username = :username LIMIT 1].isEmpty();
    }
    // ... SuccessRegistrationResponse / ErrorRegistrationResponse (위 Login과 동일 패턴)
}
```

### WebAppForgotPassword — 비밀번호 재설정 메일

`@RestResource(urlMapping='/auth/forgot-password')`, `global with sharing`. `forgotPassword(username)`가 username을 trim/소문자화하고 빈 값이면 400, 아니면 `Site.forgotPassword(username)`로 재설정 링크를 발송한다(존재하는 username일 때만 실제 발송 — 사용자 열거 방지). 예외는 500.

```apex
@RestResource(urlMapping='/auth/forgot-password')
global with sharing class WebAppForgotPassword {

    @HttpPost
    global static ForgotPasswordResponse forgotPassword(String username) {
        try {
            username = username.trim().toLowerCase();

            if (String.isBlank(username)) {
                RestContext.response.statusCode = 400;
                return new ErrorForgotPasswordResponse('Username is required.');
            }

            // sends a reset link only if the username exists
            Site.forgotPassword(username);

            return new SuccessForgotPasswordResponse();
        } catch (Exception ex) {
            WebAppAuthUtils.debugLog(ex, LoggingLevel.ERROR);
            RestContext.response.statusCode = 500;
            return new ErrorForgotPasswordResponse('Could not send password reset link.');
        }
    }
    // 응답: ForgotPasswordResponse(abstract, protected final Boolean success)
    //       SuccessForgotPasswordResponse / ErrorForgotPasswordResponse(private final String error)
}
```

> 메서드 시그니처는 파라미터명이 `username`이지만 ApexDoc 주석에는 `@param email`로 표기돼 있다(소스 그대로). 실제 바인딩되는 JSON 키는 파라미터명 `username`.

### WebAppChangePassword — 인증 사용자 비밀번호 변경

`@RestResource(urlMapping='/auth/change-password')`, `global with sharing`(인증된 본인만 자기 비밀번호 변경). `Database.setSavepoint()` 후 `Site.changePassword(newPassword, newPassword, currentPassword)` 호출. `System.SecurityException`은 사용자 오류로 400, 그 외는 500(롤백).

```apex
@RestResource(urlMapping='/auth/change-password')
global with sharing class WebAppChangePassword {

    @HttpPost
    global static PasswordChangeResponse changePassword(String newPassword, String currentPassword) {
        Savepoint sp = Database.setSavepoint();
        try {
            // newPassword and confirmPassword validated to be equal on the client
            Site.changePassword(newPassword, newPassword, currentPassword);
            return new SuccessPasswordChangeResponse();
        } catch (Exception ex) {
            Database.rollback(sp);

            if (ex instanceof System.SecurityException) {
                RestContext.response.statusCode = 400;
                return new ErrorPasswordChangeResponse(ex.getMessage());
            }

            WebAppAuthUtils.debugLog(ex, LoggingLevel.ERROR);
            RestContext.response.statusCode = 500;
            return new ErrorPasswordChangeResponse('Password change failed');
        }
    }
    // 응답: PasswordChangeResponse(abstract, protected final Boolean success)
    //       SuccessPasswordChangeResponse / ErrorPasswordChangeResponse(private final String error)
}
```

### WebAppAuthUtils — 공용 유틸 & 예외

`public without sharing`. 세 가지를 제공한다.

- `AuthException extends Exception` — `Integer statusCode`(get; private set), `List<String> messages`(get; private set). 생성자 2개: `(Integer, String)`, `(Integer, List<String>)`.
- `getSanitizedStartUrl(String url, String defaultUrl)` — **open redirect 방어**. URL 디코드 후 `/`로 시작하지 않거나 `//`(protocol-relative)·백슬래시·`@`·`:`·제어문자(ASCII<32 또는 127)를 포함하면 `defaultUrl` 반환. 통과 시 `defaultUrl + url` 반환.
- `debugLog(Exception ex, LoggingLevel level)` — 메시지·스택트레이스를 `System.debug`로 기록(Trace Flag 활성 시에만 캡처).

```apex
public without sharing class WebAppAuthUtils {

    public class AuthException extends Exception {
        public Integer statusCode { get; private set; }
        public List<String> messages { get; private set; }

        public AuthException(Integer statusCode, String message) {
            this.statusCode = statusCode;
            this.messages = new List<String>{ message };
        }
        public AuthException(Integer statusCode, List<String> messages) {
            this.statusCode = statusCode;
            this.messages = new List<String>(messages);
        }
    }

    public static String getSanitizedStartUrl(String url, String defaultUrl) {
        if (String.isBlank(url) || url.equals('/')) { return defaultUrl; }

        String decoded; // decode to catch encoded bypasses (%2f%2f -> //)
        try {
            decoded = EncodingUtil.urlDecode(url, 'UTF-8');
        } catch (Exception e) {
            return defaultUrl;
        }

        if (!decoded.startsWith('/') || decoded.startsWith('//')) { return defaultUrl; }
        if (decoded.contains('\\')) { return defaultUrl; }
        if (decoded.contains('@')) { return defaultUrl; }
        if (decoded.contains(':')) { return defaultUrl; }
        for (Integer i = 0; i < decoded.length(); i++) {
            Integer charCode = decoded.charAt(i);
            if (charCode < 32 || charCode == 127) { return defaultUrl; }
        }

        return defaultUrl + url;
    }

    public static void debugLog(Exception ex, LoggingLevel level) {
        System.debug(level, 'Message: ' + ex.getMessage());
        System.debug(level, 'Stack Trace: ' + ex.getStackTraceString());
    }
}
```

---

## 관련 노트
- [[sf-skills 샘플 앱 - 개요]]
- [[sf-skills 샘플 앱 - 데이터 모델]]
