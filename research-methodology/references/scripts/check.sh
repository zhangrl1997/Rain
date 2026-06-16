#!/bin/bash
# 卡内完整性校验 — 每张写作卡完成后运行
# 用法: ./check.sh <report_partial.md>
# macOS / Linux 兼容

report="$1"
if [ -z "$report" ] || [ ! -f "$report" ]; then
    echo "用法: ./check.sh <report_partial.md>"
    exit 1
fi

echo "━━━ 完整性校验 ━━━"
echo "文件: $report"
echo ""

# 统计
echo "📄 行数: $(wc -l < "$report" | tr -d ' ')"

# ── [N] 首次出现顺序校验 ──
first_ref=$(echo "$body" | grep -oE '\[[0-9]+\]' | grep -oE '[0-9]+' | awk '!seen[$0]++' | head -1)
if [ -n "$first_ref" ] && [ "$first_ref" != "1" ]; then
    echo ""
    echo "⚠️  [N] 编号顺序异常"
    echo "  正文中第一个出现的引用编号是 [$first_ref] 而不是 [1]"
    echo "  建议：检查编号是否按首次出现顺序排列"
fi

# ── 分离正文和参考文献 ──
body=$(sed '/^## 参考文献$/,$d' "$report")
refs=$(sed -n '/^## 参考文献$/,$p' "$report")

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

echo ""
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
if [ -n "$min_n" ]; then
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

# [U] 用户资料校验
orphan_u=$(comm -23 <(echo "$body_u_nums") <(echo "$refs_u_nums"))
if [ -n "$orphan_u" ]; then
    echo "  ❌ [U] 正文引用但文献缺失: $orphan_u"
else
    echo "  ✅ [U] 引用完整"
fi

echo ""
echo "🔗 URL 校验"
url_missing=$(echo "$refs" | grep -E '^\[[0-9]+\]' | grep -v 'https\?://' || true)
if [ -n "$url_missing" ]; then
    echo "  ⚠️  缺少 URL:"
    echo "$url_missing" | while IFS= read -r line; do
        # 只取前 80 字符显示
        short=$(echo "$line" | cut -c1-80)
        echo "    $short..."
    done
else
    echo "  ✅ 所有公开来源均有 URL"
fi

echo ""
echo "📝 推测标注"
spec_count=$(echo "$body" | grep -c '\[推测\]' || true)
echo "  [推测] 标注: $spec_count 处"

echo ""
echo "📊 参考文献统计"
public_count=$(echo "$refs" | grep -cE '^\[[0-9]+\]' || true)
user_count=$(echo "$refs" | grep -cE '^\[U[0-9]+\]' || true)
total=$((public_count + user_count))
echo "  公开来源: $public_count | 用户资料: $user_count | 合计: $total 条"

echo ""
echo "━━━ 校验完成 ━━━"
