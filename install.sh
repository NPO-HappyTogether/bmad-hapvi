#!/bin/bash
# BMad MAO Module Installer (Mac/Linux)
set -euo pipefail

# 컬러 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║   BMad MAO — Multi-Agent Orchestration   ║"
echo "║              설치 스크립트               ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}설치 대상 프로젝트: ${PROJECT_DIR}${NC}"
echo ""

# 1. _bmad 폴더 확인
if [ ! -d "${PROJECT_DIR}/_bmad" ]; then
    echo -e "${RED}✗ 오류: _bmad 폴더를 찾을 수 없습니다.${NC}"
    echo "  BMad가 설치된 프로젝트 루트에서 실행하거나"
    echo "  경로를 인수로 전달하세요: bash install.sh /path/to/project"
    exit 1
fi
echo -e "${GREEN}✓ _bmad 폴더 확인${NC}"

# 2. git 저장소 확인 (워크트리 기능 경고)
if [ ! -d "${PROJECT_DIR}/.git" ]; then
    echo -e "${YELLOW}⚠ 경고: git 저장소가 초기화되지 않았습니다.${NC}"
    echo "  워크트리 격리 기능을 사용하려면 'git init'을 먼저 실행하세요."
    echo ""
fi

# 3. .claude/skills 폴더 확인 및 생성
SKILLS_DIR="${PROJECT_DIR}/.claude/skills"
if [ ! -d "${SKILLS_DIR}" ]; then
    mkdir -p "${SKILLS_DIR}"
    echo -e "${GREEN}✓ .claude/skills 폴더 생성${NC}"
else
    echo -e "${GREEN}✓ .claude/skills 폴더 확인${NC}"
fi

# 4. 스킬 파일 복사 (old/ 폴더는 설치 제외)
echo ""
echo "스킬 설치 중..."

SKILLS=(
    "mao-create-contracts"
    "mao-orchestrate"
    "mao-score-review"
    "mao-auto-upgrade"
)
# ※ old/ 폴더는 아카이브 전용 — 설치 대상 아님

for skill in "${SKILLS[@]}"; do
    src="${SCRIPT_DIR}/skills/${skill}"
    dst="${SKILLS_DIR}/${skill}"

    if [ ! -d "${src}" ]; then
        echo -e "${YELLOW}  ⚠ ${skill}: 소스 폴더 없음, 건너뜀${NC}"
        continue
    fi

    if [ -d "${dst}" ]; then
        rm -rf "${dst}"
    fi

    cp -r "${src}" "${dst}"
    echo -e "${GREEN}  ✓ ${skill}${NC}"
done

# 5. _bmad/custom/config.toml 업데이트
CUSTOM_CONFIG="${PROJECT_DIR}/_bmad/custom/config.toml"

# 파일이 없으면 생성
if [ ! -f "${CUSTOM_CONFIG}" ]; then
    touch "${CUSTOM_CONFIG}"
fi

# [modules.mao] 이미 있으면 스킵
if grep -q "\[modules\.mao\]" "${CUSTOM_CONFIG}" 2>/dev/null; then
    echo -e "${YELLOW}⚠ _bmad/custom/config.toml에 [modules.mao]가 이미 존재합니다. 건너뜀.${NC}"
else
    cat >> "${CUSTOM_CONFIG}" << 'EOF'

# ── BMad MAO 모듈 ──────────────────────────────
[modules.mao]
contracts_folder = "{project-root}/_bmad-output/contracts"
score_pass = 8
score_summary_review = 6
score_detail_review = 5
max_rounds = 5
default_mode = "mixed"

[agents.mao-agent-orchestrator]
module = "mao"
team = "software-development"
name = "Atlas"
title = "Multi-Agent Orchestrator"
icon = "🎯"
description = "계약서 기반으로 에이전트를 배포·검증·재브리핑하는 오케스트레이터."

[agents.mao-agent-contract-writer]
module = "mao"
team = "software-development"
name = "Winston+"
title = "Contract Architect"
icon = "📐"
description = "PRD에서 인터페이스 계약을 도출하고 실행 모드(타이트/러프)를 설정한다."
# ───────────────────────────────────────────────
EOF
    echo -e "${GREEN}✓ _bmad/custom/config.toml 업데이트${NC}"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          ✅ MAO 모듈 설치 완료!          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo "사용 방법:"
echo "  Claude Code에서 다음을 입력하세요:"
echo ""
echo "  /mao-create-contracts   PRD → 계약서 생성"
echo "  /mao-orchestrate        에이전트 배포 및 관리"
echo "  /mao-score-review       품질 점수화"
echo "  /mao-auto-upgrade       자동 업그레이드"
echo ""
