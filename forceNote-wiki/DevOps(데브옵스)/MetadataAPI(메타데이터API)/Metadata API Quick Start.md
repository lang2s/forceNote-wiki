---
tags: [devops, metadata-api, quick-start, java, wsdl, wsc, MetadataLoginUtil, ConnectorConfig]
source: api_meta.pdf v67.0 Summer '26 — Chapter 2 (Quick Start), Chapter 3 (Build Client Applications)
created: 2026-05-22
aliases: [Metadata API Quick Start, Metadata API Java client, MetadataLoginUtil, WSC 연결]
---

# Metadata API Quick Start

> WSDL 기반 Java 클라이언트로 Metadata API에 연결하고 첫 deploy/retrieve를 실행하는 빠른 시작 가이드.

---

## 1. WSDL 다운로드

Salesforce 조직 Setup → API → **Metadata WSDL** 다운로드.

두 가지 WSDL:
- `enterprise.wsdl` — 강타입, 특정 org에 종속
- `partner.wsdl` — 범용, org 간 이식 가능

---

## 2. WSC (Web Service Connector) 준비

Salesforce는 Java 클라이언트용 WSC 라이브러리를 제공한다.

```bash
# 1. WSC JAR 다운로드 (Maven Central 또는 GitHub)
# force-wsc-xx.x.x.jar

# 2. WSDL → Java stub 코드 생성
java -classpath force-wsc-xx.x.x.jar com.sforce.ws.tools.wsdlc metadata.wsdl metadata-stub.jar

# 3. 클래스패스에 추가
# force-wsc-xx.x.x.jar + metadata-stub.jar
```

---

## 3. 인증 및 연결 (MetadataLoginUtil 패턴)

Metadata API는 SOAP Login API로 세션 ID를 획득한 뒤, `MetadataConnection`을 구성한다.

```java
import com.sforce.soap.metadata.*;
import com.sforce.soap.partner.*;
import com.sforce.ws.*;

public class MetadataLoginUtil {

    // Partner API WSDL 엔드포인트 (login용)
    public static final String PARTNER_SOAP_API_ENDPOINT =
        "https://login.salesforce.com/services/Soap/u/67.0";

    public static MetadataConnection login() throws ConnectionException {
        final ConnectorConfig loginConfig = new ConnectorConfig();
        loginConfig.setAuthEndpoint(PARTNER_SOAP_API_ENDPOINT);
        loginConfig.setServiceEndpoint(PARTNER_SOAP_API_ENDPOINT);
        loginConfig.setManualLogin(true);

        PartnerConnection connection = new PartnerConnection(loginConfig);
        LoginResult loginResult = connection.login(USERNAME, PASSWORD);

        final ConnectorConfig metadataConfig = new ConnectorConfig();
        metadataConfig.setServiceEndpoint(loginResult.getMetadataServerUrl());
        metadataConfig.setSessionId(loginResult.getSessionId());

        return new MetadataConnection(metadataConfig);
    }
}
```

---

## 4. 배포 빠른 시작 (deploy)

```java
public class QuickDeploy {

    static final String ZIP_FILE = "components.zip";
    static final double API_VERSION = 67.0;

    public static void main(String[] args) throws Exception {
        MetadataConnection conn = MetadataLoginUtil.login();

        // zip 파일 읽기
        byte[] zipBytes = Files.readAllBytes(Paths.get(ZIP_FILE));

        // 배포 옵션
        DeployOptions options = new DeployOptions();
        options.setPerformRetrieve(false);
        options.setRollbackOnError(true);

        // 배포 시작
        AsyncResult asyncResult = conn.deploy(zipBytes, options);
        String asyncResultId = asyncResult.getId();

        // 배포 완료 폴링
        DeployResult deployResult;
        do {
            Thread.sleep(10_000);
            deployResult = conn.checkDeployStatus(asyncResultId, false);
        } while (!deployResult.isDone());

        if (deployResult.isSuccess()) {
            System.out.println("배포 성공: " + deployResult.getId());
        } else {
            System.out.println("배포 실패: " + deployResult.getErrorMessage());
        }
    }
}
```

---

## 5. 검색 빠른 시작 (retrieve)

```java
public class QuickRetrieve {

    static final double API_VERSION = 67.0;

    public static void main(String[] args) throws Exception {
        MetadataConnection conn = MetadataLoginUtil.login();

        RetrieveRequest request = new RetrieveRequest();
        request.setApiVersion(API_VERSION);

        // package.xml 없이 직접 타입 지정
        ListMetadataQuery query = new ListMetadataQuery();
        query.setType("ApexClass");
        request.setUnpackaged(buildPackage(query));

        AsyncResult asyncResult = conn.retrieve(request);
        String asyncResultId = asyncResult.getId();

        // 검색 완료 폴링
        RetrieveResult retrieveResult;
        do {
            Thread.sleep(10_000);
            retrieveResult = conn.checkRetrieveStatus(asyncResultId, true);
        } while (!retrieveResult.isDone());

        if (retrieveResult.isSuccess()) {
            // Base64 zip 저장
            byte[] zipBytes = retrieveResult.getZipFile();
            Files.write(Paths.get("retrieved.zip"), zipBytes);
        }
    }

    private static com.sforce.soap.metadata.Package buildPackage(ListMetadataQuery query)
        throws Exception {
        com.sforce.soap.metadata.Package pkg = new com.sforce.soap.metadata.Package();
        PackageTypeMembers ptm = new PackageTypeMembers();
        ptm.setName(query.getType());
        ptm.setMembers(new String[]{"*"});
        pkg.setTypes(new PackageTypeMembers[]{ptm});
        pkg.setVersion(String.valueOf(API_VERSION));
        return pkg;
    }
}
```

---

## ConnectorConfig 주요 설정

| 설정 메서드 | 설명 |
|---|---|
| `setAuthEndpoint(url)` | 인증(Login) 엔드포인트 |
| `setServiceEndpoint(url)` | 실제 서비스 엔드포인트 |
| `setSessionId(id)` | 세션 ID 직접 설정 (이미 세션 있을 때) |
| `setManualLogin(true)` | 자동 로그인 비활성화 |
| `setTraceMessage(true)` | SOAP 메시지 디버그 출력 |
| `setProxy(host, port)` | 프록시 서버 설정 |

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API File-Based 호출]]
- [[Metadata API CRUD 호출]]
- [[CI CD 패턴]]
- [[Metadata API 에러 처리]]
