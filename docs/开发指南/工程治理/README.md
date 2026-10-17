# 工程治理台账

ledger.json（源码仓库的 `docs/开发指南/工程治理/ledger.json`） 是 [[开发指南/05-集中治理与验收|集中治理与验收]] 的结构化状态入口，按 [[开发指南/04-工作区工程标准|工作区工程标准]] 维护文件覆盖、问题、跨项目影响、复杂度例外、验证证据和检查链路工作。

该目录是正式知识库，可以随项目维护；与仅保留本地讨论记录的 `docs/superpowers/` 不同。原始工具输出、浏览器产物和临时调试文件放根 `.temp/`，不在此堆积。

## 当前状态

2026-10-12 的 [[开发指南/工程治理/2026-10-12-B02有效Root正式HTTP验证|CORE-019 正式 HTTP 专项]]已用正式 Core 用户停用及 Web 所用用户编辑撤销角色入口、PostgreSQL 行锁与 Redis Session 验证最后 Root 409、并发下限竞争和成功撤销旧 Access。2026-10-13 的 [[开发指南/工程治理/2026-10-13-B02有效Root基础角色撤权副作用验证|基础角色撤权副作用专项]]修复缺失 `ROLE_USER` 时拒绝最后 Root 撤权仍提前撤销 Session 的调用顺序；[[开发指南/工程治理/2026-10-13-B02身份解绑有效Root与会话验证|身份解绑专项]]又覆盖 EMAIL/SMS 登录身份、最后 Root 409、普通用户并发解绑、旧 Access 失效和 Web 成功后重新登录。[[开发指南/工程治理/2026-10-11-B02角色权限快照一致性验证|CORE-032 专项]]此前用正式 HTTP 登录、角色缩权和重新登录核对权限快照。凭据、策略及初始化入口已补充单进程正式 HTTP 和竞争验证；双进程自然失效、Refresh 轮换及会话策略收紧已有合成身份专项。Root/角色自然失效、角色变更跨进程、实际 Redis 停启恢复和 B08 浏览器路径仍未验证；Web 全库格式门禁仍有 7 个既有文件失败，B02 保持 `in_progress`。

第一步于 2026-10-03 建立文件枚举基线；第二步于 2026-10-04 开始，2026-10-05 补齐当前源码诊断、历史证据复核与公共影响记录。当前 coverage 实际登记 2061 个文件：1599 个 included/shared_impact、438 个暂缓业务文件、24 个排除文件；另有 22 个排除目录。2026-10-08/16 新增的专项文件和变动摘要已局部登记；未重新完成整个工作区的文件枚举或全部陈旧摘要复核。

第二步的完成记录见 `diagnosis`、issues、impacts 及 evidence；第三步的依赖排序见 `remediation_cycle`。GOV-001 仅关闭清单、诊断与风险建账职责，GOV-005 的分析已完成而统一实现仍为 `in_progress`。全局状态为 `unification_in_progress`，**诊断和排期完成不代表问题解决、行为通过或集中治理已验收。** B00 已完成；B02 仍在推进，分页排序、[[开发指南/工程治理/2026-10-11-B02审计脱敏验证|BASE-001 审计脱敏]]、[[开发指南/工程治理/2026-10-09-B02会话撤销生命周期验证|BASE-003 会话撤销]]、[[开发指南/工程治理/2026-10-09-B02重放围栏并发验证|BASE-004 重放围栏]]、[[开发指南/工程治理/2026-10-10-B02会话期限与活动时间验证|BASE-005 会话期限]]、[[开发指南/工程治理/2026-10-10-B02会话并发配额验证|BASE-006 并发配额]]、[[开发指南/工程治理/2026-10-09-B02安全集合事实源验证|BASE-007 集合事实源]]、[[开发指南/工程治理/2026-10-09-B02安全计数TTL验证|BASE-018 安全计数]]、[[开发指南/工程治理/2026-10-09-B02后台通知身份验证|CORE-034 后台通知身份]]、[[开发指南/工程治理/2026-10-10-B02通知请求快照与静态门禁验证|Common 通知请求快照]]及 [[开发指南/工程治理/2026-10-10-B02有效Root保护验证|CORE-019 有效 Root]]各有专项证据。[[开发指南/工程治理/2026-10-10-集中治理后端测试环境迁移验证|后端 test 环境]]是整个周期的真实依赖入口；旧 PostgreSQL B02 库/Redis DB 12/14 证据只作历史记录。现行入口使用 `devops00_spectra_db_test` 与 Redis DB 5。BASE-001 的合成审计 JSONB、事务、日志与错误响应专项通过。[[开发指南/工程治理/2026-10-11-B02后端静态门禁收口|后端静态门禁收口]]修复 Core 的未使用导入、无用变量和可变请求容器暴露，固定装配签名与 Spring 协作者按精确例外登记；使用 test 环境和显式测试选择的八模块 `verify` 退出 0，267 项测试通过，Checkstyle/PMD/SpotBugs 均通过。`RegionServiceTest` 未运行，OA/Workflow 编译和静态检查通过但没有测试用例。真实 HTTP/正式审计表、双应用进程、实际 Redis 停启恢复、旧格式 Session 上线处置和后台流程入口未验收。B01 与 B03–B10 继续按台账推进；协议生成、其余安全事实源与整体验收仍待实施。

