;;; magit-hanzi.el --- 让 Magit 界面显示中文 (Chinese localization for Magit) -*- lexical-binding: t; -*-

;; Copyright (C) 2026 c0ptr <0xbin66@gmail.com>

;; Author: c0ptr <0xbin66@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (magit "3.0") (transient "0.3"))
;; Keywords: vc, i18n
;; URL: https://github.com/c0ptr/magit-hanzi
;; License: GPL-3.0-or-later
;; Assisted-by: <工具名>:<模型版本>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; magit-hanzi（"Magit 汉字"）把 Magit 的界面文字换成简体中文：
;;
;;   1. 状态/日志等缓冲区的段落标题 —— Unstaged changes → 未暂存的改动
;;   2. 状态缓冲区顶部的头部标签 —— Head: / Merge: / Push: → 头部: / 合并: / 推送:
;;   3. transient 菜单（magit-dispatch 及各级菜单）的分组与条目描述
;;
;; 用法：
;;
;;   (require 'magit-hanzi)
;;   (magit-hanzi-mode 1)
;;
;; 词典落在 `magit-hanzi-dictionary'，可随时扩展或覆盖：
;;
;;   (add-to-list 'magit-hanzi-dictionary '("Your label" . "你的中文"))
;;
;; 说明：只做「整词精确匹配」，不会动 commit message、文件名等用户内容；
;; 未收录的条目保持英文，升级 Magit 后新词会自然以英文显示，不会报错。
;;
;;; Code:

(require 'magit)
(require 'transient)

(defgroup magit-hanzi nil
  "Magit 中文化。"
  :group 'magit
  :prefix "magit-hanzi-")

(defcustom magit-hanzi-dictionary
  '(;; ---- 状态/日志等缓冲区段落标题 ----
    ("Unstaged changes" . "未暂存的改动")
    ("Staged changes" . "已暂存的改动")
    ("Untracked files" . "未跟踪的文件")
    ("Unpushed commits" . "未推送的提交")
    ("Unpulled commits" . "未拉取的提交")
    ("Unmerged commits" . "未合并的提交")
    ("Unreachable commits" . "不可达的提交")
    ("Recent commits" . "最近的提交")
    ("Applying patches" . "正在应用补丁")
    ("Cherry commits" . "拣选的提交")
    ("Shelved branches" . "搁置的分支")
    ("Bisect Log" . "二分查找日志")
    ("Bisect Rest" . "二分查找重置")
    ("Branches" . "分支")
    ("Tags" . "标签")
    ("Stashes" . "储藏")
    ("Notes" . "备注")
    ("Worktrees" . "工作树")
    ("Submodules" . "子模块")
    ("Remotes" . "远程")
    ("Refs" . "引用")
    ("Author" . "作者")
    ("Committer" . "提交者")
    ("Date" . "日期")
    ("Parent" . "父提交")
    ("Diffstat" . "差异统计")
    ("Summary" . "摘要")

    ;; ---- magit-dispatch 分组 ----
    ("Transient and dwim commands" . "瞬时与智能命令")
    ("Applying changes" . "应用改动")
    ("Essential commands" . "常用命令")
    ("Commands" . "命令")
    ("Actions" . "操作")
    ("Arguments" . "参数")
    ("Commit limiting" . "提交筛选")
    ("Commit ordering" . "提交排序")

    ;; ---- magit-dispatch 条目 ----
    ("Apply" . "应用")
    ("Apply here" . "应用到此")
    ("Apply elsewhere" . "应用到别处")
    ("Apply patches" . "应用补丁")
    ("Format patches" . "格式化补丁")
    ("Branch" . "分支")
    ("Bisect" . "二分查找")
    ("Commit" . "提交")
    ("Clone" . "克隆")
    ("Diff" . "差异")
    ("Diff (change)" . "差异（修改）")
    ("Ediff" . "Ediff")
    ("Ediff (dwim)" . "Ediff（智能）")
    ("Fetch" . "获取")
    ("Pull" . "拉取")
    ("Push" . "推送")
    ("Help" . "帮助")
    ("Section info" . "段落信息")
    ("Ignore" . "忽略")
    ("Init" . "初始化")
    ("Jump to section" . "跳转到段落")
    ("Display status" . "显示状态")
    ("Display buffer" . "显示缓冲区")
    ("Log" . "日志")
    ("Log (change)" . "日志（修改）")
    ("Merge" . "合并")
    ("Remote" . "远程")
    ("Submodule" . "子模块")
    ("Subtree" . "子树")
    ("Command" . "命令")
    ("Rebase" . "变基")
    ("Tag" . "标签")
    ("Note" . "备注")
    ("Revert" . "还原")
    ("Reset" . "重置")
    ("Show Refs" . "显示引用")
    ("Cherries" . "拣选")
    ("Stash" . "储藏")
    ("Worktree" . "工作树")
    ("Run" . "运行")
    ("Stage" . "暂存")
    ("Unstage" . "取消暂存")
    ("Stage all" . "全部暂存")
    ("Unstage all" . "全部取消暂存")
    ("Discard" . "丢弃")
    ("Reverse" . "反转")
    ("Refresh current buffer" . "刷新当前缓冲区")
    ("Bury current buffer" . "关闭当前缓冲区")
    ("Toggle section at point" . "切换当前段落")
    ("Visit thing at point" . "访问光标处对象")
    ("Show all key bindings" . "显示全部键位")
    ("Show Info manual" . "打开 Info 手册")

    ;; ---- 提交/分支/储藏等菜单 ----
    ("Commit message" . "提交信息")
    ("Amend" . "修订")
    ("Extend" . "扩展")
    ("Reword" . "改写")
    ("Squash" . "压缩")
    ("Absorb" . "吸收")
    ("Continue" . "继续")
    ("Abort" . "中止")
    ("Skip" . "跳过")
    ("Checkout" . "检出")
    ("Create new branch" . "新建分支")
    ("Delete" . "删除")
    ("Rename" . "重命名")
    ("Remove" . "移除")
    ("Create" . "创建")
    ("Configure" . "配置")
    ("Merged" . "已合并")
    ("Untrack" . "取消跟踪")
    ("Edit" . "编辑")
    ("Dwim" . "智能")
    ("Blame echo" . "Blame 回显")
    ("Imenu" . "Imenu")
    ("Add" . "添加")
    ("Dry run" . "试运行")
    ("Force" . "强制")
    ("Force-with-lease" . "带租约强制")
    ("Autostash" . "自动储藏")
    ("Fast-forward only" . "仅快进")
    ("Fall back on 3way merge" . "回退到三方合并")
    ("Commit merge" . "提交合并")
    ("Abort merge" . "中止合并")
    ("Show commit" . "显示提交")
    ("Show stash" . "显示储藏")
    ("Show graph" . "显示图")
    ("Show graph in color" . "彩色显示图")
    ("Show refnames" . "显示引用名")
    ("Goto status" . "跳到状态")
    ("Goto magit" . "跳到 Magit")
    ("Also save untracked files" . "同时保存未跟踪的文件")
    ("Also save untracked and ignored files" . "同时保存未跟踪和忽略的文件")
    ("Use current time as author date" . "用当前时间作为作者时间")
    ("Use author date as committer date" . "用作者时间作为提交时间")
    ("Disable hooks" . "禁用钩子")
    ("Update default branch" . "更新默认分支")
    ("Increase verbosity" . "提高详细度")
    ("Assume unchanged" . "假定未修改")
    ("Stash changes" . "储藏改动")
    ("Apply stash" . "应用储藏")
    ("Pop stash" . "弹出储藏")
    ("Drop stash" . "删除储藏")
    ("Create tag" . "创建标签")
    ("Delete tag" . "删除标签")
    ("Create branch" . "创建分支")
    ("Delete branch" . "删除分支")
    ("Interactive rebase" . "交互式变基")
    ("Rebase onto" . "变基到")
    ("Preset" . "预设")
    ("Branch..." . "分支...")
    ("Cherries..." . "拣选...")
    ("Clone..." . "克隆...")
    ("Commit..." . "提交...")
    ("Diff..." . "差异...")
    ("Ediff..." . "Ediff...")
    ("Fetch..." . "获取...")
    ("Ignore..." . "忽略...")
    ("Init..." . "初始化...")
    ("Log..." . "日志...")
    ("Merge..." . "合并...")
    ("Pull..." . "拉取...")
    ("Push..." . "推送...")
    ("Rebase..." . "变基...")
    ("Remote..." . "远程...")
    ("Stash..." . "储藏...")
    ("Tag..." . "标签...")
    ("References..." . "引用..."))
  "英文到中文的对照表，可自由增删。
键必须与 Magit 里出现的英文原文完全一致；未收录的保持英文。"
  :type '(alist :key-type string :value-type string)
  :group 'magit-hanzi
  :set (lambda (sym val)
         (set-default sym val)
         (when (bound-and-true-p magit-hanzi--enabled)
           (magit-hanzi--rebuild))))

(defconst magit-hanzi--status-words
  '(("modified"  . "已修改")
    ("new file"  . "新文件")
    ("deleted"   . "已删除")
    ("renamed"   . "已重命名")
    ("copied"    . "已复制")
    ("typechange" . "类型变更")
    ("unmerged"  . "未合并"))
  "状态缓冲区文件行的状态词；与文件名同行，做前缀翻译。")

(defconst magit-hanzi--header-labels
  '(("Tags:" . "标签:")
    ("Tag:" . "标签:")
    ("Head:" . "头部:")
    ("Merge:" . "合并:")
    ("Rebase:" . "变基:")
    ("Push:" . "推送:")
    ("Upstream:" . "上游:"))
  "状态缓冲区头部标签。顺序重要：长者在前，避免 Tags 被 Tag 截断。")

(defvar magit-hanzi--table (make-hash-table :test #'equal))

(defvar magit-hanzi--enabled nil)

(defun magit-hanzi--rebuild ()
  "根据 `magit-hanzi-dictionary' 重建查找表。"
  (setq magit-hanzi--table (make-hash-table :test #'equal))
  (dolist (pair magit-hanzi-dictionary)
    (puthash (car pair) (cdr pair) magit-hanzi--table)))

(defun magit-hanzi--lookup (s)
  (and magit-hanzi--table (gethash s magit-hanzi--table)))

(defun magit-hanzi--translate (s)
  "翻译字符串 S；保留原有文本属性，并保留首尾空白（菜单对齐用）。"
  (when (stringp s)
    (let* ((core (string-trim s))
           (hit (magit-hanzi--lookup core)))
      (if (not hit)
          s
        (let* ((first-non-space (or (string-match-p "[^ \t]" s) 0))
               (lead (substring s 0 first-non-space))
               (tail-pos (string-match-p "[ \t]*\\'" s))
               (trail (substring s tail-pos))
               (out (concat lead hit trail))
               (props (text-properties-at first-non-space s)))
          (if props
              (let ((res (copy-sequence out)))
                (add-text-properties 0 (length res) props res)
                res)
            out))))))

(defun magit-hanzi--translate-heading (s)
  "翻译标题字符串：先整词精确匹配，再尝试文件状态词前缀（modified 等）。"
  (if (and (stringp s)
           (magit-hanzi--lookup (string-trim s)))
      (magit-hanzi--translate s)
    (let ((case-fold-search nil)
          (res s)
          (props (and (stringp s) (text-properties-at 0 s))))
      (dolist (pair magit-hanzi--status-words)
        (when (and (stringp s)
                   (string-match (concat "\\`" (regexp-quote (car pair))
                                         "[ \t]")
                                 s))
          (setq res (concat (cdr pair)
                            (substring s (length (car pair)))))
          (when props
            (add-text-properties 0 (length res) props res))))
      res)))

(defun magit-hanzi--maybe-translate (x)
  (if (stringp x) (magit-hanzi--translate x) x))

(defun magit-hanzi--maybe-translate-heading (x)
  (if (stringp x) (magit-hanzi--translate-heading x) x))

(defun magit-hanzi--advice-insert-heading (orig &rest args)
  "翻译 `magit-insert-heading' 的字符串参数。"
  (apply orig (mapcar #'magit-hanzi--maybe-translate-heading args)))

(defun magit-hanzi--relabel-headers (start end)
  "把 START..END 区域内行首的头部标签换成中文。"
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (let ((inhibit-read-only t))
        (dolist (pair magit-hanzi--header-labels)
          (goto-char (point-min))
          (while (re-search-forward (concat "^" (regexp-quote (car pair))) nil t)
            (replace-match (cdr pair) t t)))))))

(defun magit-hanzi--advice-insert-headers (orig &rest args)
  "在 `magit-insert-headers' 插入完成后翻译头部标签。"
  (let ((start (point)))
    (prog1 (apply orig args)
      (when magit-hanzi--enabled
        (magit-hanzi--relabel-headers start (point))))))

;; transient：描述统一从 `transient--get-description' 取，加一个 :around 方法即可
;; 覆盖所有菜单的分组标题与条目描述；布局里的裸字符串走 `transient-format'。
(cl-defmethod transient--get-description :around ((_obj transient-child))
  (let ((desc (cl-call-next-method)))
    (if (and magit-hanzi--enabled (stringp desc))
        (magit-hanzi--translate desc)
      desc)))

(cl-defmethod transient-format :around ((_arg string))
  (let ((s (cl-call-next-method)))
    (if (and magit-hanzi--enabled (stringp s))
        (magit-hanzi--translate s)
      s)))

(defun magit-hanzi--enable ()
  (magit-hanzi--rebuild)
  (advice-add 'magit-insert-heading :around #'magit-hanzi--advice-insert-heading)
  (advice-add 'magit-insert-headers :around #'magit-hanzi--advice-insert-headers))

(defun magit-hanzi--disable ()
  (advice-remove 'magit-insert-heading #'magit-hanzi--advice-insert-heading)
  (advice-remove 'magit-insert-headers #'magit-hanzi--advice-insert-headers))

;;;###autoload
(define-minor-mode magit-hanzi-mode
  "让 Magit 界面显示中文。"
  :global t
  :group 'magit-hanzi
  :lighter nil
  (setq magit-hanzi--enabled magit-hanzi-mode)
  (if magit-hanzi-mode
      (magit-hanzi--enable)
    (magit-hanzi--disable)))

(provide 'magit-hanzi)
;;; magit-hanzi.el ends here
