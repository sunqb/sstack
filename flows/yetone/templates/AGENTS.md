# Notes for coding agents

改代码、准备 PR 或做审查之前，按下面的顺序打开对应文档。本文件只做路由，不堆规则正文。

## 设计

改已经有文档的子系统之前，先读 [docs/subsystems/README.md](docs/subsystems/README.md) 和对应页面，并核对该页链接的源码。产品与审美上已拍板的决定在 [docs/design.md](docs/design.md)。不要在 PR 里推翻这些决定。

## 硬规则

写代码和审查时对照 [docs/code-standards.md](docs/code-standards.md)。那里是从错题本升格而来、审查要逐条看的规则。

## 错题本

**改代码之前先读 [LESSONS.md](LESSONS.md)**：最近合并的工作出过错的地方，以及当时本可以拦住它的规则。新的教训按该文件文首的格式追加；同一条规则在 3 个或更多个不同日期被看到，再搬进 code-standards。

## 社区 PR

审查社区 PR 之前，读 [docs/contributors.md](docs/contributors.md)：什么情况先停审、什么情况可以不审就关、作者屏蔽如何提议。agent 只提议屏蔽并附证据，维护者决定。

## 怎么验证

- 在出问题的真实环境里复现，再动手修。
- 跑 `bash scripts/verify.sh`。没跑的检查要在提交说明里写成「未跑」，不要省略。
- 提交说明（尤其是较大的改动）写清实际执行了什么、手工试过什么、哪些没有试。
- 未经真实运行验证，不要对用户声称可用。
