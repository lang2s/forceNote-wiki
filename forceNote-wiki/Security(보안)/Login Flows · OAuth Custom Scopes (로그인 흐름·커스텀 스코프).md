---
tags: [security, identity, login-flow, oauth, custom-scope, authentication, flow, apex]
source: help.salesforce.com - xcloud.security_login_flow.htm · xcloud.remoteaccess_oauth_customscopes.htm (외 4개, 접속 2026-07-11)
created: 2026-07-11
aliases: [Login Flow, Login Flows, Custom Login Flow, 로그인 흐름, 로그인 플로우, OAuth Custom Scope, Custom Scope, 커스텀 스코프, finishLoginFlow, 로그인 후처리]
---

# Login Flows · OAuth Custom Scopes (로그인 흐름·커스텀 스코프)

> **Login Flow** = 인증 성공 직후 실행되는 커스텀 후처리(화면/로직)로 MFA 등록 강제·약관 동의·정보 수집 등을 프로파일별로 삽입한다. **OAuth Custom Scope** = 외부 엔티티가 호스팅하는 보호 리소스에 대한 앱 권한을 정의하는 커스텀 OAuth 스코프다. 둘 다 표준 인증/OAuth 동작을 커스터마이즈하는 도구다.

---

# Part 1 — Login Flows (커스텀 로그인 흐름)

로그인 흐름은 사용자가 Salesforce org 또는 Experience Cloud 사이트에 로그인할 때 따르는 **비즈니스 프로세스를 제어**한다. Salesforce가 사용자를 인증한 **후**, 로그인 흐름이 강한 인증 강제·정보 수집 같은 프로세스로 사용자를 안내한다. 성공 완료 시 org/사이트로 리디렉트되고, 실패 시 흐름이 사용자를 즉시 로그아웃할 수 있다.

**핵심:** 로그인 흐름은 기존 인증을 **대체하지 않는다.** 사용자가 먼저 인증돼야 로그인 흐름이 호출되며, 인증 절차에 단계를 **추가**하거나 정보를 요청한다.

**지원 범위:**
- 인증 방식 전부 지원: 표준 username/password, delegated authentication, SAML SSO, 서드파티 auth provider SSO. (예: LinkedIn 로그인 사용자에게 LinkedIn 전용 흐름)
- Salesforce org·Experience Cloud 사이트에 적용 가능. OAuth를 쓰는 특정 Salesforce 클라이언트 앱에도 적용.
- ⚠️ **API 로그인**이나 non-UI 로그인에서 `frontdoor.jsp`로 세션이 UI에 전달될 때는 **적용 불가**.

**대표 유스케이스:** 로고/로그인 메시지 추가, 사용자 데이터(이메일·전화·주소) 수집·갱신, 설문/약관 동의 요청, Customer Identity 연결, 비표준 근무시간 로그인 알림 등.

## 실행 가이드라인 (성능·보안)

> ⚠️ Login Flow 설계 시 준수:
- **org 밖으로 리디렉트 금지** — open redirect 취약점이 되며, start URL을 쓰는 표준 identity 서비스(비밀번호 재설정 등)를 깨뜨린다.
- **로그인 관련 단계만 포함** — 사용자와 무관한 레코드 갱신 등 비로그인 비즈니스 프로세스를 넣으면 부작용으로 일부 서비스가 막힐 수 있다.
- 커스텀 로그인 흐름은 사용자가 **수동 로그아웃**할 때만 재호출된다.

## 만드는 방법 — Flow Builder vs Visualforce

| 방식 | 특징 | 필요 권한 |
|---|---|---|
| **Flow Builder** | 포인트앤클릭. 로그인 시 실행되는 **screen flow**(화면+커넥터) 선언적 생성. 로고·배경/버튼 색·우측 프레임 콘텐츠 커스터마이즈 | Manage Flow |
| **Visualforce + Apex** | 코드로 완전 제어(로그인 페이지 외관·동작·완료 후 이동). 픽셀 단위 제어 | VF 페이지 접근 |

### Flow Builder 로그인 흐름
1. screen flow 생성 → **저장 후 반드시 활성화(Activate)**
2. Setup에서 로그인 흐름으로 지정하고 프로파일과 연결(아래 참조)

