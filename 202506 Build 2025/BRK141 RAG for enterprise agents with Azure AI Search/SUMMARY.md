# Knowledge Retrieval: RAG for Enterprise Agents with Azure AI Search

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK141  
**Speaker:** Pablo Castro (CVP & Distinguished Engineer, AI Platform, Microsoft)  
**Link:** [Microsoft Build 2025 Session BRK141]

![Azure AI Search RAG Evolution](images/azure-ai-search-rag-enterprise.png)

---

## Executive Summary

This technical deep-dive session reveals the evolution from traditional RAG to purpose-built enterprise AI systems powered by Azure AI Search. Pablo Castro demonstrates how knowledge retrieval has transformed from simple vector search to sophisticated agentic retrieval systems capable of multi-hop reasoning, complex query decomposition, and enterprise-grade security. The session showcases three major innovation areas: agentic retrieval with 40% improvement in answer relevance, multi-modal document processing with AI-powered extraction, and native Entra ID-based access control for secure enterprise deployment.

---

## Key Topics Covered

### ?? **1. The Evolution Beyond Traditional RAG**

#### The Historical Context: Two Years of RAG Progress
**Pablo's Opening Insight:**
> "About two years ago, we started to talk about RAG... it was built out of the tools available in the room. There was this clever observation of in-context learning... we managed to put these things together."

**Traditional RAG Architecture:**

- **In-context learning** - Language models with concatenated retrieved content
- **Available tools approach** - Using existing search stacks not designed for AI
- **Vector search adoption** - Addressing vocabulary gaps and semantic understanding
- **Industry success** - Two years of progress with first-wave applications

#### The Transition to Purpose-Built Systems
**From Adoption to Innovation:**

- **Historical approach** - "Whatever we adopted to do the job"
- **Current evolution** - "Things that we purposely built and constructed"
- **Strategic goal** - Make tasks easier, better, and faster to solution
- **Enterprise focus** - Real-world agents solving real-world problems

---

### ?? **2. Agentic Retrieval: The Next Generation Query Pipeline**

#### The Limitation of Single-Shot Search
**Traditional Search Constraints:**

- **Linear results** - Top-K results from single query execution
- **Simple fact-seeking** works well: "What are the security updates for KB article #123456?"
- **Complex queries fail** - Multi-part questions with typos, references, and context

**The "Doesn't Work" Scenario Example:**
```
Complex Query: "What does KB [typo] article fix security issue mentioned earlier 
regarding the vulnerability we discussed?"

Challenges:
- Multiple moving parts in single question
- Typos requiring correction
- Cross-references requiring resolution
- Conversational context dependency
```

#### Agentic Retrieval Architecture
**Revolutionary Approach:**
```
Traditional: User Query ? Single Search ? Top-K Results ? LLM
Agentic: Chat History + Context ? Query Planning ? Parallel Execution ? Merge Results ? LLM
```

**Intelligent Query Processing:**

- **Query planning** - LLM-powered understanding of information needs
- **Query decomposition** - Breaking complex queries into retrievable components
- **Typo correction** - Context-aware error resolution
- **Parallel execution** - Multiple search operations simultaneously
- **Result merging** - Intelligent combination of diverse information sources

#### Live Demonstration: Outdoor Gear Analysis
**Complex Query Scenario:**
```
User: "What are examples of popular tents?"
System: "TrailMaster and SkyView are two popular choices."
User: "Which one fits more people?"
```

**Agentic Processing:**
1. **Context analysis** - Understanding previous conversation about tent models
2. **Query branching** - Two separate searches:
   - "TrailMaster tent maximum capacity"
   - "SkyView tent maximum capacity"
3. **Parallel execution** - Both queries processed simultaneously
4. **Result synthesis** - Combined capacity information in comparative format

#### Performance Metrics and Validation
**Quantified Improvements:**