GOV-007 已完成后端/Web Skill 的入口、受影响示例、修改前后场景和本地插件缓存对齐，验证摘要登记为 EV-SKILL-20261003。该证据只证明明确列出的 Skill 范围；当前会话仍需区分既有 Skill 目录快照与新安装版本，后续新会话加载状态另行核对。B00 的 GOV-002 已完成固定版本边界校准与阈值配置，证据为 EV-B00-CALIBRATION-20261005；后端 PMD 剩余 14 条已逐项核对并确认属于 Spring/框架固定签名或依赖注入构造器，不属于业务自有代码，见 EV-B00-LEGACY-20261005。GOV-002 已标记为 `resolved`；这些固定签名保留为明确记录的非业务约束。GOV-003 的自动核对器、回归测试和全部现存抑制例外登记已完成，校验器通过，见 EV-B00-EXCEPTION-20261005。Spotless、工作区级 SpotBugs、静态模块依赖方向检查、后端真实依赖测试和真实浏览器交互均有通过证据；正式架构门禁入口仍缺失，已在 EV-B00-TOOLING-20261005 中保留记录。其他待办及全量代码治理不能由此推定完成。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02登录失败身份桶验证|CORE-020 身份桶专项]]复核并修复运维清理的输入限制：登录、锁定、成功清理及定向清理共用规范化摘要。测试 Redis DB 5 的双连接并发和失败拒绝专项通过；更新后八模块 `verify` 退出 0，显式选择 271 项测试通过。实际 HTTP、两个应用进程和真实 Redis 停启仍未运行，B02 保持进行中。上段 267 项是此前静态门禁收口时的历史结果。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02重放围栏结果校验验证|BASE-004 当前版复核]]修复了 Refresh claim 的 Long 截断误判，以及围栏安装和映射清理对未定义 Lua 结果的接受。异常结果三项测试先失败后通过，隔离 Redis 围栏专项 15/15、后端八模块 `verify` 选定测试 301/301 通过。两个应用进程、实际 Redis 停启恢复和真实 HTTP/数据库链路尚未执行；`BC-BASE-001` 与 B02 仍未验收。

2026-10-12 的 [[开发指南/工程治理/2026-10-12-B02双进程HTTP会话撤销验证|BC-BASE-002 双进程 HTTP 撤销]]在两个独立应用 JVM 和共享 Redis DB 5 上通过 1/1 专项：正式 HTTP 登出及 Core 公共按用户撤销后，另一进程拒绝旧 Access，重新签发后恢复。身份和授权快照为合成夹具。首轮八模块真实依赖 `verify` 因 PostgreSQL 停机及增量编译产物错误退出 1；服务恢复后从干净构建重跑 `clean verify` 退出 0，315/315 与全部静态门禁通过。固定测试库的 Root 最小表与正式 Flyway schema 分段验证，完整门禁显式排除两个已单独通过的完整应用 HTTP 专项和既有 `RegionServiceTest`。正式 Core HTTP 登录/角色事务、真实 Redis 停启恢复和 B08 浏览器身份失效仍待验证，`BC-BASE-002` 与 B02 保持未验收。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02有效Root当前版入口验证|CORE-019 当前版复核]]为首次初始化的 Root 激活和授权写入接入事务锁与人数复核，并拒绝未知策略和人数结果。专用 PostgreSQL Root 专项 18/18、仓储单测 2/2、当轮八模块 `verify` 选定测试 307/307 通过。2026-10-12 的 [[开发指南/工程治理/2026-10-12-B02有效Root正式HTTP验证|正式 HTTP 补验]]覆盖用户停用及用户编辑撤销 `ROLE_DEV_OPS` 的 Spring HTTP、正式 Mapper、Root 行锁竞争及 Redis Session 撤销，专项 2/2；身份、凭据、策略及初始化的完整 HTTP、双应用进程与时间自然流逝仍未运行，`CHECK-CORE-019` 与 B02 保持未验收。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02排序范围候选验证|BC-BASE-008 范围候选复核]]修复 Mapper 名称包含 `insert/create/add` 时跳过数据范围，以及关系子查询主表列未带别名的问题。定点测试 10/10、当轮八模块 `verify` 选定测试 311/311 通过。随后 [[开发指南/工程治理/2026-10-11-B02-OA关系范围真实Mapper验证|OA 关系范围真实 Mapper 验证]] 在专用 PostgreSQL 上用合成记录执行会议、采购收货正式 Mapper 的实体查询、会议计数和拒绝路径，专项 2/2、当轮八模块 `verify` 313/313 及全部静态门禁通过。[[开发指南/工程治理/2026-10-11-B02会议分页业务入口验证|会议分页业务入口验证]] 再向上覆盖实际会议 Service 与 Controller 的 MVC 分页，验证记录与计数受参与人范围约束、撤权归零和恶意排序 HTTP 400；专项 2/2 通过。2026-10-12 的 [[开发指南/工程治理/2026-10-12-B02会议分页正式HTTP与Schema验证|会议分页正式 HTTP 与 Schema 验证]] 在重建的专用测试库上由完整应用执行 Flyway V1–V8，并用合成 Core 身份通过真实 Redis Session、过滤器、授权、范围、排序与撤销请求；单项 1/1。固定测试库中的 Root 最小表夹具与正式 Flyway schema 不可共存，完整门禁分段执行并在证据中逐条记录。正式 Core 身份装配、会议以外业务入口、浏览器和双进程仍未验证；BC-BASE-008 整体及 B02 保持未验收。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02角色权限快照一致性验证|CORE-032 角色快照专项]]在角色变更事务中清理缩权后的失效 Assignment Boundary 与孤立 Scope，并对并发 Assignment Apply 加 Role 行共享锁。专用 PostgreSQL 四项成功、失败及竞争测试通过；八模块 `verify` 退出 0，275 项选定测试及全部静态门禁通过。实际 HTTP 重登录、完整角色变更服务与双应用进程联动未运行，行为检查仍为部分执行，B02 保持进行中。

