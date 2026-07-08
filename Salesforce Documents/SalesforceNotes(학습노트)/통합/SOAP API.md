---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOAP API]
---

# SOAP API

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## SOAP API란?
Simple Object Access Protocol. XML 기반 개방 표준 메시징 프로토콜. 플랫폼·언어 독립, 단순·확장 가능, stateless. 레코드 생성·조회·업데이트·삭제.

## SOAP 요소
- **Envelope:** XML 문서를 SOAP 메시지로 식별(루트, 필수).
- **Header:** 헤더 정보(선택).
- **Body:** 요청·응답 정보(필수).
- **Fault:** 오류·상태 정보.

## SOAP 구문
XML 인코딩, SOAP Envelope·Encoding 네임스페이스, DTD 참조·XML 처리 지시 금지.
```xml
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
  soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">
  <soap:Header> ... </soap:Header>
  <soap:Body>
    <soap:Fault> ... </soap:Fault>
  </soap:Body>
</soap:Envelope>
```

**Envelope:**

메시지 시작·끝 표시(패키징). 루트, 정확히 하나의 Body. Header 있으면 첫 자식.
**Header:**

선택, 다중 가능, 새 기능 추가. 속성: actor(수신 노드 지정), mustUnderstand(필수 여부, 1이면 처리 또는 fault).
**Body:**

필수, 애플리케이션 XML 데이터.
**Fault:**

오류 시 반환(코드·설명·SOAP 프로세서 주소). 메시지당 fault 1개. HTTP 200~299=성공, 500~599=fault.

```xml
<!-- 요청 -->
<soap:Body><m:GetPrice xmlns:m="..."><m:Item>Apples</m:Item></m:GetPrice></soap:Body>
<!-- 응답 -->
<soap:Body><m:GetPriceResponse xmlns:m="..."><m:Price>1.90</m:Price></m:GetPriceResponse></soap:Body>
```

## 예: Global Weather (WSDL 소비)
URL: http://www.webserviceX.NET
**WSDL 소비:**

Setup → Apex Classes → Generate from WSDL.

생성된 클래스(wsdl2apex)는 GlobalWeather.GlobalWeatherSoap에 GetWeather·GetCitiesByCountry 메서드 포함, WebServiceCallout.invoke로 콜아웃.

```apex
// VF 컨트롤러
public class SOAPAPI_controller {
    public String CityName {set;get;}
    public String CountryName {set;get;}
    public String response {set;get;}
    public void getdata() {
        GlobalWeather.GlobalWeatherSoap gw = new GlobalWeather.GlobalWeatherSoap();
        response = gw.GetWeather(CityName, CountryName);
    }
}
```
```html
<apex:page controller="SOAPAPI_controller">
  <apex:form>
    Enter City Name <apex:inputText value="{!CityName}"/><br/>
    Enter Country Name <apex:inputText value="{!CountryName}"/><br/>
    <apex:commandButton value="Get Weather" action="{!getdata}"/><br/>
    Response:: {!Response}
  </apex:form>
</apex:page>
```
