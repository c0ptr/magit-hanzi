# magit-hanzi

让 Magit 界面显示简体中文 · Chinese localization for Magit

<!-- 合并进 MELPA 后取消下面两行注释,显示徽章:
[![MELPA](https://melpa.org/packages/magit-hanzi-badge.svg)](https://melpa.org/#/magit-hanzi)
-->
[![License: GPL v3](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## 简介 · Overview

**magit-hanzi**(“Magit 汉字”)把 Magit 的界面文字换成简体中文:

- 状态/日志等缓冲区的段落标题 —— `Unstaged changes` → `未暂存的改动`
- 状态缓冲区顶部的头部标签 —— `Head:` / `Merge:` / `Push:` → `头部:` / `合并:` / `推送:`
- transient 菜单(`magit-dispatch` 及各级菜单)的分组与条目描述

设计原则 · Design:

- **只做整词精确匹配**,不会改动 commit message、文件名等用户内容
- **未收录的条目保持英文**,升级 Magit 后新词自然以英文显示,不会报错
- 词典落在 `magit-hanzi-dictionary`,可随时扩展或覆盖

## 安装 · Installation

### use-package(MELPA 合并后)

```elisp
(use-package magit-hanzi
  :ensure t
  :after magit
  :config
  (magit-hanzi-mode 1))
```

`magit-hanzi-mode` 是全局 minor mode,开启一次即对所有 Magit 缓冲区生效。

### use-package + straight.el(从 GitHub)

```elisp
(use-package magit-hanzi
  :straight (magit-hanzi :type git :host github :repo "c0ptr/magit-hanzi")
  :after magit
  :config
  (magit-hanzi-mode 1))
```

### use-package + quelpa(从 GitHub)

```elisp
(use-package magit-hanzi
  :quelpa (magit-hanzi :fetcher github :repo "c0ptr/magit-hanzi")
  :after magit
  :config
  (magit-hanzi-mode 1))
```

### 本地 load-path · Manual

```sh
git clone https://github.com/c0ptr/magit-hanzi.git ~/Code/magit-hanzi
```

```elisp
(use-package magit-hanzi
  :ensure nil
  :load-path "~/Code/magit-hanzi"
  :after magit
  :config
  (magit-hanzi-mode 1))
```

## 兼容性 · Compatibility

- Emacs 27.1 及以上
- Magit 3.0 及以上
- transient 0.3 及以上

## 工作原理 · How it works

- 段落标题:advice `magit-insert-heading` 与 `magit-insert-headers`
- transient 菜单:为 `transient--get-description`、`transient-format` 添加 `:around` 方法
- 所有翻译都经过 `magit-hanzi--translate`,保留原文的文本属性与首尾空白(菜单对齐不受影响)

## 自定义词典 · Customizing the dictionary

```elisp
(add-to-list 'magit-hanzi-dictionary '("Your label" . "你的中文"))
```

词典的键必须与 Magit 中出现的英文原文完全一致。

## FAQ

- **某个词没有翻译?** 用上面的 `add-to-list` 补进词典,欢迎提 PR 收录进默认词典。
- **如何关闭?** `M-x magit-hanzi-mode`(即 `(magit-hanzi-mode -1)`),advice 会立即移除,transient 方法因开关判断随之失效。
- **会翻译我的 commit message 吗?** 不会,只匹配固定的界面标签,不碰用户内容。

## License

GPL-3.0-or-later,见 [LICENSE](LICENSE)。
