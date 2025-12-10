
**Link:** [Microsoft Ignite 2025 Session BRK431](https://ignite.microsoft.com/en-US/sessions/BRK431)

xpand all

Collapse all

About the session
Join Mark Russinovich, Azure CTO and Technical Fellow, to learn about the latest innovations in cloud native computing. Mark will present exciting projects that supports multi-cloud portability and cloud native development.


AI Summary
Serverless container advancements: Azure Container Instances (ACI) pioneered serverless containers, now enhanced with direct virtualization eliminating intermediate hypervisors, enabling better security and hardware access. Features like container groups, virtual node integration with Kubernetes, rapid scaling, and standby pools facilitate efficient container management and bursting capabilities. Stretchable container instances allow dynamic resource scaling on the fly, improving performance under load.  Networking improvements: Azure Managed Cilium with eBPF host routing replaces inefficient IP tables layers, boosting network performance for Kubernetes pods by over 50% through deep integration with Azure CNI and Azure Boost offload. This enhances security, observability, and throughput.  Storage innovations: Azure Container Storage integrates local NVMe drives and Azure Discs with distributed caching, significantly reducing data load times for large AI models by sharing cached data across nodes, minimizing redundant downloads from storage.  Container security enhancements: Combining SELinux, DM Verity, and Integrity Policy Enforcement (IPE) in a feature called OS Guard enables immutable, lockdown Linux containers by verifying image integrity at runtime. This prevents unauthorized code execution inside containers, enhancing security.  Confidential containers: Upcoming confidential container groups use hardware-based protections and strict policy enforcement to ensure workload confidentiality and integrity, allowing only approved commands to execute within containers.  Rapid container patching: Project Copacetic allows hot patching of container images by layering security updates without full rebuilds, drastically reducing patch deployment times. Recent advances enable patching runtime libraries, such as Python packages, improving vulnerability management in production.  Radius application modeling: Radius separates application definitions from infrastructure, allowing developers to define resource types while operators manage deployment recipes for Kubernetes, Azure, or AWS environments. This abstraction supports app portability, governance, and environment-specific policies without changing the app code.  Radius AI app deployment demo: Demonstrated by ratifying an Azure chatbot app, Radius facilitates deploying the same containerized app with different environment policies (e.g., dev vs. prod) controlling resource tiers and security features like jailbreak filters, showcasing seamless app deployment and governance.  Dracy event-driven framework: Dracy simplifies complex event-driven architectures by enabling continuous graph queries over multiple data sources to detect state changes and trigger reactions. It supports real-time updates for AI workloads, demonstrated by maintaining an up-to-date product rating vector database from multiple databases without polling.


About the speaker
Profile picture of Mark Russinovich
Mark Russinovich
Azure CTO, Deputy CISO, and Technical Fellow
Microsoft
Mark Russinovich is CTO, Deputy CISO, and Technical Fellow for Microsoft Azure, Microsoft’s global enterprise-grade cloud platform. A widely recognized expert in distributed systems, operating systems and cybersecurity, Mark earned a Ph.D. in computer engineering from Carnegie Mellon University. He later co-founded Winternals Software, joining Microsoft in 2006 when the company was acquired. Mark is a popular speaker at industry conferences such as Microsoft Ignite, Microsoft Build, and RSA Conference. He has authored several nonfiction and fiction books, including the Microsoft Press Windows Internals book series, Troubleshooting with the Sysinternals Tools, as well as fictional cyber security thrillers Zero Day, Trojan Horse and Rogue Code. 
Show less

Save to favorites


Related sessions

Azure Infrastructure for Cloud Native...

Azure IaaS best practices to enhance ...

What’s new and what’s next in Azure IaaS

Enabling the next wave of cloud trans...

Inside Azure Innovations with Mark Ru...

Advanced capabilities and innovation ...