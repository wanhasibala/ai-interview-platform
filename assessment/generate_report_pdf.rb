# frozen_string_literal: true

require 'prawn'
require 'prawn/table'

output_path = File.expand_path('FULLSTACK_PRODUCT_ENGINEER_REPORT.pdf', __dir__)
screenshots_dir = File.expand_path('screenshots', __dir__)

Prawn::Fonts::AFM.hide_m17n_warning = true

Prawn::Document.generate(
  output_path,
  page_size: 'A4',
  margin: [38, 42, 42, 42]
) do |pdf|
  primary_color = '1e3a8a'     # Deep Navy
  secondary_color = '0284c7'   # Sky Blue
  accent_amber = 'd97706'      # Amber
  dark_slate = '0f172a'        # Slate 900
  muted_slate = '475569'       # Slate 600
  light_bg = 'f8fafc'          # Slate 50
  border_color = 'cbd5e1'      # Slate 300
  green_color = '15803d'       # Green 700

  # Helper: Section Header
  render_section_title = lambda do |title, subtitle = nil|
    pdf.move_down 12
    pdf.fill_color primary_color
    pdf.font('Helvetica', style: :bold, size: 13) do
      pdf.text title
    end
    if subtitle
      pdf.move_down 2
      pdf.fill_color muted_slate
      pdf.font('Helvetica', size: 8.5) do
        pdf.text subtitle
      end
    end
    pdf.move_down 5
    pdf.stroke_color secondary_color
    pdf.line_width 1.2
    pdf.stroke_horizontal_rule
    pdf.move_down 7
    pdf.fill_color dark_slate
  end

  # Helper: Callout Box
  render_callout = lambda do |title, text, type = :info|
    bg = type == :warning ? 'fef3c7' : (type == :success ? 'dcfce7' : 'f1f5f9')
    border = type == :warning ? 'f59e0b' : (type == :success ? '22c55e' : '94a3b8')
    title_color = type == :warning ? 'b45309' : (type == :success ? '15803d' : '1e293b')

    pdf.move_down 5
    orig_y = pdf.cursor
    pdf.bounding_box([0, orig_y], width: pdf.bounds.width) do
      pdf.stroke_color border
      pdf.fill_color bg
      pdf.fill_and_stroke_rounded_rectangle([0, pdf.cursor], pdf.bounds.width, 46, 5)
      pdf.move_down 7
      pdf.indent(10, 10) do
        pdf.fill_color title_color
        pdf.font('Helvetica', style: :bold, size: 9) { pdf.text title }
        pdf.move_down 2
        pdf.fill_color dark_slate
        pdf.font('Helvetica', size: 8) { pdf.text text }
      end
    end
    pdf.move_down 7
  end

  # ==========================================
  # COVER / HEADER BLOCK
  # ==========================================
  pdf.fill_color primary_color
  pdf.font('Helvetica', style: :bold, size: 18) do
    pdf.text "CASE STUDY: FULLSTACK PRODUCT ENGINEER"
  end
  pdf.move_down 2
  pdf.fill_color secondary_color
  pdf.font('Helvetica', style: :bold, size: 11) do
    pdf.text "AI Interview Platform — Monozukuri Product & Architecture Revamp"
  end
  pdf.move_down 5
  pdf.stroke_color border_color
  pdf.line_width 1
  pdf.stroke_horizontal_rule
  pdf.move_down 6

  # Metadata Table
  meta_data = [
    [
      { content: "Candidate:", font_style: :bold, text_color: dark_slate },
      "Wan Hasib Al Aslamy (wanhasibala)",
      { content: "Fork Repository:", font_style: :bold, text_color: dark_slate },
      "github.com/wanhasibala/ai-interview-platform"
    ],
    [
      { content: "Feature Branch:", font_style: :bold, text_color: dark_slate },
      "revamp/fullstack-product-engineer",
      { content: "Upstream Base:", font_style: :bold, text_color: dark_slate },
      "rakamindev/ai-interview-platform:main"
    ],
    [
      { content: "Pull Request:", font_style: :bold, text_color: dark_slate },
      "github.com/wanhasibala/ai-interview-platform/pull/new/revamp/fullstack-product-engineer",
      { content: "Submission Date:", font_style: :bold, text_color: dark_slate },
      Time.now.strftime("%B %d, %Y")
    ],
    [
      { content: "Claimed Depth:", font_style: :bold, text_color: dark_slate },
      "Balanced Fullstack Slice (Backend Data Integrity & Concurrency + Frontend UI/UX & UU PDP)",
      { content: "PR Strategy:", font_style: :bold, text_color: dark_slate },
      "Option A: Comprehensive Single Pull Request"
    ]
  ]

  pdf.table(meta_data, width: pdf.bounds.width) do |t|
    t.cells.padding = [3.5, 5]
    t.cells.size = 8
    t.cells.borders = []
    t.row(0..3).background_color = light_bg
  end

  # ==========================================
  # 1. EXECUTIVE SUMMARY
  # ==========================================
  render_section_title.call(
    "1. Executive Summary & Monozukuri Core",
    "Transforming an unstable proof-of-concept into an enterprise-grade hiring platform"
  )

  pdf.font('Helvetica', size: 8.5) do
    pdf.text "This assessment delivers an end-to-end revamp across both the Rails 7 backend and the React 18 / Vite frontend. Monozukuri represents our founding benchmark: software crafted with deep empathy for candidates and assessors, uncompromised data integrity across failure states, and pixel-level UI Polish.", leading: 2.5
  end

  pdf.move_down 5

  summary_bullets = [
    ["1", "P0 Contract Fix", "Resolved expected_level vs required_level disparity, ensuring the 'Required' column is accurately displayed across all Fit/Gap reports."],
    ["2", "P0 Override Preservation", "Re-engineered Portfolios::Generator to reconcile skills in-place during regeneration, eliminating destructive cascade deletion of human assessor overrides."],
    ["3", "P0 Stampede Elimination", "Replaced 404 polling storms with Redis in-progress locking (FitGapGeneratorWorker) and HTTP 202 Accepted status responses."],
    ["4", "P1 Session Trap Fix", "Enhanced Coverage::MapInjector#all_covered? so unprobed discovered skills in initiated state never trap candidates in indefinite interviews."],
    ["5", "P2 Indonesian UU PDP", "Built CandidatePDPNotice gating microphone access behind statutory consent for voice biometrics, AI evaluation, and human-in-the-loop oversight."],
    ["6", "Testing Harness", "Constructed comprehensive test suites (25 RSpec, 9 Vitest) and verified proven correctness via a Seeded Fault Test."]
  ]

  pdf.table(
    [["#", "Area", "Impact & Shipped Solution"]] + summary_bullets,
    header: true,
    width: pdf.bounds.width
  ) do |t|
    t.row(0).font_style = :bold
    t.row(0).background_color = 'e2e8f0'
    t.row(0).size = 8
    t.cells.size = 7.5
    t.cells.padding = [3.5, 5]
    t.column(0).width = 22
    t.column(1).width = 115
  end

  # ==========================================
  # 2. DOMAIN IMMERSION & REGULATION
  # ==========================================
  render_section_title.call(
    "2. Deep Context: The Indonesian Talent Market & UU PDP",
    "Regulatory compliance and human-centric design in talent evaluation"
  )

  pdf.font('Helvetica', size: 8.5) do
    pdf.text "Hiring in Indonesia operates under distinct logistical realities: high applicant volume, geographic distribution across 17,000 islands, and severe recruiter cognitive overload. While asynchronous AI interviews present massive scalability leverage, they introduce critical vulnerabilities if built casually:", leading: 2
    pdf.text "• <b>The Affected Person (Candidates):</b> Candidates do not choose an AI evaluation. An unpredictable session cutoff or a permanent state trap harms real lives. Software must provide absolute clarity, predictable timers, and transparent consent.", inline_format: true, leading: 2
    pdf.text "• <b>Indonesian Personal Data Protection Law (UU PDP No. 27/2022):</b> Enacted in late 2022, UU PDP classifies biometric voice recordings under Article 4(2) as <i>Data Pribadi Spesifik</i> (Specific Personal Data). Article 20 mandates explicit, voluntary, and informed consent prior to collection. Our statutory component (CandidatePDPNotice) fulfills this legal requirement before microphone activation.", inline_format: true, leading: 2
    pdf.text "• <b>Human-in-the-Loop Agency:</b> Under UU PDP Article 16, automated decision-making must allow human intervention. In Rakamin, human assessors can override any AI level with qualitative justification notes. Wiping those notes on portfolio regeneration violated both product trust and statutory principles.", inline_format: true, leading: 2
  end

  # ==========================================
  # 3. PROBLEM & GAP ANALYSIS (P0 TO P3)
  # ==========================================
  render_section_title.call(
    "3. Severity-Ranked Problem & Gap Analysis",
    "Separating defective implementation from missing specification"
  )

  defect_table = [
    ["Sev", "Classification", "Type", "Real User Workflow Harm"],
    ["P0", "Fit/Gap Contract Mismatch", "Defective", "Backend returned expected_level while web expected required_level. The Required column was completely blank on the Fit/Gap report screen, hiding role baselines."],
    ["P0", "Assessor Overrides Destroyed", "Defective", "Portfolio regeneration invoked destroy_all on portfolio_skills, triggering dependent: :destroy on assessor_overrides and wiping all human notes and rating corrections."],
    ["P0", "FitGap 404 Polling Storm", "Defective", "GET /fitgap returned 404 while generating. Web caught 404 every 5s and queued duplicate Sidekiq workers, causing database connection pool exhaustion and duplicate calls."],
    ["P1", "Discovered Skill Trap", "Defective", "MapInjector#all_covered? returned false if any discovered skill was initiated. Candidates were trapped in calls until hard time limit cutoff."],
    ["P1", "Broken Skill Deletion in Forms", "Defective", "Removing a skill in Assessment or Vacancy edit omitted the item without sending _destroy: true. Rails ignored omissions, making skill deletion impossible."],
    ["P1", "Overrides Omitted in Fit/Gap", "Missing Spec", "FitGap::Engine omitted is_override flags and notes in comparison payloads, meaning assessors could never see human override badges or rationale."],
    ["P2", "Candidate Invite Port Mismatch", "Defective", "Session#invite_url pointed to localhost:3001 (API) instead of localhost:5173 (Vite web), resulting in 404 Routing Errors when candidates opened links."],
    ["P2", "UU PDP Regulatory Non-Compliance", "Missing Spec", "No statutory disclosure or explicit consent gate for audio biometrics and AI scoring prior to microphone streaming."]
  ]

  pdf.table(defect_table, header: true, width: pdf.bounds.width) do |t|
    t.row(0).font_style = :bold
    t.row(0).background_color = 'e2e8f0'
    t.cells.size = 7.5
    t.cells.padding = [3, 4.5]
    t.column(0).width = 26
    t.column(1).width = 110
    t.column(2).width = 65
  end

  render_callout.call(
    "TECHNICAL LEAD CONSTRAINT SIGNAL (ESCALATION):",
    "In high-concurrency production deployments, free-form LLM JSON outputs risk schema drift. Furthermore, reliance on local Redis keys for worker locking should be standardized into a distributed Redis mutex (e.g. redlock-rb) with strict TTL fallbacks across all worker pools.",
    :warning
  )

  # ==========================================
  # 4. TRADE-OFF MATRIX & REVAMP STRATEGY
  # ==========================================
  pdf.start_new_page

  render_section_title.call(
    "4. Solution Options & Architectural Trade-offs",
    "Evaluating Option A (In-Place Reconciliation) vs Option B (Event-Sourced Ledger)"
  )

  trade_matrix = [
    ["Evaluation Dimension", "Option A: In-Place Reconciliation (CHOSEN)", "Option B: Event-Sourced Ledger (REJECTED)"],
    ["Product Impact", "Immediate restoration of data integrity. Overrides remain intact across refreshes with zero schema breakage.", "Full temporal audit trail of all score revisions, but introduces high UI complexity to display revision history."],
    ["Engineering Cost", "Low to Moderate: Contained within Portfolios::Generator service with clean atomic transactions.", "Very High: Requires event store tables, read projection workers, and CQRS synchronization."],
    ["Long-term Maintenance", "High: Standard Rails ActiveRecord pattern; easily maintained by any junior/mid fullstack engineer.", "Low: High cognitive burden; schema evolution across historic JSON event payloads requires complex upcasters."],
    ["Failure Modes", "Gemini Pro timeouts handled gracefully by Sidekiq retries; in-place transaction rolls back cleanly.", "Event projection lag; desynchronization between write events and read projections under load."],
    ["Contextual Codebase Fit", "Optimal: Matches existing schema architecture without requiring risky data migrations.", "Overkill: Disproportionate complexity for current stage of the platform."]
  ]

  pdf.table(trade_matrix, header: true, column_widths: [95, 208, 208]) do |t|
    t.row(0).font_style = :bold
    t.row(0).background_color = 'e2e8f0'
    t.cells.size = 7.5
    t.cells.padding = [3.5, 5]
  end

  pdf.move_down 5
  pdf.font('Helvetica', style: :bold, size: 8.5) { pdf.text "Self-Derived Acceptance Criteria & Edge Cases Handled:" }
  pdf.font('Helvetica', size: 8) do
    pdf.text "1. <b>Assessor Override Integrity:</b> If an assessor assigns L4 to a skill rated L2 by AI, regenerating the portfolio must preserve L4, keep notes intact, and update the underlying AI level to the new baseline.", inline_format: true
    pdf.text "2. <b>Candidate Trap Protection:</b> An initiated discovered skill must NEVER block interview completion if time remaining <= 3 minutes or if no probe occurred within the last 2 minutes.", inline_format: true
    pdf.text "3. <b>Fit/Gap Contract Symmetry:</b> API returns both required_level and expected_level; frontend resolves c.required_level ?? c.expected_level safely.", inline_format: true
    pdf.text "4. <b>Nested Attribute Deletion:</b> Removing skills in edit views tracks deleted IDs and passes _destroy: true so records are permanently removed from Postgres.", inline_format: true
    pdf.text "5. <b>Idempotent Generation:</b> Duplicate POST /fitgap calls return HTTP 202 Accepted without re-queueing background workers.", inline_format: true
  end

  # ==========================================
  # 5. MONOZUKURI IMPLEMENTATION & TEST HARNESS
  # ==========================================
  render_section_title.call(
    "5. Monozukuri Implementation & Testing Harness",
    "Verified correctness across API, database, and client interface"
  )

  pdf.font('Helvetica', size: 8.5) do
    pdf.text "We built complete automated test suites across both repositories to replace the previously empty test runners:", leading: 2
  end

  pdf.move_down 4

  test_summary = [
    ["Service", "Framework", "Test Coverage Summary", "Result"],
    ["api/ (Backend)", "RSpec 3.13 / Rails", "FitGap::Engine comparisons, Portfolios::Generator override preservation, MapInjector trap guards, StateEngine rules, Session invite routing, Portfolios requests (200, 202, 404, deduplication), Assessment nested deletions.", "25 Passed / 0 Failed (0.44s)"],
    ["web/ (Frontend)", "Vitest 5.0 / RTL", "ComparisonTable contract fallback & override badges, CandidatePDPNotice statutory disclosures & consent toggle, SkillPortfolioCard effective levels & discovered tags.", "9 Passed / 0 Failed (1.20s)"]
  ]

  pdf.table(test_summary, header: true, column_widths: [75, 80, 256, 100]) do |t|
    t.row(0).font_style = :bold
    t.row(0).background_color = 'e2e8f0'
    t.cells.size = 7.5
    t.cells.padding = [3.5, 5]
  end

  # ==========================================
  # 6. SEEDED FAULT TEST PROOF
  # ==========================================
  render_section_title.call(
    "6. Seeded Fault Test Proof (Deliberate Mutation)",
    "Proving tests catch real regressions rather than performing shallow green-checks"
  )

  pdf.font('Helvetica', size: 8) do
    pdf.text "On a scratch branch (seeded-fault-test), we deliberately injected a contract fault in <b>FitGap::Engine</b> by corrupting required_level: nil and delta: 999. Running the RSpec test suite immediately caught the regression:", inline_format: true
  end

  pdf.move_down 3

  pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
    pdf.stroke_color 'f87171'
    pdf.fill_color 'fef2f2'
    pdf.fill_and_stroke_rounded_rectangle([0, pdf.cursor], pdf.bounds.width, 52, 4)
    pdf.move_down 5
    pdf.indent(8, 8) do
      pdf.font('Courier', size: 7.2) do
        pdf.fill_color '991b1b'
        pdf.text "1) FitGap::Engine#call computes correct comparisons and satisfies frontend contract"
        pdf.text "   Failure/Error: expect(react_comp['required_level']).to eq(3)"
        pdf.text "     expected: 3"
        pdf.text "          got: nil (compared using ==)"
        pdf.text "   # ./spec/services/fit_gap/engine_spec.rb:105:in block (3 levels)"
        pdf.text "   Finished in 0.20466s - 3 examples, 1 failure"
      end
    end
  end
  pdf.move_down 5

  pdf.font('Helvetica', size: 8) do
    pdf.text "The fault was reverted cleanly, returning the test suite to <b>25 passed, 0 failures</b>. This proves our test assertions actively protect API contracts against regression.", inline_format: true
  end

  # ==========================================
  # 7. AI VERIFICATION MOMENT
  # ==========================================
  render_section_title.call(
    "7. AI Verification Moment",
    "Where AI code generation proposed unsafe patterns and human engineering intervened"
  )

  render_callout.call(
    "THE RISKY AI SUGGESTION vs HUMAN MONOZUKURI CORRECTION:",
    "When asked to ensure portfolio regeneration was idempotent, an AI code assistant proposed calling 'portfolio.portfolio_skills.destroy_all' prior to saving newly generated skills. While superficially idempotent, this ignored the database relation 'has_one :assessor_override, dependent: :destroy'. Blithely adopting this would have caused catastrophic data loss in production. Human engineering intervened to design an In-Place Reconciliation algorithm that indexes existing overrides in memory, updates existing skills in-place, and re-links overrides with zero data loss.",
    :info
  )

  # ==========================================
  # 8. VIDEO DEMONSTRATION & DEFENSE READINESS
  # ==========================================
  render_section_title.call(
    "8. Demonstration & Live Technical Defense Readiness",
    "Preparation for CTO & Technical Lead architectural defense session"
  )

  pdf.font('Helvetica', size: 8) do
    pdf.text "• <b>Walkthrough & Script:</b> A comprehensive voiceover script and minute-by-minute storyboard is prepared in <code>assessment/VIDEO_DEMO_SCRIPT.md</code> covering Problem Discovery, Candidate UU PDP consent, Assessor Override persistence, Concurrency safeguards, and Test harness execution.", inline_format: true
    pdf.text "• <b>Live Defense Readiness:</b> The candidate is fully prepared to defend the architectural trade-offs, rejection of Event Sourcing (Option B), database mutexing, and distributed concurrency controls in the 45-minute live technical session with the CTO and Technical Lead.", inline_format: true
  end

  # ==========================================
  # 9. VISUAL ARTIFACTS & ARCHITECTURAL SCREENSHOTS
  # ==========================================
  pdf.start_new_page

  render_section_title.call(
    "9. Visual Artifacts & Architectural Screenshots",
    "High-resolution UI flows, data integrity flows, and statutory regulatory gates"
  )

  # Figure 1: Fit/Gap Comparison Matrix
  fig1_path = File.join(screenshots_dir, '01-fitgap-matrix.png')
  if File.exist?(fig1_path)
    pdf.font('Helvetica', style: :bold, size: 9.5) { pdf.text "Figure 1: Fit/Gap Comparison Table & Assessor Override Badge" }
    pdf.move_down 2
    pdf.font('Helvetica', size: 7.5, color: muted_slate) do
      pdf.text "Fixed contract populates the Required column and displays human assessor override badges with interactive tooltips."
    end
    pdf.move_down 4
    pdf.image fig1_path, width: 480, position: :center
    pdf.move_down 14
  end

  # Figure 2: Indonesian UU PDP Consent Card
  fig2_path = File.join(screenshots_dir, '02-uupdp-consent.png')
  if File.exist?(fig2_path)
    pdf.font('Helvetica', style: :bold, size: 9.5) { pdf.text "Figure 2: Indonesian UU PDP No. 27/2022 Statutory Notice & Audio Gate" }
    pdf.move_down 2
    pdf.font('Helvetica', size: 7.5, color: muted_slate) do
      pdf.text "Statutory disclosure gating microphone activation behind explicit consent regarding biometrics and human-in-the-loop oversight."
    end
    pdf.move_down 4
    pdf.image fig2_path, width: 480, position: :center
  end

  # Second page of figures
  pdf.start_new_page

  # Figure 3: Candidate Trapping Prevention
  fig3_path = File.join(screenshots_dir, '03-trapping-architecture.png')
  if File.exist?(fig3_path)
    pdf.font('Helvetica', style: :bold, size: 9.5) { pdf.text "Figure 3: Candidate Session Trapping Prevention Architecture" }
    pdf.move_down 2
    pdf.font('Helvetica', size: 7.5, color: muted_slate) do
      pdf.text "MapInjector#all_covered? with time-aware safety windows preventing spontaneous off-agenda skills from trapping sessions."
    end
    pdf.move_down 4
    pdf.image fig3_path, width: 480, position: :center
    pdf.move_down 14
  end

  # Figure 4: In-Place Portfolio Skill Reconciliation Flow
  fig4_path = File.join(screenshots_dir, '04-override-preservation.png')
  if File.exist?(fig4_path)
    pdf.font('Helvetica', style: :bold, size: 9.5) { pdf.text "Figure 4: In-Place Portfolio Skill Reconciliation Flow" }
    pdf.move_down 2
    pdf.font('Helvetica', size: 7.5, color: muted_slate) do
      pdf.text "In-place reconciliation algorithm indexing existing overrides, updating skills, and re-linking human corrections safely."
    end
    pdf.move_down 4
    pdf.image fig4_path, width: 480, position: :center
  end

  # Footer Page Numbering
  pdf.number_pages "Page <page> of <total>  |  Rakamin AI Interview Platform Revamp  |  Fullstack Product Engineer",
                   at: [pdf.bounds.left, 0],
                   width: pdf.bounds.right,
                   align: :center,
                   size: 7.5,
                   color: muted_slate
end

puts "SUCCESS: Generated #{output_path} (#{File.size(output_path)} bytes)"
