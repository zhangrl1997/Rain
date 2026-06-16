---
name: research-methodology
version: 1.0.0
description: 系统化的行业研究和公司研究方法论。当用户需要做行业深度研究（市场分析、价值链、技术趋势、区域对比）或公司深度研究（投资尽调、横纵分析、财务模型、竞品分析）时触发。支持完整的研究报告撰写、财务模型构建和事实核查工作流。用户说"研究一下XX公司"、"做一份XX行业报告"、"尽调XX"、"覆盖XX"、"写一份研究报告"、"分析XX行业"等均触发。也适用于能源、AI、制造、消费、科技等各类行业。
---

# Research Methodology — 主 Skill 分发器

你是卡片系统（Card System）的入口调度器。你负责：
1. 判断用户需要行业研究还是公司研究
2. 检查 `.card-progress` 确定当前进度
3. 推荐并加载下一张卡片
4. 在卡片之间执行检查点

## 卡片序列总览

### 行业研究（7 张卡）

| 卡 | 名称 | 内容 | 之后 |
|----|------|------|------|
| Card 0 | **setup** | 建文件夹 + 读方法论 + 定义范围 | → Card 1 |
| Card 1 | **basics** | Ch1 市场结构 + Ch2 定价与商业模式 | → **检查点①** |
| → | **检查点①** | 早期方向验证 | → Card 2 |
| Card 2 | **value-chain** | Ch3 价值链与五力 + Ch4 技术分析 | → Card 3 |
| Card 3 | **region-policy** | Ch5 区域对比 + Ch6 监管与政策 | → **检查点②** |
| → | **检查点②** | 中期方向校验 | → Card 4 |
| Card 4 | **competition** | Ch7 竞品图谱 + Ch8 供应链 | → Card 5 |
| Card 5 | **trends-risk** | Ch9 趋势全景 + Ch10 机会与风险 | → **检查点③** |
| → | **检查点③** | 终稿前完整性检查 | → Card 6 |
| Card 6 | **finalize** | 校验 + 格式 | → 完成 |

### 公司研究（8 张卡）

| 卡 | 名称 | 内容 | 之后 |
|----|------|------|------|
| Card 0 | **setup** | 建文件夹 + 读方法论 + 定义范围 | → Card 1 |
| Card 1 | **basics** | Ch1 概览 + Ch2 历程 + Ch3 团队 | → **检查点①** |
| → | **检查点①** | 早期方向验证 | → Card 2 |
| Card 2 | **product-customer** | Ch4 产品 + Ch5 客户与市场策略 | → Card 3 |
| Card 3 | **industry-chain** | Ch6 行业概览 + Ch7 价值链分析 | → **检查点②** |
| → | **检查点②** | 中期方向校验 | → Card 4 |
| Card 4 | **competitive-opp** | Ch8 竞争格局 + Ch9 市场机会 | → Card 5 |
| Card 5 | **risk-synthesis** | Ch10 风险 + Ch11 横纵总结 | → Card 6（可选） |
| Card 6 | **financial-model** | 财务模型（可选） | → **检查点③** |
| → | **检查点③** | 终稿前完整性检查 | → Card 7 |
| Card 7 | **finalize** | 校验 + 格式 | → 完成 |

---

## 分派逻辑

### 第一步：确定模式

根据用户输入判断：

```
"研究一下便携式储能行业"      → 行业研究
"做一份储能行业深度报告"       → 行业研究  
"分析一下EcoFlow"             → 公司研究
"尽调中微公司"               → 公司研究
"覆盖宁德时代"               → 公司研究
```

### 第二步：检查进度

在项目根目录搜索 `.card-progress`：
- **没有找到** → 全新项目
  1. 询问用户研究主题
  2. 确认是否需要财务模型（仅公司模式）
  3. 建议加载 Card 0（Setup）
  
- **找到且有未完成卡片** → 续接项目
  1. 读取 `.card-progress` 获取当前状态
  2. 向用户汇报已有进度
  3. 建议加载下一张未完成的卡

- **找到且全部完成** → 已完成项目
  1. 告知用户该项目已完成
  2. 询问是否需要修正或展开

### 第三步：加载卡片

读取 `cards/{mode}/{card-file}.md` 获取卡片指令：