- **40% increase in answer relevance** for complex queries
- **30% increase in result rate** for difficult question scenarios
- **Multi-dataset validation** - Support, MIML (Multi-Industry Multi-Language)
- **Groundedness preservation** - No regression in hallucination prevention

**Evaluation Framework:**

- **Content relevance** - Retrieved information matches query intent
- **Answer relevance** - LLM response addresses actual question
- **Groundedness** - Response based on retrieved data, not hallucinated

---

### ?? **3. Multi-Modal Document Processing Revolution**

#### Beyond Simple Text Chunking
**Traditional RAG Data Problems:**

- **500-token chunking** - Arbitrary text segmentation ignoring document structure
- **Text-only processing** - Missing critical visual information
- **Layout ignorance** - Losing contextual relationships and hierarchies
- **Manual extraction** - Developer responsibility for complex document parsing

#### Advanced Document Intelligence
**Real-World Document Challenges:**

- **Complex schematics** - Arrows, text boxes, and diagram relationships
- **Multi-modal content** - Text and images requiring coordinated understanding
- **Layout significance** - Document structure conveying meaning
- **Addressable components** - Individual elements for citation and reference

#### AI-Powered Processing Pipeline
**End-to-End Document Processing:**
1. **AI Document Intelligence** - Automatic layout and structure extraction
2. **Image verbalization** - LLM-powered image description generation
3. **Multi-modal embeddings** - Coordinated text and visual understanding
4. **Component addressability** - Individual images and sections for citation
5. **Sophisticated chunking** - Structure-aware content segmentation

#### Live Demo: Azure Search Documentation Processing
**Multi-Modal RAG Implementation:**

- **Data source** - PDF documentation with diagrams and text
- **Processing options** - Simple extraction vs. full AI Document Intelligence
- **Image handling** - Verbalization vs. embedding vs. hybrid approaches
- **Knowledge Store** - Addressable component storage for application integration

**Generated Application Results:**

- **Automatic image extraction** - Individual diagrams made addressable
- **Visual grounding** - Images shown alongside text responses
- **Citation support** - References to specific document sections
- **Multi-format support** - Text, images, and layout information combined

---

### ?? **4. Enterprise-Grade Security and Access Control**

#### The Security Challenge of Intelligent Retrieval
**The Problem:**
> "An interesting effect of all this super-smart retrieval systems and the copilots we build on top of them is that they'll find everything."

**Enterprise Requirements:**

- **Access control propagation** - Document permissions must flow through AI systems
- **Identity integration** - Enterprise identity systems must control AI access
- **Group membership** - Dynamic group changes affecting document visibility
- **Audit trails** - Compliance and security monitoring requirements

#### Native Entra ID Integration
**Announcement: Document-Level Access Control**
- **Automatic group expansion** - Dynamic membership resolution
- **User-scoped indexing** - Search results filtered by user permissions
- **RBAC integration** - Azure role-based access control support
- **Zero manual configuration** - Automatic security policy enforcement

**Implementation Architecture:**
```
Document ACLs ? Azure AI Search ? User Token ? Filtered Results
??? User IDs field
??? Groups field  
??? RBAC roles field
```

#### Live Security Demo
**Access Control in Action:**

- **Document creation** - Three documents with different permission sets
- **User authentication** - Application identity with user token delegation
- **Filtered results** - Only accessible documents returned
- **Dynamic enforcement** - Real-time permission checking

#### Advanced Security: Sensitivity Labels
**Microsoft Purview Integration (Private Preview):**

- **Document encryption** - Automatic handling of encrypted documents
- **Policy enforcement** - Sensitivity label policy compliance
- **Organizational protection** - Document classification and handling rules
- **End-to-end security** - From document creation to AI response

---

### ?? **5. Data Integration and Pipeline Innovation**

#### Logic Apps Integration for External Data
**Challenge:** Enterprise data exists beyond Azure ecosystem
**Solution:** Azure AI Search + Logic Apps partnership

