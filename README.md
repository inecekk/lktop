lktop 
lktop 是一个极简的 Linux 交互式看板，旨在用最轻量的方式提供仪表盘级的监控体验。它没有 htop 那么复杂，但比 top 更漂亮，且原生支持 Docker 容器监控。

🛠 为什么开发它？
在运维 1Panel 或轻量级云服务器时，经常需要同时看系统负载和容器状态。现有的工具要么太重（需安装），要么不支持容器。lktop 通过纯 Bash 解决了以下痛点：

实时性：直接读取 /proc 接口，比解析命令输出更快。

准确性：自研 CPU 计算逻辑，规避了 Linux 瞬时采样导致的“虚高”现象。

直观性：引入可视化进度条，一眼定位资源瓶颈。

🌟 核心功能
双维度看板：同时监控物理机指标与容器指标。

Docker 视图：自动抓取 Top 9 活跃容器（CPU/内存/网络）。

进程快照：展示 Top 22 内存进程，支持交互式 Kill。

自适应布局：针对标准终端窗口优化的对齐算法。

时间精度：支持年、月、日、时、分、秒级别的系统运行统计。

📦 快速安装

🚀 一键安装并运行 (Quick Start)
复制下方命令到终端，体验安装即运行的快感：

```Bash
sudo curl -L https://raw.githubusercontent.com/inecekk/lktop/main/lktop -o /usr/local/bin/lktop && sudo chmod +x /usr/local/bin/lktop && lktop
```
📖 使用方法 (Usage)安装完成后，在终端任何位置输入以下命令即可启动快照：
```Bash
lktop
```
🗑️ 卸载 (Uninstall)
```bash
sudo rm /usr/local/bin/lktop
```

⚙️ 技术细节
CPU 算法：采样两次 /proc/stat 的 CPU ticks，通过 (Δuser + Δsystem) / Δtotal 计算真实负载。

内存算法：解析 free 命令输出，实时计算物理内存百分比。

UI 渲染：利用 ANSI Escape Code 实现彩色进度条，无任何外部图形库依赖。支持所有主流终端兼容性适配主流 Linux 发行版 (Ubuntu, Debian, CentOS, Arch 等)极高的环境适应性，支持 x86 与 ARM

⚠️ 常见说明 (Troubleshooting)CPU 显示为 0.0%：lktop 计算的是 0.2s 内的瞬时占用。如果系统空闲，这是正常现象。乱码问题：请确保您的 SSH 客户端（如 PuTTY, Termius, VSCode, Tabby）支持 256 色显示。

⚖️ 开源协议 (License)
本项目遵循 MIT License。

🤝 贡献与反馈欢迎提交 Issue 或 Pull Request 来改进排版逻辑或增加新功能！如果觉得好用，请给个 Star ⭐，这是对开发者最大的支持。
