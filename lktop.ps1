# lktop_win_v3.5.ps1
$OutputEncoding = [System.Text.Encoding]::UTF8

# --- 1. 样式与颜色定义 / Style & Color ---
$ESC = [char]27
$BOLD = "$ESC[1m"; $D = "$ESC[90m"; $W = "$ESC[1;37m"; $G = "$ESC[32m"; $Y = "$ESC[33m"; $R = "$ESC[31m"; $RES = "$ESC[0m"
$C_NET = "$ESC[38;5;45m"; $C_CPU = "$ESC[38;5;208m"; $C_BOOT = "$ESC[38;5;155m"; $C_NIX = "$ESC[38;5;141m"; $C_TIME = "$ESC[38;5;220m"

$Global:TotalDown = 0; $Global:TotalUp = 0

function Write-Gradient {
    param([string]$text, [int]$r1, [int]$g1, [int]$b1, [int]$r2, [int]$g2, [int]$b2)
    $len = $text.Length
    for ($i = 0; $i -lt $len; $i++) {
        $r = [int]($r1 + ($r2 - $r1) * ($i / $len)); $g = [int]($g1 + ($g2 - $g1) * ($i / $len)); $b = [int]($b1 + ($b2 - $b1) * ($i / $len))
        Write-Host "$ESC[38;2;$r;$g;${b}m$($text[$i])$RES" -NoNewline
    }
}

function Format-Memory {
    param([long]$bytes)
    $mb = $bytes / 1MB
    if ($mb -ge 1024) { return "{0:N2} GB" -f ($mb / 1024) }
    return "{0:N1} MB" -f $mb
}

function Draw-Bar([int]$val) {
    $w = 12; $f = [Math]::Max(0, [Math]::Min($w, [int]($val * $w / 100)))
    $color = if($val -gt 85){$R}elseif($val -gt 50){$Y}else{$G}
    return "$D[$RES$color$($('■' * $f))$D$($('·' * ($w-$f)))]$RES"
}

# 引导位置与 NixOS 识别 / Boot & NixOS Detection
function Get-BootDeepDetails {
    $details = @{ Entries = @(); Path = "Unknown"; Disk = "N/A"; Nix = $false }
    try {
        $bcdLoaders = bcdedit /enum osloader
        $details.Entries = $bcdLoaders | Select-String "description" | ForEach-Object { $_.ToString().Split(" ", 2)[1].Trim() }
        $details.Path = ($bcdLoaders | Select-String "path" | Select-Object -First 1).ToString().Split(" ", 2)[1].Trim()
        $details.Disk = (Get-CimInstance Win32_DiskPartition | Where-Object { $_.IsSystem -eq $true }).DiskIndex
        if (bcdedit /enum all | Select-String "nixos|grub" -Quiet) { $details.Nix = $true }
    } catch {}
    return $details
}

# 静态预取 / Static Fetch
$os = Get-CimInstance Win32_OperatingSystem
$osName = $os.Caption -replace "Microsoft ",""
$cpuModel = (Get-CimInstance Win32_Processor).Name.Trim()
$boot = Get-BootDeepDetails
$publicIP = "Fetching..."
try { $publicIP = (Invoke-RestMethod -Uri "https://api.ipify.org" -TimeoutSec 1) } catch { $publicIP = "Offline" }

