---
tags: [service-cloud, voice, telephony, service-cloud-voice, amazon-connect, contact-center, voicecall, omni-channel]
source: help.salesforce.com (Salesforce Help — Set Up Service Cloud Voice) + developer.salesforce.com (Object Reference — VoiceCall · Salesforce Voice Developer Guide), 라이브 공식 문서, Tier 2, 접속 2026-07-12
official_doc: https://help.salesforce.com/s/articleView?id=service.voice_intro.htm&type=5
created: 2026-07-12
aliases: [Service Cloud Voice, SCV, Salesforce Voice, Voice, 서비스 클라우드 보이스, Amazon Connect, Contact Center, VoiceCall, 통화 전사]
---

# Service Cloud Voice

> 콘솔에 네이티브로 통합된 클라우드 텔레포니 — 통화·실시간 전사·AI 인사이트를 CRM 한 화면에서 처리한다. 레거시 [[Open CTI & Telephony (전화 통합)]](2028-02-28 은퇴 예정)의 공식 후속 전화 채널.

---

## 개념 — Service Cloud Voice란

**Service Cloud Voice(SCV)**는 전화 통화를 Salesforce **Service Console**에 네이티브로 통합하는 클라우드 텔레포니 솔루션이다. 상담원이 별도 전화 시스템으로 화면을 전환하지 않고, CRM 데이터·케이스·통화 제어·실시간 전사를 한 워크스페이스에서 다룬다. 음성 대화·디지털 채널·CRM 데이터를 하나로 묶어, 통화 내용이 실시간으로 텍스트화되고 Einstein AI가 그 위에서 next best action·추천 아티클을 제시한다.

핵심 가치는 **"통화가 곧 CRM 레코드"** 라는 점이다. 통화가 시작되면 Salesforce에 **VoiceCall** 레코드(= conversation)가 생성되고, 녹음·전사·인사이트가 그 레코드에 매달린다. 라우팅은 채팅·메시지와 동일한 **[[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반|Omni-Channel]]** 엔진을 재사용해, 음성을 다른 디지털 채널과 같은 규칙으로 상담원에게 배분한다.

> ⚠️ **Setup 라벨 캐비엇(2026-07-12):** 아래 모델명·Setup 경로 라벨(예: "Voice", "Contact Centers")은 릴리즈·에디션에 따라 표기가 달라질 수 있다. 실제 구성 시 조직의 Setup 검색으로 최신 라벨을 확인한다.

## Open CTI와의 관계 (레거시 vs 후속)

| 구분 | [[Open CTI & Telephony (전화 통합)]] (레거시) | Service Cloud Voice (후속) |
|---|---|---|
| 형태 | 서드파티 CTI를 붙이는 **JavaScript API** | Salesforce **네이티브 클라우드 텔레포니** 제품 |
| 통화 처리 | 벤더가 구축한 softphone (Call Center) | 콘솔 내장 Phone + Omni-Channel |
| 전사·AI | 벤더 몫 (기본 없음) | **실시간 전사 + Einstein 인사이트 기본** |
| 상태 | **유지보수 모드 · 2028-02-28 은퇴 예정** | 현행 권장 채널 |

Salesforce는 장기 호환성과 최신 혁신을 위해 신규 전화 통합을 Open CTI가 아니라 **Service Cloud Voice로 구축**하도록 권장한다. Open CTI의 은퇴 세부는 [[Open CTI & Telephony (전화 통합)]] 노트 참조.

## 텔레포니 모델 3종

SCV는 "누가 통신망(캐리어)을 제공하고 AWS 계정을 누가 소유하느냐"에 따라 세 가지 배포 모델을 제공한다.

| 모델 | 통신망 제공 주체 | AWS 계정 | 언제 |
|---|---|---|---|
| **Voice with Amazon Connect** (턴키/번들) | **Salesforce가 제공** — Amazon Connect를 Salesforce가 관리하는 AWS 계정 위에서 프로비저닝 | Salesforce Master Payer 아래 신규 AWS 계정(고객이 root 접근, Service Control Policy로 서비스 제한) | 가장 빠른 시작. Salesforce가 텔레포니까지 일괄 제공받고 싶을 때 |
| **Voice with Partner Telephony** | **파트너 통신사** — Amazon Connect(BYOA) 또는 Genesys·NICE CXone·Vonage·Cisco·Avaya 등 인증 파트너 | Partner Telephony from Amazon Connect의 경우 **고객 소유 AWS 계정**(BYOA); 비-Amazon 파트너는 파트너 인프라 | 기존 파트너 통신사 계약을 유지하며 SCV로 통합하고 싶을 때 |
| **Voice with Bring Your Own Telephony (BYOT)** | **고객의 기존 캐리어** — 자체 텔레포니 인프라를 Voice API로 연결 | 고객 인프라 | 자체 통신 사업자/장비를 그대로 쓰고 싶을 때 |

- SCV 자체 기능(콘솔 통합·전사·인사이트·Omni 라우팅)은 세 모델에서 **본질적 차이가 없다.** 차이는 통신망·AWS 소유·프로비저닝 방식이다.
- Government Cloud 등 일부 환경은 **Partner Telephony** 경로가 필요하다.