2026-10-11 的 [[开发指南/工程治理/2026-10-11-B02凭证年龄验证|CORE-022 凭证年龄专项]]纠正了台账旧源码结论：当前 Assembler 已校验最长年龄，新增改动让凭证创建、重置和改密使用同一可注入 `Clock`。固定时钟、失败路径及过期提示协作者测试通过；`mise test` 八模块 `verify` 退出 0，280 项选定测试和静态门禁通过。实际 HTTP、凭证写入专用 PostgreSQL 端到端测试及双应用进程重载未运行，行为检查保持部分执行，B02 未验收。

2026-10-14 的 [[开发指南/工程治理/2026-10-14-B02凭据生命周期与并发验证|CORE-019/022 凭据入口专项]]用正式 HTTP、专用 PostgreSQL 和 Redis Session 验证凭据超龄 401、管理员重置、必须改密 403、改密后会话撤销及重新登录；固定 Root 策略行锁重现两个并发请求重复使用旧密码并修复，两个 Root 同时写过期凭据只准一次提交。`RootGovernanceFullHttpTest` 当轮 8/8（6 项 HTTP、2 项直接服务竞争），重建专用库的八模块 `clean verify` 317/317 和静态门禁通过；再次重建后正式 Flyway schema 上整组 8/8 通过。该轮未覆盖双进程自然失效、实际 Redis 停启和策略/初始化正式 HTTP，后者见 2026-10-16 的后续专项；B02 不据此完成。

2026-10-16 的 [[开发指南/工程治理/2026-10-16-B02策略与首次初始化正式HTTP验证|CORE-019 策略与初始化专项]]补齐单进程正式 HTTP：密码策略收紧使最后 Root 失效时 409 且回滚，保留有效 Root 时成功并使旧 Access 401；同版本并发策略请求仅一次成功。首次初始化的无效令牌、并发开始、错误 ID、并发完成及首个 Root 登录已在专用 PostgreSQL/Redis 上通过。测试揭示安全策略版本冲突原响应不为 409，现统一映射为 409，并补会话策略过期版本 HTTP 断言。Root 组 9/9、初始化 1/1；八模块 `clean verify` 317/317 和静态门禁通过。该轮未覆盖双进程、自然失效、Redis 停启、独立 `error_code` 及 B08 浏览器路径；B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02双进程会话自然失效验证|BASE-005 双进程自然失效专项]]在两个独立应用 JVM、专用 PostgreSQL 与 Redis DB 5 上验证：Access Redis Key 自然到期后两端拒绝，第二进程仍可使用有效 Web Refresh 轮换并使首进程接受新 Access；收紧绝对期限后两端拒绝同一 Family，Refresh Key 自然到期后跨进程刷新返回 401。双进程整组 2/2，八模块 `clean verify` 317/317 与静态门禁通过，专用库最后恢复正式 Flyway schema。该用例使用合成身份，真实 Core 角色/凭据自然失效、实际 Redis 停启、浏览器与 OA/Workflow 间接行为仍待验证；B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02两进程重放与配额竞争验证|BC-BASE-001/002 两进程重放、配额与到期后撤销专项]]在 `SessionTwoProcessHttpTest` 增加四个完整应用用例，并新增仅在测试类路径装载的合成签发夹具：跨进程重放旧 Refresh 即撤销整个 Token Family、轮换新 Access 两端拒绝；同一 Refresh 并发消费只成功一次，任意交错下无可用的新 Access；`REJECT_NEW` `max_sessions=1` 时第二进程签发返回 409 且共享 `USER_TOKENS` 仅一个成员；Access 自然到期但 Refresh 仍有效时，按用户与排除令牌撤销在另一进程拒绝刷新。双进程整组 6/6、Spotless 通过。`BC-BASE-001` 的两个子项（两进程重放、多实例配额）已有证据，`BC-BASE-002` 的按用户/排除令牌入口补齐 Access 到期后两进程证据；真实 Redis 停启恢复、按客户端/句柄/改密/踢旧入口、角色变更跨进程与 B02 整体仍保持进行中。

