# Essential AI Prompts for Developers: 4 Strategies to Make AI Work Super Hard for You

**Session Date:** May 22, 2025  
**Duration:** 15 minutes  
**Venue:** Build 2025 Conference - DEM509  
**Speaker:** Burke Holland (Developer Advocate, Microsoft)  
**Link:** [Microsoft Build 2025 Session DEM509]

![AI Prompting Strategies](images/essential-ai-prompts-developers.png)

---

## Executive Summary

This fast-paced session delivers four powerful AI prompting strategies that transform how developers interact with AI tools like GitHub Copilot. Burke Holland demonstrates practical techniques for getting better results from AI through strategic prompt engineering, moving beyond basic completions to sophisticated collaborative workflows. The strategies are applicable not just for programming, but for any task where AI assistance can improve productivity and outcomes.

---

## Key Topics Covered

### ?? **1. The Foundation: Talk, Don't Type**

#### Voice-First AI Interaction
**Core Principle:** "You don't have to be articulate - you can literally just verbally vomit into the chat what you want and it will pull out the context."

**Key Benefits:**
- **Natural communication** - No need for perfect grammar or structured writing
- **Faster input** - Speech recognition allows rapid idea expression
- **Local processing** - Modern speech models run locally for instant response
- **Context extraction** - AI excels at parsing meaning from casual conversation

**Technical Implementation:**
- **Built-in speech recognition** in VS Code and GitHub Copilot
- **Real-time transcription** with high accuracy
- **Context awareness** from conversational input patterns

---

### ?? **2. Strategy 1: The Q&A Prompt**

#### Problem-Solving Through Reverse Questioning
**Use Case:** Project structure organization and architectural decisions

#### Live Demonstration: Project Structure Optimization
**Challenge:** Messy, unstructured project that "looks like a junk drawer"

**The Q&A Prompt Pattern:**
```
"Hey there, how's it going? Listen up here, I got this project 
over here that has like no structure. It's kind of a mess. 
And so I need like a recommended file or folder structure 
for this mug and I need you to give that to me. 
But before you do that, could you please ask me 5 yes or 
no questions that will help you make a better recommendation."
```

#### Enhanced Context Integration
**The @codebase Modifier:**
- **File system analysis** - AI scans existing project structure
- **Intelligent questioning** based on actual codebase content
- **Technology detection** - Recognizes frameworks and patterns

**Example Q&A Flow:**
1. "Are you planning to follow a model-view-controller pattern?" ? Yes
2. "Do you need to handle authentication?" ? Yes  
3. "Do you plan to implement API endpoints?" ? No
4. "Will you be using automated tests?" ? No ("You kidding me?")
5. "Are you planning to include middleware?" ? Yes

#### Implementation and Automation
**Recommended Structure Generated:**
- `/config` - Configuration files
- `/controllers` - MVC controller logic
- `/middleware` - Request processing middleware
- `/models` - Data models and schemas
- `/routes` - API route definitions
- `/services` - Business logic services
- `/types` - TypeScript type definitions

**Script Generation Request:**
```
"Totes Magotes. That is a dope structure. There's nothing about 
it that I don't love. Could you just give me a single script 
that will generate that structure? Don't create any of the files 
though. I just want the folders and then you can just move the 
existing files that I have into the right spots."
```

**Practical Results:**
- **Automated folder creation** via shell script
- **Executable permissions** handling (`chmod +x`)
- **Immediate project organization** improvement

#### Key Benefits of Q&A Prompting
- **Context-driven recommendations** rather than generic solutions
- **Interactive refinement** of requirements
- **Reduced cognitive load** on architectural decisions
- **Automated implementation** of recommendations

---

### ?? **3. Strategy 2: The Pros and Cons Prompt**

#### Multi-Option Analysis for Better Decision Making
**Core Philosophy:** "In programming, there's never one right way to do anything, even though you read a lot of blog posts that tell you otherwise."

#### The Problem with Direct Questions
**AI Tendency:** Models are "tuned to give you an answer" - they provide single solutions rather than exploring alternatives.

#### Live Demonstration: Database Injection Pattern
**Technical Context:** Preventing multiple database connection instantiations

