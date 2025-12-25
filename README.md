🌈 lktopA stunning, rainbow-themed Linux snapshot monitor that values your privacy.一个令人惊叹的、彩虹主题 Linux 系统快照工具，专为隐私与美感而生。
📸 预览 (Preview)运行效果：仪表盘随系统负载实时变换色彩，排版严丝合缝。
✨ 项目亮点 (Features)
🎨 彩虹视觉：内置 256 色彩虹渐变算法，监控指标随负载压力动态变换颜色，告别枯燥。
🔒 隐私保护：原生隐藏内外网 IP 地址，无需打码即可安全分享系统状态截图。
🚀 极致轻量：纯 Bash 编写，直接解析 /proc 文件系统，无常驻进程，零外部依赖。
📊 深度信息：一屏掌握 CPU 占用、内存百分比、负载趋势、进程运行时间及实时监听端口。
📂 精简排版：智能提取核心进程名，自动过滤冗长路径，在不同尺寸的终端下均有出色表现。
🚀 快速安装 (Installation)在终端执行以下命令即可一键安装并赋予执行权限：
```Bash
sudo curl -L https://raw.githubusercontent.com/inecekk/lktop/main/lktop -o /usr/local/bin/lktop && sudo chmod +x /usr/local/bin/lktop
```
📖 使用方法 (Usage)安装完成后，在终端任何位置输入以下命令即可启动快照：
```Bash
lktop
```
删除
```bash
rm /usr/local/bin/lktop
```

🛠️ 技术实现 (Tech Stack)维度实现方式优势内核数据直接读取 /proc/stat, /proc/meminfo, /proc/loadavg绕过重型系统调用，毫秒级读取网络状态封装 ss -tunlp 实现进程与端口关联相比 netstat 速度更快，占用更低视觉渲染ANSI 256-Color Escape Codes 动态映射零外部库依赖，支持所有主流终端兼容性适配主流 Linux 发行版 (Ubuntu, Debian, CentOS, Arch 等)极高的环境适应性，支持 x86 与 ARM⚠️ 
常见说明 (Troubleshooting)CPU 显示为 0.0%：lktop 计算的是 0.2s 内的瞬时占用。如果系统空闲，这是正常现象。乱码问题：请确保您的 SSH 客户端（如 PuTTY, Termius, VSCode, Tabby）支持 256 色显示。
⚖️ 开源协议 (License)本项目基于 MIT License 开源。
🤝 贡献与反馈欢迎提交 Issue 或 Pull Request 来改进排版逻辑或增加新功能！如果觉得好用，请给个 Star ⭐，这是对开发者最大的支持。
