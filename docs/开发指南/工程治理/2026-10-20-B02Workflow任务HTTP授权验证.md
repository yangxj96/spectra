# B02 Workflow 任务 HTTP 授权验证

## 范围

本项沿 `DIAG-CORE-034`、`IMP-CORE-007`、`CHECK-CORE-034` 继续核对 Workflow 任务 HTTP 入口。CodeGraph 确认 `TaskController` 将待办、已办及四个写动作交给 `TaskService`，OA 工作台与申请详情分别经任务 Service 计数和流程可见性间接调用。Web 沿用 API `1.0.0` 的任务端点，不涉及协议修改。本项只新增真实 HTTP 测试，复用已实施的 Service 当前主体与活授权边界。

## 场景与实际命令

环境：原生 Windows PowerShell、`mise -E test`、JDK 25、仓库 Maven Wrapper；隔离 PostgreSQL `devops00_spectra_db_test`、Redis DB 5，随机合成用户与 Flowable 单任务流程。未使用真实业务数据。

`WorkflowAuditRedactionHttpTest.taskHttpActionsRequireLivePermissionAndOwnedAssignee` 从正式登录取得令牌：本人待办和已办可读；匿名请求完成、驳回、转办、委派均以 401/403 拒绝且任务未变；角色指派自然到期后旧令牌的四个写动作及待办均以 401/403 拒绝且任务未变；恢复授权后同一令牌完成任务成功，任务消失。原审计脱敏测试保持通过。

后续单项 `rejectTransferAndDelegateSucceedForCurrentAssignee` 复用同一专用依赖，为本人和目标人创建合成用户、部署单任务流程，并启动三个独立实例：转办 HTTP 200 且 Flowable 办理人变为目标用户名；委派 HTTP 200 且办理人变为目标、委派状态为 `PENDING`；驳回 HTTP 200 且任务及流程实例结束。三个实例分别清理，未使用业务数据。

| 命令 | 结果 |
|---|---|
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=WorkflowAuditRedactionHttpTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' clean test` | 退出 0，2/2；真实 HTTP、PostgreSQL、Redis、Flowable。 |
| 同一选择参数的 `test` 重跑 | 将拒绝断言收紧至 401/403 后退出 0，2/2。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch '-Dspotless.ratchetFrom=origin/master' spotless:check` | 初轮退出 1，新增测试格式修正；最终门禁重新检查。 |
| `mise -E test exec -- .\mvnw.cmd '-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-DargLine=-Djava.io.tmpdir=D:\Develop\Workspace\spectra-docs\.temp\b02\junit-tmp' clean verify` | 退出 0，八模块成功；发现 501 项、跳过真实依赖等 143 项、执行 358 项；Spotless、Checkstyle、PMD、SpotBugs 通过。 |
| `pwsh -NoProfile -File scripts/check-governance-exceptions.ps1 -RootPath . -LedgerPath docs/开发指南/工程治理/ledger.json -SourceRoot spectra-admin -SuppressionFile spectra-admin/config/spotbugs/exclude.xml` | 退出 0，核对 100 个例外、扫描 1744 个文件。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=WorkflowAuditRedactionHttpTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' test` | 后续单项定点退出 0，3/3；覆盖驳回、转办、委派成功状态。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch '-Dspotless.ratchetFrom=origin/master' spotless:check` | 后续单项初轮退出 1，新增测试格式差异已修正；完整门禁重新检查。 |
| `mise -E test exec -- .\mvnw.cmd '-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-DargLine=-Djava.io.tmpdir=D:\Develop\Workspace\spectra-docs\.temp\b02\junit-tmp' clean verify` | 后续单项退出 0，八模块成功；发现 502 项、跳过真实依赖等 144 项、执行 358 项；Spotless、Checkstyle、PMD、SpotBugs 通过。 |

## 边界

这是单应用 JVM 的正式 HTTP 场景。完成、驳回、转办和委派的成功路径均已覆盖；角色变化与动作同时竞争、两应用 JVM 竞争、OA 回调、故障恢复和外部通知供应商仍未验证。`CHECK-CORE-034` 保持 `partially_executed`，B02 保持 `in_progress`。
