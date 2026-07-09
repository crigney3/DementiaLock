<#
.SYNOPSIS
    Walks the Modified/ folder and writes an ASCII directory tree to
    ModifiedLinesLog.txt, showing mp3 counts per folder and, for hero
    folders specifically, an "x out of y" completion indicator.

.DESCRIPTION
    Expected structure under Modified/:

        Modified/
          Archmother|HiddenKing/
            Intro/<HeroName>/*.mp3                   (out of 5)
            Support/<HeroName>/*.mp3                 (out of 1)
            Killstreak/Ally|Enemy/<HeroName>/*.mp3   (out of 3)

    Every folder in the tree is annotated with the total number of mp3
    files found anywhere beneath it. Hero folders (the lowest level -
    folders with no subfolders of their own) additionally get a
    "(n/x)" completion indicator, where x depends on which category
    folder they're under:
        Intro            -> 5
        Support          -> 1
        Killstreak\*     -> 3

    ModifiedLinesLog.txt at RepoRoot is fully overwritten each run - this
    is meant to be a fresh snapshot, not an accumulating log.

.PARAMETER RepoRoot
    Root of the repo (the folder that directly contains Modified/).
    Defaults to the current directory - convenient for CI, where the
    working directory is already the checked-out repo.

.PARAMETER ModifiedFolderName
    Name of the folder to scan. Defaults to "Modified".

.EXAMPLE
    .\Generate-ModifiedLinesLog.ps1 -RepoRoot "C:\Mod\Repo"
#>

[CmdletBinding()]
param(
    [string]$RepoRoot = (Get-Location).Path,

    [string]$ModifiedFolderName = 'Modified'
)

$modifiedPath = Join-Path $RepoRoot $ModifiedFolderName

if (-not (Test-Path $modifiedPath)) {
    throw "'$ModifiedFolderName' folder not found under $RepoRoot"
}

# Category folder name (lowercase) -> expected total line count.
# Killstreak's max applies whether it's Ally or Enemy underneath it.
$CategoryMax = @{
    'intro'      = 5
    'support'    = 1
    'killstreak' = 3
}

# Walks upward through a path's own segments (not the whole tree) to find
# which category folder a hero folder lives under.
function Get-CategoryMax {
    param([string[]]$PathSegments)

    foreach ($segment in $PathSegments) {
        $key = $segment.ToLowerInvariant()
        if ($CategoryMax.ContainsKey($key)) {
            return $CategoryMax[$key]
        }
    }
    return $null
}

# Recursively builds a node tree: each node knows its own total mp3 count
# (including all descendants), whether it's a leaf (hero folder), and its
# expected max if applicable.
function Get-Node {
    param(
        [string]$Path,
        [string[]]$PathSegments
    )

    $subDirs  = Get-ChildItem -Path $Path -Directory | Sort-Object Name
    $ownCount = (Get-ChildItem -Path $Path -File -Filter '*.mp3' -ErrorAction SilentlyContinue).Count
    $isLeaf   = $subDirs.Count -eq 0

    $children = New-Object System.Collections.Generic.List[object]
    $total    = $ownCount

    foreach ($dir in $subDirs) {
        $childSegments = $PathSegments + $dir.Name
        $childNode = Get-Node -Path $dir.FullName -PathSegments $childSegments
        $children.Add($childNode)
        $total += $childNode.Total
    }

    $max = $null
    if ($isLeaf) {
        $max = Get-CategoryMax -PathSegments $PathSegments
    }

    return [pscustomobject]@{
        Name     = Split-Path $Path -Leaf
        Total    = $total
        IsLeaf   = $isLeaf
        Max      = $max
        Children = $children
    }
}

# Renders a node (and its children) into ASCII tree lines.
function Add-TreeLines {
    param(
        $Node,
        [string]$Prefix,
        [bool]$IsLast,
        [bool]$IsRoot,
        [System.Collections.Generic.List[string]]$Lines
    )

    if ($Node.IsLeaf -and $Node.Max) {
        $countPart = "($($Node.Total)/$($Node.Max))"
    }
    else {
        $countPart = "($($Node.Total) Voicelines)"
    }

    if ($IsRoot) {
        $Lines.Add("$($Node.Name)/ $countPart")
        $childPrefix = ''
    }
    else {
        $branch = if ($IsLast) { '`-- ' } else { '|-- ' }
        $Lines.Add("$Prefix$branch$($Node.Name)/ $countPart")
        $childPrefix = $Prefix + $(if ($IsLast) { '    ' } else { '|   ' })
    }

    for ($i = 0; $i -lt $Node.Children.Count; $i++) {
        $isLastChild = ($i -eq $Node.Children.Count - 1)
        Add-TreeLines -Node $Node.Children[$i] -Prefix $childPrefix -IsLast $isLastChild -IsRoot $false -Lines $Lines
    }
}

# ---------------------------------------------------------------------------
# Build + render
# ---------------------------------------------------------------------------
$rootNode = Get-Node -Path $modifiedPath -PathSegments @()

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("Modified Lines Log - generated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$lines.Add("")
Add-TreeLines -Node $rootNode -Prefix '' -IsLast $true -IsRoot $true -Lines $lines

$logPath = Join-Path $RepoRoot 'ModifiedLinesLog.txt'
Set-Content -Path $logPath -Value $lines

Write-Host "Wrote $logPath ($($rootNode.Total) total Voicelines found under $ModifiedFolderName/)"

# ---------------------------------------------------------------------------
# Contributor leaderboard
#
# For each mp3 under Modified/, ask git who committed the change that added
# it (the most recent "A" - added - entry for that file's history). Tallies
# are written as an ASCII leaderboard to Contributors.txt, sorted highest
# first, overwriting whatever was there before each run.
# ---------------------------------------------------------------------------
function Get-FileAuthor {
    param([string]$FilePath)

    $author = git -C $RepoRoot log --diff-filter=A --format='%an' -1 -- "$FilePath" 2>$null
    if (-not $author) {
        # Fallback: no "added" entry found (e.g. shallow history) - fall
        # back to whoever most recently touched the file.
        $author = git -C $RepoRoot log --format='%an' -1 -- "$FilePath" 2>$null
    }
    if (-not $author) {
        $author = 'Unknown'
    }
    return $author.Trim()
}

$allMp3s = Get-ChildItem -Path $modifiedPath -Recurse -File -Filter '*.mp3'
$contributorCounts = @{}

foreach ($mp3 in $allMp3s) {
    $author = Get-FileAuthor -FilePath $mp3.FullName
    if ($contributorCounts.ContainsKey($author)) {
        $contributorCounts[$author]++
    }
    else {
        $contributorCounts[$author] = 1
    }
}

$ranked = $contributorCounts.GetEnumerator() | Sort-Object -Property Value -Descending

$contribLines = [System.Collections.Generic.List[string]]::new()
$contribLines.Add("Contributors Leaderboard - generated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$contribLines.Add("")

if ($ranked.Count -eq 0) {
    $contribLines.Add("No mp3 files found under $ModifiedFolderName/")
}
else {
    $nameWidth = [Math]::Max(20, (($ranked | ForEach-Object { $_.Key.Length }) | Measure-Object -Maximum).Maximum + 2)

    $header = "{0,-6}{1,-$nameWidth}{2}" -f 'Rank', 'Contributor', 'Voicelines'
    $contribLines.Add($header)
    $contribLines.Add('-' * $header.Length)

    $rank = 0
    foreach ($entry in $ranked) {
        $rank++
        $bar = '#' * [Math]::Min($entry.Value, 25)
        $line = "{0,-6}{1,-$nameWidth}{2}  $bar" -f $rank, $entry.Key, $entry.Value
        $contribLines.Add($line)
    }
}

$contributorsPath = Join-Path $RepoRoot 'Contributors.txt'
Set-Content -Path $contributorsPath -Value $contribLines

Write-Host "Wrote $contributorsPath ($($ranked.Count) contributor(s))"