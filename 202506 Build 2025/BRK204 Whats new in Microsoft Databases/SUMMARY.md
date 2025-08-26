# What's New in Microsoft Databases: Empowering AI-Driven App Development

**Session Date:** May 19, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK204  
**Speakers:** Arun Ulag (CVP, Microsoft), Shireesh Thota (CVP Azure Databases, Microsoft), Priya Sathy (Partner Director of Product SQL, Microsoft), Charles Feddersen (Partner Director of Program Management, Microsoft), Kirill Gavrylyuk (VP Azure Cosmos DB, Microsoft), Genis Campa (Head of Data Innovation, NTT Data)  
**Link:** [Microsoft Build 2025 Session BRK204]

![Microsoft Database Portfolio](images/microsoft-databases-ai.png)

---

## Executive Summary

This comprehensive session showcases Microsoft's complete database portfolio transformation for the AI era. Led by CVPs Arun Ulag and Shireesh Thota, the presentation demonstrates how SQL Server 2025, Azure SQL, Cosmos DB, and PostgreSQL deliver AI-ready capabilities through vector search, semantic operators, and intelligent data processing. Live demonstrations show real-world implementations across enterprise customers like UBS, NFL, BMW, and NTT Data.

---

## Key Topics Covered

### ?? **1. AI-First Database Strategy**

#### The Data-AI Imperative
**Core Principle:** "AI is only as good as the data that it gets to work on"

**Strategic Foundation:**
- **Data quality determines AI success** - "Garbage in, garbage out"
- **Getting data AI-ready** is the critical first step for organizations
- **Comprehensive portfolio** - Most complete database offering across the industry
- **Three decades of SQL Server** - Still the leading enterprise database for scale, reliability, and security

#### Microsoft Database Portfolio Momentum
**Market Leadership Metrics:**
- **Azure SQL:** Used by 97% of Fortune 500 companies
- **Cosmos DB:** #1 database for building AI applications (Bloomberg CIO survey)
- **PostgreSQL:** Microsoft has more committers than any other hyperscaler
- **ChatGPT:** Built on Cosmos DB, demonstrating real-world AI scale

---

### ?? **2. SQL Server 2025: AI-Ready Enterprise Database**

#### Major Announcement: Public Preview Launch
**SQL Server 2025 Public Preview** - 2x adoption rate compared to SQL Server 2022

#### AI-Ready Capabilities
**Built-in Vector Search:**
- **Native vector data type** supporting embeddings in binary format
- **DiskANN vector indexing** - Microsoft Research technology powering Bing
- **Multi-language model support** - From local Ollama to Azure OpenAI
- **Semantic search capabilities** integrated into enterprise database

**Live Demo Highlights:**
- **Natural language search** across multilingual product catalogs
- **Dynamic model switching** - From local to cloud AI models
- **Security integration** - Microsoft Entra Managed Identity support
- **Developer experience** - Direct AI application code generation

#### Security and Integration Enhancements
**Enterprise Security:**
- **Microsoft Entra Managed Identity** support for Azure resource access
- **ARC enablement** for hybrid cloud scenarios
- **Secure AI model connections** replacing API key authentication

**Fabric Integration:**
- **OneLake connectivity** - Data available in open Delta Parquet format
- **Mirroring capabilities** - Real-time data synchronization
- **Cross-cloud availability** - Runs anywhere, any cloud

---

### ?? **3. Azure SQL Database Evolution**

#### SQL Server Management Studio 21 GA
**Complete Modernization:**
- **Visual Studio 2022 shell** - Modern development environment
- **64-bit architecture** support
- **Dark mode** and modern UI
- **Git integration** for database development
- **New query editor** and enhanced results grid
- **Azure authentication** built-in

#### SSMS 21 Copilot Integration (Public Preview)
**AI-Powered Database Management:**
- **Natural language query generation** - Write, edit, and tune queries in plain English
- **Context-aware responses** - Grounded in actual database schema and data
- **Database administration** - Configuration, maintenance, and troubleshooting assistance
- **Intelligent suggestions** - Performance optimization recommendations

#### Azure SQL Hyperscale Innovations
**Enterprise Scale Performance:**
- **30 read replicas** support
- **100+ terabyte** transactional workloads
- **50% faster than AWS Aurora** in price-performance
- **Continuous priming** (GA) - Consistent performance during failovers
- **150 MB/s log throughput** - Optimized for write-heavy workloads

**Customer Success: UBS**
- **2 petabytes** of data migrated from mainframe
- **50,000 tables** managed
- **400 billion records** processed
- **Tier 1 banking** workload reliability

