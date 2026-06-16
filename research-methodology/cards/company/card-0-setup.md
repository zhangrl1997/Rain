---
name: research-methodology-company-setup
version: 1.0.0
description: 公司研究 Card 0/8 — 准备工作：建文件夹、读方法论、定义研究范围
card:
  mode: company
  sequence: 0
  total: 8
  title: 准备工作
  chapters: []
  optional: false
---

# Card 0/8：准备工作

这是公司研究项目的第一张卡。只做准备工作，不写报告内容。

## 你的任务

1. 与用户确认研究标的和覆盖范围
2. **收集用户手头已有资料**
3. 创建研究文件夹
4. 读取方法论文档
5. 初始化项目文件

## 工作流

### Step 1：确定研究范围

与用户确认：
- 研究哪家公司？（如"EcoFlow"、"中微公司"）
- 需要覆盖哪些方面？全面覆盖 / 投资尽调 / 竞品分析 / 更新
- 时间范围：历史数据到哪一年？预测到哪一年？
- 是否需要财务模型？
- 是否有特定的关注点（技术/市场/管理/风险）？

### Step 2：用户自有资料

询问用户是否有参考资料（报告/财报/PDF/链接）。如有，Read `../../research-methodology/references/reference-pretreat.md` 按规则处理，提取关键数据写入 `reference_materials.md`。无则跳过。

### Step 3：创建文件夹

在项目根目录 `Research/` 下创建：
```
{公司名}_Research_{日期}/
```

例如 `EcoFlow_Research_2026-06-10/`

### Step 3：读取方法论文档

读取：
1. `../../research-methodology/references/company.md` — 公司研究方法论（横纵分析法、五链追问、六道算数、报告模板）
2. `../../research-methodology/references/workflow.md` — 检索→标注→校验工作流

### Step 4：初始化项目文件

创建 `.card-progress`：
```json
{
  "mode": "company",
  "topic": "{公司名}",
  "created": "{YYYY-MM-DD}",
  "folder": "{公司名}_Research_{日期}",
  "current_card": 0,
  "completed_cards": [],
  "next_card": 1,
  "next_checkpoint_after": 1,
  "last_checkpoint_type": null
}
```

创建空的 `sources.md` 和 `report_partial.md`（含标题和报头信息）。

## 完成后

```
✅ 准备工作完成。
- 文件夹：{公司名}_Research_{日期}/
- 方法论：已读取 company.md + workflow.md
- 财务模型：{需要/不需要}

下一步：Card 1 — Ch1 公司概览 + Ch2 发展历程 + Ch3 管理团队
要加载 Card 1 吗？
```