## 구성 요소

| 요소 | 역할 |
|---|---|
| **Contact Center** | SCV의 최상위 구성 단위. 텔레포니 벤더·전화번호·에이전트·라우팅 설정을 담는 컨테이너. Setup에서 Contact Center를 생성하고 상담원을 여기에 추가한다. |
| **Phone (콜 컨트롤)** | 콘솔 utility bar에 내장된 통화 제어판(softphone). 발신·수신·보류·전환·음소거 등. Omni-Channel utility와 함께 동작. |
| **통화 녹음 (Call Recording)** | 통화를 자동 녹음해 VoiceCall 레코드에서 재생. 관련 객체: `VoiceCallRecording`. |
| **실시간 전사 (Transcription)** | 통화 음성을 실시간 텍스트로 변환해 레코드에 저장. 케이스·레코드에 자동 반영되어 수기 입력을 줄인다. |
| **Einstein 인사이트 (AI)** | 전사 위에서 next best action·추천 Knowledge 아티클 제공. 관련 객체: `VoiceCallInsight`(녹음/전사별 인사이트). |
| **Omni-Channel 라우팅 연계** | 음성을 채팅·메시지와 동일한 [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반|Omni-Channel 엔진]]으로 상담원에 배분. 상담원 presence status에 phone 채널이 포함돼야 한다. |
| **VoiceCall 객체** | 통화 1건 = 레코드 1건. 통화가 생성되면 Salesforce에 conversation이 만들어진다. (아래 참조) |

## VoiceCall 객체 (레퍼런스)

`VoiceCall`은 Salesforce Voice·Sales Dialer 등 지원 커넥터에서의 **통화 1건을 표현하는 표준 객체**다. Object Reference에 정적 문서로 공개돼 있다.

Voice REST API로 통화 레코드를 만들 때 사용하는 주요 필드(공식 Voice Developer Guide — *Create a Voice Call Record*):

```json
// 구조 예시 — 실제 동작 설정 아님 (Voice REST API 'Create a Voice Call Record' 필드 발췌)
{
  "callCenterApiName": "MyContactCenter",   // Salesforce에 생성된 Contact Center의 API 이름
  "vendorCallKey": "abc-123",               // 텔레포니 시스템 내 통화 고유 키
  "to": "+15551234567",                     // 착신 번호(또는 이메일)
  "from": "+15557654321",                   // 발신 번호(또는 이메일)
  "initiationMethod": "Inbound",            // Inbound | Transfer — 통화 시작 방식
  "startTime": "2026-07-12T00:00:00Z",      // UTC 통화 시작 시각
  "participants": [ { /* end user 1인 */ } ],
  "callSubtype": "PSTN",                     // PSTN(전화) | WebRTC(VoIP)
  "callOrigin": "Voicemail",                 // Preview | Progressive | Voicemail (선택)
  "parentVoiceCallId": null,                 // 전환된 통화면 원 통화 참조 (선택)
  "callAttributes": { }                      // 표준/커스텀 필드 JSON (선택)
}
```

- 통화 레코드를 만들면 Salesforce에 **conversation**이 함께 생성된다.
- 연관 객체: `VoiceCallRecording`(녹음), `VoiceCallInsight`(AI 인사이트). VoiceCall 자체는 API 40.0 이상에서 사용 가능(연관 Voice 객체군은 릴리즈별 확장).

## 설정 절차 개요

Setup에서 대략 다음 순서로 구성한다(모델·파트너에 따라 세부 상이).

```
// 구조 예시 — 실제 원본 절차 UI 아님 (SCV 셋업 개요)
1. Contact Center 생성        — Setup > (Service Cloud) Voice/Contact Centers
                                텔레포니 모델(Amazon Connect / Partner / BYOT) 선택
2. 전화번호 프로비저닝         — Amazon Connect 등 텔레포니 측에서 번호 확보·연결
3. 상담원 할당                — Contact Center Agent / Admin permission set 부여 후
                                Contact Center에 사용자 추가
4. Omni-Channel 연결          — phone 채널을 포함한 presence status 생성·할당,
                                콘솔 앱 utility bar에 Omni-Channel utility 추가
5. 라우팅 설정                — Omni-Channel 규칙(스킬·언어·가용성)으로 통화 배분
```

- 라우팅 규칙 상세(Queue 기반 vs Skills 기반, 외부 라우팅)는 **[[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]]** 및 [[Omni-Channel External Routing]]에 위임한다.
- 상담원이 통화를 처리하는 워크스페이스 자체는 [[Service Console (서비스 콘솔)]] 참조.

## 관련 노트
- [[Open CTI & Telephony (전화 통합)]] — 레거시 전화 통합(2028-02-28 은퇴), SCV의 전신
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Service Console (서비스 콘솔)]] — Phone/softphone이 붙는 워크스페이스
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — 음성 라우팅 엔진
- [[Omni-Channel External Routing]] — 외부 라우팅 연계
