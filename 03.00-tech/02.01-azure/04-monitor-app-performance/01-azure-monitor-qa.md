the following article analyzes interesting points about Azure Monitor

## 📑 Table of Contents

- [📊 Q. Azure Monitor Features](#q-azure-monitor-features)
- [🔄 Q. Appinsight vs OpenTelemetry](#q-appinsight-vs-opentelemetry)

---

## 📊 Q. Azure Monitor Features

| Feature | Description |
|---------|-------------|
| <mark>Live Metrics | Observe activity from your deployed application in real time with no effect on the host environment. |
| <mark>Availability | Also known as Synthetic Transaction Monitoring, probe your applications external endpoints to test the overall availability and responsiveness over time. |
| <mark>GitHub or Azure DevOps integration | Create GitHub or Azure DevOps work items in context of Application Insights data. |
| <mark>Usage | Understand which features are popular with users and how users interact and use your application. |
| <mark>Smart Detection | Automatic failure and anomaly detection through proactive telemetry analysis. |
| <mark>Application Map | A high level top-down view of the application architecture and at-a-glance visual references to component health and responsiveness. |
| <mark>Distributed Tracing | Search and visualize an end-to-end flow of a given execution or transaction. |

## 🔄 Q. Appinsight vs OpenTelemetry

| Application Insights | OpenTelemetry |
|---------------------|---------------|
| <mark>Autocollectors | Instrumentation libraries |
| <mark>Channel | Exporter |
| <mark>Codeless / Agent-based | Autoinstrumentation |
| <mark>Traces | Logs |
| <mark>Requests | Server Spans |
| <mark>Dependencies | Other Span Types (Client, Internal, etc.) |
| <mark>Operation ID | Trace ID |
| <mark>ID or Operation Parent ID | Span ID |

