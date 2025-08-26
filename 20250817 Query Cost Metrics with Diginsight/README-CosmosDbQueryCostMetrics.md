# CosmosDB Query Cost Metrics with Diginsight

This document explains how to collect and monitor CosmosDB query costs using Diginsight's metrics infrastructure.

## Overview

The Diginsight.Components.Azure package now includes automatic collection of CosmosDB query costs as metrics. These metrics are collected every time a CosmosDB query is executed and include detailed tags for analysis.

## How It Works

### Activity-Based Metric Collection

The query cost metrics follow the same pattern as Diginsight's `span_duration` metrics:

1. **Activity Tagging**: When CosmosDB operations are performed using the `*Observable` extension methods, the query details are automatically tagged on the current activity:
   - `query`: The SQL query text or operation type
   - `container`: The CosmosDB container name
   - `database`: The CosmosDB database name

2. **Cost Recording**: When a query completes in `ReadNextObservableAsync`, the Request Units (RU) cost is set as a `query_cost` tag on the activity.

3. **Metric Collection**: The `QueryCostMetricRecorder` listens for activity completion events and records the `query_cost` metric with these tags:
   - `query`: The SQL query text
   - `method`: The current activity operation name
   - `entrymethod`: The root operation name in the activity chain
   - `application`: The application name
   - `container`: CosmosDB container name
   - `database`: CosmosDB database name

### Security Considerations

**Important**: The implementation excludes sensitive information from logs:
- **Continuation tokens** are never logged in activity payloads for security reasons
- Only query text, container, and database names are included in observability data
- Request options that might contain sensitive data are excluded from logged payloads

## Setup

### 1. Register the Query Cost Metrics

Add the query cost metric recorder to your service collection:

```csharp
services.AddCosmosDbQueryCostMetrics();
```

### 2. Use Observable Extensions

Make sure you're using the `*Observable` extension methods from Diginsight.Components.Azure:

```csharp
// Instead of:
var iterator = container.GetItemQueryIterator<MyEntity>(queryDefinition);

// Use:
var iterator = container.GetItemQueryIteratorObservable<MyEntity>(queryDefinition);

// When reading results:
var response = await iterator.ReadNextObservableAsync();
```

### 3. Configure Metrics Export

Configure your metrics infrastructure (e.g., Prometheus, Application Insights) to collect the `query_cost` histogram:

```csharp
// Example with OpenTelemetry
services.AddOpenTelemetry()
    .WithMetrics(builder => builder
        .AddMeter("Diginsight.Components.Azure")
        .AddPrometheusExporter());
```

## Metric Details

### Metric Name
- **Name**: `query_cost`
- **Type**: Histogram
- **Unit**: RU (Request Units)
- **Description**: CosmosDB query cost in Request Units

### Tags
- `query`: The SQL query text or operation description
- `method`: The current operation method name
- `entrymethod`: The entry point method name
- `application`: The application name
- `container`: CosmosDB container name
- `database`: CosmosDB database name

## Example Usage

```csharp
public class OrderService
{
    private readonly Container _container;

    public OrderService(Container container)
    {
        _container = container;
    }

    public async Task<List<Order>> GetOrdersByStatusAsync(string status)
    {
        // This will automatically generate metrics
        using var activity = ActivitySource.StartActivity("GetOrdersByStatus");
        activity?.SetTag("order_status", status);

        var queryDefinition = new QueryDefinition(
            "SELECT * FROM c WHERE c.status = @status")
            .WithParameter("@status", status);

        var iterator = _container.GetItemQueryIteratorObservable<Order>(queryDefinition);
        
        var orders = new List<Order>();
        while (iterator.HasMoreResults)
        {
            // This call will record query_cost metric
            var response = await iterator.ReadNextObservableAsync();
            orders.AddRange(response);
        }

        return orders;
    }
}
```

## Monitoring and Alerting

With the collected metrics, you can:

1. **Monitor Query Costs**: Track RU consumption patterns over time
2. **Identify Expensive Queries**: Find queries with high RU costs
3. **Set Alerts**: Create alerts for unusual RU consumption spikes
4. **Optimize Performance**: Use query text tags to identify and optimize expensive queries

## Integration with Existing Metrics

The query cost metrics integrate seamlessly with Diginsight's existing observability features:

- **Correlation**: Query costs are correlated with activities and traces
- **Context**: Full context including entry method and application name
- **Consistency**: Same tagging and naming conventions as `span_duration` metrics
- **Security**: Sensitive data like continuation tokens are excluded from logs
