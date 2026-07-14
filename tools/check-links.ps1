<#
.SYNOPSIS
  결정론적 마크다운 상대링크 실존 검사 (온디맨드 링크 무결성).
.DESCRIPTION
  지정한 대상(.md 파일/폴더)의 모든 마크다운 링크 [텍스트](경로)를 파싱해,
  상대경로 링크가 실제 파일/폴더로 해석되는지 Test-Path로 검사한다.
  외부 URL(http/mailto)·순수 앵커(#...)는 건너뛴다. %20 등 URL 인코딩은 디코드.
  bare 상대링크(디렉토리 접두어 없는 파일명)까지 잡아 grep 사각지대를 보완한다.
.PARAMETER Root
  저장소 루트. 기본값은 이 스크립트의 상위 폴더(= rules repo 루트).
.PARAMETER Include
  검사 대상(Root 기준 상대경로). 폴더는 재귀, 파일은 단건.
.EXAMPLE
  powershell -File tools/check-links.ps1
  powershell -File tools/check-links.ps1 -Include 지침
#>
param(
    [string]$Root = (Split-Path $PSScriptRoot -Parent),
    [string[]]$Include = @('지침', 'CLAUDE.md', 'docs/tasks/README.md', 'docs/tasks/모듈 현황.md'),
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'
$broken = @()
$checked = 0

$files = @()
foreach ($inc in $Include) {
    $p = Join-Path $Root $inc
    if (Test-Path -LiteralPath $p -PathType Container) {
        $files += Get-ChildItem -LiteralPath $p -Recurse -Filter *.md -File
    } elseif (Test-Path -LiteralPath $p -PathType Leaf) {
        $files += Get-Item -LiteralPath $p
    }
}

# [텍스트](경로)  — 이미지 ![..](..) 포함. 경로에 공백 있으면 %20 인코딩 전제.
$linkRx = [regex]'\[[^\]]*\]\(([^)]+)\)'

foreach ($f in $files) {
    $raw = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8
    # 코드펜스 제거 — 라인 시작 ```(백틱 3+) 여는 delimiter를 같은 길이 이상으로만 닫음
    # (인라인 ```bash 예시·4틱 블록이 홀짝을 틀지 않도록 라인 단위로 상태 추적)
    $keep = @()
    $inFence = $false; $fenceLen = 0
    foreach ($ln in ($raw -split "`r?`n")) {
        if ($ln -match '^\s*(`{3,})') {
            $len = $matches[1].Length
            if (-not $inFence) { $inFence = $true; $fenceLen = $len; continue }
            elseif ($len -ge $fenceLen) { $inFence = $false; continue }
            else { continue }
        }
        if (-not $inFence) { $keep += $ln }
    }
    # 인라인 코드는 줄 단위로 제거 — `[텍스트](url)` 전체가 인라인 코드면 예시로 보아 제외,
    # [`텍스트`](url)처럼 표시텍스트만 백틱이면 URL은 살아 링크로 검사됨 (줄 단위라 백틱 홀짝 어긋남이 그 줄에 국한)
    $text = (($keep | ForEach-Object { [regex]::Replace($_, '`[^`]*`', '') }) -join "`n")
    foreach ($m in $linkRx.Matches($text)) {
        $target = $m.Groups[1].Value.Trim()
        if ($target -match '^(https?:|mailto:|#)') { continue }
        $path = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($path)) { continue }
        $path = [uri]::UnescapeDataString($path)
        if ($path -match '[<>|"*?]') { continue }
        $checked++
        if ($path -match '^[A-Za-z]:' -or $path.StartsWith('\')) {
            $resolved = $path
        } else {
            $resolved = Join-Path $f.DirectoryName $path
        }
        if (-not (Test-Path -LiteralPath $resolved)) {
            $broken += [pscustomobject]@{
                Source = $f.FullName.Substring($Root.Length).TrimStart('\')
                Link   = $target
            }
        }
    }
}

if (-not $Quiet) {
    Write-Output "검사한 상대링크: $checked (대상 파일 $($files.Count)개)"
}
if ($broken.Count -gt 0) {
    Write-Output "깨진 링크 $($broken.Count)건:"
    $broken | ForEach-Object { Write-Output ("  [{0}] -> {1}" -f $_.Source, $_.Link) }
    exit 1
} else {
    Write-Output "OK — 깨진 상대링크 0건"
    exit 0
}