同日的 [[开发指南/工程治理/2026-10-16-B02登录失败身份桶正式HTTP验证|CORE-020 登录失败身份桶专项]]用正式 `/api/security/authentication/login` 补齐：大小写/空白变体错误密码归并到同一 `AuthenticationIdentifierHash.digest` 身份桶、达 `lockoutMaxAttempts` 后正确密码也被锁定拒绝（日志出现「账号已锁定，请稍后再试」）、另一账号成功登录清理同一桶；正式 HTTP 2/2、Spotless 通过。运维/缓存管理端口的身份桶定向清理 HTTP、双独立应用进程与真实 Redis 停启恢复仍未验证；`CHECK-CORE-020` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02改密审计正式HTTP验证|BASE-005 改密审计专项]]用正式 `/api/user/password` 补齐正式审计表证据：改密 200 后按 `X-Correlation-ID` 在 `spectra_core.sys_audit_event` 查到同事务 `#changePassword` `SUCCEEDED` 行，`before_snapshot` 已脱敏为 `***` 且明文旧/新口令不出现在任何审计文本列，旧口令 401、新口令 200；正式 HTTP 1/1、Spotless 通过。OA/Workflow 逐入口与审计写入失败故障仍未验证；`BC-BASE-005` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02绑定验证码预算正式HTTP验证|CORE-023 绑定验证码预算专项]]用正式 `/api/security/identities/email` 补齐：绑定验证码按地址键与用户绑定，预算内正确码绑定成功并落库 EMAIL 身份，错误码达 `verificationCodeMaxAttempts` 后验证码原子失效且随后正确码也被拒（日志「绑定验证码尝试次数过多」），跨地址提交不消耗本地址预算；正式 HTTP 1/1、Spotless 通过。双应用进程、真实 Redis 停启与通知投递联动仍未验证；`CHECK-CORE-023` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02会议以外分页入口正式HTTP验证|BASE-008 会议以外分页入口专项]]用正式 Core 身份补齐 `/api/user/page` 与 `/api/audit/page`：用户分页接受已注册排序字段、拒绝恶意表达式与未注册字段，审计固定排序入口拒绝客户端排序；正式 HTTP 1/1、Spotless 通过。会议以外的其余业务入口与 B08 浏览器路径仍未验证；`BC-BASE-008` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02双进程Core凭据重载验证|CORE-022 双进程凭据重载专项]]新建两进程真实 Core HTTP 套件 `CoreTwoProcessHttpTest`：两个独立 JVM 共享 PostgreSQL/Redis，首进程正式登录的 Access 在第二进程可用，改密后旧 Access 两端 401、旧 Refresh 第二进程 401、新口令第二进程登录 200；并补 Access Redis Key 自然到期后两端 401、仍有效的 Web Refresh 跨进程轮换出新 Access。整组 4/4、Spotless 通过。管理员重置与真实 Redis 停启恢复仍未验证；`CHECK-CORE-022` 保持进行中。该套件是 `CHECK-CORE-019/032`、`BC-BASE-002` 两进程专项的共同前置。

同日的 [[开发指南/工程治理/2026-10-16-B02角色变更两进程联动验证|CORE-032 角色变更两进程联动专项]]在 `RoleAuthorizationFullHttpTest` 内复用夹具与授权变更 token 配置新增两进程用例：目标用户在第二进程登录的 Access 在首进程可用，首进程 impact-preview/apply 缩权后第二进程旧 Access 401、重新登录快照收缩（含 `role:read`、不含 `role:grant`）；整组（单进程并发缩权 + 两进程联动）2/2、Spotless 通过。部门合并重组与 OA/Workflow 受众业务入口仍未验证；`CHECK-CORE-032` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02双进程客户端与踢旧撤销验证|BASE-002 双进程客户端与踢旧撤销专项]]在 `CoreTwoProcessHttpTest` 增加用例：第二进程登录的目标用户在首进程经 `/api/cache/admin/security/session/revoke`（按客户端）、`revoke-all`（按用户）与 `revoke-one`（经 `/api/user/online` 取句柄）撤销后，其 Access 在第二进程 401；Web 策略 `KICK_OLD` 时目标用户在首进程重新登录跨进程踢掉第二进程同端旧会话（旧 401、新 200）；再把 Web `access_ttl` 收紧到 3 秒，验证 Access 自然到期后按客户端撤销使 Refresh 第二进程 401、KICK_OLD 跨进程踢掉同端旧 Refresh。含凭据重载、会话策略收紧与 Access 到期撤销整组 5/5、Spotless 通过。`BC-BASE-002` 的 necessary_acceptance 已具备证据、置为 `passed`；B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02双进程会话策略收紧验证|CORE-019 双进程会话策略收紧专项]]在 `CoreTwoProcessHttpTest` 增加第三个用例：首进程运维用户经 `/api/security/policy/session/{clientId}` 把 Web 会话绝对期限收紧为 1 秒后，第二进程旧 Access 返回 401，证明策略经共享数据库跨进程生效；整组 4/4、Spotless 通过。真实自然时间失效、初始化/策略故障恢复、独立 `error_code` 与 OA/Workflow 间接入口仍未验证；`CHECK-CORE-019` 维持部分执行，B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02隔离Redis停启恢复验证|BASE-003 隔离 Redis 停启恢复专项]]自启隔离 `redis-server` 并以 `--spring.data.redis.url` 指向：停用后受保护请求不再返回 200、登录返回 503（`SecurityRedisUnavailableException`），重启后登录恢复 200；`BC-BASE-003-FAULT-RECOVERY` 通过、`BC-BASE-003` 置为 `passed`，`CHECK-CORE-022` 因双进程自然失效重载与真实故障恢复均已具备而置为 `passed`。旧格式会话上线处置、显式就绪门（`BC-BASE-009` 未实现）与双实例交错故障窗口仍未验证；B02 保持 `in_progress`。

