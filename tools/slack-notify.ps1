[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$webhookFile = Join-Path $PSScriptRoot '..\credentials\slack\webhook.url'
if (-not (Test-Path $webhookFile)) { exit 0 }
$webhookUrl = (Get-Content -Encoding UTF8 -LiteralPath $webhookFile -Raw).Trim()
if (-not $webhookUrl) { exit 0 }

function Get-LastAssistantSummary {
    param([string]$TranscriptPath)
    if (-not (Test-Path $TranscriptPath)) { return $null }
    $lines = Get-Content -Encoding UTF8 -LiteralPath $TranscriptPath
    for ($i = $lines.Count - 1; $i -ge 0; $i--) {
        try { $obj = $lines[$i] | ConvertFrom-Json -ErrorAction Stop } catch { continue }
        if ($obj.type -ne 'assistant') { continue }
        if ($obj.message.role -ne 'assistant') { continue }
        $content = $obj.message.content
        $textBlock = $null
        if ($content -is [string]) {
            $textBlock = $content
        } elseif ($content) {
            for ($j = $content.Count - 1; $j -ge 0; $j--) {
                if ($content[$j].type -eq 'text' -and $content[$j].text.Trim()) {
                    $textBlock = $content[$j].text
                    break
                }
            }
        }
        if (-not $textBlock) { continue }
        return $textBlock
    }
    return $null
}

function Get-LastUserMessage {
    param([string]$TranscriptPath)
    if (-not (Test-Path $TranscriptPath)) { return $null }
    $lines = Get-Content -Encoding UTF8 -LiteralPath $TranscriptPath
    for ($i = $lines.Count - 1; $i -ge 0; $i--) {
        try { $obj = $lines[$i] | ConvertFrom-Json -ErrorAction Stop } catch { continue }
        if ($obj.type -ne 'user' -or $obj.message.role -ne 'user' -or $obj.isMeta) { continue }
        $text = $null
        $content = $obj.message.content
        if ($content -is [string]) { $text = $content }
        elseif ($content) {
            foreach ($c in $content) {
                if ($c.type -eq 'text' -and $c.text) { $text = $c.text; break }
            }
        }
        if (-not $text) { continue }
        $trimmed = $text.TrimStart()
        if ($trimmed.StartsWith('<system-reminder>') -or
            $trimmed.StartsWith('<command-message>') -or
            $trimmed.StartsWith('<command-name>') -or
            $trimmed.StartsWith('<local-command-stdout>') -or
            $trimmed.StartsWith('Caveat:')) { continue }
        return $text
    }
    return $null
}

function Format-Summary {
    param([string]$Text, [int]$MaxLen = 140)
    if (-not $Text) { return '' }
    $t = $Text
    $t = [regex]::Replace($t, '```[\s\S]*?```', ' ')
    $t = [regex]::Replace($t, '`([^`]+)`', '$1')
    $t = [regex]::Replace($t, '\*\*(.+?)\*\*', '$1')
    $t = [regex]::Replace($t, '\*(.+?)\*', '$1')
    $t = [regex]::Replace($t, '\[([^\]]+)\]\([^)]+\)', '$1')
    $t = [regex]::Replace($t, '(?m)^\s*#+\s*', '')
    $t = [regex]::Replace($t, '(?m)^\s*[-*+]\s+', '')
    $t = [regex]::Replace($t, '(?m)^\s*\|.*\|\s*$', '')
    $firstLine = ($t -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -First 1)
    if (-not $firstLine) { return '' }
    $firstLine = ($firstLine -replace '\s+', ' ').Trim()
    if ($firstLine.Length -le $MaxLen) { return $firstLine }
    return $firstLine.Substring(0, $MaxLen - 1) + '…'
}

$message = '작업이 완료되었습니다'

if ([Console]::IsInputRedirected) {
    $stdin = [Console]::In.ReadToEnd()
    if ($stdin) {
        try {
            $hookData = $stdin | ConvertFrom-Json -ErrorAction Stop
            if ($hookData.transcript_path) {
                $summary = Format-Summary -Text (Get-LastAssistantSummary -TranscriptPath $hookData.transcript_path)
                if (-not $summary) {
                    $userMsg = Get-LastUserMessage -TranscriptPath $hookData.transcript_path
                    if ($userMsg) { $summary = Format-Summary -Text $userMsg }
                }
                if ($summary) { $message = $summary }
            }
        } catch {}
    }
}

if ($args.Count -ge 1 -and $args[0]) { $message = $args[0] }

$payload = @{ text = "✅ $message" } | ConvertTo-Json -Compress
$bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)

try {
    Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType 'application/json; charset=utf-8' -Body $bytes -TimeoutSec 8 | Out-Null
} catch {
    exit 0
}
