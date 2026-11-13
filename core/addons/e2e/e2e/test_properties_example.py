# 性质测试示例（hypothesis），给 Python 项目参考。
# 安装：pip install hypothesis pytest
# from hypothesis import given, strategies as st
#
# def unique_preserve_order(items: list[str]) -> list[str]:
#     seen: set[str] = set()
#     out: list[str] = []
#     for item in items:
#         if item not in seen:
#             seen.add(item)
#             out.append(item)
#     return out
#
# @given(st.lists(st.text()))
# def test_dedup_is_idempotent_and_subset(items: list[str]) -> None:
#     result = unique_preserve_order(items)
#     assert unique_preserve_order(result) == result
#     assert set(result) <= set(items)
