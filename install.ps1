#Requires -Version 5.1
# BMad MAO Module Installer (Windows PowerShell)

param(
    [string]$ProjectPath = (Get-Location).Path
)

# 컬러 함수
function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Color ""
Write-Color "╔══════════════════════════════════════════╗" "Cyan"
Write-Color "║   BMad MAO — Multi-Agent Orchestration   ║" "Cyan"
Write-Color "║              설치 스크립트               ║" "Cyan"
Write-Color "╚══════════════════════════════════════════╝" "Cyan"
Write-Color ""
Write-Color "설치 대상 프로젝트: $ProjectPath" "Cyan"
Write-Color ""

# 1. _bmad 폴더 확인
if (-not (Test-Path "$ProjectPath\_bmad")) {
    Write-Color "✗ 오류: _bmad 폴더를 찾을 수 없습니다." "Red"
    Write-Color "  BMad가 설치된 프로젝트 루트에서 실행하거나" "Red"
    Write-Color "  -ProjectPath 'C:\path\to\project' 인수를 전달하세요." "Red"
    exit 1
}
Write-Color "✓ _bmad 폴더 확인" "Green"

# 2. git 저장소 확인 (경고)
if (-not (Test-Path "$ProjectPath\.git")) {
    Write-Color "⚠ 경고: git 저장소가 초기화되지 않았습니다." "Yellow"
    Write-Color "  워크트리 격리 기능을 사용하려면 'git init'을 먼저 실행하세요." "Yellow"
    Write-Color ""
}

# 3. .claude/skills 폴더 확인 및 생성
$SkillsDir = "$ProjectPath\.claude\skills"
if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
    Write-Color "✓ .claude/skills 폴더 생성" "Green"
} else {
    Write-Color "✓ .claude/skills 폴더 확인" "Green"
}

# 4. 스킬 파일 복사
Write-Color ""
Write-Color "스킬 설치 중..." "White"

$Skills = @(
    "mao-create-contracts",
    "mao-orchestrate",
    "mao-score-review",
    "mao-auto-upgrade",
    "mao-spark",
    "mao-status"
)

foreach ($skill in $Skills) {
    $src = "$ScriptDir\skills\$skill"
    $dst = "$SkillsDir\$skill"

    if (-not (Test-Path $src)) {
        Write-Color "  ⚠ ${skill}: 소스 폴더 없음, 건너뜀" "Yellow"
        continue
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }

    Copy-Item -Recurse $src $dst
    Write-Color "  ✓ $skill" "Green"
}

# 5. _bmad/custom/config.toml 업데이트
$CustomConfig = "$ProjectPath\_bmad\custom\config.toml"

# 파일이 없으면 생성
if (-not (Test-Path $CustomConfig)) {
    New-Item -ItemType File -Path $CustomConfig -Force | Out-Null
}

# [modules.mao] 이미 있는지 확인
$existingContent = Get-Content $CustomConfig -Raw -ErrorAction SilentlyContinue
if ($existingContent -and $existingContent.Contains("[modules.mao]")) {
    Write-Color "⚠ _bmad/custom/config.toml에 [modules.mao]가 이미 존재합니다. 건너뜀." "Yellow"
} else {
    $maoConfig = @'

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
'@
    Add-Content -Path $CustomConfig -Value $maoConfig -Encoding utf8
    Write-Color "✓ _bmad/custom/config.toml 업데이트" "Green"
}

# 6. CLAUDE.md 세션 시작 프로토콜 섹션 추가
$ClaudeMd = "$ProjectPath\CLAUDE.md"
$SessionProtocol = @'

## BMad MAO 세션 시작 프로토콜

**매 대화 시작 시 반드시 실행:**
1. `docs/bmad-status.md` 파일이 존재하면 읽고 현재 상태를 표시한다.
2. 현재 BMad 워크플로우 위치, 중단 지점, 다음 즉시 액션을 요약해서 사용자에게 보여준다.
3. 사용자가 별도 지시를 하기 전까지 이 상태를 기반으로 응답한다.
4. `/mao-status` 스킬로 상세 상태를 언제든 확인할 수 있다.
'@

if (-not (Test-Path $ClaudeMd)) {
    # CLAUDE.md 없으면 최소 버전 생성
    Set-Content -Path $ClaudeMd -Value "# 프로젝트`n" -Encoding utf8
    Write-Color "✓ CLAUDE.md 생성" "Green"
}

$claudeContent = Get-Content $ClaudeMd -Raw -ErrorAction SilentlyContinue
if ($claudeContent -and $claudeContent.Contains("BMad MAO 세션 시작 프로토콜")) {
    Write-Color "⚠ CLAUDE.md에 세션 프로토콜이 이미 존재합니다. 건너뜀." "Yellow"
} else {
    Add-Content -Path $ClaudeMd -Value $SessionProtocol -Encoding utf8
    Write-Color "✓ CLAUDE.md 세션 시작 프로토콜 추가" "Green"
}

Write-Color ""
Write-Color "╔══════════════════════════════════════════╗" "Green"
Write-Color "║          ✅ MAO 모듈 설치 완료!          ║" "Green"
Write-Color "╚══════════════════════════════════════════╝" "Green"
Write-Color ""
Write-Color "사용 방법:" "White"
Write-Color "  Claude Code에서 다음을 입력하세요:" "White"
Write-Color ""
Write-Color "  /mao-status             현재 워크플로우 상태 확인  ← 세션 시작 시 자동 표시" "Cyan"
Write-Color "  /mao-create-contracts   PRD → 계약서 생성" "Cyan"
Write-Color "  /mao-orchestrate        에이전트 배포 및 관리" "Cyan"
Write-Color "  /mao-score-review       품질 점수화" "Cyan"
Write-Color "  /mao-auto-upgrade       자동 업그레이드" "Cyan"
Write-Color "  /mao-spark              빠른 HTML 프로토타입 탐색" "Cyan"
Write-Color ""
