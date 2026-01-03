
## Q. What are Deployment slots ? how can I use them?
When deploying a web app, you can use a separate deployment slot instead of the default production slot when you're running in the Standard App Service pricing tier or better. Deployment slots are live apps with their own host names. App content and configurations elements can be swapped between two deployment slots, including the production slot.

## Q.What are Linux web app Limitations
App Service on Linux does have some limitations:

App Service on Linux isn't supported on Shared pricing tier.
The Azure portal shows only features that currently work for Linux apps. As features are enabled, they're activated on the portal.
When deployed to built-in images, your code and content are allocated as a storage volume for web content, backed by Azure Storage. The disk latency of this volume is higher and more variable than the latency of the container filesystem. Apps that require heavy read-only access to content files might benefit from the custom container option, which places files in the container filesystem instead of on the content volume.

## Q.What is App Service Environment? when should I use it?
App Service Environment is an Azure App Service feature that provides a fully isolated and dedicated environment for running App Service apps. It offers improved security at high scale.

Unlike the App Service offering, where supporting infrastructure is shared, with App Service Environment, compute is dedicated to a single customer. For more information on the differences between App Service Environment and App Service, see the comparison.

## Q. to manually push your code to Azure:

- **Git**: App Service web apps feature a Git URL that you can add as a remote repository. Pushing to the remote repository deploys your app.
- **CLI**: The **<mark>az webapp up** is a feature of the az command-line interface that packages your app and deploys it. Unlike other deployment methods, az webapp up can create a new App Service web app for you.
- **Zip deploy**: Use curl or a similar HTTP utility to send a ZIP of your application files to App Service.
- **FTP/S**: FTP or FTPS is a traditional way of pushing your code to many hosting environments, including App Service.

## Q. Sidecar containers
In Azure App Service, you can add up to <mark>nine sidecar containers</mark> for each sidecar-enabled custom container app. Sidecar containers are supported for Linux-based custom container apps and enable deploying extra services and features without making them tightly coupled to your main application container. For example, you can add monitoring, logging, configuration, and networking services as sidecar containers.

You can add a sidecar container through the Deployment Center in the app's management page.


## Q. Autoscaling options 

**Azure App Service** supports manual scaling, and two options for scaling out your web apps automatically:

- **Autoscaling with <mark>Azure autoscale</mark>** - Autoscaling makes scaling decisions based on <mark>rules that you define</mark>.
- **Azure App Service <mark>automatic scaling</mark>** - Automatic scaling makes scaling decisions for you based on the <mark>parameters that you select</mark>.

### **Azure Autoscale** (Rule-Based Scaling)

**Where it's applied:**
- Azure App Service running on **<mark>Standard tier or higher**
- Uses **<mark>Azure Monitor Autoscale** service
- Applied to the underlying **<mark>App Service Plan**

**How it works:**
- **Rule-based scaling** - You define custom rules based on metrics
- **Reactive scaling** - Responds to load **after** thresholds are exceeded
- **Metric-driven** - Based on CPU utilization, memory usage, request count, or custom metrics
- **Manual configuration** required for all scaling rules

**Scale behavior:**
- **Scale OUT/IN** (horizontal scaling) - Adds/removes instances
- **Slower scaling** - Takes **2-5 minutes** to provision new VM instances
- **Threshold-based** - Scales when metrics exceed defined limits (e.g., CPU > 70%)
- **Cannot scale to zero** - Requires minimum number of instances

**Example triggers:**
- <mark>CPU > 80% for 5 minutes</mark> → Scale out
- <mark>Memory > 75% for 10 minutes</mark> → Scale out  
- <mark>Request count > 1000 per minute</mark> → Scale out

### **Azure App Service Automatic Scaling** (AI-Powered Scaling)

**Where it's applied:**
- Azure App Service **<mark>Premium v3 tier and higher**
- Uses **built-in automatic scaling intelligence**
- Applied directly to the **App Service**

**How it works:**
- **<mark>AI-powered scaling** - Makes intelligent scaling decisions for you
- **<mark>Proactive scaling** - Anticipates load patterns and scales before demand peaks
- **<mark>Parameter-based** - You select scaling parameters rather than defining complex rules
- **<mark>Minimal configuration** - System learns and optimizes automatically

**Scale behavior:**
- **Scale OUT/IN** (horizontal scaling) - Adds/removes instances intelligently  
- **Faster scaling** - More responsive than rule-based autoscale
- **Pattern-aware** - Learns from historical usage patterns
- **Intelligent scale-in** - Smarter decisions about when to remove instances

### **Summary of Key Differences**

| Aspect | Azure Autoscale | App Service Automatic Scaling |
|--------|-----------------|-------------------------------|
| **Configuration** | Manual rule definition | Parameter selection |
| **Intelligence** | Rule-based thresholds | AI-powered learning |
| **Response** | Reactive to metrics | Proactive pattern recognition |
| **Complexity** | High - requires metric expertise | Low - simplified setup |
| **Scaling Speed** | Slower (2-5 minutes) | Faster and more responsive |
| **Required Tier** | Standard+ | Premium v3+ |
| **Learning** | No learning capability | Learns usage patterns |

The following table highlights the differences between the two automatic scaling options:

![alt text](<images/01. autoscaling options.png>)

## Q. Slot specific settings
what settings are slot specific in Azure Web Apps?

![alt text](<images/02.slotspecific settings.png>)