**OneDrive for Business Example:**
1. **Azure Portal wizard** - Simplified integration setup
2. **Logic Apps workflow** - Automated data ingestion and processing
3. **Change tracking** - Continuous synchronization with source systems
4. **Vectorization pipeline** - Automatic embedding generation and indexing

#### Comprehensive Data Source Support
**Native Azure Integration:**

- **Blob Storage** - Document and file processing
- **OneLake** - Microsoft Fabric data lake integration
- **Azure SQL Database** - Structured data indexing
- **Cosmos DB** - NoSQL document processing

**External Source Integration:**

- **OneDrive/SharePoint** - Microsoft 365 document systems
- **Third-party systems** - Through Logic Apps connectors
- **Custom APIs** - Extensible integration patterns

#### Azure Data Lake Storage Gen2 ACL Propagation
**Automatic Permission Flow:**

- **Source ACL detection** - Native ADLS Gen2 access control lists
- **Permission propagation** - Automatic transfer to search index
- **User/group mapping** - Entra ID integration throughout pipeline
- **Zero-touch security** - No manual permission configuration required

---

### ?? **6. Model Context Protocol and Developer Experience**

#### MCP Integration for Agent Development
**Azure MCP Server Capabilities:**

- **Resource management** - Azure resource groups and services
- **Service integration** - SQL, Azure Monitor, Cosmos DB, Azure AI Search
- **Developer-focused** - Tools for development workflows
- **Self-describing APIs** - Enhanced agent interaction capabilities

#### Agent-Driven Development Demo
**Intelligent Application Generation:**
**Query:** "Build me a Next.js app for outdoor gear using my Azure Search index"

**Automated Results:**

- **Schema analysis** - Automatic index structure discovery
- **Data sampling** - Understanding actual content patterns
- **UI generation** - Complete application with faceted navigation
- **Branding decisions** - Logos and visual design choices
- **Search integration** - Functional search interface with filtering

**Developer Productivity Gains:**

- **Zero manual UI development** - Complete application from description
- **Facet exploitation** - Automatic use of searchable/filterable fields
- **Metadata utilization** - Index descriptions driving application behavior
- **API integration** - Functional search capabilities without manual coding

---

## Technical Architecture Deep Dive

### Knowledge Agent Abstraction
**Up-Leveled API Design:**
```python
# Traditional Search API
search_client.search(
    query="tents",
    search_fields=["title", "description"],
    vector=embedding,
    top_k=10
)

# Knowledge Agent API  
knowledge_agent.retrieve(
    chat_history=[...],
    context="outdoor gear shopping",
    model="gpt-4o"
)
```

**Architectural Benefits:**

- **Higher abstraction** - Chat history instead of field specifications
- **Automatic optimization** - AI-driven query planning and execution
- **Policy integration** - Built-in access control and security
- **Extensible foundation** - Room for continuous innovation

### Multi-Modal Processing Pipeline
**Document Intelligence Integration:**
```
PDF Input ? Layout Extraction ? Image Identification ? 
Verbalization (GPT-4o) ? Text Indexing ? Vector Generation ? 
Component Storage ? Addressable References
```

**Processing Options:**

- **Simple extraction** - Basic text and image separation
- **Full AI Document Intelligence** - Complete layout and structure analysis
- **Image verbalization** - LLM-powered image description
- **Hybrid approaches** - Combined embedding and description strategies

### Security Architecture
**Document-Level Access Control:**
```json
{
  "id": "doc1",
  "content": "Sensitive financial data...",
  "users": ["user1@contoso.com"],
  "groups": ["finance-team", "executives"],
  "roles": ["Storage Blob Data Reader"]
}
```

**Query-Time Enforcement:**

- **Token delegation** - Application identity with user context
- **Dynamic filtering** - Real-time permission checking
- **Group expansion** - Automatic membership resolution
- **RBAC integration** - Azure role-based access control

---

## Performance Metrics and Validation

### Agentic Retrieval Effectiveness
**Complex Query Performance:**

