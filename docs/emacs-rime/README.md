# emacs-rime Notes

## 需求

这套配置希望同时满足下面几点：

1. macOS 原生前端 `Squirrel` 继续使用 `~/Library/Rime`。
2. `emacs-rime` 使用独立的本地用户数据目录，避免和 `Squirrel` 共享 `*.userdb/` 与 `build/` 造成锁冲突。
3. `emacs-rime` 的配置尽量与当前机器上的主 `Squirrel` 配置保持一致。
4. `emacs-rime` 与 `Squirrel` 仍然通过同一个 `sync_dir` 互通词频和用户词典快照。
5. `emacs-rime` 在同步层面应被视为一个独立安装实例，而不是主 `Squirrel` 配置的镜像。

## 当前实现

当前实现位于 [`lisp/init-rime.el`](../../lisp/init-rime.el)。

### 目录职责

- `~/Library/Rime`
  - 作为 `Squirrel` 的主配置目录。
  - 是 Emacs 侧配置同步的来源目录。
- `~/.emacs.d/rime`
  - 作为 `emacs-rime` 的本地用户数据目录。
  - 保存 Emacs 自己的 `build/`、`*.userdb/` 和 `installation.yaml`。

### 同步策略

启动时不会自动同步配置。

启动阶段只会做两件事：

- 确保 Emacs 侧 `installation.yaml` 中的 `installation_id` / `sync_dir` 元数据正确。
- 在 Emacs 连续空闲 10 分钟后，检查一次 `~/Library/Rime` 与 `~/.emacs.d/rime` 的配置差异，并通过 `message` 提醒。

这个提醒在每个 Emacs 会话里只会自动执行一次。
只要当前 Emacs 进程不退出，就不会重复检查，目的是尽量减少打扰。

这个差异检查不会把 Emacs 专用兼容补丁当成“配置漂移”。
实现方式是先在临时目录里复制一份 `~/Library/Rime` 配置，并应用和 Emacs 同步时相同的补丁，再和 `~/.emacs.d/rime` 做对比。

真正执行配置同步时，`hsk/rime-sync-config` 会把 `~/Library/Rime` 的配置资产同步到 `~/.emacs.d/rime`，但明确排除：

- `installation.yaml`
- `build/`
- `*.userdb/`
- `*.userdb.txt`
- `*.userdb.kct`
- `.DS_Store`

这意味着：

- schema、Lua、词库、OpenCC 配置会跟随 `Squirrel` 对齐。
- Emacs 自己的部署产物和词频数据库不会被覆盖。
- Emacs 这边仍然是一个独立设备实例。

### installation_id 与 sync_dir

- `Squirrel`: 保留主安装实例已有的 `installation_id`
- `emacs-rime`: 在主安装实例的 `installation_id` 后追加 `-emacs`；如果主安装实例没有该值，则回退为 `emacs-rime`
- 两者共用同一个 `sync_dir`

这样 Rime 会把它们当成两个安装实例处理，词频通过同步目录互通，但本地用户数据不会直接共用。

### Emacs 侧兼容补丁

同步到 `~/.emacs.d/rime` 后，还会对少量文件做 Emacs 专用补丁：

- `lua/search.lua`
- `lua/cn_en_spacer.lua`
- `lua/en_spacer.lua`
- `rime.lua`
- `rime_ice.schema.yaml`

这些补丁的目的主要是兼容 `emacs-rime` 使用的 Lua / librime 运行环境，不回写到 `~/Library/Rime`。

### 退出阶段的 workaround

当前还额外加了一个退出阶段的 workaround：

- 如果本次 Emacs 会话里实际加载过 `rime`，则在 `kill-emacs-hook` 里主动调用一次 `rime-lib-finalize`
- 这样可以把 librime 的清理提前到 Emacs 仍然处于正常 Lisp 生命周期的阶段
- 目的是规避部分平台上已知的“Emacs 退出时，librime 在析构阶段崩溃”问题

这个 workaround 只影响 Emacs 退出，不影响平时输入、配置同步和词频同步。

## 手动操作

- 查看当前配置差异：

```elisp
M-x hsk/rime-show-config-diff
```

- 手动刷新 Emacs 侧配置：

```elisp
M-x hsk/rime-sync-config
```

- 兼容旧名字，下面这个命令仍然可用：

```elisp
M-x hsk/rime-bootstrap-user-data
```

## 设计取舍

这套实现不是“两个目录完全独立，不发生任何配置复制”，而是：

- 配置层尽量一致
- 运行时数据层独立
- 词频同步层共享
- 配置同步由用户显式触发，启动时只提醒差异

这样比“完全共享 `~/Library/Rime`”更稳，也比“完全独立且不复制配置”更省维护。