#### Developer Experience Enhancements
**VS Code Integration:**
- **MSSQL extension** with Copilot capabilities
- **Query generation** and ORM migrations
- **Schema exploration** within IDE
- **Database chat** functionality for application development

**JSON Data Support:**
- **JSON indexing** (Public Preview) - High-performance semi-structured queries
- **Native JSON types** with optimized binary storage
- **JSON aggregation** - Seamless relational-to-JSON transformations
- **2GB document** storage capacity per JSON field

---

### ?? **4. PostgreSQL: Open Source AI Integration**

#### Vector Search Performance Breakthrough
**DiskANN for PostgreSQL (GA):**
- **35 million vectors** queried in under 1 second
- **10x performance improvement** over HNSW (1000ms ? 100ms average latency)
- **Product quantization** optimization
- **Superior accuracy** compared to pgvector

#### Semantic Operators Innovation (Public Preview)
**Natural Language SQL Integration:**
Four powerful semantic operators:
- **GENERATE:** ChatGPT-style content generation within queries
- **IS_TRUE:** Semantic predicate evaluation
- **EXTRACT:** Entity knowledge extraction
- **RANKING:** AI-powered result relevance ordering

**Example Implementation:**
```sql
SELECT product_name, reviews 
FROM products 
WHERE reviews IS_TRUE 'positive sentiment about comfort'
ORDER BY reviews RANKING 'best for gaming'
```

#### High Availability Architecture
**Premium SSD v2 Integration (Public Preview):**
- **Sub-10 second failover** times
- **Performance parity** with existing SSD solutions
- **Enhanced reliability** for critical workloads

#### Enhanced Developer Experience
**VS Code PostgreSQL Extension:**
- **Native Entra ID** authentication
- **Azure-integrated experience** with subscription/resource group dropdowns
- **Copilot optimization** for PostgreSQL-specific queries
- **Query performance analysis** - 38ms to 8.5ms optimization examples
- **Export capabilities** - Excel, JSON, CSV support

#### Graph Database Capabilities
**Apache AGE Extension (GA):**
- **Native Cypher queries** in PostgreSQL
- **Semantic relationships** beyond traditional foreign keys
- **Product-review-feature** graph modeling
- **Advanced pattern matching** for complex data relationships

**Customer Success: PTC**
- **300 complex scenarios** migrated to Azure Database for PostgreSQL
- **Increased reliability** and faster processing
- **Cost efficiency gains** enabling AI application focus
- **AKS and Semantic Kernel** integration

---

### ?? **5. Cosmos DB: Global AI Database Platform**

#### AI Foundry Native Integration
**Thread Services Integration (Preview):**
- **Structured conversations** between users and agents
- **Context preservation** across multi-turn interactions
- **Bring Your Own Storage** for thread management
- **Foundry SDK** embedding for intelligent applications

#### Performance and Scale Innovations
**Global Secondary Indexing:**
- **Read-only containers** with alternative partition keys
- **Cross-partition query** optimization
- **Performance boost** for non-partition-key queries
- **Cost reduction** through targeted indexing

**Vector and Full-Text Search (GA):**
- **Hybrid search capabilities** combining vector similarity and BM25 text ranking
- **Multi-language support** (Public Preview)
- **Fuzzy search** with typo tolerance
- **Phrase search** capabilities

#### Zero-Downtime Architecture
**Per-Partition Automatic Failover:**
- **Surgical failover** - Individual partition recovery without full database failover
- **Zero downtime** (RTO = 0) guarantee
- **Zero data loss** (RPO = 0) with strong consistency
- **Zero touch** - SDK-managed transparent failover

**The "000 Database":**
- **RTO: 0** - No recovery time
- **RPO: 0** - No data loss
- **Manual intervention: 0** - Fully automated

#### Fleet Management for Multi-Tenancy
**SaaS Optimization:**
- **Shared throughput** across tenant accounts
- **Aggregated monitoring** and management
- **Cost optimization** for multi-tenant applications
- **Security isolation** maintained per tenant

**Customer Success: NFL**
- **AI coaching assistant** built on Cosmos DB
- **Azure OpenAI** integration for talent evaluation
- **Real-time insights** for athlete assessment
- **Container services** orchestration

#### MongoDB API Enhancements
**Open Source Collaboration:**
- **Cosmos Mongo vCore API** open sourced
- **Partnership with Yugabyte and FerretDB**
- **PostgreSQL-backed** document API
- **Community contribution** to document database ecosystem

**Enterprise Features:**
- **Entra ID authentication** for MongoDB vCore clusters
- **DiskANN vector search** for document databases
- **Transactional semantics** with document flexibility

---

### ?? **6. Live Demonstrations and Real-World Applications**