- **40% improvement** in answer relevance for difficult questions
- **30% increase** in successful result rate
- **Multi-industry validation** - Finance, manufacturing, multiple sectors
- **Multi-language testing** - Global deployment readiness

**Query Type Analysis:**

- **Simple queries** - Maintained existing performance levels
- **Multi-hop questions** - Significant improvement in accuracy
- **Complex scenarios** - Material quality gains across all datasets
- **Groundedness** - No regression in hallucination prevention

### Multi-Modal Processing Benefits
**Document Coverage Expansion:**

- **Visual information** - Previously inaccessible diagram content
- **Layout understanding** - Structural relationships preserved
- **Component addressability** - Individual elements citeable
- **Application-ready** - Immediate integration with existing systems

---

## Live Demonstration Results

### Agentic Retrieval in Action
**Complex Query Processing:**
```
Input: "Which tent fits more people?" (with context about TrailMaster vs SkyView)
Processing:
??? Query Planning: Understand comparative capacity question
??? Context Analysis: Previous discussion about specific tent models  
??? Query Decomposition: Two separate capacity searches
??? Parallel Execution: TrailMaster capacity + SkyView capacity
??? Result Synthesis: Comparative capacity information

Output: Structured comparison with capacity details and citations
```

### Multi-Modal Document Processing
**Azure Search Documentation Analysis:**

- **Input:** Technical PDFs with diagrams and text
- **Processing:** AI Document Intelligence + Image Verbalization
- **Output:** Searchable text + addressable images + layout information
- **Application:** Functional Q&A with visual grounding and citations

### Security Enforcement
**Access Control Validation:**
```
Document Set:
??? Doc 1: User has direct access ? Visible
??? Doc 2: User lacks permission ? Hidden
??? Doc 3: User via group membership ? Visible

Search Results: Only documents 1 and 3 returned
```

### Agent-Driven Development
**Application Generation:**

- **Input:** "Build outdoor gear app with my search index"
- **Analysis:** Automatic schema discovery + data sampling
- **Output:** Complete Next.js application with search, facets, branding
- **Result:** Functional e-commerce interface without manual development

---

## Session Highlights

> *"We started with whatever elements we had in the room and we're transitioning to a purpose-built system."* - Pablo Castro

> *"The reality is that if you think about how RAG was constructed at that point... it was built out of the tools available in the room."* - Pablo Castro

> *"What we are announcing today is what we call agentic retrieval... applying the same methods we use to create agents out there in our own search engine."* - Pablo Castro

> *"An interesting effect of all this super-smart retrieval systems and the copilots we build on top of them is that they'll find everything. So it becomes super important that you have proper access control policies."* - Pablo Castro

> *"I'm highly incompetent in anything that has to do with UI, so I would've never been able to do something like this."* - Pablo Castro (on agent-generated application)

---

## Implementation Guide

### Getting Started with Agentic Retrieval

#### 1. Knowledge Agent Creation
```python
# Create Knowledge Agent
knowledge_agent = search_client.create_knowledge_agent(
    name="product_agent",
    data_sources=["contoso_products_index"],
    model="gpt-4o",
    policy={
        "relevance_threshold": 0.7,
        "max_queries": 5
    }
)

# Use Agent for Retrieval
response = knowledge_agent.retrieve(
    chat_history=[
        {"role": "user", "content": "What are popular tents?"},
        {"role": "assistant", "content": "TrailMaster and SkyView..."},
        {"role": "user", "content": "Which fits more people?"}
    ]
)
```

#### 2. Multi-Modal Document Processing
```markdown
**Portal Setup Process:**
1. Import and Vectorize Data wizard
2. Select data source (Blob Storage, OneLake, etc.)
3. Enable AI Document Intelligence
4. Configure image verbalization with GPT-4o
5. Set up embedding model for vectorization
6. Enable Knowledge Store for component addressability
7. Configure Semantic Ranker for quality improvement
```

