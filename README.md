🚀 lktop: Minimalist Multi-Boot & System Monitor

lktop 是一款专为开发者与运维工程师设计的极简跨平台监控看板。
它在保持 轻量化（纯脚本、零依赖） 的同时，提供了比 top 更直观、比 htop 更聚焦的交互体验。
特别针对 NixOS 25.11 + Windows 11 IoT 企业版 LTSC 双系统环境 深度优化。

🌟 核心优势 / Key Highlights

💎 双系统深度适配
自动识别 EFI 分区中的 NixOS 引导路径与引导链状态，高亮显示 NixOS 引导链，方便双系统用户确认启动配置。

🔧 统一指令集
Linux 和 Windows 均可使用统一指令 lktop 启动监控。

📊 智能数据呈现

内存占用 >1024 MB 自动切换 GB 单位

高能耗进程自动高亮颜色预警

🌐 全球时区同步
顶部实时显示本地时间和新加坡 (SGT) 时间，方便跨境协作。

⌨️ 极简交互操作
列表左侧绿色序号 (1-30) 支持一键结束进程，无需手动输入 PID。

🧪 测试环境 / Testing Environment
平台	系统版本	终端环境
Windows	Windows 11 IoT 企业版 LTSC	PowerShell 5.1 / 7+ (管理员)
Linux	NixOS 25.11	Bash 5.0+, Zsh

推荐字体：JetBrains Mono / Cascadia Code

📦 安装与运行 / Installation & Run
🐧 Linux (NixOS, Ubuntu, Debian 等)

直接读取内核 /proc 接口，无额外依赖。

# 一键安装并运行
```bash
sudo curl -L https://raw.githubusercontent.com/inecekk/lktop/main/lktop -o /usr/local/bin/lktop \
&& sudo chmod +x /usr/local/bin/lktop \
&& lktop
```

安装完成后，在任何终端窗口直接输入 lktop 即可启动。

🪟 Windows (PowerShell - 请以管理员身份运行)

针对 Windows 11 IoT 深度定制，自动处理执行策略，修复 UTF-8 BOM 编码以杜绝乱码。

# 一键部署并运行
```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

$c = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/inecekk/lktop/main/lktop.ps1"

# 将内容写入 UTF-8 BOM 文件，保证控制台显示正常
[System.IO.File]::WriteAllLines("$env:SystemRoot\System32\lktop.ps1", $c, (New-Object System.Text.UTF8Encoding($true)))

# 启动 lktop
lktop
```

安装完成后，今后在任何终端窗口直接输入 lktop 即可唤起。

🗑️ 卸载与清理 / Uninstall & Clean
🐧 Linux
```bash
sudo rm /usr/local/bin/lktop
```
🪟 Windows
```bash
Remove-Item "$env:SystemRoot\System32\lktop.ps1" -Force -ErrorAction SilentlyContinue
```
🛠 技术细节 / Technical Details
1️⃣ 引导追踪逻辑 (Boot Tracking)

Windows 环境下，解析 bcdedit /enum osloader 自动定位 EFI 分区

检测到 NixOS 关键字时，高亮显示引导链，方便双系统用户确认启动配置

2️⃣ 乱码预防机制

Windows 控制台对普通 UTF-8 支持不稳定

部署脚本生成 UTF-8 with BOM 文件

保证进度条 ■、边框 │、状态点 ● 在中文版 Windows 下正常显示

⌨️ 交互指南 / Controls
操作	功能
[Enter]	刷新监控数据 (Refresh)
[数字序号]	结束进程 (Kill)
[Ctrl + C]	退出监控 (Exit)
⚖️ 开源协议 / License

本项目遵循 MIT License
欢迎 Star ⭐ 或提交 Pull Request！


截图
debian13
<img width="1595" height="1889" alt="捕获1" src="https://github.com/user-attachments/assets/e71def26-caaa-467b-a568-8eaaacb53809" />
Windows 11 IoT 企业版 LTSC    
<img width="1565" height="1895" alt="捕获" src="https://github.com/user-attachments/assets/4635a07a-c7c9-4cfb-b3c1-159057085db0" />


