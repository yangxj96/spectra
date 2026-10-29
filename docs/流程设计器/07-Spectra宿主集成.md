---
tags:
  - frontend
  - workflow
  - spectra
---

# Spectra 宿主集成

> 对应源码：`spectra-ui/src/views/System/Workflow/components/WorkflowDesigner/index.vue`、`src/api/workflow/workflow-api.ts` 和 Picker 对话框组件。

## 页面入口

Spectra 工作流入口由 `src/plugin/router/modules/system.ts` 注册：

| 路由 | 页面 |
|---|---|
| `/system/workflow` | 流程定义列表 |
| `/system/flow-edit` | `WorkflowDesigner` 创建/编辑流程 |

流程编辑页通过 query 参数区分模式：

- `id` 存在：编辑已有流程定义，调用资源接口加载 BPMN XML。
- `key` 存在：部署时作为流程 Key 传递。
- 两者都没有：新建流程，插件生成默认流程上下文。

## 宿主初始化

Spectra 创建 LogicFlow 时注册 `Control`、`SelectionSelect` 和 `Flowable.Plugin`：

```typescript
const lf = new LogicFlow({
  container,
  grid: true,
  idGenerator: type => {
    const prefix = type === "bpmn:sequenceFlow" ? "edge" : "node";
    return `${prefix}-${crypto.randomUUID()}`;
  },
  plugins: [Control, SelectionSelect, Flowable.Plugin],
  pluginsOptions: {
    flowable: {
      panel: { dnd: graph, property: panel },
      pickers: ["user", "group", "javaClass", "process"]
    }
  }
});
```

页面布局为 4:14:6：左侧 DND 面板、中间画布、右侧属性面板。`designer-body` 和各列都必须保留高度、`min-height: 0` 和溢出控制，否则属性面板和画布无法正确计算滚动区域。

宿主还通过 LogicFlow Control 增加“返回”和“部署”两个按钮；插件自身不创建这两个业务操作。

`FlowablePlugin` 保存 DND 和属性面板句柄，`graph:rendered` 只初始化一次属性面板，`connection:not-allowed` 为具名监听。`flush()` 与 `destroy()` 统一释放面板、属性事件、`DynamicGroup`、Picker 请求和防抖定时器；面板释放后从 `WeakMap` 删除容器登记，同一容器重建可重新挂载。`createFormSync` 固定创建时的目标节点 ID，导出前通过 `Flowable.toBpmnXml(lf)` 同步表单，销毁后不产生迟到写入。

## 编辑已有流程

编辑模式下调用：

```text
GET /api/workflow/process-definitions/{id}/resource
        │
        ▼
ProcessDefinitionResourceVO.bpmn_xml
        │
        ▼
Flowable.fromBpmnXml(bpmn_xml, logicFlow)
```

导入成功后，插件更新流程上下文、画布节点/边和属性面板；请求失败时页面显示“加载流程定义失败”，不会用模拟流程替代。

## Picker 对话框

宿主监听插件的 `property:picker` 事件，把事件载荷转换为对话框状态：

| Picker | 宿主组件 | 返回值 |
|---|---|---|
| `user` | `UserPickerDialog.vue` | 用户 ID 和名称，支持多选 |
| `group` | `GroupPickerDialog.vue` | 用户组/部门 ID 和名称，支持多选 |
| `javaClass` | `JavaClassPickerDialog.vue` | Java 全限定类名 |
| `process` | `ProcessPickerDialog.vue` | 流程定义 Key |

确认时调用 `payload.resolve(value, label)`；取消、关闭弹框或路由离开时调用 `payload.cancel()`。`PickerRequestPayload` 携带 `requestId` 并提供 `cancel()`，每个属性面板实例只接受同一目标的最新请求；目标切换、节点删除、面板销毁或显式取消后丢弃旧 `resolve`。插件按面板实例、目标 ID/类型和请求标识校验，切换节点后的迟到 `resolve` 不会写入新对象。插件负责把 value 写入 BPMN 属性，宿主负责查询候选数据和展示选择界面。Spectra 不注册 `form` Picker，因此 Flowable 原生 `formKey` 在此宿主中作为普通文本编辑；插件的通用 Picker API 保持不变。

`WorkflowDesigner` 保存完整请求对象，关闭弹框或离开路由时调用 `cancel()`。用户、部门、流程定义选择器在加载时维护请求序号和关闭失效，关闭后旧响应不能覆盖重新打开后的数据。`WorkflowDesigner` 在 `onUnmounted` 中先 flush 待写入表单、再取消未决 Picker、最后调用 `lf.destroy()`；插件释放面板、事件、Picker 和定时器。

## 部署流程

部署按钮的处理顺序：

1. 如果正在加载或部署，直接阻止重复操作。
2. 调用 `Flowable.toBpmnXml(logicFlow)` 生成完整 XML。
3. 调用 `WorkflowApi.deployProcess()`。
4. 后端返回部署版本后提示成功。
5. 返回 `/system/workflow?tab=workflow`。

当前 API：

```text
GET  /api/workflow/process-definitions/{id}/resource
POST /api/workflow/process-definitions/deploy
```

部署参数包括 `bpmn_xml`，可选 `key`、`name` 和 `category`。XML 是否满足 Flowable 执行要求由后端部署校验决定，宿主应在部署前补充 [[05-连接规则与交互行为]] 中的完整性检查。

## 工作流 API 边界

`WorkflowApi` 同时封装：

- 待办和已办任务查询。
- 任务完成和驳回。
- 流程定义列表、详情、图、挂起和激活。
- 流程实例启动和流程图。
- 流程定义 BPMN XML 资源。
- 流程定义部署。

页面通过 API 模块获取数据，不能把 Flowable JavaScript 客户端或后端内部对象直接暴露到画布组件中。

## 宿主必须负责的能力

- 流程定义权限、版本和发布状态。
- 部署前的流程完整性校验和错误展示。
- Picker 数据查询、分页、回填标签和用户取消。
- 保存草稿、自动保存或发布审批（当前编辑页面只有部署动作）。
- 部署失败后的 XML 定位和后端错误提示。
- 浏览器兼容、画布容器尺寸和编辑器销毁。
