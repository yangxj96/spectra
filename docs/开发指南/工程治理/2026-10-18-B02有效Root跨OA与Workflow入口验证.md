# B02 有效 Root 跨 OA 与 Workflow 入口验证

## 场景与调用方

本项补 `DIAG-CORE-019` / `CHECK-CORE-019` 与 `IMP-CORE-001` 的间接业务入口证据。CodeGraph 与当前源码核对了 Core 有效 Root、认证会话和权限快照，以及 OA `ContactController.page`、Workflow `ProcessDefinitionController.definitions` 的 `hasPermission` 调用链。两个入口分别读取 Core 组织目录和 Flowable 流程定义，不需要创建真实业务记录；本次未改生产协议或模块实现。

在两个独立应用 JVM 共用专用 PostgreSQL 与安全 Redis 的正式 HTTP 测试中，创建两个随机合成 `ROLE_DEV_OPS` 用户。目标用户从第二进程登录，Access 在两个进程访问 `/api/oa/contact/page?pageNum=1&pageSize=5` 和 `/api/workflow/process-definitions` 均为 200。将目标的角色授权有效期设为数据库当前时间之后约 5 秒，等待真实时间到期且有效 Root 人数从 2 降至 1；目标 Access 的 Core 上下文仍可读取，但上述 OA/Workflow 入口在两个进程均变为 403。另一名有效 Root 访问两个入口仍为 200，且最后 Root 停用保持 409。

恢复目标角色有效期，再让其密码凭据自然到期；有效 Root 人数再次从 2 降至 1。目标旧 Access 的 Core、OA 和 Workflow 请求在两个进程均为 401，旧 Refresh 在第二进程为 401；有效 Root 的 OA/Workflow 读取仍为 200。测试仅验证这两个间接读取入口及共享认证/权限边界，不推定 OA/Workflow 的所有写入、受众、任务或流程事务已验收。

## 实际验证

环境：原生 Windows PowerShell、`spectra-admin/`、`mise -E test exec -- .\mvnw.cmd`、JDK 25、正式 Flyway schema、专用 `devops00_spectra_db_test` 与 Redis DB 5。合成用户和会话由测试夹具清理；未读取或输出本机凭据。日志与退出码在根目录 `.temp/b02/`，不进入 Git。

| 命令与场景 | 结果 |
|---|---|
| `-pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=CoreTwoProcessHttpTest#naturalRootAssignmentAndCredentialExpiryPropagatesAcrossProcesses' '-Dsurefire.failIfNoSpecifiedTests=false' '-DargLine=-Djava.io.tmpdir=D:\Develop\Workspace\spectra-docs\.temp\b02\junit-tmp' '-Dspectra.test.real-deps=true' test` | 首轮与最终源码定点均退出 0，分别 1/1；最终源码在 OA/Workflow 两入口、两个进程、三个状态逐一断言，日志 `root-oa-workflow-indirect-focused.log` 与 `root-oa-workflow-indirect-focused-final.log`。 |
| 同一命令选择 `'-Dtest=CoreTwoProcessHttpTest'` | 退出 0，双进程整组 8/8；日志 `root-oa-workflow-indirect-suite.log` 与 `.exit`。 |
| `'-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-DargLine=-Djava.io.tmpdir=D:\Develop\Workspace\spectra-docs\.temp\b02\junit-tmp' clean verify` | 首轮退出 1：Launch Spotless 指出新增辅助方法签名需换行；修正后完整复跑退出 0，八模块发现 481 项、跳过真实依赖等 136 项、执行 345 项，Spotless、Checkstyle、PMD、SpotBugs、Enforcer 通过。首次与复跑日志分别为 `root-oa-workflow-indirect-unit-static-gate.log` 和 `root-oa-workflow-indirect-unit-static-gate-retry.log`，退出码见同名 `.exit`。 |

## 验收边界

本项覆盖两个具体业务读取入口的共享身份与授权传播，使用合成 Root、空业务数据和真实时间自然到期。OA/Workflow 的数据范围、真实业务记录、流程任务写入、通知投递、后台身份，以及 Redis 撤销与数据库提交之间的非原子窗口仍需各自验证。`CHECK-CORE-019` 和 B02 保持部分执行与进行中。
