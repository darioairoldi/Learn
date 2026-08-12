please look at diginsight documentation 
https://github.com/diginsight/telemetry
https://diginsight.github.io/telemetry/Index.html

please look at diginsight 
.github\prompts\10.00-application-development\log-ensure-class-logging.prompt.md

understand criteria for logging and ensure class logging in the context of application development with diginsight telemetry. 
The documentation provides guidelines on how to implement logging effectively, ensuring that all classes have appropriate logging mechanisms in place, still ensuring:
- observability of method calls and relevant incoming/outgoing data
- overall efficiency
- ease of troubleshooting and debugging


then create a prompt:
.github\prompts\10.00-application-development\diginsight-ensure-project-logging.prompt.md


further than with logging efficiency and ease of troubleshooting and debugging can be achieved with use of concurrency control:
instead of 
- Task.WhenAll (with infinite concurrency)
- or sequential foreach (...) (with no concurrency)

concurrency control can be implemented with IParallelService ForEachAsync and WhenAllAsync.
then create a prompt:
.github\prompts\10.00-application-development\diginsight-ensure-concurrency-control.prompt.md







