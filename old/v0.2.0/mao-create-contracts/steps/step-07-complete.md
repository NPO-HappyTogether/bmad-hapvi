# Step 07: 완료 & 핸드오프

## MANDATORY RULES (반드시 먼저 읽기):

- 📖 이 파일을 끝까지 읽은 뒤에만 행동한다
- 🎉 사용자와 함께 달성한 것을 구체적으로 짚으며 완료를 축하한다
- 📋 다음 단계 가이드를 명확히 제공한다
- 🔒 `00-index.md` frontmatter를 `status: final`로 업데이트한다
- 💬 `{communication_language}`로 모든 출력을 작성한다

## 이 단계의 목표

계약서 워크플로우를 공식적으로 완료하고, 에이전트 실행을 위한 핸드오프 정보를 제공한다.

---

## 실행 순서

### A. 완료 처리

**`00-index.md` frontmatter 업데이트:**
```yaml
status: final
completed: {date}
```

**`.decision-log.md`에 완료 기록:**
```markdown
| {n} | {date} | 계약서 패키지 최종 완료 | 완료 | 모든 기술 파일 생성 및 사용자 승인 완료 | {user_name} | 완료 |
```

### B. 완료 요약 제시

```
📐 에이전트 실행 계약서가 완성되었습니다!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 완료된 작업
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 인터페이스 계약
  • API 엔드포인트: {n}개 확정
  • WebSocket 이벤트: {n}개 확정
  • DB 테이블: {n}개 확정
  • 외부 어댑터: {n}개 확정

📝 결정 이력
  • 설계 결정: {n}개 기록
  • 에이전트 위임: {m}개 기록
  • 총 결정 로그: {k}개 항목

📁 생성된 파일
  • _bmad-output/contracts/00-index.md       ← 진입점
  • _bmad-output/contracts/01-api.yaml
  • _bmad-output/contracts/02-ws-events.ts
  • _bmad-output/contracts/03-schema.sql
  • _bmad-output/contracts/04-adapter-interfaces.ts
  • _bmad-output/contracts/.decision-log.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 에이전트 핸드오프 지침
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

에이전트는 작업 시작 전 반드시:
1. `00-index.md`를 읽고 전체 계약 구조 파악
2. 담당 기능의 관련 계약 파일 확인
3. 타이트 항목은 계약대로 구현
4. 변경 필요 시 `.decision-log.md`에 이유 기록

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📌 권장 다음 단계
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• `bmad-create-epics-and-stories` — 계약서 기반 Epic/Story 생성
• `bmad-create-architecture`      — 계약서 기반 아키텍처 문서 작성
• `bmad-sprint-planning`          — 첫 스프린트 계획
• `bmad-help`                     — 다음에 뭘 해야 할지 안내

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

계약서 관련 질문이 있으면 언제든지 물어보세요.
```

### C. on_complete 실행

`customize.toml`의 `workflow.on_complete`가 비어 있지 않으면 해당 지시를 따른다.  
비어 있으면 생략한다.

---

## SUCCESS CRITERIA:

✅ `00-index.md` `status: final` 업데이트  
✅ `.decision-log.md`에 완료 기록  
✅ 파일 목록과 통계 포함한 완료 요약 제시  
✅ 에이전트 핸드오프 지침 제공  
✅ 다음 단계 권장 옵션 제시  

## FAILURE MODES:

❌ frontmatter 상태 미업데이트  
❌ 완료 기록 누락  
❌ 다음 단계 안내 없이 종료  

## 워크플로우 완료

이 단계가 `mao-create-contracts` 워크플로우의 마지막 단계다.

계약서 패키지가 완성되었고, 에이전트는 이 계약서를 기반으로 일관된 구현을 수행할 수 있다.