#### SQL Server 2025 AI Application Development
**Multi-Language Vector Search:**
- **English and Chinese** product search in single database
- **Dynamic model switching** between Ollama and Azure OpenAI
- **Semantic Kernel integration** for C# application development
- **Automatic code generation** for vector store operations

#### Azure SQL Hyperscale Insurance Application
**Data API Builder (DAB) Integration:**
- **REST and GraphQL** endpoint generation from database schema
- **Claims-based security** with user context
- **JSON document storage** up to 2GB per field
- **Model Context Protocol (MCP)** server integration
- **Natural language database** manipulation through chat interface

**Advanced Scenarios:**
- **Complex business rules** triggered via chat commands
- **Multi-step operations** (name change, address update, insurance addition)
- **Email notifications** integrated with database changes

#### PostgreSQL Vector Search Performance
**35 Million Vector Demo:**
- **Sub-second response** times with DiskANN
- **Semantic operator re-ranking** for result optimization
- **Graph query integration** with Apache AGE
- **Copilot query optimization** reducing latency 5x

#### Cosmos DB Agentic Applications
**Multi-Tenant Chat Platform:**
- **MCP client-server** architecture
- **Per-tenant container** isolation
- **Semantic caching** with vector similarity
- **Hybrid search** with automatic tool selection
- **AI Foundry portal** integration for agent deployment

---

### ?? **7. Customer Success Stories**

#### Enterprise Transformations

**UBS (Banking):**
- **Mainframe migration** to Azure SQL Hyperscale
- **2 petabyte** data estate management
- **Mission-critical** banking operations
- **Enterprise scale** reliability

**BMW (Automotive):**
- **Mobile data recorder** infrastructure
- **PostgreSQL Flexible Server** for vehicle data
- **AI-powered** conversation and chat history
- **Real-time processing** capabilities

**Carvana (E-commerce):**
- **CARE system** - Conversational Analyst Review Engine
- **Millions of conversations** processed monthly
- **AI-first development** culture
- **Cosmos DB** as central data platform

**NTT Data (IT Services):**
- **Data-driven strategy** transformation
- **6,000+ employees** actively using platform
- **70 developers** deploying 3-4 times daily
- **4-year development** journey to production stability

#### Industry Impact Examples

**Mondra Global (Sustainability):**
- **Environmental impact** assessment for food retailers
- **Product lifecycle** evaluation acceleration
- **Weeks/months ? 4 hours** processing time
- **60,000 products** with 1M+ ingredients analyzed
- **Azure SQL Hyperscale + Semantic Kernel** architecture

---

### ?? **8. Microsoft Fabric Integration Strategy**

#### Unified Data Platform Vision
**Four Strategic Pillars:**
1. **Enterprise-grade** reliability and security
2. **AI developer** optimization
3. **SaaS-ified** autonomous database operations
4. **OneLake integration** for unified data estate

#### Database Services in Fabric
**SQL Database in Fabric:**
- **Simplified provisioning** and management
- **Autonomous operations** - security, HA, indexing, tuning
- **AI integration** - vector indexing and semantic search
- **Analytical integration** with unified data platform

#### Cosmos DB in Fabric (Public Preview)
**Enterprise AI Applications:**
- **Dynamic scalability** with five-nines reliability
- **Sub-10ms latency** for 400 billion vector operations
- **DiskANN technology** from Microsoft Research
- **Real-time sentiment analysis** with OneLake integration
- **No ETL required** for analytical workflows

#### Mirroring Capabilities Expansion
**Real-Time Data Synchronization:**
- **SQL Database** behind firewalls (existing)
- **PostgreSQL** mirroring (announced)
- **SQL Server 2016-2022** on-premises support (Public Preview)
- **SQL Server 2025** first-class mirroring integration

---

## Technical Architecture and Integration

### AI-Ready Database Stack
**Unified AI Capabilities Across Portfolio:**
- **Vector data types** and indexing (SQL Server, Azure SQL, Cosmos DB, PostgreSQL)
- **DiskANN technology** - Microsoft Research algorithm for billion-scale vector operations
- **Semantic operators** - Natural language SQL integration
- **Multi-model support** - Local and cloud AI model flexibility

### Developer Experience Evolution
**IDE-Native Database Development:**
- **VS Code extensions** for all database platforms
- **GitHub Copilot integration** across SQL Server, PostgreSQL
- **Natural language** query generation and optimization
- **Context-aware assistance** grounded in actual database schemas

### Security and Compliance Framework
**Enterprise-Grade Security:**
- **Microsoft Entra ID** integration across all platforms
- **Managed Identity** support for secure cloud resource access
- **ARC enablement** for hybrid cloud scenarios
- **Zero-trust architecture** with identity-based access control

