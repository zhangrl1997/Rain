# Rain — Claude Code Skills Collection

Claude Code 技能集合，包含多个独立的方法论 skill。

## 技能列表

### research-methodology
行业研究和公司研究方法论卡片系统。每次只加载当前步骤所需指令，避免上下文稀释。

```
research-methodology/
├── SKILL.md                 # 主入口
├── cards/                   # 卡片指令集
│   ├── industry/            # 行业研究（7 张卡）
│   └── company/             # 公司研究（8 张卡）
└── references/              # 方法论文档
```

### cfo-multi-agents
多Agent协同研究方法论 — 多专业Agent并行研究、交叉审核、辩论、合稿的标准化工作流。

```
cfo-multi-agents/
├── SKILL.md                 # 技能入口
├── agents/                  # Agent 定义（7个角色）
└── references/              # 校验脚本 + 引用规则
```
    ├── workflow.md
    ├── reference-pretreat.md
    └── scripts/
        ├── extract_text.py  # 文档全文提取工具
        └── check.sh         # 卡内完整性校验脚本
```

## 工作流

每张卡完成后执行三层校验方可继续：

1. **自动化校验**（`check.sh`）— 检查 [N] 引用、URL 完整性、编号连续性
2. **关键数据核验** — 选 3-5 个核心数据/假设逐一独立搜索验证
3. **卡内完整性自查** — 7 项手动确认

## 使用方式

触发 `research-methodology` skill 后，系统自动判断模式并引导逐卡推进：

```
用户 → "研究一下光伏行业"
     → 主 skill 触发 → 判断为行业研究
     → 加载 Card 0 Setup → 建文件夹/读方法论/定范围
     → Card 1 Ch1-2 → 检索→写作→校验→检查点
     → 依次推进至 Finalize
```

每完成 3 张内容卡执行一次检查点（方向验证）。

## 卡片定义

| 模式 | 卡数 | 结构 |
|------|------|------|
| 行业研究 | 7 张 | Setup → Ch1-2 → Ch3-4 → Ch5-6 → Ch7-8 → Ch9-10 → Finalize |
| 公司研究 | 8 张 | Setup → Ch1-3 → Ch4-5 → Ch6-7 → Ch8-9 → Ch10-11 → 财务模型 → Finalize |

## 前置条件

```bash
# Python 依赖
pip3 install pypdf python-docx openpyxl
```

## 安全说明

- 所有路径使用相对引用，无硬编码绝对路径
- 部署脚本内置备份机制（首次覆盖前自动备份）
- 通过 `--dry-run` 预览部署操作
- 无密钥/Token 硬编码
