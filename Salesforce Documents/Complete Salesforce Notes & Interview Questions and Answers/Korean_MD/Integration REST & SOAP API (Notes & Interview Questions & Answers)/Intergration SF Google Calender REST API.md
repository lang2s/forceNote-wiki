# Salesforce-Google Calendar REST API 통합

## Postman 설정

**1. Google Cloud 프로젝트 생성·Calendar API 활성화:** Google Cloud Console → 프로젝트 생성/선택 → APIs & Services → Library → "Google Calendar API" 검색 → Enable.

**2. OAuth 2.0 자격 증명 생성:** APIs & Services → Credentials → Create Credentials → OAuth client ID → Web application → Authorized JavaScript origins(`https://app.getpostman.com`) → Authorized redirect URIs(`https://www.getpostman.com/oauth2/callback`) → Create. Client ID·Client Secret 기록.

**3·4. Postman OAuth 2.0 구성:** Authorization 탭 → Type=OAuth 2.0 → Grant Type=Authorization Code.
- Token Name: Google Calendar API
- Callback URL: `https://www.getpostman.com/oauth2/callback`
- Auth URL: `https://accounts.google.com/o/oauth2/auth`
- Access Token URL: `https://accounts.google.com/o/oauth2/token`
- Client ID·Secret: Google Cloud 값
- Scope: `https://www.googleapis.com/auth/calendar.readonly`

Get New Access Token → Google 로그인·권한 부여.

**5. API 요청:** `GET https://www.googleapis.com/calendar/v3/calendars/primary/events`, Authorization=Bearer Token.

## Salesforce 설정

**1. Auth. Provider 생성:** Setup → Auth. Providers → New.
- Provider Type: Google
- Name: Google Calendar, URL Suffix: GoogleCalendar
- Consumer Key·Secret: Google Cloud 값
- Authorize Endpoint URL: `https://accounts.google.com/o/oauth2/auth?access_type=offline&prompt=consent`
- Token Endpoint URL: `https://accounts.google.com/o/oauth2/token`
- Default Scopes: `https://www.googleapis.com/auth/calendar.readonly`

> Callback URL을 Google OAuth 자격 증명의 Authorized redirect URIs에 추가.

**2. Named Credential 생성:** Setup → Named Credentials → New Legacy.
- URL: `https://www.googleapis.com/calendar/v3`
- Identity Type: Named Principal
- Authentication Protocol: OAuth 2.0
- Authentication Provider: GoogleCalendar
- Scope: `https://www.googleapis.com/auth/calendar.readonly`

**3. Apex 클래스로 API 호출:**
```apex
public class GoogleCalendarService {
    public static String getCalendarData() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Your_Named_Credential_Name');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() == 200) return res.getBody();
        return null;
    }
}
```

**4. 실행(익명 창):** `String calendarData = GoogleCalendarService.getCalendarData();`