**The Pros and Cons Prompt:**
```
"Sup bro, I'm back. Yo, listen, new sitch here. What's going 
on is I got a database file and I want to just inject it 
once into the application. Like I don't want to instantiate 
that mug every single time I use it. What is the best way 
to do that? Actually give me several options and give me 
the pros and cons of each."
```

#### Comprehensive Solution Analysis
**Option 1: Module-Level Singleton**
- **Pros:** Simple implementation, automatic lazy loading
- **Cons:** Global state, potential testing complications

**Option 2: Classical Singleton Pattern**
- **Pros:** Controlled instantiation, thread-safe options
- **Cons:** More complex implementation, potential bottlenecks

**Option 3: Dependency Injection Container**
- **Pros:** Testable, configurable, follows SOLID principles
- **Cons:** Framework dependency, learning curve

#### Implementation Selection and Execution
**Selection Process:**
```
"Dope sauce. I like #2 a whole lot. Why don't you go ahead 
and implement that? And then you're going to need to update 
the places in my project where this file is being used to 
make sure that everything is copacetic."
```

**Agent Mode Integration:**
- **Automatic code analysis** - Finds all usage locations
- **Comprehensive refactoring** - Updates imports and instantiation
- **Consistency validation** - Ensures pattern implementation across codebase

#### Benefits of Pros and Cons Strategy
- **Informed decision-making** with full context of trade-offs
- **Multiple implementation paths** revealed upfront
- **Reduced regret** from choosing suboptimal solutions
- **Educational value** - Understanding why certain patterns are preferred

---

### ?? **4. Strategy 3: The Stepwise Chain of Thought**

#### Controlling Refactoring Complexity
**Problem Statement:** "Refactors are usually multiple steps, and the next step depends on what you just previously did. The model tends to get confused."

#### The Challenge with Multi-Step Operations
**Traditional AI Behavior:**
- **All-at-once approach** - Attempts complete refactoring in single response
- **Context confusion** - Loses track of incremental changes
- **Overwhelming output** - Difficult to review and validate changes

#### The Stepwise Solution
**Incremental Control Pattern:**
```
"Hey, listen, I want to refactor this file. And what I want 
you to do is move one step at a time. So let's just move 
incrementally through this refactor and do not move to the 
next step until I give you the keyword banana."
```

#### Live Demonstration: Security and Architecture Refactoring
**Step 1: Security Vulnerability Identification**
- **Issue detected:** SQL injection vulnerability in vehicle service
- **Recommendation:** Parameterized queries implementation
- **Control point:** Awaiting "banana" keyword for continuation

**Developer Dialogue and Alternatives:**
```
"Parameterized queries are kind of clunky. Is there some 
other way that we can do this? Should I be using an ORM 
or something?"
```

**Step 2: ORM Evaluation**
- **Alternative suggestion:** Prisma ORM implementation
- **Installation requirements** - Dependencies and setup steps
- **Architecture implications** - Database layer abstraction

**Controlled Progression:**
- **Keyword activation:** "banana" ? moves to next implementation step
- **Incremental validation** - Review each change before proceeding
- **Flexibility maintained** - Can pivot or refine at each stage

#### Best Practices for Stepwise Prompting
**Keyword Selection:**
- **Unique terms** - Avoid words commonly used in code
- **Memorable phrases** - Easy to remember during development sessions
- **Context-independent** - Works across different problem domains

**Benefits of Stepwise Approach:**
- **Controlled pacing** - Developer maintains oversight of changes
- **Quality assurance** - Each step can be validated before proceeding
- **Learning opportunity** - Understanding incremental improvement patterns
- **Reduced errors** - Prevents cascading mistakes from rushed implementations

---

### ?? **5. Strategy 4: The Role Play Prompt**

#### Leveraging AI's Role-Playing Capabilities
**Core Insight:** "Models really, really, really like to role play. If you tell them that they're good at something, they're just magically good at that thing."

#### The Psychology of AI Role Assignment
**Why Role Playing Works:**
- **Performance enhancement** - AI models respond to identity assignments
- **Expertise simulation** - Adopts characteristics of specified roles
- **Behavioral modification** - Changes response patterns based on assigned personality
- **Context specialization** - Focuses capabilities on domain-specific knowledge