同日的 [[开发指南/工程治理/2026-10-16-B02登录桶与验证码预算双进程验证|CORE-020/023 双进程共享专项]]新建 `CoreSharedStateTwoProcessHttpTest`：两个独立应用 JVM 共享 Redis，首进程与第二进程的登录失败累计到同一身份桶并锁定；绑定验证码跨进程累计尝试并在达上限时原子删除、耗尽后正确码被拒；专项 1/1、Spotless 通过。`CHECK-CORE-023` 的通知投递联动仍未验证、维持部分执行。

同日的 [[开发指南/工程治理/2026-10-16-B02登录失败身份桶正式HTTP验证|CORE-020 运维端口定向清理专项]]在 `LoginFailureBucketFullHttpTest` 增加用例：目标账号锁定后，运维用户经 `/api/cache/admin/security/login-failure/clear` 清理同一身份桶（计数回 0），随后该账号用正确密码登录 200；正式 HTTP 整组 3/3、Spotless 通过。`CHECK-CORE-020` 的 necessary_acceptance 已具备证据、置为 `passed`；B02 保持 `in_progress`。

## 本轮收口

2026-10-16 本轮将 `BC-BASE-001`、`BC-BASE-002`、`BC-BASE-003`、`CHECK-CORE-020`、`CHECK-CORE-022` 置为 `passed`；新增两进程真实 Core HTTP 套件与单进程正式 HTTP 用例（见上列各专项）。重建空白专用测试库后八模块真实依赖 `clean verify` 退出 0：**common 5 + framework 130 + core 119 + launch 63 = 317/317**，Spotless、Checkstyle、PMD、SpotBugs、Enforcer 全部通过（证据 `EV-B02-FULL-GATE-20261016`）。B02 仍为 `in_progress`：剩余为需产品决策或外部依赖的方向——独立 `error_code`、旧格式会话上线处置、显式就绪门、通知投递、部门重组与 OA/Workflow 业务入口、B08 浏览器、启用调度器的通知/Quartz/Workflow。

同日收口 **B01 脚本删除与导入隔离**：`sync-website-docs` 入口固定根 `.venv`、构建经 `mise exec -- pnpm`，旧同步清单删除候选解析为绝对路径并核对受控生成根，越界/博客/非法结构一律 fail-closed；`import-regions` 入口要求 `SPECTRA_REGION_IMPORT_ALLOWED_DATABASES` 并在连接前拒绝，新增 `RegionImportDatabaseGuard` 按实际数据源库名在导入上下文启动时校验。`BEH-IMP-SCRIPTS-001-1..5` 全部 `passed`，`DIAG-SCRIPT-001/002/004` 与 `IMP-SCRIPTS-001` 置为 `resolved`，`BC-BASE-013` 为 `partially_executed`（allow-list 已具备证据，完整 66.5 万行真实导入未执行）。证据 `EV-SCRIPT-B01-20261016`。

