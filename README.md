# BMad MAO — Multi-Agent Orchestration Module
# BMad MAO — 멀티에이전트 오케스트레이션 모듈

> PRD를 에이전트 실행 계약서로 변환하고, 병렬 에이전트를 배포·검증·개선하는 BMad 확장 모듈.
>
> Extends BMad Method with contract-driven parallel agent orchestration, quality scoring, and auto-upgrade loops.

---

## 포함 스킬 (Included Skills)

| 스킬 | 페르소나 | 역할 |
|------|---------|------|
| `mao-create-contracts` | 📐 Winston+ | PRD → 에이전트 실행 계약서 생성. 타이트/러프 모드 선택, 멀티에이전트 설계 리뷰 |
| `mao-orchestrate` | 🎯 Atlas | 계약서 기반 브리핑 생성, 에이전트 병렬 배포, 재브리핑 |
| `mao-score-review` | 📊 시스템 | 3단계 품질 평가 (L1 자동 / L2 요약 / L3 상세), 점수판 생성 |
| `mao-auto-upgrade` | 🔄 패턴 분석가 | 반복 실패 패턴 감지, 에이전트·계약서·체크리스트 자동 개선 제안 |

---

## 전체 흐름 (Full Flow)

```
PRD 완성
   ↓
📐 mao-create-contracts
   PRD 분석 → 실행 모드 선택 (타이트/러프/혼합)
   → 설계 결정 협업 (멀티에이전트 딥다이브 가능)
   → 00-index.md 사용자 승인
   → 계약서 파일 생성
   ↓
🎯 mao-orchestrate
   브리핑 생성 → 에이전트 병렬 배포
   ↓
📊 mao-score-review
   L1 자동 → L2 요약 → L3 상세
   점수판 출력 (사람이 최종 판단)
   ↓
   8~10점 ✅ 통과      6~7점 ⚠️ 재브리핑      0~5점 ❌ 정밀 재브리핑
       ↓                     ↓                        ↓
   다음 단계           mao-orchestrate 재실행    mao-orchestrate 재실행
   ↓
🔄 mao-auto-upgrade (Sprint 완료 후)
   패턴 감지 → 리서치 → 개선 제안 → 승인 → 적용
```

---

## 실행 모드 (Execution Modes)

| 모드 | 설명 | 언제 사용 |
|------|------|---------|
| 🔒 **타이트** | 필드·타입·에러코드까지 모두 명시. 에이전트 자율 없음 | 핵심 경로, 운영 시스템 |
| 🔓 **러프** | 목적과 방향만 명시. 세부 설계는 에이전트 자율 | 탐색, PoC, 보조 기능 |
| ⚖️ **혼합** | 핵심 경로는 타이트, 보조 기능은 러프 | 일반적인 개발 (권장) |

---

## 요구사항 (Requirements)

- BMad Method 설치됨 (`_bmad/` 폴더 존재)
- Git 초기화됨 (`git init`) — 워크트리 기능 사용 시 필수
- Claude Code

---

## 설치 (Installation)

### Mac / Linux
```bash
cd /path/to/your/project   # BMad가 설치된 프로젝트 루트
bash /path/to/bmad-mao/install.sh
```

### Windows
```powershell
cd C:\path\to\your\project   # BMad가 설치된 프로젝트 루트
powershell -ExecutionPolicy Bypass -File C:\path\to\bmad-mao\install.ps1
```

설치 후 Claude Code에서 `/mao-create-contracts` 입력하면 바로 사용 가능.

---

## 파일 구조 (Package Structure)

```
bmad-mao/
  ├── README.md
  ├── install.sh               (Mac/Linux 설치 스크립트)
  ├── install.ps1              (Windows 설치 스크립트)
  └── skills/
      ├── mao-create-contracts/
      │   ├── SKILL.md
      │   ├── customize.toml
      │   ├── steps/           (단계별 실행 파일)
      │   ├── assets/
      │   └── templates/
      ├── mao-orchestrate/
      │   ├── SKILL.md
      │   └── customize.toml
      ├── mao-score-review/
      │   ├── SKILL.md
      │   └── customize.toml
      └── mao-auto-upgrade/
          ├── SKILL.md
          └── customize.toml
```

---

## 커스터마이제이션

프로젝트별 설정은 `_bmad/custom/` 폴더에서:

```toml
# _bmad/custom/mao-score-review.toml
[scoring_weights]
contract_compliance = 0.50   # 계약 준수 가중치 높이기
prd_coverage = 0.25
integration_readiness = 0.15
code_quality = 0.10
```

---

## BMad 정신 계승

이 모듈은 BMad Method의 핵심 원칙을 그대로 이어받습니다:
- **사람이 이해하면서 결정하고, 에이전트는 실행한다**
- 모든 결정은 `decision-log`에 이력 보존
- 불필요한 질문 최소화 (자동 추출 가능한 것은 묻지 않음)
- Fast Path / Coaching Path → 타이트 / 러프 모드

---

MIT License
