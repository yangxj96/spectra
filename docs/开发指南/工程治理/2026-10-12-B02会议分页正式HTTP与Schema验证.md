# B02 会议分页正式 HTTP 与 Schema 验证

## 单项范围

本单项接续 BC-BASE-008 的会议分页 Service/MVC 专项。CodeGraph 和当前源码确认 `MeetingController.page` → `MeetingServiceImpl.page` → `MeetingMapper.selectPage`，Web `MeetingApi.page` 及 OA 会议列表仍使用该入口；没有修改 API 1.0.0 协议或 Web 调用方。新增完整 Spring Boot HTTP 测试，覆盖正式过滤器、Redis Session、方法授权、数据范围、分页 SQL、响应包装和 Flyway schema。Core 身份加载与授权快照使用只在此测试启用的合成提供者，因此该证据不证明正式 Core 用户/角色数据库装配。

专用 `devops00_spectra_db_test` 原有 OA 表却无 Flyway history。按用户已授权的专用测试库重建，先确认无其他数据库连接，再执行 `DROP DATABASE IF EXISTS` / `CREATE DATABASE`；正式应用从空库运行 V1–V8，未使用 baseline、repair 或修改已发布迁移。测试先严格核对 `DB_URL` 库名和 Redis DB 5，再启动应用；随机 UUID 合成会议、参与人，测试后按 ID 删除，Redis Session 在 `finally` 撤销。未读取或输出本机凭据，未触碰真实业务数据。

完整 HTTP 场景覆盖无令牌 401、同一有效令牌的参与人会议总数和记录、无关会议不可见、快照范围清空后总数 0、移除权限后 403、恶意排序 400、权限恢复后 200、撤销 Redis Session 后 401。测试在实际 Spring Boot Servlet 安全链、审计 Advice、数据范围拦截器和 Flyway V1–V8 表结构上执行；认证主体和授权快照是合成夹具。

完整应用测试初次启动发现 `RegionImportTestApplication`（人工行政区划导入专用配置）被模块扫描意外纳入，产生两个 `MetaObjectHandler`。为该测试配置添加 `spectra.test.region-import=true` 条件，`RegionServiceTest` 显式启用；完整应用测试不再装配导入夹具。行政区划人工导入测试本轮没有执行，独立导入/重启语义仍属 B01。

## 实际命令与结果

环境：原生 Windows PowerShell、mise `test` 环境、Temurin 25、Maven Wrapper；PostgreSQL `devops00_spectra_db_test`、Redis DB 5。日志保存在 Git 忽略的 `.temp/b02/`，其中可能包含应用初始化时一次性令牌，不纳入台账或提交。

| 命令或检查 | 结果 |
|---|---|
| `mise -E test exec -- java -cp <本机 Maven 缓存 PostgreSQL JDBC jar> ..\\.temp\\b02\\SchemaProbe.java` | exit 0；只读探测确认专用库存在 OA 表而无 Flyway history。 |
| `mise -E test exec -- java -cp <本机 Maven 缓存 PostgreSQL JDBC jar> ..\\.temp\\b02\\RecreateTestDatabase.java` | exit 0；目标库名、维护库及零活动连接检查通过，重建专用库。 |
| `mise -E test exec -- .\\mvnw.cmd -pl spectra-launch -am '-Dspectra.test.groups.exclude=' '-Dtest=OaMeetingFullHttpFlywayTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspectra.test.real-deps=true' test` | 初次编译 exit 1（Spring Boot 4 WebServer 类型包名），修正后应用启动 exit 1（人工导入测试配置污染）；隔离配置后 exit 0，1/1。最终版在再次重建的空库上 exit 0，1/1，Flyway 成功执行 V1–V8，随机端口完整 HTTP 场景通过。 |
| `mise -E test exec -- .\\mvnw.cmd '-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-Dspectra.test.real-deps=true' verify` | exit 1；Core `RootGovernancePostgresTest` 的 18 项最小表夹具在已迁移的正式 schema 上 `TRUNCATE` 被外键拒绝，命令在 Core 停止。两组测试使用同一个固定数据库，但要求不同的初始 schema。 |
| `mise -E test exec -- .\\mvnw.cmd '-Dspectra.test.groups.exclude=' '-Dtest=*Test,!RegionServiceTest,!OaMeetingFullHttpFlywayTest' '-Dsurefire.failIfNoSpecifiedTests=false' '-Dspotless.ratchetFrom=origin/master' '-Dspectra.test.real-deps=true' verify` | 重建专用空库后 315 项选定测试全部通过，包括 Root 18/18；首次 exit 1，仅因 `RegionServiceTest` 新注解的 Spotless 单行格式。修正后第二次 exit 0，八模块 315/315，Spotless、Checkstyle、PMD、SpotBugs、Enforcer 全通过。 |
| `mise -E test exec -- .\\mvnw.cmd -pl spectra-launch '-Dspotless.ratchetFrom=NONE' '-DspotlessFiles=.*OaMeetingFullHttpFlywayTest\\.java' com.diffplug.spotless:spotless-maven-plugin:3.9.0:check` | 新增测试的格式检查两次 exit 1，按格式调整后 exit 0。 |
| `mise -E test exec -- java -cp <本机 Maven 缓存 PostgreSQL JDBC jar> ..\\.temp\\b02\\PostRunProbe.java` | exit 0；迁移成功记录 8 条，合成会议剩余 0 条。该探针仅查询专用测试库。 |

## 验证边界

本次关闭会议分页的正式 Flyway schema 与完整应用 HTTP 安全链缺口；Core 用户/角色数据库装配被合成身份夹具替代，其他分页业务入口、采购详情与资产入库 Service、浏览器、双应用进程及 Redis 停启恢复未执行。固定 PostgreSQL 测试库中的 Root 最小表夹具与正式 Flyway schema 需重建数据库后分段执行，不能将两段结果描述为一次不间断的全量测试。`RegionServiceTest` 仍显式排除。BC-BASE-008 整体及 B02 保持未验收，不由这项会议分页证据推定整个治理周期 accepted。
