# magit-hanzi

让 Magit 界面显示简体中文 (Chinese localization for Magit)。

把 Magit 状态/日志缓冲区的段落标题、头部标签，以及 transient 菜单（`magit-dispatch` 及各级菜单）的分组与条目描述换成中文。只做整词精确匹配，不会改动 commit message、文件名等用户内容；未收录的条目保持英文，升级 Magit 后新词会自然以英文显示，不会报错。

## 安装

### 方式一：本地 load-path（最简单）

先克隆仓库到任意位置：

```sh
git clone https://github.com/<你的用户名>/magit-hanzi.git ~/.emacs.d/lisp/magit-hanzi
```

然后在 `init.el` 中：

```elisp
(use-package magit-hanzi
  :ensure nil                     ; 不走包管理器，直接从本地加载
  :load-path "~/.emacs.d/lisp/magit-hanzi"
  :after magit
  :config
  (magit-hanzi-mode 1))
```

### 方式二：straight.el 从 GitHub 安装

```elisp
(use-package magit-hanzi
  :straight (magit-hanzi :type git :host github :repo "<你的用户名>/magit-hanzi")
  :after magit
  :config
  (magit-hanzi-mode 1))
```

### 方式三：quelpa 从 GitHub 安装

```elisp
(use-package magit-hanzi
  :quelpa (magit-hanzi :fetcher github :repo "<你的用户名>/magit-hanzi")
  :after magit
  :config
  (magit-hanzi-mode 1))
```

### 方式四：MELPA（推荐给更多人用）

本包的文件头已经符合 MELPA 的 recipe 规范（含 `Package-Requires`、`;;;###autoload` 等）。只要把仓库推到 GitHub，然后到 <https://github.com/melpa/melpa> 提一个 PR，新增 recipe 文件 `recipes/magit-hanzi`：

```elisp
(magit-hanzi :repo "<你的用户名>/magit-hanzi" :fetcher github)
```

合并后就可以像普通包一样安装：

```elisp
(use-package magit-hanzi
  :ensure t
  :after magit
  :config
  (magit-hanzi-mode 1))
```

## 自定义词典

词典落在 `magit-hanzi-dictionary`，可随时扩展或覆盖：

```elisp
(use-package magit-hanzi
  :after magit
  :config
  (add-to-list 'magit-hanzi-dictionary '("Your label" . "你的中文"))
  (magit-hanzi-mode 1))
```

## License

GPL-3.0-or-later。完整文本见 [LICENSE](LICENSE)。
