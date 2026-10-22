# B02 Workflow 任务 Service 授权边界验证

## 范围与调用方

本项处理 `DIAG-CORE-034`、`IMP-CORE-007`、`CHECK-CORE-034` 在 Workflow 任务 Service 的直接调用边界。CodeGraph 与当前源码确认：`TaskController` 将当前用户名传给 `TaskService` 的待办、已办、完成、驳回、转办和委派；OA 工作台用同一端口读取当前用户待办计数，OA 申请详情用 `canAccessProcess` 判断当前用户是否参与流程。Web 的 Workflow API 与 OA 审批中心继续使用原有 `1.0.0` HTTP 路径和请求体，无需协议修改。

原实现仅用传入的 `operator` 查询 Flowable 办理人，直接调用 Service 时可伪造该参数；待办和已办也直接信任传入的 `assignee`。现在 Service 在访问 Flowable 前校验传入用户名与当前认证主体 ID、用户名一致；四个写操作还按当前用户 ID 读取有效授权快照并要求 `workflow:task:update`。无身份、参数冒用、缺权限或快照读取失败均在任务查询与写入前拒绝。`canAccessProcess` 对不匹配身份返回 `false`，保留 OA 详情的布尔调用契约；OA 工作台按当前本人统计待办，保持既有权限组合。

## 实际验证

环境：原生 Windows PowerShell、mise `test`、JDK 25、仓库 Maven Wrapper；真实依赖使用专用 PostgreSQL `devops00_spectra_db_test`、Redis DB 5 和随机合成用户、角色指派、BPMN。未使用真实业务数据。

| 命令或场景 | 结果 |
|---|---|
| `mise -E test exec -- .\mvnw.cmd -pl spectra-modules/spectra-workflow -am '-Dtest=TaskServiceAuthorizationTest' '-Dsurefire.failIfNoSpecifiedTests=false' test` | 退出 1，Workflow 模块未声明 JUnit/Mockito 测试依赖，测试编译失败；单测移至 Launch。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dtest=TaskServiceAuthorizationTest,WorkflowInstanceNotificationFullAppTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' test` | 退出 1，Workflow 模块的 Surefire `groups` 属性要求测试引擎；后续显式清空排除组。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=TaskServiceAuthorizationTest,WorkflowInstanceNotificationFullAppTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' test` | 退出 1，增量产物 `PageFrom` class 文件损坏，JUnit 在测试发现阶段停止；后续使用 `clean test`。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=TaskServiceAuthorizationTest,WorkflowInstanceNotificationFullAppTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' clean test` | 退出 0，7/7：6 个 Service 单测覆盖无身份、冒用、缺权限、未知快照、读取故障、本人读取和授权转办；1 个真实 Flowable 测试覆盖实际结果/待办通知、错误办理人、重放、角色自然到期后拒绝和双线程竞争。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=TaskServiceAuthorizationTest,WorkflowInstanceNotificationFullAppTest,PaginationCallerBoundaryTest,FixedPaginationCallerTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' clean test` | 退出 0，63/63：分页边界 54、固定排序 2、Service 授权 6、真实流程 1。 |
| `mise -E test exec -- .\mvnw.cmd -pl spectra-modules/spectra-workflow,spectra-launch '-Dspotless.ratchetFrom=origin/master' spotless:check` | 初轮格式退出 1；按规则修正后退出 0。 |
| `mise -E test exec -- .\mvnw.cmd '-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-DargLine=-Djava.io.tmpdir=D:\Develop\Workspace\spectra-docs\.temp\b02\junit-tmp' clean verify` | 首轮退出 1：既有分页边界 2 项因身份检查先于非法排序拒绝而失败；修正后重跑退出 0，八模块成功，发现 500 项、跳过真实依赖等 142 项、执行 358 项；Spotless、Checkstyle、PMD、SpotBugs 均通过。 |
| `pwsh -NoProfile -File scripts/check-governance-exceptions.ps1 -RootPath . -LedgerPath docs/开发指南/工程治理/ledger.json -SourceRoot spectra-admin -SuppressionFile spectra-admin/config/spotbugs/exclude.xml` | 退出 0，核对 100 个例外、扫描 1744 个文件。 |

初轮将单测放在尚无 JUnit/Mockito 依赖的 Workflow 模块导致测试编译失败；移至已有测试基础设施的 Launch 模块。随后增量构建出现损坏的 `PageFrom` class 文件，改用 `clean test` 后进入断言；合成 `ROLE_ADMIN_SYSTEM` 未配置指派权限边界导致预期的任务所有权断言先被权限门拒绝，改为测试库登记的合成 Root 指派后定点 7/7。首次八模块门禁的既有分页边界测试 2 项失败：新身份检查先于纯排序输入拒绝，已调整为排序输入先检查、身份仍在 Flowable 查询前检查。原始输出及退出码见 `.temp/b02/core034-workflow-auth-*.log/.exit`；这些中间失败不计为通过证据。

## 验证边界

已验证单应用 JVM 内 Service 直接调用和真实 PostgreSQL/Redis/Flowable；角色在两次调用间自然到期后拒绝。尚未运行 HTTP 任务动作的完整权限矩阵、角色变更与动作同时竞争、两个应用 JVM 的任务竞争、OA 业务回调、故障恢复及外部通知供应商。待办和已办按当前主体限制为本人；OA 工作台的本人计数仍按其 `oa:workbench:read` 入口授权，不在本项增加独立 `workflow:task:read` 要求。`CHECK-CORE-034` 保持 `partially_executed`，B02 保持 `in_progress`。