### Visualforce + Apex 로그인 흐름
비즈니스 프로세스를 VF 페이지의 **Apex 컨트롤러**에 정의한다. Salesforce는 VF 로그인 흐름에 입력 변수를 전달하지 않지만, 사용자/로그인 컨텍스트에 접근할 수 있다. 컨트롤러는 아래 Apex 메서드 중 하나를 포함해야 한다.

| 메서드 | 동작 |
|---|---|
| `Auth.SessionManagement.finishLoginFlow()` | 로그인 흐름 완료를 알리고 **홈페이지**로 리디렉트 |
| `Auth.SessionManagement.finishLoginFlow(startURL)` | 로그인 흐름 완료를 알리고 **지정 페이지**로 리디렉트 |

로그인 흐름은 **제한된(restricted) 세션**에서 실행된다. `finishLoginFlow` 호출이 세션 제한을 해제하고 Salesforce/사이트 접근을 부여한다 — 언제/어떤 조건에서 호출할지 개발자가 결정한다.

공식 문서 Apex 컨트롤러 예:
```apex
// 실제 문서 발췌 — VF 로그인 흐름 컨트롤러
public class VFLoginFlowController {
    public PageReference FinishLoginFlowStartUrl() {
        //do stuff
        // 로그인 흐름 종료 후 startUrl(여기선 account 페이지)로 이동
        return Auth.SessionManagement.finishLoginFlow('/001');
    }
    public PageReference FinishLoginFlowHome() {
        //do stuff
        // 로그인 흐름 종료 후 기본 홈페이지로 이동
        return Auth.SessionManagement.finishLoginFlow();
    }
}
```
대응 VF 페이지는 두 액션을 커맨드 버튼으로 노출한다(`<apex:commandButton action="{!FinishLoginFlowHome}" .../>` 등). VF 로그인 흐름은 연결할 각 프로파일에 **VF 페이지 접근 권한**을 줘야 한다(Setup > Visualforce Pages > 대상 페이지 > Security).

## 프로파일 연결 — Set Up a Login Flow and Connect to Profiles

흐름을 만든 뒤 로그인 흐름으로 지정하고 **사용자 프로파일**과 연결한다. 여러 로그인 흐름을 만들어 각기 다른 프로파일에 연결할 수 있다.

**연결 전 주의:**
- Flow Builder 흐름은 프로파일 연결 전 **활성화 필수**.
- 흐름이 제대로 동작한다고 확신하기 전엔 **관리자 프로파일에 연결하지 말 것** — 실패 시 org 로그인 불가.
- VF 로그인 흐름은 연결 프로파일이 해당 **VF 페이지 접근 권한**을 가져야 함.
- 관리자가 **다른 사용자로 로그인(Login As)** 할 때는 로그인 흐름 적용 안 됨.

**절차:**
1. Setup > Quick Find > **Login Flows**
2. 사용 가능한 흐름 드롭다운에서 생성한 로그인 흐름 선택
3. 프로파일과 연결된 **user license** 선택
4. 해당 라이선스의 프로파일 목록에서 연결할 **프로파일** 선택
5. 저장

연결 후에는 Login Flows Setup 페이지에서 편집·삭제 가능.

> ⚠️ **Render Flow in Lightning Runtime** 활성화 시, 로그인 흐름 사용자가 흐름을 완료하기 **전에** Salesforce 기능에 접근할 수 있어 무단 접근 보안 위험이 있다. 보안 강제 목적의 로그인 흐름이면 이 설정을 켜지 않는 것을 권장한다.

---

# Part 2 — OAuth Custom Scopes (OAuth 커스텀 스코프)

앱은 OAuth 프로토콜로 보호 리소스에 접근하고, **OAuth 기본(default) 스코프**가 Salesforce 내 보호 리소스 접근 권한을 조율한다. 그러나 보호 리소스를 **외부 엔티티**가 호스팅하면 기본 스코프로는 부족하다 — 이때 Salesforce는 OAuth 인증·인가 제공자 역할을 하지만 보호 대상 리소스에 대해 아는 게 거의 없다. **OAuth custom scope**를 만들면, 외부 클라이언트 앱이 접근 인가받은 정보가 무엇인지 외부 엔티티에 알린다.