同日推进 **B03 必需基础设施与启动运行门**（进行中）：完成基础修复并单元/启动验证——Dockerfile `EXPOSE` 统一 4004、compose PostgreSQL 18 卷改挂 `/var/lib/postgresql`、模块开关严格布尔解析、Flowable schema 更新只跟随 `flowable.database-schema-update`（缺省 false）、启用加解密但密钥未就绪时启动失败、缓存损坏/未知值显式拒绝、上传/S3 配置约束与 S3 条件校验、安全 Redis 启动连通门（不可达启动非零）。`DIAG-BASE-011/014/015/016/017` 与 `DIAG-ADDITIONAL-003` 置 `resolved`，`DIAG-CORE-033` 为 `in_progress`；`BC-BASE-009/014/015`、`BC-ADDITIONAL-003` 部分/通过。另在一次性隔离库上验证 Flyway 空库 V1–V8（8 个）、V7→V8 升级只应用 V8 与重复 validate 通过（`EV-B03-MIGRATION-20261016`）。并新增**运行期就绪门**：数据库或安全 Redis 运行故障时业务请求返回 503、恢复后再服务、进程保留、探测有界退避、后台调度暂停/恢复（`EV-B03-READINESS-20261016`，`ReadinessGateHttpTest` 1/1；后台调度暂停/恢复另有独立断言 `EV-B03-PROBE-20261016`，`DependencyReadinessProbeTest` 3/3；数据库运行故障以真实连接中断验证 `EV-B03-DBOUTAGE-20261016`，`DatabaseOutageReadinessTest` 1/1；恢复前一致性校验（`ReadinessVerifier`/`CryptoKeyConsistencyVerifier`）与健康端点 OUT_OF_SERVICE 反馈（`ReadinessHealthIndicator`）见 `EV-B03-CONSISTENCY-20261016`）。缓存键生成器按长度前缀分界与类型标记修复真实同键（`ab+c` vs `a+bc`、`null` vs `"null"`、`1` vs `"1"`），真实调用验证 7/7，`BC-BASE-015` 置 passed（`EV-B03-KEYGEN-20261016`）。文件流 `Content-Range` 改为按 provider 实际返回字节裁剪（`FileAssetStreamControllerTest` 2/2，`EV-B03-RANGE-20261016`）；非法/越界 Range 已统一 416 且已知总长度附 `Content-Range: bytes */total`，`DIAG-ADDITIONAL-002` 置 resolved（`EV-B03-RANGE416-20261016`，`FileAssetStreamControllerTest`+`FileUploadExceptionAdviceTest` 5/5）。统一错误码已落地：`R.error_code` + `WebErrorCode`，`EntityUpdateException` 与完整性/重复键→409、调度/Redis→503、filter 503 走统一响应，Web 改为读取 `error_code` 并删除 msg 前缀解析（`EV-B03-ERRORCODE-20261016`，`DIAG-BASE-010` resolved）。审计元数据改为注入 `Clock`，启动与 Docker 固定 UTC（`EV-B03-CLOCK-20261016`，`DIAG-BASE-009` resolved）；非法用户/系统时区显式失败（`EV-B03-TIMEZONE-20261016`），String 时间解析收敛为严格 ISO 日期时间、拒绝仅日期/仅时间（`EV-B03-TIMEPARSE-20261016`）。分片确认/写入加入 `upload_attempt` 谓词，旧尝试迟到回调被拒绝（`EV-B03-ATTEMPT-20261016`，DIAG-ADDITIONAL-004 in_progress，S3 存储侧 ETag 校验待实现）。在线用户 VO 与 `TimeMapper` 已增加 `OffsetDateTime` 保留偏移（`EV-B03-OFFSET-20261016`）。用户编辑显式拒绝 `phone/email`（`EV-B03-CONTACT-20261016`，DIAG-ADDITIONAL-001 resolved，专用联系方式变更入口为后续能力）。S3 分片确认改为 ListParts 存储侧大小/ETag 校验，真实预签名上传通过（`EV-B03-S3-20261016`，DIAG-ADDITIONAL-004 resolved）；Docker 实际映射按用户决定不验证，`BC-BASE-014` 标记完成。应用已用无 DDL 运行角色启动并服务，数据范围默认 NONE 与 SELF 已断言（`EV-B03-RUNTIMEROLE-20261016`、`EV-B03-SCOPE-20261016`，BC-BASE-010 完成）。401/403/503 的 body `error_code` 已与状态码对齐（`EV-B03-PROTOCOL-20261016`，BC-BASE-006 部分，409 真实 HTTP 与 OpenAPI 同步待做）。`RuntimeSecret`/`SecurityToken` 诊断输出已脱敏（`EV-B03-REDACT-20261016`，BC-BASE-012 完成）。数据源会话固定 UTC，DST gap/overlap 与 offset 输出已断言（`EV-B03-TIMEPROTO-20261016`，BC-BASE-007 完成）。绝对/空闲 TTL 不被刷新重置、refresh TTL 受绝对剩余约束已单测（`EV-B03-TTL-20261016`，BC-BASE-004 完成）。PMD 复杂度阈值（15/200/5/嵌套4）校准通过，模块反向依赖由边界脚本自测校准，Spotless 热/冷/离线三态退出 0（`EV-B03-GATECAL-20261016`、`EV-B03-BOUNDARY-20261016`、`EV-B03-FORMATTER-20261016`，BC-BASE-011 完成）。409 冲突（重复键/完整性/版本）已对齐 status 与 `error_code`，并将重复角色编码由 500 修为 409 `DATA_EXIST`，真实 MVC HTTP 通过（`EV-B03-CONFLICT-20261016`、`EV-B03-CONFLICT-HTTP-20261016`，BC-BASE-006 部分，OpenAPI 同步待做）。31 个分页入口（用户/在线用户/审计/角色/Quartz 任务与历史/通知收件箱·模板·分组·请求·任务·投递/文件类型·资产·引用·上传/区域/OA 会议·公告·资产·申请·文档·报销·采购·合同·联系人·日历·请假·用品/Workflow 待办与已办）的排序契约已补真实 HTTP（`EV-B03-PAGE-20261016`，BC-BASE-008 完成）。OA 会议创建与 Workflow 任务失败路径均验证审计脱敏，并修复会议/参与人 UUID 类型（`EV-B03-OA-AUDIT-20261016`、`EV-B03-WF-AUDIT-20261016`，BC-BASE-005 完成）。Core/OA/Workflow 全部 VO 时间字段已迁移为 `OffsetDateTime`，无日期 `LocalTime` 显式拒绝（`EV-B03-OFFSET-FULL-20261016`，`DIAG-BASE-008` resolved）；运行角色无 DDL 已由 BC-BASE-010 完成，Docker 实际映射按用户决定不验证。

