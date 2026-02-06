---
name: sow-creator
description: |
  Create professional Statement of Work (SOW) documents for Astrafy consulting projects.
  Use when user requests to create a SOW, statement of work, proposal, or project scope document.
  Outputs a .md file with the complete SOW. Supports multiple languages (English, Spanish, etc.).
  Excludes financial information. Asks clarifying questions to build the best document.
---

# SOW Creator Skill

Create professional Statement of Work documents for Astrafy consulting engagements.

## Workflow

### 1. Gather Required Information

Ask the user for:
- **Client name** (required)
- **Client website** (required) - Use WebSearch to research the company and write context
- **Project name/title** (required)
- **Project description** (required) - What problem are we solving? What's the goal?
- **Timeline** - Start date and duration
- **Detailed implementation plan** - Phases, milestones, deliverables
- **Language** - English (default) or Spanish

Ask detailed questions about deliverables. If user prefers high-level, adapt accordingly.

### 2. Research the Client

Use WebSearch with the client website to:
- Understand the company's business and industry
- Identify their challenges and context
- Write a compelling Executive Summary that speaks to their needs

### 3. Generate the SOW

Create a markdown file with this structure:

```markdown
# [Client Name]

## [Project Name]

## [Date]

# Executive Summary
[Compelling narrative about the client's situation and how the project addresses it]

# Scope of Services
## [Phase/Section 1]
[Detailed activities and deliverables]

## [Phase/Section 2]
[...]

# Success Criteria
[Auto-generated based on scope - measurable outcomes]

# Project Timeline
[Phases with dates/durations]

# Assumptions and Customer Responsibilities

## Our Assumptions
[Adapt from template below based on project type]

## Customer Responsibilities
[Adapt from template below based on project type]

# Out of Scope
[Suggest common exclusions + any user-specified items]

# Change Requests
[Standard change request table - see template]
```

### 4. Optional Sections (ask user if needed)

- **Team Bios** - Project team members and their expertise
- **References** - Similar past projects/case studies
- **Detailed Methodology** - Agile approach, communication framework
- **Training** - Knowledge transfer and enablement plan
- **Documentation** - What documentation will be delivered

## Templates

### Standard Assumptions

Adapt these based on project type:

**Infrastructure Access:** Customer provides timely access to existing infrastructure and systems required for the project.

**Documentation Availability:** Customer makes available existing documentation describing current architecture, systems, and procedures.

**Data/Schema Access:** Customer provides access to data schemas and definitions for relevant sources.

**Development Environment:** Customer provides access to a development environment for testing and validation.

### Standard Customer Responsibilities

**Providing Access:** Grant necessary access to infrastructure, data, and environments in a timely manner.

**Documentation Provision:** Supply architectural documentation and specifications as requested.

**Stakeholder Availability:** Ensure key technical and business stakeholders are available for meetings and approvals.

**Timely Feedback:** Provide prompt feedback and approvals to avoid project delays.

**Data Privacy and Security:** Ensure data provided complies with privacy regulations and security policies.

### Change Request Table

```markdown
| Field | Value |
| :---- | :---- |
| Date of Master Services Agreement | |
| Date of Change Request | |
| Name and Date of Impacted SOW | |
| Description of modified Services | |
| Description of modified Deliverables | |
| Impact on resources | |
| Impact on Project Timeline | |
| Effective Date of approval | |
```

### Common Out of Scope Items by Project Type

**Data Platform / dbt / BigQuery:**
- Ongoing managed services or post-go-live support
- Development of new business features unrelated to data platform
- Advanced analytics (predictive modeling, ML) unless specified
- Data quality remediation in source systems

**GCP Infrastructure:**
- Multi-region deployment (unless specified)
- Development of business applications
- Ongoing operations and maintenance
- Security penetration testing

**Looker / BI:**
- Advanced analytics beyond dashboards
- Data pipeline development (unless specified)
- Ongoing dashboard maintenance
- End-user training beyond basic operation

**AI/ML Migration:**
- Model retraining or continuous learning pipelines
- Integration with external systems (EHR, etc.)
- Advanced API access controls beyond basic auth
- Production monitoring beyond basic observability

## Important Rules

1. **Never include financial information** - No pricing, costs, payment terms, or Google Partner Funds
2. **No signature section** - Omit the signatures table
3. **Auto-generate success criteria** - Based on scope deliverables, make them measurable
4. **Adapt language** - Match user's preferred language throughout
5. **Use Astrafy branding** - Always reference "Astrafy" as the partner/provider

## Output

Save the SOW as a markdown file: `[ClientName] SoW for [ProjectName].md`
