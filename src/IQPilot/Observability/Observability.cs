using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Diginsight.Diagnostics;
using Microsoft.Extensions.Logging;

namespace Diginsight.Tools.IQPilot;

internal static class Observability
{
    public static readonly ActivitySource ActivitySource = new(Assembly.GetExecutingAssembly().GetName().Name!);

    // Diginsight 3.7: the ambient logger factory is exposed via LoggerFactoryStaticAccessor
    // (populated when the Diginsight service provider is built). This replaces the removed
    // 3.5-era ObservabilityRegistry.RegisterComponent(...) callback.
    public static ILoggerFactory? LoggerFactory => LoggerFactoryStaticAccessor.LoggerFactory;
}