## 结构与字段

### 第一阶段枚举基线与复核方法

本轮使用原生 PowerShell `Get-ChildItem -LiteralPath <目录> -Force` 逐层枚举文件元数据，包含隐藏文件及被 Git 忽略的手写输入，不按 Git 跟踪状态决定范围；不读取源码、配置凭据或计算内容摘要。记录路径统一相对工作区根且使用 `/`。枚举遇到错误即终止，不静默跳过无权访问的目录，不跟随目录链接。

| 初步范围 | 文件数 | 下一步 |
|---|---:|---|
| included | 1484 | 按职责进行源码、测试、配置、脚本、构建和规则诊断 |
| shared_impact | 30 | 先核对公共导出、宿主、协议和混合迁移职责，再建立影响 |
| deferred_business | 438 | 独立业务治理暂缓；全部保留为公共影响分析候选 |
| excluded | 22 | 逐文件记录生成产物、静态二进制或私有配置排除原因 |

上表为第一阶段历史基线：当时共有 1514 个纳入/公共候选文件待审查，468 个公共/暂缓候选文件待影响分析；两组相互重叠，不能相加作为文件总数。当前数量以 `inventory.scope_counts` 为准，待审查列表筛选 `coverage` 中 `scope` 为 `included` 或 `shared_impact` 且 `state != reviewed`；公共影响待分析列表筛选 `impact_state == pending_analysis`。不另建平行状态表。

范围依据是第一阶段路径及职责候选分类，并非已经分析调用链：后端 OA/Workflow 的 `src/`、Web 对应业务页面/API/类型、插件 elements/features 和流程示例记为 `deferred_business`；模块 POM、启动装配、公共配置、测试入口和规则仍登记。插件公共导出/类型/辅助/宿主面板、Web 流程宿主候选及 Launch 混合数据库迁移记为 `shared_impact`。知识库、本地 Skill 及历史报告作为规则或证据输入纳入；不由历史报告推定当前源码 reviewed。第二阶段按实际定义、调用和职责复核这些初步边界，必要时提升暂缓文件为公共一致性范围。

`inventory.directory_exclusions` 记录实际遇到的排除目录、原因及 `applies_to: all_descendant_files`；该目录下每个文件继承 `excluded/enumerated`，不展开巨大的依赖和生成树。这不是整业务目录排除。排除目录名集合为 `.git`、`node_modules`、`.venv`、`.codegraph`、`.idea`、`.obsidian`、`.temp`、`.playwright-mcp`、`target`、`dist`、`dist-ssr`、`build`、`coverage`、`.cache`、`.mise-data`、`.maven-repository`、`.pnpm-store`、`.npm`、`.yarn`、`logs`、`out`、`test-results`、`playwright-report`、`docker-data`、`docker-volumes`、`.codex-tmp`。新增同名手写目录时必须复核排除合理性，不自动认为其治理已通过。

依赖目录、包缓存、Git 内部数据库、CodeGraph 索引、构建/测试产物和运行临时状态分别排除，原始生成链路、POM、锁文件、构建配置另行纳入。私有 `.mise.local.toml`、`.mise.test.toml`、`.miserc.local.toml`、实际 `.env` 文件、密钥/密钥库及可能含凭据的本机配置仅枚举路径，禁止读取或摘要；example/template 示例配置继续纳入。二进制静态资源不套用手写源码规则，其引用和打包入口仍待审查。

可重复核对方法：再次枚举相同目录边界，并以 `rg --files --hidden --no-ignore` 独立枚举，每个排除目录名追加 `-g '!**/<目录名>/**'`；归一化路径后使用 `Compare-Object -CaseSensitive` 与 `coverage.path` 双向比对。差集必须为空，且路径唯一、每条记录有职责与范围、排除原因存在、证据引用有效。本阶段核对还要求所有记录为 `enumerated`，`content_sha256` 为 null，`reviewed_rules` 和 `issue_ids` 为空。任何新增或删除文件均需更新清单；内容变化后的审查失效由第二阶段建立的内容摘要复核。

历史证据为 EV-INVENTORY-20261003。本地辅助脚本 `docs/superpowers/plans/2026-10-03-全量覆盖核对.ps1` 不带参数可输出新枚举；其 `-Verify` 专用于“全部 enumerated、摘要为空”的第一阶段快照，不能用于已升级为 reviewed 的当前台账。辅助文件不纳入 Git 跟踪，也不作为长期唯一复现依据。枚举核对只证明范围记录一致，不证明源码、工具门禁或业务行为通过。

### 第二阶段诊断与内容复核

纳入文件登记具体职责、适用规则、发现及阅读限制，`reviewed` 只表示已审查当前输入。知识库按结构、引用及高影响声明核对，不能由此推断每句业务说明已验证。CodeGraph 用作定义/调用导航，裁剪和未命中由当前源码及 rg 补查。