# --- 2. 主循环 / Main Loop ---
try {
    while ($true) {
        $now = Get-Date
        # 核心逻辑：新加坡时间转换 / Singapore Time Conversion
        $sgt = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($now, "Singapore Standard Time")
        $up = $now - $os.LastBootUpTime

        # 硬件温度采集 / Thermal Collection
        $cpuT = $null; $gpuT = $null; $diskT = $null
        try {
            $rawCpu = Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
            if ($rawCpu) { $cpuT = [Math]::Round(($rawCpu.CurrentTemperature / 10) - 273.15, 0) }
            $gpuStat = Get-Counter "\GPU Adapter Memory(*)\Temperature" -ErrorAction SilentlyContinue
            if ($gpuStat) { $gpuT = [Math]::Round(($gpuStat.CounterSamples[0].CookedValue), 0) }
            $dT = (Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_PhysicalDisk -ErrorAction SilentlyContinue).Temperature | Measure-Object -Average
            if ($dT.Average -gt 0) { $diskT = [Math]::Round($dT.Average, 0) }
        } catch {}

        # 性能指标 / Performance
        $cpuInfo = Get-CimInstance Win32_Processor
        $cpuFreq = [Math]::Round($cpuInfo.CurrentClockSpeed / 1000, 2)
        $cpuLoad = $cpuInfo.LoadPercentage
        $memP = [Math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100, 1)

        # 流量统计 / Network Traffic
        $netDown = (Get-Counter "\Network Interface(*)\Bytes Received/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue | Measure-Object -Sum
        $netUp = (Get-Counter "\Network Interface(*)\Bytes Sent/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue | Measure-Object -Sum
        $instD = $netDown.Sum / 1KB; $instU = $netUp.Sum / 1KB
        $Global:TotalDown += ($instD / 1024); $Global:TotalUp += ($instU / 1024)

        Clear-Host
        # --- 头部看板 / Header Section ---
        Write-Host "  " -NoNewline
        Write-Gradient -text "lktop Global-Ops v3.5" -r1 255 -g1 215 -b1 0 -r2 255 -g2 69 -b2 0
        Write-Host "  $D│ 运行时间/Uptime: $W$($up.Days)d $($up.Hours)h$RES"
        
        $nixFlag = if($boot.Nix){ "$C_NIX[NixOS Detected / 已检测到 NixOS]$RES" } else { "" }
        Write-Host "  $BOLD$D 系统/System: $W$osName$RES $nixFlag"
        Write-Host "  $BOLD$C_BOOT 📂 引导列表/Boot List: $W$($boot.Entries -join ' | ')$RES"
        Write-Host "  $BOLD$D 引导路径/Boot Path: $D Disk:$($boot.Disk) -> $W$($boot.Path)$RES"
        
        # 增加新加坡时间展示 / Added Singapore Time
        Write-Host "  $BOLD$D 时间/Time: $W$($now.ToString('HH:mm:ss')) (Local)$RES $D│ $C_TIME$($sgt.ToString('HH:mm:ss')) (SGT/Singapore)$RES $D│ IP: $Y$publicIP$RES"
        Write-Host "  $D$('-' * 104)$RES"

        # --- 性能看板 / Performance Dashboard ---
        Write-Host "  $BOLD$D CPU负载/Load $W$([string]$cpuLoad.ToString().PadLeft(3))%$RES $(Draw-Bar $cpuLoad) $C_CPU @ $($cpuFreq) GHz$RES"
        $tempLine = "  $BOLD$D "
        if ($null -ne $cpuT)  { $cCol = if($cpuT -gt 75){$R}else{$G}; $tempLine += "CPU温度/Temp: $cCol$($cpuT)°C$RES  " }
        if ($null -ne $gpuT)  { $gCol = if($gpuT -gt 75){$R}else{$G}; $tempLine += "GPU温度/Temp: $gCol$($gpuT)°C$RES  " }
        if ($null -ne $diskT) { $dCol = if($diskT -gt 55){$R}else{$G}; $tempLine += "硬盘/Disk Temp: $dCol$($diskT)°C$RES" }
        if ($tempLine.Trim().Length -gt 10) { Write-Host $tempLine }
        Write-Host "  $BOLD$D 内存/Memory  $W$([string]$memP.ToString().PadLeft(3))%$RES $(Draw-Bar $memP)  $D CPU型号: $D$cpuModel$RES"
        
        # --- 网络统计 / Network Statistics ---
        Write-Host "`n  $BOLD$C_NET 🌐 网络统计 / Network Statistics$RES"
        Write-Host "  $D 瞬时/Inst: $G↓ $("{0:N1}" -f $instD) KB/s$RES $R↑ $("{0:N1}" -f $instU) KB/s$RES  $D 累计/Total: $G$("{0:N1}" -f $Global:TotalDown) MB$RES $R$("{0:N1}" -f $Global:TotalUp) MB$RES"

        # --- 进程看板 / Process Manager ---
        Write-Host "`n  $BOLD$W #   PID      进程名/Process Name (Top 30)      内存占用/Mem      状态/Status$RES"
        Write-Host "  $D$('-' * 104)$RES"
        
        $procs = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 30
        $pidMap = @{}; $i = 1
        foreach ($p in $procs) {
            $pidMap[$i] = @{ Id = $p.Id; Name = $p.ProcessName }
            $pName = if($p.ProcessName.Length -gt 28){$p.ProcessName.Substring(0,25)+"..."}else{$p.ProcessName}
            $memStr = Format-Memory $p.WorkingSet64
            $memColor = if($p.WorkingSet64 -gt 1GB){$R}elseif($p.WorkingSet64 -gt 512MB){$Y}else{$W}
            
            Write-Host ("  $BOLD$G{0,2}$RES  $D{1,-8}$RES {2,-30} $memColor{3,16}$RES    $G●$D 有效/Active$RES" -f $i, $p.Id, $pName, $memStr)
            $i++
        }
        Write-Host "  $D$('-' * 104)$RES"
        
        # --- 交互提示 / User Input ---
        $input = Read-Host "  $BOLD$W⚡ [Enter]:刷新/Refresh | [序号/No.]:杀进程/Kill | [Ctrl+C]:退出/Exit $RES"

        if ($input -match "^\d+$") {
            $idx = [int]$input
            if ($pidMap.ContainsKey($idx)) {
                $target = $pidMap[$idx]
                try {
                    Stop-Process -Id $target.Id -Force -ErrorAction Stop
                    Write-Host "  $G[SUCCESS] 已结束进程: $idx - $($target.Name)$RES"
                    Start-Sleep -Seconds 1
                } catch {
                    Write-Host "  $R[ERROR] 权限不足或系统保护$RES"
                    Start-Sleep -Seconds 2
                }
            }
        }
    }
} catch {
    Write-Host "`n  $R退出 lktop$RES"
}
