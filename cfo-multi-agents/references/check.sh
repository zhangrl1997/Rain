#!/bin/bash
# 方案文档引用完整性校验
# 用法: bash references/check.sh <文档.md>
# macOS / Linux 兼容

report="$1"
if [ -z "$report" ] || [ ! -f "$report" ]; then
    echo "用法: bash references/check.sh <文档.md>"
    exit 1
fi

echo "━━━ 方案文档引用校验 ━━━"
echo "文件: $report"
echo ""

# ── 基础统计 ──
echo "📄 文件大小: $(wc -c < "$report" | tr -d ' ') 字节"
echo "📄 总行数: $(wc -l < "$report" | tr -d ' ')"
echo ""

# ── 分离正文和参考文献 ──
body=$(sed '/^## 参考文献$/,$d' "$report")
refs=$(sed -n '/^## 参考文献$/,$p' "$report")

# ── 检查是否有参考文献章节 ──
if ! grep -q '^## 参考文献$' "$report"; then
    echo "❌ 缺少 ## 参考文献 章节"
    echo "  建议：文档末尾添加参考文献列表"
    echo ""
fi

# ── [N] 首次出现顺序校验 ──
first_ref=$(echo "$body" | grep -oE '\[[0-9]+\]' | grep -oE '[0-9]+' | awk '!seen[$0]++' | head -1)
if [ -n "$first_ref" ] && [ "$first_ref" != "1" ]; then
    echo "⚠️  [N] 编号顺序异常"
    echo "  正文中第一个出现的引用编号是 [$first_ref] 而不是 [1]"
fi

# ── 工具函数 ──
extract_numbers() {
    echo "$1" | grep -oE '\[[0-9]+\]' | grep -oE '[0-9]+' | sort -n | uniq
}

extract_u() {
    echo "$1" | grep -oE '\[U[0-9]+\]' | sort -n | uniq
}

body_nums=$(extract_numbers "$body")
refs_nums=$(extract_numbers "$refs")
body_u_nums=$(extract_u "$body")
refs_u_nums=$(extract_u "$refs")

# ── [N] 引用校验 ──
echo "🔍 [N] 引用校验"

orphan=$(comm -23 <(echo "$body_nums") <(echo "$refs_nums"))
if [ -n "$orphan" ]; then
    echo "  ❌ 正文引用但文献缺失: [$(echo $orphan | tr ' ' ',')]"
else
    echo "  ✅ 正文 [N] 均在参考文献中有对应条目"
fi

unused=$(comm -13 <(echo "$body_nums") <(echo "$refs_nums"))
if [ -n "$unused" ]; then
    echo "  ⚠️  文献中有但正文未引用: [$(echo $unused | tr ' ' ',')]"
else
    echo "  ✅ 参考文献条目均在正文中引用"
fi

# 编号连续性
min_n=$(echo "$body_nums" | head -1)
max_n=$(echo "$body_nums" | tail -1)
if [ -n "$min_n" ] && [ -n "$max_n" ]; then
    missing=""
    for i in $(seq "$min_n" "$max_n"); do
        echo "$body_nums" | grep -qx "$i" || missing="$missing $i"
    done
    if [ -n "$missing" ]; then
        echo "  ❌ 编号不连续，缺失: [$missing]"
    else
        echo "  ✅ 编号 $min_n-$max_n 连续"
    fi
fi

echo ""

# ── [U] 用户资料校验 ──
echo "🔍 [U] 用户资料引用校验"

orphan_u=$(comm -23 <(echo "$body_u_nums") <(echo "$refs_u_nums"))
if [ -n "$orphan_u" ]; then
    echo "  ❌ [U] 正文引用但文献缺失: $orphan_u"
else
    echo "  ✅ [U] 引用完整"
fi

unused_u=$(comm -13 <(echo "$body_u_nums") <(echo "$refs_u_nums"))
if [ -n "$unused_u" ]; then
    echo "  ⚠️  [U] 文献中有但正文未引用: $unused_u"
fi

echo ""

# ── URL 校验 ──
echo "🔗 URL 完整性校验"
url_missing=$(echo "$refs" | grep -E '^\[[0-9]+\]' | grep -v 'https\?://' || true)
if [ -n "$url_missing" ]; then
    echo "  ⚠️  以下公开来源缺少 URL:"
    echo "$url_missing" | while IFS= read -r line; do
        short=$(echo "$line" | cut -c1-80)
        echo "    $short..."
    done
else
    echo "  ✅ 所有公开来源均有 URL"
fi

echo ""

# ── 法规文号检查 ──
echo "📜 法规引用检查"
law_refs=$(echo "$body" | grep -oE '「[^」]+」|[\(（][^)）]*\d{4}[^)）]*[\)）]|第[一二三四五六七八九十百千]+条|第\d+条|[第〔（]?\d+\s*号[文公规]|[第〔（]?\d+\s*号公告' || true)
law_count=$(echo "$law_refs" | grep -c . || true)
if [ "$law_count" -gt 0 ]; then
    echo "  检测到 $law_count 处法规/条款引用"
else
    echo "  （未检测到法规引用）"
fi

echo ""

# ── 推测标注检查 ──
echo "📝 推测标注检查"
spec_count=$(echo "$body" | grep -c '\[推测\]' || true)
judge_count=$(echo "$body" | grep -c '（作者判断）' || true)
if [ "$spec_count" -gt 0 ] || [ "$judge_count" -gt 0 ]; then
    echo "  [推测] 标注: $spec_count 处"
    echo "  （作者判断）标注: $judge_count 处"
else
    echo "  ⚠️  未检测到 [推测] 或（作者判断）标注 — 如有推测性内容请补充标注"
fi

echo ""

# ── 参考文献统计 ──
echo "📊 参考文献统计"
public_count=$(echo "$refs" | grep -cE '^\[[0-9]+\]' || true)
user_count=$(echo "$refs" | grep -cE '^\[U[0-9]+\]' || true)
total=$((public_count + user_count))
echo "  公开来源 [N]: $public_count 条"
echo "  内部资料 [U]: $user_count 条"
echo "  合计: $total 条"

echo ""
echo "━━━ 校验完成 ━━━"
