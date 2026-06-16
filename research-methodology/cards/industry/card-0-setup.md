---
name: research-methodology-industry-setup
version: 1.0.0
description: 行业研究 Card 0/7 — 准备工作：建文件夹、读方法论、定义研究范围
card:
  mode: industry
  sequence: 0
  total: 7
  title: 准备工作
  chapters: []
  optional: false
---

# Card 0/7：准备工作

这是行业研究项目的第一张卡。你的任务只是做准备工作，不写任何报告内容。

## 你的任务

1. 与用户确认研究主题和覆盖范围
2. **收集用户手头已有资料**
3. 创建研究文件夹
4. 读取方法论文档了解框架
5. 初始化进度文件和来源文件

## 工作流

### Step 1：确定研究范围

与用户确认：
- 研究哪个行业？（如"便携式储能"、"虚拟电厂"、"阳台光伏"）
- 覆盖哪些区域？全球 / 中国 / 美国 / 欧洲 / 其他
- 时间范围：历史数据到哪一年？预测到哪一年？
- 是否有特别关注的细分领域、公司或技术路线？

### Step 2：用户自有资料

询问用户是否有参考资料。如有，Read `../../research-methodology/references/reference-pretreat.md` 按规则预处理，按章节提取关键数据写入 `reference_materials.md`。无则跳过。

### Step 3：创建文件夹

在项目根目录 `Research/` 下创建：
```
{行业名}_Report_{日期}/
```

例如用户说"便携式储能行业"，则创建：
```
便携式储能_Report_2026-06-10/
```

### Step 3：读取方法论文档

读取以下关键文档：
1. `../../research-methodology/references/industry.md` — 行业研究框架（5层递进、价值链、市场分析模板）
2. `../../research-methodology/references/workflow.md` — 检索→标注→校验工作流规则

通读后向用户简要汇报方法论要点，确保双方对框架有一致理解。

### Step 4：初始化项目文件

创建 `.card-progress`：
```json
{
  "mode": "industry",
  "topic": "{行业名}",
  "created": "{YYYY-MM-DD}",
  "folder": "{行业名}_Report_{日期}",
  "current_card": 0,
  "completed_cards": [],
  "next_card": 1,
  "next_checkpoint_after": 1,
  "last_checkpoint_type": null
}
```

创建空的 `sources.md`：
```markdown
# 来源清单

（本卡将在后续写作中逐步填充）
```

创建空的 `report_partial.md`（含标题和报头信息，不含正文）：
```markdown
# {行业名} —— 深度研究报告

> 报告类型：行业研究
> 覆盖期间：{起止时间}
> 发布日期：{日期}

---
```

## 完成后

告知用户准备就绪，询问是否加载 Card 1。

输出格式：
```
✅ 准备工作完成。
- 文件夹：便携式储能_Report_2026-06-10/
- 方法论：已读取 industry.md + workflow.md
- 范围：已确认

下一步：Card 1 — Ch1 市场结构 + Ch2 定价与商业模式
要加载 Card 1 吗？
```
