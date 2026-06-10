---
name: research-methodology-company-financial-model
version: 1.0.0
description: 公司研究 Card 6/8 — 财务模型（可选）
card:
  mode: company
  sequence: 6
  total: 8
  title: 财务模型
  chapters: []
  optional: true
---

# Card 6/8：财务模型（可选）

**本卡为可选卡**——仅在用户需要财务模型时执行。如果不需要，直接跳到 Card 7 Finalize。

## 你的任务

读已有报告 → 建财务模型 Excel → 勾稽校验 → 输出文件

## 工作流

### 1. 读取输入

- `{report_dir}/report_partial.md` — 全部章节，了解公司业务和财务概况
- `../../research-methodology/references/company.md` — 财务模型规范（公式模式、勾稽校验）
- `../../research-methodology/references/workflow.md`

### 2. 构建财务模型

使用 openpyxl 构建 Excel 模型。

**模型结构：**
- Sheet 1: Assumptions（假设输入，蓝色字体标注）
- Sheet 2: Income Statement（利润表）
- Sheet 3: Balance Sheet（资产负债表，可选——如数据充足）
- Sheet 4: Cash Flow（现金流量表）
- Sheet 5: Valuation（估值，如需要）

**关键规则（来自 company.md）：**
- 所有预测单元格必须写 Excel 公式，严禁硬编码
- 唯一硬编码：历史实际值、假设输入（蓝色字体）
- CoGS 为负值（`= -Rev * (1 - GPM)`）
- PP&E 滚动：`= 期初 - CapEx(负值) + D&A(正值)`
- CFO：`= NI + D&A + SBC + ΔWC`
- 表名含特殊字符时加单引号（`='P&L'!A1`）

**勾稽校验（必须通过）：**
- GP CHECK：`GP - Rev - CoGS = 0`
- EBIT CHECK：`EBIT - EBITDA - D&A = 0`
- BS CHECK：`Total Assets - Total L&E = 0`
- Cash Tie-Out：`BS Cash - CF Ending Cash = 0`

### 3. 输出文件

- 保存为 `{report_dir}/{公司名}_Financial_Model_{日期}.xlsx`
- 设置 `calc.fullCalcOnLoad = True`
- 更新 `.card-progress`：`current_card: 6, next_card: 7`

## 完成后

```
✅ Card 6/8 完成。
- 财务模型：{公司名}_Financial_Model_{日期}.xlsx
- 勾稽校验：全部通过

⚠️ 下一步是检查点③（终稿前完整性检查）
执行检查点后再加载 Card 7 Finalize。
```
