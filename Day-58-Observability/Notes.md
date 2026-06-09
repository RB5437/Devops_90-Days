
## 📊 Metrics in Prometheus:
- Metrics in Prometheus are the core data objects that represent measurements collected from monitored systems.
- These metrics provide insights into various aspects of **system performance, health, and behavior**.
Docs: https://prometheus.io/docs/concepts/data_model/

Metrics = core data objects representing measurements from monitored systems
Every metric has a name + labels (key-value pairs)
Labels differentiate dimensions — same metric, different services/instances

# Format: metric_name{label1="value1", label2="value2"}
container_cpu_usage_seconds_total{namespace="kube-system", endpoint="https-metrics"}
Why labels matter:

Without labels: node_cpu_seconds_total → all CPUs combined
With labels: node_cpu_seconds_total{cpu="0", mode="idle"} → specific CPU + mode



## 🏷️ Labels:
- Metrics are paired with Labels.
- Labels are key-value pairs that allow you to differentiate between dimensions of a metric, such as different services, instances, or endpoints.


## 🔍 Example:
```bash
container_cpu_usage_seconds_total{namespace="kube-system", endpoint="https-metrics"}
```
- `container_cpu_usage_seconds_total` is the metric.
- `{namespace="kube-system", endpoint="https-metrics"}` are the labels.


## 🛠️ What is PromQL?
- PromQL (Prometheus Query Language) is a powerful and flexible query language used to query data from Prometheus.
- It allows you to retrieve and manipulate time series data, perform mathematical operations, aggregate data, and much more.

- 🔑 Key Features of PromQL:
    - Selecting Time Series: You can select specific metrics with filters and retrieve their data.
    - Mathematical Operations: PromQL allows for mathematical operations on metrics.
    - Aggregation: You can aggregate data across multiple time series.
    - Functionality: PromQL includes a wide range of functions to analyze and manipulate data.

    Docs: https://prometheus.io/docs/prometheus/latest/querying/basics/
Types of Selectors
promql# Exact match
container_cpu_usage_seconds_total{namespace="kube-system"}

# Regex match (~=)
container_cpu_usage_seconds_total{pod=~"kube-proxy.*"}

# Negative regex (!~)
container_cpu_usage_seconds_total{pod!~"kube-proxy.*"}
Instant vs Range Vector
promql# Instant vector — current value
node_load1

# Range vector — last 5 minutes of data
node_cpu_seconds_total[5m]
Key Functions
FunctionUseExamplerate()Per-second rate over time rangerate(http_requests_total[5m])irate()Instant rate (last 2 points)irate(http_requests_total[5m])increase()Total increase over time rangeincrease(restarts_total[1h])sum()Aggregate across all seriessum(rate(cpu[5m]))avg()Averageavg(memory_bytes) by (namespace)histogram_quantile()Percentile from histogramhistogram_quantile(0.95, ...)
Docs: https://prometheus.io/docs/prometheus/latest/querying/functions/

## 💡 Basic Examples of PromQL
- `container_cpu_usage_seconds_total`
    - Return all time series with the metric container_cpu_usage_seconds_total
- `container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}`
    - Return all time series with the metric `container_cpu_usage_seconds_total` and the given `namespace` and `pod` labels.
- `container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}[5m]`
    - Return a whole range of time (in this case 5 minutes up to the query time) for the same vector, making it a range vector.

## ⚙️ Aggregation & Functions in PromQL
- Aggregation in PromQL allows you to combine multiple time series into a single one, based on certain labels.
- **Sum Up All CPU Usage**:
    ```bash
    sum(rate(node_cpu_seconds_total[5m]))
    ```
    - This query aggregates the CPU usage across all nodes.

- **Average Memory Usage per Namespace:**
    ```bash
    avg(container_memory_usage_bytes) by (namespace)
    ```
    - This query provides the average memory usage grouped by namespace.

- **rate() Function:**
    - The rate() function calculates the per-second average rate of increase of the time series in a specified range.
    ```bash
    rate(container_cpu_usage_seconds_total[5m])
    ```
    - This calculates the rate of CPU usage over 5 minutes.
