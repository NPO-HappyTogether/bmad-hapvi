# BMad MAO — Multi-Agent Orchestration Module

> **BMad Method** 위에서 동작하는 멀티 에이전트 오케스트레이션 확장 모듈

[![version](https://img.shields.io/badge/version-v0.2.0-blue)](CHANGELOG.md)
[![license](https://img.shields.io/badge/license-MIT-green)](#)
[![BMad](https://img.shields.io/badge/requires-BMad-orange)](#사전-요구사항)

---

## 목차

- [이게 뭔가요?](#이게-뭔가요)
- [스킬 목록](#스킬-목록)
- [사전 요구사항](#사전-요구사항)
- [설치 방법](#설치-방법)
- [기본 사용 흐름](#기본-사용-흐름)
- [버전 관리 / 롤백](#버전-관리--롤백)
- [English](#english)

---

## 이게 뭔가요?

BMad MAO는 **BMad Method**를 사용하는 프로젝트에 추가할 수 있는 멀티 에이전트 오케스트레이션 모듈입니다.

PRD를 작성한 뒤 여러 에이전트를 **동시에 병렬로** 실행하고, 그 결과물을 **계약서(Contract)** 기반으로 검증·통합하는 워크플로우를 제공합니다.

```
PRD (WHY/WHAT)
    ↓
계약서 생성 (/mao-create-contracts)   ← 에이전트 간 인터페이스 명세
    ↓
병렬 에이전트 배포 (/mao-orchestrate) ← 각 에이전트가 독립된 영역 담당
    ↓
품질 점수화 (/mao-score-review)       ← 10점 만점 3단계 검증
    ↓
자동 개선 (/mao-auto-upgrade)         ← 반복 실패 패턴 감지 → 프롬프트 개선
```

팀 브레인스토밍용 빠른 프로토타입이 필요하면 `/mao-spark`로 먼저 방향을 잡은 뒤 위 흐름으로 넘어갈 수 있습니다.

---

## 스킬 목록

| 스킬 | 페르소나 | 역할 |
|------|----------|------|
| `/mao-create-contracts` | Winston+ 📐 | PRD → 인터페이스 계약서 생성 (타이트/러프/혼합 모드) |
| `/mao-orchestrate` | Atlas 🎯 | 병렬 에이전트 배포·브리핑·재브리핑 |
| `/mao-score-review` | — | 3단계 품질 점수화 (L1 자동 / L2 요약 / L3 상세) |
| `/mao-auto-upgrade` | — | 반복 실패 패턴 감지 → 에이전트 프롬프트 자동 개선 제안 |
| `/mao-spark` | Spark ⚡ | 빠른 HTML 프로토타입 탐색 (질문 없이 즉시 시작) |

---

## 사전 요구사항

1. **BMad Method 설치** — 프로젝트에 `_bmad/` 폴더가 있어야 합니다.
   > BMad 설치: https://github.com/bmad-method/bmad-method

2. **Claude Code** — Anthropic Claude Code CLI가 설치되어 있어야 합니다.

3. **git 초기화 (권장)** — 워크트리 격리 기능을 쓰려면 필수입니다.
   ```bash
   git init
   ```

---

## 설치 방법

### Mac / Linux

```bash
# 1. 이 저장소 클론
git clone https://github.com/NPO-HappyTogether/bmad-hapvi.git

# 2. BMad가 설치된 프로젝트 루트에서 실행
bash /path/to/bmad-hapvi/install.sh

# 또는 경로를 직접 지정
bash /path/to/bmad-hapvi/install.sh /path/to/my-project
```

### Windows (PowerShell)

```powershell
# 1. 이 저장소 클론
git clone https://github.com/NPO-HappyTogether/bmad-hapvi.git

# 2. BMad가 설치된 프로젝트 루트에서 실행
.\bmad-hapvi\install.ps1

# 또는 경로를 직접 지정
.\bmad-hapvi\install.ps1 -ProjectPath "C:\path\to\my-project"
```

### 설치 확인

설치가 완료되면 프로젝트의 `.claude/skills/` 폴더에 다음이 생깁니다:

```
.claude/skills/
  ├── mao-create-contracts/
  ├── mao-orchestrate/
  ├── mao-score-review/
  ├── mao-auto-upgrade/
  └── mao-spark/
```

Claude Code를 열고 `/mao-` 를 입력해 자동완성이 뜨면 설치 성공입니다.

---

## 기본 사용 흐름

### A. 빠른 탐색 → 정식 개발

처음 아이디어를 탐색하거나 팀과 방향을 맞출 때:

```
1. /mao-spark              → HTML 프로토타입으로 방향 잡기 (A/B/C 3가지 제안)
2. /mao-create-contracts   → 확정된 방향으로 계약서 작성
3. /mao-orchestrate        → 에이전트 병렬 배포
4. /mao-score-review       → 결과물 품질 검증
```

### B. PRD가 준비된 경우 → 바로 개발

```
1. /mao-create-contracts   → PRD → 계약서 생성
2. /mao-orchestrate        → 에이전트 배포 (타이트/러프/혼합 모드 선택)
3. /mao-score-review       → 점수 확인 (8점 이상 통과)
4. /mao-auto-upgrade       → 3회 연속 실패 시 자동 개선 제안
```

### 실행 모드

| 모드 | 설명 | 추천 상황 |
|------|------|-----------|
| **타이트** | 계약서 조건을 엄격하게 준수, 이탈 금지 | 명세가 확실할 때 |
| **러프** | 계약서를 가이드라인으로만 활용, 자율 허용 | 탐색·실험 단계 |
| **혼합** | 핵심 인터페이스만 타이트, 나머지 자율 | 기본값 (권장) |

---

## 버전 관리 / 롤백

### 새 버전으로 업그레이드

```bash
# 현재 버전을 프로젝트 내 아카이브에 보관한 뒤 새 버전 설치
cp -r .claude/skills/mao-create-contracts .claude/skills/mao-old/v현재버전/
bash /path/to/bmad-hapvi/install.sh
```

### 이전 버전으로 롤백

```bash
cp -r .claude/skills/mao-old/v0.1.0/mao-create-contracts .claude/skills/
```

### 버전 이력

| 버전 | 날짜 | 주요 변경 |
|------|------|-----------|
| v0.2.0 | 2026-05-27 | mao-spark 추가 (빠른 HTML 프로토타입 탐색) |
| v0.1.0 | 2026-05-27 | 최초 릴리스 — 스킬 4종 |

---

## 라이선스 및 저작권

MIT License — Copyright (c) 2026 NPO-HappyTogether. 전체 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

이 프로젝트는 [BMad Method](https://github.com/bmad-code-org/BMAD-METHOD) (MIT License, © BMad Code, LLC)의 **독립적인 확장 모듈**입니다.
BMad Code, LLC와 공식적으로 제휴하거나 승인받은 프로젝트가 아닙니다.

---
---

## English

### What is BMad MAO?

BMad MAO is a **Multi-Agent Orchestration** extension module for projects using the [BMad Method](https://github.com/bmad-method/bmad-method).

After writing a PRD, it lets you run multiple AI agents **in parallel** — each handling an isolated scope — then validates and integrates their outputs using **interface contracts** derived from the PRD.

```
PRD (WHY / WHAT)
    ↓
Generate contracts  (/mao-create-contracts)  ← interface specs between agents
    ↓
Deploy agents       (/mao-orchestrate)        ← each agent owns its domain
    ↓
Score results       (/mao-score-review)       ← 3-level quality check (10-pt scale)
    ↓
Auto-improve        (/mao-auto-upgrade)       ← detect patterns → improve prompts
```

For quick team brainstorming, start with `/mao-spark` to lock in a direction before the full flow.

---

### Prerequisites

1. **BMad Method** installed (`_bmad/` folder in your project root)
   > https://github.com/bmad-method/bmad-method
2. **Claude Code** (Anthropic Claude Code CLI)
3. **git init** (recommended — required for worktree isolation)

---

### Installation

**Mac / Linux**
```bash
git clone https://github.com/NPO-HappyTogether/bmad-hapvi.git
bash /path/to/bmad-hapvi/install.sh
# or with explicit project path:
bash /path/to/bmad-hapvi/install.sh /path/to/my-project
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/NPO-HappyTogether/bmad-hapvi.git
.\bmad-hapvi\install.ps1
# or with explicit project path:
.\bmad-hapvi\install.ps1 -ProjectPath "C:\path\to\my-project"
```

After installation, `.claude/skills/` in your project will contain all five skills. Open Claude Code and type `/mao-` to confirm auto-complete appears.

---

### Skills

| Skill | Persona | Role |
|-------|---------|------|
| `/mao-create-contracts` | Winston+ 📐 | Generate interface contracts from PRD (tight / loose / mixed mode) |
| `/mao-orchestrate` | Atlas 🎯 | Deploy parallel agents, generate briefings, re-brief on failure |
| `/mao-score-review` | — | 3-level quality scoring (L1 auto / L2 summary / L3 detailed) |
| `/mao-auto-upgrade` | — | Detect repeated failure patterns → suggest prompt improvements |
| `/mao-spark` | Spark ⚡ | Fast HTML prototype exploration — no questions, instant A/B/C output |

---

### Basic Usage

**Quick exploration → production**
```
/mao-spark              → align team direction with HTML prototypes (A/B/C vote)
/mao-create-contracts   → turn chosen direction into interface contracts
/mao-orchestrate        → deploy agents in parallel
/mao-score-review       → verify quality (pass threshold: 8/10)
```

**PRD already written → straight to development**
```
/mao-create-contracts   → PRD → contracts
/mao-orchestrate        → deploy (tight / loose / mixed mode)
/mao-score-review       → score check
/mao-auto-upgrade       → auto-improve after 3 consecutive failures
```

---

### Version History

| Version | Date | Changes |
|---------|------|---------|
| v0.2.0 | 2026-05-27 | Added mao-spark (fast HTML prototyping skill) |
| v0.1.0 | 2026-05-27 | Initial release — 4 skills |

---

## License & Attribution

MIT License — Copyright (c) 2026 NPO-HappyTogether. See [LICENSE](LICENSE) for details.

This project is an **independent extension module** for the [BMad Method](https://github.com/bmad-code-org/BMAD-METHOD) (MIT License, © BMad Code, LLC).  
Not affiliated with or endorsed by BMad Code, LLC.
