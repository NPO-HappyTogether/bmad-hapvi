# Step 06: 기술 파일 백그라운드 생성

## MANDATORY RULES (반드시 먼저 읽기):

- 📖 이 파일을 끝까지 읽은 뒤에만 행동한다
- ⚡ 4개 파일을 최대한 병렬로 생성한다
- 🎯 타이트 항목: 필드·타입·에러코드 완전히 명시 / 러프 항목: 목적·형태만 명시
- 📋 생성 중에도 사용자와 대화를 이어갈 수 있도록 진행 상황을 보고한다
- ✅ 모든 파일 생성 후 완료를 사용자에게 보고한다
- 💬 `{communication_language}`로 모든 출력을 작성한다

## 이 단계의 목표

Step 04~05에서 확정된 결정을 기반으로 4개의 기술 계약 파일을 생성한다.

---

## 생성 전 알림

```
📐 기술 파일 생성을 시작합니다.

생성 파일:
  01-api.yaml            — REST API 계약
  02-ws-events.ts        — WebSocket 이벤트 타입
  03-schema.sql          — DB 스키마
  04-adapter-interfaces.ts — 외부 어댑터 인터페이스

가능하면 병렬로 생성합니다. 완료 후 알려드리겠습니다.
```

---

## 01-api.yaml 생성 지침

**파일 경로:** `{contracts-root}/01-api.yaml`

**형식:** OpenAPI 3.1.0

**타이트 항목 작성 기준:**
- `requestBody`: 모든 필드명, `type`, `required`, 예시값 명시
- `responses`: 성공(2xx)과 에러(4xx/5xx) 코드 모두 명시
- 에러 응답 스키마 통일 (Step 04 결정 기반)
- `operationId` 필수 (에이전트 참조용)
- `tags`로 도메인 구분

**러프 항목 작성 기준:**
- `summary`와 `description`만 상세히 작성
- `requestBody`와 `responses` 스키마는 `# TODO: 에이전트가 컨텍스트에 맞게 정의` 주석 추가

**템플릿 골격:**
```yaml
openapi: 3.1.0
info:
  title: "{project_name} API 계약서"
  version: "0.1.0"
  description: |
    에이전트 실행 계약서 — {project_name}
    생성일: {date}
    실행 모드: {mode}
    PRD 소스: {prd_source}

servers:
  - url: http://localhost:{port}
    description: 개발 서버
  - url: https://{domain}
    description: 프로덕션 서버 (미확정)

tags:
  {PRD 도메인 기반 태그 목록}

paths:
  {Step 02/04 결정 기반 엔드포인트}

components:
  schemas:
    Error:
      {Step 04 DP-03 결정 기반 에러 스키마}
    {공통 스키마}
  securitySchemes:
    {Step 04 DP-04 결정 기반 인증 방식}
```

---

## 02-ws-events.ts 생성 지침

**파일 경로:** `{contracts-root}/02-ws-events.ts`

**형식:** TypeScript — `type`, `interface`, `enum`

**타이트 항목 작성 기준:**
- 이벤트별 페이로드 타입 완전 정의
- 클라이언트→서버 / 서버→클라이언트 방향 주석
- 에러 이벤트 타입 정의

**러프 항목 작성 기준:**
- 이벤트명과 방향만 선언
- `payload: unknown // TODO: 에이전트가 컨텍스트에 맞게 정의` 사용

**템플릿 골격:**
```typescript
/**
 * {project_name} WebSocket 이벤트 계약서
 * 생성일: {date}
 * 실행 모드: {mode}
 *
 * 방향 표기:
 *   C→S : 클라이언트가 서버로 전송
 *   S→C : 서버가 클라이언트로 전송
 *   S→ALL: 서버가 전체 구독자에게 브로드캐스트
 */

// ──────────────────────────────────────────
// 공통 타입
// ──────────────────────────────────────────

export type EventBase<T extends string, P = unknown> = {
  event: T;
  payload: P;
  timestamp: string; // ISO 8601
};

// ──────────────────────────────────────────
// {도메인명} 이벤트
// ──────────────────────────────────────────

{Step 02/04 결정 기반 이벤트 타입}

// ──────────────────────────────────────────
// 에러 이벤트
// ──────────────────────────────────────────

export type WsErrorEvent = EventBase<'error', {
  code: string;
  message: string;
  details?: unknown;
}>;

// 에이전트가 사용할 유니온 타입
export type ClientToServerEvent = {도메인 이벤트 유니온};
export type ServerToClientEvent = {도메인 이벤트 유니온} | WsErrorEvent;
```