#### 3. Access Control Implementation
```python
# Document with Access Control
document = {
    "id": "secure_doc_1",
    "content": "Confidential business information...",
    "users": ["alice@contoso.com"],
    "groups": ["finance_team", "management"],
    "roles": ["Storage Blob Data Reader"]
}

# Query with User Context
results = search_client.search(
    query="quarterly results",
    user_token=user_access_token  # Automatic permission filtering
)
```

### Best Practices for Enterprise Deployment

#### Data Pipeline Optimization
- **Use AI Document Intelligence** for complex multi-modal documents
- **Enable image verbalization** when visual content contains critical information
- **Configure Knowledge Store** for application integration and citation support
- **Set up incremental indexing** for continuous data synchronization

#### Security Configuration
- **Map existing ACLs** from source systems to search index fields
- **Use managed identity** for secure service-to-service communication
- **Enable Entra ID integration** for automatic group expansion
- **Test permission propagation** with representative user scenarios

#### Performance Tuning
- **Use Semantic Ranker** for improved result quality
- **Configure relevance thresholds** based on application requirements
- **Monitor agentic retrieval costs** vs. traditional search approaches
- **Implement caching strategies** for frequently accessed content

---

## Advanced Applications

### Enterprise RAG Architecture
**Comprehensive Implementation Stack:**
```
Application Layer: Copilot/Agent Interface
??? Agentic Retrieval: Complex query processing
??? Multi-Modal Processing: Document + visual understanding  
??? Access Control: Entra ID integration
??? Data Integration: Logic Apps + native connectors
??? Foundation: Azure AI Search with semantic ranking
```

### Development Acceleration
**MCP-Enabled Workflows:**

- **Automatic application generation** from search index schemas
- **Schema discovery** and data pattern recognition  
- **UI component optimization** based on facetable fields
- **Citation and reference** system integration

### Security and Compliance
**Enterprise-Grade Features:**

- **Document-level access control** with dynamic group membership
- **Sensitivity label support** for classified content
- **Audit trail integration** for compliance reporting
- **RBAC policy enforcement** across AI-powered systems

---

## Resources and Links

### Official Documentation
- **[Agentic Retrieval Announcement](https://aka.ms/agentrag)** - Complete technical overview and implementation guide
- **[Agentic Retrieval Evaluation Results](https://aka.ms/aisearch-arevals)** - Detailed performance metrics and methodology
- **[Multi-Modal Updates](https://aka.ms/Build25/aisearch-multim)** - Document processing and AI integration features
- **[What's New in Azure AI Search](https://aka.ms/AISearch-new)** - Comprehensive feature updates and roadmap

### Sample Code and Demos  
- **[Agentic Retrieval Demo](https://aka.ms/ragchat)** - Working implementation of knowledge agents
- **[Multi-Modal Demo](https://aka.ms/aisearch-multimodal)** - Document processing with visual content
- **[Azure MCP Repository](https://aka.ms/azure-mcp)** - Model Context Protocol server for Azure services
- **[Foundry MCP Server](https://aka.ms/foundry-mcp)** - AI Foundry integration examples

### Security and Compliance
- **[Private Preview: Sensitivity Labels](https://aka.ms/AISearch-senslabels)** - Enterprise document classification support

---

## About the Speaker

**Pablo Castro**  
CVP & Distinguished Engineer, AI Platform  
Microsoft  
*Corporate Vice President leading Azure AI Search team with focus on state-of-the-art information understanding and retrieval systems. Expert in information retrieval, machine learning, distributed systems, and database systems. Co-founder of Lagash Systems (acquired by Mercado Libre).*

---

*This session reveals the transformation of enterprise AI from simple RAG implementations to sophisticated, purpose-built knowledge retrieval systems that understand context, process multi-modal content, and enforce enterprise security policies. Pablo Castro demonstrates how Azure AI Search has evolved beyond traditional search into an intelligent knowledge platform that powers the next generation of enterprise AI applications.*

