🌈 lktopA stunning, rainbow-themed Linux snapshot monitor that values your privacy.一个令人惊叹的、彩虹主题 Linux 系统快照工具，专为隐私与美感而生。

🌈 lktop
一款追求“呼吸感”与“易读性”的 Linux 运维管理工具。 它不只是一个监控快照，更是你终端里的一件艺术品。

✨ 核心特性 (Features)
🎨 视觉舒适区 采用 ANSI 256 渐变色阶，针对深色终端优化，增加行间距与双端留白，拒绝密恐，保护视力。

🔢 无需 PID 的交互 (New!) 列表化管理：每个进程都有专属序号。结束进程时，只需输入 1 或 2，无需再费神核对 7 位数的 PID。

🛠️ 自动化环境补丁 运行即自动修复常见的 sudo: unable to resolve host 报错，确保在任何环境下都能丝滑启动。

📊 深度信息集成 实时显示 CPU/内存进度条、系统负载、进程启动时长 (精确到秒) 及网络监听端口。

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

🛠️ 技术实现 (Tech Stack)维度实现方式优势内核数据直接读取 /proc/stat, /proc/meminfo, /proc/loadavg绕过重型系统调用，毫秒级读取网络状态封装 ss -tunlp 实现进程与端口关联相比 netstat 速度更快，占用更低视觉渲染ANSI 256-Color Escape Codes 动态映射零外部库依赖，支持所有主流终端兼容性适配主流 Linux 发行版 (Ubuntu, Debian, CentOS, Arch 等)极高的环境适应性，支持 x86 与 ARM

⚠️ 常见说明 (Troubleshooting)CPU 显示为 0.0%：lktop 计算的是 0.2s 内的瞬时占用。如果系统空闲，这是正常现象。乱码问题：请确保您的 SSH 客户端（如 PuTTY, Termius, VSCode, Tabby）支持 256 色显示。

⚖️ 开源协议 (License)
本项目遵循 MIT License。

🤝 贡献与反馈欢迎提交 Issue 或 Pull Request 来改进排版逻辑或增加新功能！如果觉得好用，请给个 Star ⭐，这是对开发者最大的支持。
