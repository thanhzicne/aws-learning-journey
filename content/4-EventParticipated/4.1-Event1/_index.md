---

title: "Event 1"
date: 2026-06-08
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

## Reflection Report: FCAJ Community Day

### Event Overview

**FCAJ Community Day** was a community-driven event organized by **First Cloud A Journey (FCAJ)**, bringing together nearly 400 participants at the 26th floor of **Bitexco Financial Tower**, Ho Chi Minh City. The event provided a valuable opportunity for learning and networking, where speakers from the community—including students and industry professionals—shared practical knowledge about AI, Cloud Computing, and modern technologies.

One of the most distinctive aspects of the event was its **"by the community, for the community"** spirit. The speakers were not distant experts but people who had experienced similar learning journeys, making the sessions more relatable, practical, and inspiring.

---

### Objectives of the Event

* Connect members of the First Cloud Journey community who are learning and practicing AWS in Vietnam.
* Share practical insights on AI, Cloud Computing, and modern technologies from experienced practitioners.
* Inspire and guide students and young developers pursuing careers in cloud computing.
* Promote peer-to-peer learning where knowledge is shared collaboratively rather than through traditional top-down teaching.
* Strengthen and expand the AWS community ecosystem in Vietnam.

---

### Event Information

| Information | Details |
| --- | --- |
| **Event Name** | FCAJ Community Day |
| **Organized By** | Huỳnh Hoàng Long, Thiện Lữ & Trần Đại Vĩ |
| **Location** | 26th Floor, Bitexco Financial Tower, 2 Hai Trieu Street, District 1, Ho Chi Minh City |
| **Number of Participants** | Approximately 399 attendees |
| **Time** | 09:00 – 12:00, May 23, 2026 |
| **Language** | Vietnamese |

---

### Session Schedule

| Time | Topic | Main Content |
| --- | --- | --- |
| 08:30 – 09:00 | Check-in | Participant registration and seating |
| 09:00 – 09:30 | Context Is Everything | Making AI Actually Work for You |
| 09:30 – 09:45 | Friendly AI Assistant | Amazon QuickSight Q |
| 09:45 – 10:25 | From Edge To Origin | CloudFront as Your Foundation |
| 10:25 – 10:55 | 36 hrs with LotusHacks | Building UTMorpho from Idea to Reality |
| 10:55 – 11:00 | Break | Short break |
| 11:00 – 11:30 | Non-Determinism of LLM | Understanding "Deterministic" Settings |
| 11:30 – 12:00 | Multi-Agent System | Enterprise Credit Scoring Case Study |

---

### Detailed Session Notes

#### Session 1: Context Is Everything – Making AI Actually Work for You (09:00 – 09:30)

The speaker addressed a common question: **Why does AI often produce poor results?** The answer is usually not the AI itself, but rather the lack of context provided by users.

**Why AI Fails:**

* Short and generic prompts often lead to generic responses with limited practical value.
* Missing background information, objectives, and constraints prevent AI from delivering optimal results.

**What Context Really Means:**

* Context includes the role assigned to AI, specific goals, constraints, examples, and conversation history.
* The concept of a **Second AI Brain** was introduced, emphasizing the importance of building a long-term knowledge system rather than treating each interaction as an isolated conversation.

**Evolution of AI Usage:**

* Stage 1: Using simple prompts with inconsistent outcomes.
* Stage 2: Learning how to create structured prompts.
* Stage 3: Building sustainable context systems that allow AI to understand users over time.

---

#### Session 2: Friendly AI Assistant with Amazon QuickSight Q (09:30 – 09:45)

Key features introduced:

* **Quick Chat Agent:** Explore datasets using natural language without writing SQL.
* **Quick Flows:** Build intelligent workflows through natural language descriptions without coding.
* **Quick Spaces:** Collaborative environments for sharing insights across teams and reducing data silos.
* **QuickSight Dashboards:** Create dashboards directly from raw data using natural language, with AI recommending suitable visualizations automatically.

---

#### Session 3: From Edge To Origin – CloudFront as Your Foundation (09:45 – 10:25)

The session highlighted that CloudFront is not merely a CDN but a comprehensive platform for modern workloads.

**Cost Optimization:**

* **Price Class** selection based on target user regions.
* Improving **cache hit ratio** to reduce origin requests and lower costs.
* **Origin Shield** for centralized caching before reaching the origin.
* Automatic **Gzip** and **Brotli** compression to reduce bandwidth usage.

**Security:**

* Integration with **AWS WAF**, **AWS Shield Standard/Advanced**, and **HTTPS/TLS 1.3**.
* Support for **Geo Restriction** and **Signed URLs/Cookies** for private content.
* **Origin Access Control (OAC)** to ensure that S3 buckets are only accessible through CloudFront.

**Performance & Reliability:**