```
# 行业研究
Read: cards/industry/card-0-setup.md                (Card 0)
Read: cards/industry/card-1-basics.md               (Card 1)
Read: cards/industry/card-2-value-chain.md          (Card 2)
Read: cards/industry/card-3-region-policy.md        (Card 3)
Read: cards/industry/card-4-competition.md          (Card 4)
Read: cards/industry/card-5-trends-risk.md          (Card 5)
Read: cards/industry/card-6-finalize.md             (Card 6)

# 公司研究  
Read: cards/company/card-0-setup.md                    (Card 0)
Read: cards/company/card-1-basics.md                   (Card 1)
Read: cards/company/card-2-product-customer.md         (Card 2)
Read: cards/company/card-3-industry-chain.md           (Card 3)
Read: cards/company/card-4-competitive-opp.md          (Card 4)
Read: cards/company/card-5-risk-synthesis.md           (Card 5)
Read: cards/company/card-6-financial-model.md          (Card 6)
Read: cards/company/card-7-finalize.md                 (Card 7)
```

---

## 检查点执行指令

检查点不是独立 skill，由你（主 skill）在当前对话中执行。

### 检查点① — 早期方向验证

**触发时机**：行业 Card 1 / 公司 Card 1 完成后

**执行步骤**：
1. 读取 `{report_dir}/report_partial.md`（刚写完的 1-2 章或 1-3 章）
2. 逐一核查：
   - 研究方向是否准确？覆盖范围的定义清晰吗？
   - 数据检索是否充分（每章 ≥ 2 次搜索）？
   - 章节结构是否符合方法论框架？
   - 有没有过早下结论或数据不足的判断？
   - [N] 编号是否正确开始？
3. 输出检查报告，格式：
   ```
   ━━━ 检查点①报告 ━━━
   
   ✅ 已完成：Ch{范围}
   ✅ 检索次数：{N}次
   ⚠️ / ✅ 分析...
   
   建议：{继续 / 补充搜索 / 调整范围}
   
   你的意见：
   ```
4. 等待用户决定（继续 / 修正 / 调整方向）

### 检查点② — 中期方向校验

**触发时机**：行业 Card 3 / 公司 Card 3 完成后（已写约 60% 内容）

**执行步骤**：
1. 读取 `{report_dir}/report_partial.md`（已写 6-7 章）
2. 逐一核查：
   - 各章之间有无矛盾或重复？
   - 数据来源是否可靠且标注正确？
   - [N] 编号连续无冲突？
   - 逻辑链条是否完整？
   - 有没有偏离最初定义的范围？
   - 已完成部分的质量是否一致？
3. 输出检查报告

### 检查点③ — 终稿前完整性检查

**触发时机**：行业 Card 5 / 公司 Card 6 完成后（全部内容已完成）

**执行步骤**：
1. 读取完整报告
2. 逐一核查：
   - 所有章节覆盖完整，无遗漏
   - 跨章关键数据逻辑一致（如 Ch1 市场规模与 Ch9 增长预测匹配）
   - 参考文献与 [N] 编号一一对应
   - 推测性内容标注 `[推测]` 或 `（作者判断）`
   - 整体报告质量评估
3. 输出检查报告，决策：进入 Finalize / 补充修改

---

## 中断恢复

当用户隔了一段时间回来继续时：

1. 读取 `.card-progress`
2. 向用户汇报当前进度（已完成哪些卡、下一张卡是什么）
3. 建议继续的步骤
4. **显示进度跟踪表**，让用户直观看到进展

```
━━━ 项目进度 ━━━

公司：{公司名}
模式：公司研究
进度：Card 4/8 已完成（Ch1-7）
状态：等待 Card 5（Ch10-11）

已完成：✅ Card 0 ✅ Card 1 ✅ Card 2 ✅ Card 3 
进行中：⬜ Card 4 ← 你在哪
待完成：⬜ Card 5 ⬜ Card 6 ⬜ Card 7

下步建议：加载 Card 4（Ch8 竞争格局 + Ch9 市场机会）
```

---

## 预设消息

### 新项目提示

```
我注意到这是一个新项目。按卡片系统执行：

1. 先加载 Setup 卡（创建工作文件夹 + 读方法论）
2. 然后逐卡写作，每 3 张卡执行一次检查点
3. 最后 Finalize 卡收尾

现在加载 Setup 卡开始准备？
```

### 续接项目提示

```
项目已有进度：
- 模式：{模式}
- 已完成：{N}张卡
- 当前章节：Ch{范围}
- 下一张卡：{卡名}

要加载下一张卡吗？
```

### 项目完成提示

```
━━━ 🎉 项目完成 ━━━

报告：{最终文件名}
总来源数：{N}条
总卡数：{N}/{总}

如需调整或补充，随时告诉我。
```