- **increase() Function:**
    - The increase() function returns the increase in a counter over a specified time range.
    ```bash
    increase(kube_pod_container_status_restarts_total[1h])
    ```
    - This gives the total increase in container restarts over the last hour.

- **histogram_quantile() Function:**
    - The histogram_quantile() function calculates quantiles (e.g., 95th percentile) from histogram data.
    ```bash
    histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (le))
    ```
    - This calculates the 95th percentile of Kubernetes API request durations.

🔍 Concept 3: Node Exporter
GitHub: https://github.com/prometheus/node_exporter

Runs as DaemonSet — one pod per node
Exposes hardware metrics on port 9100
Prometheus pulls from /metrics endpoint

Key metrics from Node Exporter:
node_cpu_seconds_total{cpu="0",mode="idle"}          → CPU idle time
node_memory_MemTotal_bytes                           → Total RAM
node_memory_MemAvailable_bytes                       → Available RAM
node_filesystem_avail_bytes                          → Disk available
node_load1 / node_load5 / node_load15               → Load averages
node_network_receive_bytes_total                     → Network RX
node_network_transmit_bytes_total                    → Network TX
node_disk_io_time_seconds_total                      → Disk I/O time
Verified in live cluster:
node_load1 = 1.14  (1-min load)
node_load5 = 1.41  (5-min load)
node_memory_MemTotal_bytes = 7.16GB
node_memory_MemAvailable_bytes = 2.72GB

🔍 Concept 4: kube-state-metrics
GitHub: https://github.com/kubernetes/kube-state-metrics

Listens to K8s API → generates metrics about K8s object states
Exposes on port 8080
Different from Node Exporter — Node Exporter = hardware, kube-state-metrics = K8s objects

Key metrics:
kube_pod_status_phase                    → Pod Running/Pending/Failed
kube_pod_container_status_ready          → Container ready = 1
kube_pod_container_status_restarts_total → Restart count
kube_deployment_status_replicas_ready    → Ready replicas
kube_node_status_condition               → Node Ready/NotReady
kube_daemonset_status_number_ready       → DaemonSet pods ready
Verified in live cluster:

All 9 monitoring pods: kube_pod_container_status_ready = 1 ✅
Node Exporter DaemonSet: 3 desired, 3 ready ✅
Alertmanager StatefulSet: 2/2 replicas ready ✅


⚙️ Concept 5: custom_kube_prometheus_stack.yml
Why custom config?
yamlalertmanager:
  alertmanagerSpec:
    replicas: 2                        # HA — prevents alert blackout on pod crash
    alertmanagerConfigSelector:
      matchLabels:
        release: monitoring            # Selects AlertmanagerConfig CRDs
    alertmanagerConfigMatcherStrategy:
      type: None                       # No namespace matchers — clean routing
Without this config:

alertmanagerConfigSelector mismatch → custom alert configs not picked up
replicas: 1 → single point of failure for alerting
namespace matchers → routing issues with multi-namespace setups


🔑 Key Concepts to Remember
ConceptWhat to RememberPrometheusPull-based — it scrapes targets, not pushTSDBLocal disk — not distributed by defaultNode ExporterDaemonSet — runs on every node, port 9100kube-state-metricsK8s API watcher — pod/deploy/node statesPromQL rate()Always use with counter metrics, not gaugeLabelsKey to filtering — use {} for label selectorsAlertmanager HA2+ replicas in production — always

📖 Official Links
TopicLinkPromQL Basicshttps://prometheus.io/docs/prometheus/latest/querying/basics/PromQL Functionshttps://prometheus.io/docs/prometheus/latest/querying/functions/PromQL Exampleshttps://prometheus.io/docs/prometheus/latest/querying/examples/Storage/TSDBhttps://prometheus.io/docs/prometheus/latest/storage/Node Exporterhttps://github.com/prometheus/node_exporterNode Exporter metricshttps://github.com/prometheus/node_exporter#collectorskube-state-metricshttps://github.com/kubernetes/kube-state-metricskube-state-metrics exposedhttps://github.com/kubernetes/kube-state-metrics/tree/main/docsAlertmanager HAhttps://prometheus.io/docs/alerting/latest/alertmanager/#high-availability
    