---

## 03-schema.sql 생성 지침

**파일 경로:** `{contracts-root}/03-schema.sql`

**형식:** PostgreSQL DDL (Step 04 DB 결정 기반)

**타이트 항목 작성 기준:**
- 컬럼 타입, `NOT NULL`, `DEFAULT`, `CHECK` 제약 명시
- 인덱스 전략 명시 (`CREATE INDEX` 포함)
- 외래 키와 `ON DELETE` 정책 명시
- `COMMENT ON` 으로 컬럼 목적 설명

**러프 항목 작성 기준:**
- 테이블명과 핵심 컬럼만 선언
- `-- TODO: 에이전트가 실제 스키마 확정` 주석 추가

**템플릿 골격:**
```sql
-- ============================================================
-- {project_name} DB 스키마 계약서
-- 생성일: {date}
-- 실행 모드: {mode}
-- DB: PostgreSQL 16
-- 인코딩: UTF-8
-- ============================================================

-- 확장 모듈
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
{Step 04 결정에 따른 추가 확장}

-- ──────────────────────────────────────────
-- 테이블 생성 순서 (외래 키 의존성 순)
-- 1. {독립 테이블 목록}
-- 2. {의존 테이블 목록}
-- ──────────────────────────────────────────

{Step 02/04 결정 기반 DDL}
```

---

## 04-adapter-interfaces.ts 생성 지침

**파일 경로:** `{contracts-root}/04-adapter-interfaces.ts`

**형식:** TypeScript — `interface`, `abstract class`, `type`

**타이트 항목 작성 기준:**
- 모든 메서드 시그니처 완전 정의
- 파라미터 타입, 반환 타입 명시
- throws 가능한 예외 타입 JSDoc으로 명시
- 타임아웃, 재시도 정책을 생성자 옵션 타입에 포함

**러프 항목 작성 기준:**
- 어댑터 인터페이스 이름과 핵심 메서드만 선언
- `// TODO: 에이전트가 실제 연동 스펙 확인 후 구체화` 주석

**템플릿 골격:**
```typescript
/**
 * {project_name} 외부 어댑터 인터페이스 계약서
 * 생성일: {date}
 * 실행 모드: {mode}
 *
 * 구현 원칙:
 * - 어댑터는 외부 시스템 장애를 내부 도메인 에러로 변환한다
 * - 모든 어댑터는 AdapterBase를 상속한다
 * - 타임아웃/재시도는 AdapterOptions로 설정한다
 */

// ──────────────────────────────────────────
// 공통 기반
// ──────────────────────────────────────────

export type AdapterOptions = {
  timeoutMs: number;
  retries: number;
  retryDelayMs: number;
};

export class AdapterError extends Error {
  constructor(
    public readonly code: string,
    message: string,
    public readonly cause?: unknown,
  ) {
    super(message);
    this.name = 'AdapterError';
  }
}

// ──────────────────────────────────────────
// {외부 시스템명} 어댑터
// ──────────────────────────────────────────

{Step 02/04 결정 기반 어댑터 인터페이스}
```

---

## 생성 완료 보고

모든 파일이 생성되면:

```
📐 기술 파일 생성 완료.

생성된 파일:
  ✅ 01-api.yaml            ({엔드포인트 n}개)
  ✅ 02-ws-events.ts        ({이벤트 n}개)
  ✅ 03-schema.sql          ({테이블 n}개)
  ✅ 04-adapter-interfaces.ts ({어댑터 n}개)

00-index.md의 파일 상태를 "✅ 완료"로 업데이트했습니다.

[C] 완료 — 핸드오프 요약 보기
```

`00-index.md`의 파일 상태 표에서 각 파일의 "⏳ 생성 예정"을 "✅ 완료"로 업데이트한다.

---

## SUCCESS CRITERIA:

✅ 4개 파일 모두 생성  
✅ 타이트/러프 모드 구분 적용  
✅ Step 04 결정 사항이 파일에 반영됨  
✅ 00-index.md 파일 상태 업데이트  
✅ 생성 완료 보고  

## FAILURE MODES:

❌ Step 04 결정을 무시하고 임의 설계  
❌ 타이트 항목에서 필드/타입 생략  
❌ 러프 항목에 TODO 주석 없이 빈 구조만 작성  
❌ 00-index.md 상태 업데이트 누락  

## NEXT STEP:

파일 생성 완료 후 사용자가 [C]를 선택하면 `./step-07-complete.md`를 로드한다.