* More than **600 edge locations** worldwide.
* Support for **HTTP/2** and **HTTP/3**.
* Built-in failover mechanisms, health checks, and retry logic.

---

#### Session 4: 36 hrs with LotusHacks – Building UTMorpho (10:25 – 10:55)

**UTMorpho** is an AI-powered personalized learning platform developed during a 36-hour hackathon.

**Key Takeaways:**

* Defining the MVP within the first two hours was the most critical decision.
* Knowing when to cut features helped maintain a stable and demonstrable product.
* Team communication under pressure was more important than technical skills alone.
* Hackathons are primarily about accelerating learning rather than simply winning.

---

#### Session 5: Non-Determinism of "Deterministic" LLM Settings (11:00 – 11:30)

**Common Misconception:** Setting Temperature to 0 does not guarantee identical outputs every time.

**Reasons for Non-Determinism:**

* Floating-point arithmetic on GPUs.
* Tensor parallelism across multiple GPUs.
* Load balancers routing requests to different server instances.
* Quantization techniques that reduce precision.

**Mitigation Strategies:**

* Seed control mechanisms.
* Output validation layers.
* Response caching systems.
* Designing systems that tolerate non-determinism rather than attempting to eliminate it completely.

---

#### Session 6: Enterprise-Grade Multi-Agent System – Startup Credit Scoring (11:30 – 12:00)

**Problem Statement:** Startups are often underserved by traditional banking systems because they lack extensive financial histories and possess intangible assets that are difficult to evaluate.

**Why Multi-Agent Systems?**

A single AI agent handling multiple domains may suffer from context overload, reduced accuracy, and poor maintainability.

**Virtual Credit Committee Architecture:**

* Data Collection Agent
* Financial Analysis Agent
* Market Intelligence Agent
* Team Assessment Agent
* Risk Scoring Agent
* Central Orchestrator

**Important Guardrails:**

* Mandatory explainability.
* Human-in-the-loop decision-making for critical cases.
* Comprehensive audit trails.
* Periodic bias detection and evaluation.

---

### Key Learnings

#### AI & Context Thinking

* **Context-first mindset:** AI output quality depends heavily on the quality of the provided context.
* **Second AI Brain concept:** Building persistent context systems improves long-term productivity.
* **LLMs are probabilistic, not deterministic:** Even with Temperature = 0, outputs may vary.
* **Multi-Agent thinking:** Complex problems benefit from specialized agents with clearly defined responsibilities.

#### AWS Architecture Knowledge

* **CloudFront as a platform:** Beyond CDN functionality, it provides security, intelligent routing, edge computing, and cost optimization.
* **OAC vs OAI:** OAC is the newer and more secure method for restricting S3 access through CloudFront.
* **Comprehensive caching strategies:** Proper TTL settings, invalidation strategies, Origin Shield, and cache optimization are essential for balancing performance and cost.

#### Product Mindset & Soft Skills

* **Done beats perfect:** A stable product with 80% of planned features is better than a feature-rich but unstable solution.
* **Communication under pressure:** Clear and frequent communication is critical when working under tight deadlines.
* **Scope management:** Knowing when to reject additional features and protect the MVP scope is a valuable skill.

---

### Practical Applications

* **Improving AI usage:** Provide complete context, system prompts, project background, technical constraints, and objectives before interacting with AI tools.
* **Production-ready CloudFront:** Properly configure OAC, optimize cache behaviors, enable compression, and consider Origin Shield for production workloads.
* **LLM integration awareness:** Temperature = 0 does not guarantee deterministic outputs; validation and caching mechanisms remain important.
* **Multi-Agent architecture:** For complex AI systems, assigning clear responsibilities to specialized agents improves testing, maintenance, and scalability.

---

### Event Experience

One of the most valuable aspects of the event was the community itself. The speakers were engineers, students, and professionals who had recently gone through similar learning journeys, making the discussions practical and highly relatable.

Beyond the technical knowledge gained from the sessions, the networking opportunities were equally valuable. Meeting people who share similar interests in AWS and cloud technologies created a sense of belonging and motivation, reinforcing the idea that learning does not have to be a solitary journey.

---

### Photos from the Event

> ![join_event2](/images/events/event1/join_event2.jpg)
>
> ![Session1](/images/events/event1/ss1.png)
>
> ![Session2](/images/events/event1/ss2.png)
>
> ![Session4](/images/events/event1/ss3.png)
>
> ![Session6](/images/events/event1/ss4.png)
>
> ![Session1](/images/events/event1/ss1.png)
>
> ![Session2](/images/events/event1/ss5.png)
>
> ![Session4](/images/events/event1/ss6.png)
>
> ![Session6](/images/events/event1/ss7.png)
>
> ![Session6](/images/events/event1/ss8.png)