#### Live Demonstration: AI as Expert Instructor
**Role Assignment:**
```
"You are the greatest instruction instructor in the world. 
You're almost as good as James Montemagno. Not quite close, 
close to being as good as James Montemagno. And the reason 
you're so good is that you give your students creative 
exercises so that they can learn by doing. And your class 
is the most popular class in school. Everyone loves it."
```

**Educational Method Specification:**
```
"And today you're teaching a class on regex. Go ahead and 
start the class, move one exercise at a time. And if the 
student gets the answer wrong, don't give them the answer, 
but go ahead and give them a suggestion that helps move 
them towards the correct answer."
```

#### Interactive Learning Session
**Teaching Approach:**
- **Progressive difficulty** - Starting with phone number pattern matching
- **Guided discovery** - Hints rather than direct answers
- **Practical exercises** - Real-world pattern recognition challenges
- **Encouraging feedback** - "We're getting closer" rather than criticism

**Example Interaction Flow:**
1. **Exercise:** "Write a regex pattern that matches phone numbers in format XXX-XXX-XXXX"
2. **Student attempt:** Literal string instead of regex pattern
3. **AI guidance:** "That looks like the test string itself, not a regex pattern. To create a regex, we need to wrap it in / and for digits, use \d"
4. **Iterative refinement** continues until mastery achieved

#### Versatile Role Applications
**Educational Contexts:**
- **Technology tutorials** - Learning new programming languages (Rust example)
- **Code review sessions** - Senior developer perspective on code quality
- **Architecture discussions** - System design expert guidance
- **Debugging assistance** - QA engineer mindset for testing strategies

**Professional Simulation:**
- **Client consultation** - Business analyst gathering requirements  
- **Technical interviews** - Practicing problem-solving explanations
- **Peer programming** - Collaborative development scenarios
- **Mentorship sessions** - Junior developer guidance and support

#### Benefits of Role Play Strategy
- **Enhanced AI performance** through identity assignment
- **Specialized knowledge access** - Domain expertise simulation
- **Interactive learning** - Engaging educational experiences
- **Customizable expertise** - Tailored to specific learning objectives

---

## Technical Implementation Details

### GitHub Copilot Integration Patterns

#### Multi-Mode Utilization
**Ask Mode:**
- **Information gathering** and strategy development
- **Analysis and recommendation** generation
- **Script and documentation** creation

**Agent Mode:**
- **Autonomous code implementation** based on specifications
- **Multi-file refactoring** with consistency validation
- **Project-wide pattern** application

**Edit Mode:**
- **Targeted code modifications** with surgical precision
- **Context-aware suggestions** based on cursor position
- **Real-time collaboration** during active development

#### Context Management Strategies
**Chat Clearing Discipline:**
- **Regular context reset** - "Clear the chat like all the time"
- **Topic isolation** - Separate conversations for different problems
- **Context accumulation** - Intentional conversation threading for complex problems

**Codebase Context Integration:**
- **@codebase modifier** - File system analysis integration
- **Active file context** - Current editor state awareness  
- **Project structure understanding** - Framework and pattern detection

### Voice Recognition and Natural Language Processing

#### Local Speech Model Performance
- **Real-time transcription** with high accuracy
- **Conversational input handling** - Casual speech patterns supported
- **Context extraction** from unstructured verbal input
- **Multi-language support** for international developers

#### Communication Optimization
- **Verbal brainstorming** - Stream of consciousness input processing
- **Technical terminology** - Programming concepts in natural language
- **Iterative refinement** - Conversational back-and-forth optimization

---

## Practical Application Examples

### Project Organization Automation
**Before State:** Unstructured files in root directory, no clear organization pattern
**After State:** Professional MVC structure with:
- Logical separation of concerns
- Automated folder generation
- File organization recommendations
- Scalable architecture foundation

### Database Pattern Implementation
**Challenge:** Manual database connection management across multiple files
**Solution:** Singleton pattern implementation with:
- Centralized instance management
- Performance optimization
- Consistent usage patterns
- Refactored existing code integration

