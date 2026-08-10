# Day 84 — Interview Preparation: DevOps Fundamentals + Git, AWS (Core + Advanced)

**Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90) | **Target:** 10+ LPA / 3+ years experience bar

---

## 🎯 Today's Focus

Continued the senior-calibrated interview-prep stretch — **DevOps Fundamentals + Git**, then the full **2-day AWS block** (Core Services + Advanced Security & Architecture). Same format as every prior day: **20 Basic + 10 Advanced + 10 Scenario (STAR format)** per topic, every question sourced from real interview experiences or verified 2026 question banks — sources noted under each question in the docs.

---

## 📋 Topics Covered

### 1. DevOps Fundamentals + Git (`Day5_DevOpsFundamentals_Git_Interview_Prep.docx`)
- **Basic (20):** CI/CD/Continuous Deployment, merge vs rebase, merge conflict resolution, branching strategies (GitFlow vs GitHub Flow vs trunk-based), **DORA metrics**, **GitOps**, monitoring vs observability
- **Advanced (10):** DORA performer tiers (elite/high/medium/low actual benchmarks), trunk-based vs GitFlow trade-off, secrets-management "wrong answer that fails interviews," GitOps reconciliation loop mechanism, SLI/SLO alerting strategy, blameless postmortem process
- **Scenario (10):** hardcoded secret in Git, merge conflict walkthrough, rebased-shared-branch recovery, targeted rollback with `revert`, GitOps drift correction, improving a team's DORA metrics, running a blameless postmortem, fixing painful merge conflicts via trunk-based migration

### 2. AWS Core Services (`Day6_AWS_Core_Interview_Prep.docx`)
- **Basic (20):** EC2 pricing models, S3 storage classes, IAM Role vs User, VPC building blocks, RDS, CloudWatch vs CloudTrail, Lambda, ECS vs EKS vs Fargate, Auto Scaling, ALB vs NLB
- **Advanced (10):** AWS Well-Architected Framework's 6 pillars, multi-account network design (Transit Gateway), SCPs vs IAM policies, Control Tower, Shared Responsibility Model trade-offs
- **Scenario (10):** S3 Access Denied debugging, NAT Gateway failure, least-privilege CI/CD setup, CloudWatch alarm misconfiguration, cost optimization, RDS read scaling, Lambda throttling, DR budget trade-offs, VPC DNS issues, cost-anomaly investigation

### 3. AWS Advanced — Security & Architecture (`Day7_AWS_Advanced_Security_Architecture_Interview_Prep.docx`)
- **Basic (20):** KMS, GuardDuty, WAF, Security Hub, CloudFront, SSM Session Manager vs Bastion/SSH, Parameter Store vs Secrets Manager, Trusted Advisor
- **Advanced (10):** secure data-pipeline design, multi-tenant SaaS isolation patterns, Route 53 failover vs active-active, SCP vs AWS Config rules, zero-downtime credential rotation, compliance/data-residency architecture
- **Scenario (10):** GuardDuty incident response, public-S3-bucket audit failure, Multi-AZ failover DNS-caching bug, Lambda least-privilege right-sizing, zero-downtime secrets migration, cross-account vendor access, orphaned Elastic IP cleanup, Security Hub regression tracing, org-wide SCP governance, DR-drill RTO reality check

---

## 💡 Key Takeaway

Git and AWS interviews at the senior level stop rewarding "I know the command" the moment the interviewer asks *why*. The real signal is trade-off reasoning: revert vs reset in production, trunk-based vs GitFlow, SCP vs IAM policy, Multi-AZ vs Read Replica — each pair solves a different problem, and confusing them is the fastest way to sound junior despite knowing the syntax.

---

## 📁 Reference

- `Day5_DevOpsFundamentals_Git_Interview_Prep.docx`
- `Day6_AWS_Core_Interview_Prep.docx`
- `Day7_AWS_Advanced_Security_Architecture_Interview_Prep.docx`

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*