暂缓文件继续为 `enumerated`，公共影响使用独立的 `impact_content_sha256`、`shared_dependency_refs`、`behavior_candidates`、`impact_review_kind`、`impact_review_summary`、`impact_review_limits`、`impact_ids`。`shared_reference_scan_only` 是全文件输入的机械导入/候选扫描，`shared_boundary_source_review` 是人工公共边界核对；二者均不表示独立业务治理完成，也不以未命中证明没有间接影响。影响链接注明确定关系或潜在间接边界，关键调用和完整共同范围由 impacts 描述。

问题和影响使用稳定 ID。共同影响归并保留 `diagnosis.impact_aliases`；互有关联的前后端问题保留各自具体事实，通过 `related_impact_ids` 联结，不合成模糊问题。R1–R6 和旧发现的当前归属、反证、暂缓及未验证范围登记在 `diagnosis.historical_reconciliation`。待行为场景见 `diagnosis.behavior_checks`，`not_run` 不可记作 passed。

交付核对重新枚举实际路径，检查唯一性、纳入 reviewed、摘要变化、问题位置和所有问题/影响/证据引用。普通审查输入的 `content_sha256` 是原文件 SHA256；暂缓影响摘要同样关联当前原文件。台账自身无法保存自身原字节摘要，唯一特殊记录使用 `digest_mode: canonical_json_with_self_digest_null`：原生 PowerShell 7.6 中 `ConvertFrom-Json -DateKind String` 解析，置自身 `content_sha256` 为 null，经 `ConvertTo-Json -Depth 100 -Compress` 序列化后计算 UTF-8 SHA256。写回该摘要后按同法核对。凭据及 excluded 内容始终不摘要。

本地核对入口为 `docs/superpowers/plans/2026-10-04-诊断台账核对.ps1`，交付记录为 EV-DIAG-VERIFY-20261005。它只核对本次诊断台账，不处理源码抑制、复杂度计数、例外失效或真实业务行为，不是 GOV-003 或整体验收门禁已实现的证据。长期复现依据为上述字段、枚举边界及摘要方法，原始输出在 `.temp/`。

路径相对工作区根，使用 `/`；ID 全工作区唯一且稳定。记录按实际分析更新，不自动从旧报告或类名推断完成。文件内容摘要在实际分析时保存；本文不要求读取凭据。

| 集合 | 每项字段 |
|---|---|
| coverage | `path`, `role`, `scope`, `state`, `content_sha256`, `reviewed_rules`, `issue_ids`, `evidence_ids` |
| issues | `id`, `rule`, `locations`, `finding`, `impact`, `priority`, `disposition`, `state`, `exception_ids`, `evidence_ids` |
| impacts | `id`, `change_source`, `direct`, `indirect`, `data_protocol_runtime`, `required_changes`, `deferred_boundary`, `state`, `evidence_ids` |
| exceptions | `id`, `path`, `symbol`, `rule`, `measured_value`, `tool_version`, `necessity`, `risk`, `verification`, `owner_area`, `reevaluate_when`, `state`, `evidence_ids` |
| evidence | `id`, `scope`, `command_or_scenario`, `environment`, `tool_versions`, `checked_at`, `result`, `artifacts`, `limits` |
| work_items | `id`, `area`, `requirement`, `state`, `resolution`, `evidence_ids` |

`remediation_cycle` 是正式整改顺序：每批记录 `id`、`depends_on`、`issue_ids`、`impact_ids`、`work_item_ids`、`change_scope`、`prerequisites`、`checks`、`done_when`。问题恰归属一个主批次；共同影响和治理工作可跨批出现。B00–B10 的 `scheduled` 仅表示排期，不能作为整改或验证通过的证据。已解决的 GOV-001/007 不再作为待整改项分派。

`locations` 可以包含多个明确的路径、符号或行号；行号只用于定位，不能作为例外符号的唯一身份。`verification` 描述例外需要的验证，`evidence_ids` 指向实际记录；填了验证要求不表示验证已完成。

## 状态约定

- 范围：`included`、`deferred_business`、`shared_impact`、`excluded`，排除原因必须可核对。
- 文件：`enumerated`、`reviewed`、`stale`；行为验证单独引用证据，不能混为一类。
- 问题/工作：`pending`、`in_progress`、`resolved`、`excepted`、`deferred`、`blocked`。
- 例外：`active`、`review_required`、`retired`；只有理由充分、范围有效及所需证据具备的 active 记录可用于验收。
- 证据：`passed`、`failed`、`not_run`、`inconclusive`；未执行不能写 passed。
- 全局：`not_started`、`inventory_in_progress`、`inventory_complete`、`unification_in_progress`、`acceptance_pending`、`accepted`。

结构版本管理只约束本台账格式，不改变 API 1.0.0。本次诊断已有本地覆盖与引用核对；正式例外/源码抑制/指标和失效自动核对仍登记为待实施，不能将本 README 或本地辅助当作已经落地的完整门禁。