### Interactive Learning Systems
**Traditional Approach:** Static documentation and tutorials
**AI-Enhanced Learning:**
- **Personalized pacing** based on comprehension level
- **Interactive exercises** with guided discovery
- **Immediate feedback** and course correction
- **Progressive difficulty** adjustment

---

## Session Highlights

> *"You don't have to be articulate - you can literally just verbally vomit into the chat what you want and it will pull out the context."* - Burke Holland

> *"In programming, there's never one right way to do anything, even though you read a lot of blog posts that tell you otherwise."* - Burke Holland

> *"Models really, really, really like to role play. If you tell them that they're good at something, they're just magically good at that thing."* - Burke Holland

> *"Remember, everyone is just one prompt away from being independently wealthy."* - Burke Holland (closing humor)

> *"Why should I do it when you can do it?"* - Burke Holland (on automation philosophy)

---

## Implementation Guide

### Getting Started with Advanced Prompting

#### 1. Q&A Prompt Implementation
```markdown
**Template:**
"[Casual greeting] I have [problem description]. I need [desired outcome]. 
But before you do that, could you please ask me [X number] questions 
that will help you make a better recommendation."

**Enhancement:** Add @codebase for project context
**Follow-up:** Request implementation scripts for automation
```

#### 2. Pros and Cons Analysis
```markdown
**Template:**
"[Problem context] What is the best way to [objective]? 
Actually give me several options and give me the pros and cons of each."

**Selection:** Choose preferred option and request implementation
**Integration:** Use Agent Mode for comprehensive refactoring
```

#### 3. Stepwise Chain of Thought
```markdown
**Template:**
"I want to [complex task]. Move one step at a time. 
Do not move to the next step until I give you the keyword [unique_word]."

**Control:** Use unique keywords (like "banana") for progression
**Validation:** Review each step before continuing
```

#### 4. Role Play Specification
```markdown
**Template:**
"You are [role description with expertise level]. 
You're [personality/teaching characteristics]. 
Today you're [specific task context]. 
[Behavioral guidelines and interaction rules]."

**Customization:** Tailor expertise and personality to learning objectives
**Interaction:** Engage in character-appropriate dialogue patterns
```

### Best Practices for AI Collaboration

#### Communication Strategies
- **Voice-first interaction** for natural expression
- **Iterative refinement** through conversational feedback
- **Context preservation** through strategic chat management
- **Multiple approaches** evaluation before implementation

#### Quality Assurance
- **Step-by-step validation** of complex operations
- **Multiple option analysis** for critical decisions
- **Role-based expertise** verification of recommendations
- **Automated testing** of generated code and scripts

#### Workflow Integration
- **Multi-mode utilization** (Ask ? Agent ? Edit progression)
- **Context switching** management for different problem types
- **Documentation generation** alongside implementation
- **Knowledge transfer** through interactive teaching sessions

---

## Advanced Applications Beyond Programming

### Creative Problem Solving
- **Business strategy** development with pros/cons analysis
- **Content creation** with role-playing expert perspectives
- **Learning acceleration** through personalized AI tutoring
- **Decision making** enhancement through structured questioning

### Professional Development
- **Skill acquisition** via AI mentorship simulation
- **Interview preparation** through role-playing scenarios
- **Technical communication** improvement via teaching practice
- **Leadership development** through strategic consultation simulation

### Team Collaboration
- **Requirements gathering** through Q&A facilitation
- **Code review** enhancement with multiple perspectives
- **Architecture discussions** with simulated expert input
- **Knowledge sharing** through interactive documentation

---

## About the Speaker

**Burke Holland**  
Developer Advocate  
Microsoft  
*Front-end developer and VS Code team member specializing in developer experience and productivity tools. Known for combining technical expertise with humor and practical insights. Active in the JavaScript and AI development communities.*

---

*This session demonstrates that effective AI collaboration requires strategic prompting techniques that leverage the unique capabilities of large language models. By understanding how to communicate effectively with AI through Q&A, pros/cons analysis, stepwise progression, and role playing, developers can transform AI from a simple autocomplete tool into a sophisticated collaborative partner.*