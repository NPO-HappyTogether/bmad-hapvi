# Step 01: 활성화 & PRD 스캔

## MANDATORY RULES (반드시 먼저 읽기):

- 🛑 사용자 입력 없이 계약서 내용을 생성하지 않는다
- 📖 이 파일을 끝까지 읽은 뒤에만 행동한다
- 🔍 PRD 없이는 절대 진행하지 않는다
- 💬 `{communication_language}`로 모든 출력을 작성한다
- ⚡ PRD에서 추출 가능한 것은 사용자에게 묻지 않는다
- 🔄 기존 contracts 폴더가 있으면 재개(resume) 여부를 먼저 확인한다

## 이 단계의 목표

contracts 워크플로우를 초기화하고, PRD를 찾아 읽고, 기존 작업이 있는지 확인한다.

---

## 실행 순서

### A. 기존 contracts 폴더 확인

`{project-root}/_bmad-output/contracts/` 하위에서 다음 파일을 탐색한다:
- `00-index.md` — 인덱스 파일 (있으면 작업 진행 중)
- `.decision-log.md` — 결정 로그

**기존 폴더가 있는 경우:**
```
📐 기존 contracts 작업을 발견했습니다.

📁 위치: _bmad-output/contracts/
📋 인덱스: {00-index.md 존재 여부}
📝 결정 로그: {.decision-log.md 존재 여부}

계속 진행하시겠습니까, 아니면 새로 시작하시겠습니까?

[R] 재개 — 기존 작업에서 이어서 진행
[N] 새로 시작 — 기존 파일은 보존하고 새 폴더 생성
```

사용자가 [R] 선택 → 기존 파일을 읽고 현재 상태를 파악한 뒤 적절한 단계로 이동  
사용자가 [N] 선택 → 신규 폴더 생성으로 진행

**폴더가 없는 경우:** 신규 워크플로우로 진행

---

### B. PRD 탐색

다음 경로에서 PRD를 탐색한다 (순서대로, 찾으면 멈춤):
1. `{project-root}/_bmad-output/planning-artifacts/prds/**/*.md`
2. `{project-root}/_bmad-output/**/*prd*.md`
3. `{project-root}/docs/**/*prd*.md`

샤딩된 폴더도 확인한다: `*prd*/` 디렉토리가 있으면 `index.md` 먼저 읽고, 연결된 파일을 모두 로드한다.

**PRD를 찾지 못한 경우:**
```
📐 PRD를 찾을 수 없습니다.

에이전트 실행 계약서는 완성된 PRD를 기반으로 생성됩니다.
먼저 PRD를 완성하거나, PRD 파일 경로를 직접 알려주세요.

권장 다음 단계: bmad-prd 스킬로 PRD를 먼저 작성해 주세요.
```
→ 여기서 멈춘다. 사용자가 경로를 제공하면 해당 파일을 로드하고 계속 진행한다.

**PRD를 찾은 경우:** 파일을 완전히 로드한다 (offset/limit 없이).

---

### C. contracts 작업 폴더 초기화

신규 폴더 생성 시:
- 폴더 경로: `{project-root}/_bmad-output/contracts/`
- `.decision-log.md` 초기화 (아래 템플릿 사용)

**`.decision-log.md` 초기 템플릿:**
```markdown
# Decision Log — {project_name} 에이전트 실행 계약서

**프로젝트**: {project_name}
**시작일**: {date}
**PRD 소스**: {prd_file_path}
**워크스페이스**: `_bmad-output/contracts/`

---

## 결정 기록

| # | 날짜 | 결정 항목 | 선택 | 근거 | 결정자 | 상태 |
|---|------|-----------|------|------|--------|------|

---

## 미결 항목

| # | 항목 | 관련 파일 | 우선순위 |
|---|------|-----------|----------|

---
```

---

### D. 사용자에게 보고

```
📐 contracts 워크스페이스를 초기화했습니다.

**PRD 발견:**
- 파일: {prd_file_path}
- 제목: {prd_title}
- 상태: {prd_status}

**워크스페이스:** _bmad-output/contracts/

다음 단계에서 PRD의 인터페이스 포인트를 자동 추출합니다.
PRD에서 API 엔드포인트, WebSocket 이벤트, DB 테이블, 외부 어댑터를 찾아낼게요.

[C] 계속 — 인터페이스 포인트 추출
```

---

## SUCCESS CRITERIA:

✅ 기존 contracts 폴더 유무 확인 및 재개/신규 결정  
✅ PRD 발견 및 완전 로드  
✅ PRD 없이 진행하지 않음  
✅ `.decision-log.md` 초기화  
✅ 사용자에게 현황 보고  

## FAILURE MODES:

❌ PRD 없이 계약서 생성 시도  
❌ 기존 contracts 폴더 미확인  
❌ 파일 일부만 로드  
❌ 사용자 확인 없이 다음 단계 진행  

## NEXT STEP:

사용자가 [C]를 선택하면 `./step-02-extract.md`를 로드하여 인터페이스 포인트 추출을 시작한다.