- **에디션:** External client app 생성 가능 — Group, Essentials, Professional, Enterprise, Performance, Unlimited, Developer. 설치는 전 에디션.
- ⚠️ custom scope는 **샌드박스 새로고침 시 포함되지 않는다** — refresh 후 ECA에 재할당 필요.

## 동작 흐름 (예: Customer Order Status 웹앱)

Salesforce의 custom scope는 외부 엔티티에서 정의해 리소스에 할당하는 **정책(policy)** 에 대응한다.

```text
// 구조 예시 — 공식 문서 시나리오 요약(실제 코드/설정 아님)
[Salesforce Org Admin]
  1. order_status OAuth custom scope 생성 + 보호 데이터 설명(고객 주문 상태)
  2. 그 scope를 Customer Order Status 웹앱의 ECA에 할당
[API Provider Admin]
  3. API Management에서 "order_status scope 필요" 정책을 주문 상태 리소스에 적용

[런타임 토큰 흐름]
  · API gateway가 호출을 가로채 OAuth grant type 기반으로 Salesforce에 access token 질의
  · Salesforce가 client ID/secret 검증 → access token에 order_status scope 포함해 gateway로 전송
  · gateway가 (1) 토큰 유효 (2) order_status scope 포함 확인 → 웹앱에 주문상태 접근 허용
```

## Create an OAuth Custom Scope (생성)

- **필요 권한:** Manage external client apps

**절차:**
1. Setup > Quick Find > **OAuth Custom Scopes**
2. **New Custom Scope** 클릭
3. **이름** 입력 — 외부 엔티티의 대응 정책에 **정확히 같은 이름**을 준다. 고유해야 하고 **문자로 시작**, 영숫자·언더스코어만, **공백 불가**.
4. **설명** 입력 — 스코프가 허용하는 보호 데이터 설명. 고유하고, 영숫자만, **60자 이하**. (설명 대신 **Custom Label** 사용 가능 — 재사용·다국어 번역 이점. 같은 포맷 요건 적용)
5. (선택) **Include on well known endpoint** — 스코프를 ECA의 **OpenID Connect discovery endpoint**(well-known)에 포함.

> 스코프 설명·custom label은 사용자가 ECA를 승인할 때 **OAuth approval 페이지에 표시**된다.

## Assign an OAuth Custom Scope to an External Client App (할당)

- **필요 권한:** Manage external client apps

**절차:**
1. Setup > Quick Find > **External Client Apps Manager**
2. 목록에서 대상 ECA 선택
3. Policies 페이지의 **OAuth Policies** 섹션 펼치기
4. 할당할 **OAuth custom scopes** 선택 후 저장

**토큰에서 스코프 수령:** 보통 authorization request의 **scope 파라미터**에 스코프를 포함해야 한다. 단 **OAuth 2.0 JWT bearer flow**에서 사전 승인(pre-authorized)된 ECA는 custom scope가 access token과 함께 **자동 반환**된다.

> 참고: 커스텀 스코프 할당의 정본 위치는 **External Client Apps Manager**다(위 SAML 노트처럼 connected app 신규 생성은 Spring '26부터 제한 — ECA 권장).

---

## 관련 노트
- [[Salesforce as Identity Provider (SF를 IdP로)]]
- [[External Client App (외부 클라이언트 앱)]]
- [[Connected App (연결된 앱) — OAuth 클라이언트]]
- [[Auth Provider (인증 공급자)]]
- [[Screen Flow 설계]]

---

### 출처 (Tier 2 · help.salesforce.com · 접속 2026-07-11)
- Custom Login Flows — `xcloud.security_login_flow.htm`
- Create a Login Flow with Flow Builder — `xcloud.security_login_flow_cloud_designer.htm`
- Create a Custom Login Flow with Visualforce — `xcloud.security_login_flow_visualforce.htm`
- Set Up a Login Flow and Connect to Profiles — `xcloud.security_login_flow_associate.htm`
- OAuth Custom Scopes — `xcloud.remoteaccess_oauth_customscopes.htm`
- Create an OAuth Custom Scope — `xcloud.remoteaccess_oauth_customscopes_create.htm`
- Assign an OAuth Custom Scope to an External Client App — `xcloud.remoteaccess_oauth_customscopes_assign.htm`