---

## Session Highlights

> *"AI is only as good as the data that it gets to work on... if you put garbage in, most likely you're going to get garbage out."* - Arun Ulag

> *"Folks, no other enterprise database on the planet can do something like this so easily, so seamlessly."* - Priya Sathy (on SQL Server 2025 multi-language AI capabilities)

> *"With semantic search, semantic re-ranker, fleet management, per partition auto failover... Cosmos DB is the go-to database for your agentic apps that need scale, reliability, performance, and serverless cost efficiency."* - Kirill Gavrylyuk

> *"We are proud to say Cosmos DB is the 000 database: RTO zero, RPO zero, zero touch."* - Shireesh Thota

> *"Microsoft has more committers on Postgres than any other hyperscaler... we actively contribute back to the Postgres community."* - Arun Ulag

---

## Practical Implementation Guide

### Getting Started with AI-Ready Databases

**SQL Server 2025 AI Development:**
1. **Download public preview** and explore vector data types
2. **Install SSMS 21** for modern management experience
3. **Enable Copilot** for AI-assisted query development
4. **Experiment with multi-model** AI integration (Ollama ? Azure OpenAI)

**Azure SQL Hyperscale for Modern Apps:**
1. **Leverage JSON indexing** for flexible schema design
2. **Implement Data API Builder** for instant REST/GraphQL APIs
3. **Integrate Model Context Protocol** for conversational data access
4. **Utilize continuous priming** for consistent performance

**PostgreSQL AI Applications:**
1. **Deploy DiskANN** for high-performance vector search
2. **Experiment with semantic operators** for natural language queries
3. **Use VS Code extension** with Copilot optimization
4. **Implement Apache AGE** for graph database scenarios

**Cosmos DB Agentic Development:**
1. **Design multi-tenant** container architecture
2. **Implement semantic caching** for cost optimization
3. **Configure AI Foundry** integration for agent deployment
4. **Leverage fleet management** for SaaS applications

### Migration and Modernization Strategies

**Assessment Tools:**
- **Azure Migrate** for MySQL discovery and readiness assessment
- **Database Migration Service** for PostgreSQL transitions
- **SQL Server Migration Assistant** for Oracle-to-PostgreSQL paths

**Modernization Pathways:**
- **Rehost:** SQL VMs for lift-and-shift scenarios
- **Modernize:** SQL Managed Instance for hybrid scenarios
- **Rebuild:** Azure SQL Database for cloud-native applications

---

## Future Roadmap and Innovation

### Emerging Technologies
- **Semantic re-ranker** integration across database portfolio
- **Advanced agentic frameworks** with MCP standardization
- **Enhanced multi-language** AI model support
- **Deeper Fabric integration** with analytical workflows

### Community and Open Source
- **PostgreSQL contributions** leadership in hyperscaler space
- **MongoDB API open sourcing** with community collaboration
- **Developer tool ecosystem** expansion across IDEs
- **AI model marketplace** integration

---

## About the Speakers

**Arun Ulag**  
Corporate Vice President  
Microsoft  
*20+ years at Microsoft leading Azure Data portfolio including databases, analytics, messaging, and business intelligence across SQL, Cosmos DB, PostgreSQL, MySQL, and Microsoft Fabric.*

**Shireesh Thota**  
Corporate Vice President, Azure Databases  
Microsoft  
*Founding member of Cosmos DB with 20+ years experience in distributed systems. Previously Senior VP at SingleStore, now leading Azure's comprehensive database portfolio.*

**Priya Sathy**  
Partner Director of Product, SQL  
Microsoft  
*25+ years in data and analytics, leading SQL Server, Azure SQL, and Fabric SQL Database development. Expert in enterprise-scale data platform architecture.*

**Charles Feddersen**  
Partner Director of Program Management  
Microsoft  
*Leading PostgreSQL on Azure including managed services and open source contributions. Responsible for product strategy and customer experience.*

**Kirill Gavrylyuk**  
Vice President, Azure Cosmos DB  
Microsoft  
*20+ years in distributed systems and database platforms, leading Cosmos DB engineering and product development for global-scale applications.*

**Genis Campa**  
Head of Data Innovation  
NTT Data  
*Leading enterprise data transformation initiatives with focus on AI integration and strategic partnerships with Microsoft ecosystem.*

---

*This session demonstrates Microsoft's comprehensive database portfolio evolution for the AI era, showing how traditional database platforms are being transformed into AI-ready foundations for next-generation intelligent applications while maintaining enterprise-grade reliability, security, and performance.*

