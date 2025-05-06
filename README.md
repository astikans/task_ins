# README

## Short Description

Rails API-only - Applicant Tracking System (ATS) that uses the Event Sourcing pattern to manage job and application statuses and other fields. Jobs and applications derive their status from the latest event (e.g., activated, hired, rejected), with events stored using Single Table Inheritance (STI). HR can also add non-status-altering note events to applications. Two JSON endpoints: one listing applications for active jobs (with job and candidate info, status, note count, and interview date), and another listing all jobs with their status and counts of hired, rejected, and ongoing applications.

Full task description: https://docs.google.com/document/d/17wv7TI5TJiOj6NRAOdkMutHJ_Lthr17msjm-AqT-yRw/edit?tab=t.0

## Setup

Project is published in GitHub https://github.com/astikans/task_ins

### Prerequisites
- Git
- Ruby 3.4.2
- Bundler

### Usage
- Clone repository: `git clone git@github.com:astikans/task_ins.git`
- Bundle all dependencies
- Seed data: `bundle exec rake db:seed` (setup new db and run migrations if not already done)
- Run application - `rails server`
- Visit endpoints to check imported data:
  -  All jobs `/api/jobs`
  -  All applications for all activated jobs `/api/applications`

## Implementation

### Events

Events table store all system events: uses STI to define which event is created and uses polymorphic association to references eventable - owner of event. Additional params are stored in jsonb column for each subclass. When event is created, it calls eventable to apply the latest changes to projection in after_commit callback (if it fails - we have events to recreate owner projections).

DB schema:
```
t.string "type", null: false
t.string "eventable_type", null: false
t.bigint "eventable_id", null: false
t.jsonb "properties", default: {}, null: false
t.datetime "created_at", null: false
t.datetime "updated_at", null: false
t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
```

### Jobs

Jobs table store all jobs, projection data which is created from events and counters to store stats from application statuses.
- Any time projection data could be recreated from events (future improvement).
- All counters are recalculated every time related application is saved (in after_commit callback).

```
t.string "title", null: false
t.text "description", null: false
t.jsonb "projection", default: {}, null: false
t.jsonb "counters", default: {}, null: false
t.datetime "created_at", null: false
t.datetime "updated_at", null: false
t.index "((projection ->> 'state'::text))", name: "index_jobs_on_projection_state"
```

### Applications

Applications table store all applications, references to job and projection data which is created from events.
- Any time projection data could be recreated from events (not implemented)

```
t.bigint "job_id", null: false
t.string "candidate_name", null: false
t.jsonb "projection", default: {}, null: false
t.datetime "created_at", null: false
t.datetime "updated_at", null: false
t.index "((projection ->> 'state'::text))", name: "index_applications_on_projection_state"
t.index ["job_id"], name: "index_applications_on_job_id"
```

## Tests

App has 80 unit tests and controller tests.

Run: `bundle exec rspec spec`
```
................................................................................

80 examples, 0 failures
```

## Test data

Data seed from `seeds.rb`

Jobs:
```
1. No State Job (default state: deactivated)
2. RoR Developer (state: activated)
3. DevOps Engineer (state: deactivated, was previously activated)
```

Applications:
```
1. John Doe → RoR Developer job (no status)
2. Jane → RoR Developer job (status: interview)
   - Note: "This is a note"
   - Note: "This is another note"
3. Alan → RoR Developer job (status: hired)
4. Mary → RoR Developer job (status: rejected, was previously interview)
5. John Smith → DevOps Engineer job (no status)
```

### Output

All jobs `/api/jobs`
```
[
  {
    "id": 1,
    "title": "No State Job",
    "description": "A job with no state, default should be deactivated",
    "state": "deactivated",
    "hired_applications_count": 0,
    "rejected_applications_count": 0,
    "ongoing_applications_count": 0
  },
  {
    "id": 2,
    "title": "RoR Developer",
    "description": "Looking for an experienced RoR developer",
    "state": "activated",
    "hired_applications_count": 1,
    "rejected_applications_count": 1,
    "ongoing_applications_count": 2
  },
  {
    "id": 3,
    "title": "DevOps Engineer",
    "description": "Seeking a DevOps engineer with experience in AWS",
    "state": "deactivated",
    "hired_applications_count": 0,
    "rejected_applications_count": 0,
    "ongoing_applications_count": 1
  }
]
```

All applications for all activated jobs `/api/applications`
```
[
  {
    "id": 1,
    "job_name": "RoR Developer",
    "candidate_name": "John Doe",
    "state": "applied",
    "notes_count": 0,
    "last_interview_date": null
  },
  {
    "id": 2,
    "job_name": "RoR Developer",
    "candidate_name": "Jane",
    "state": "interview",
    "notes_count": 2,
    "last_interview_date": "2025-05-05"
  },
  {
    "id": 3,
    "job_name": "RoR Developer",
    "candidate_name": "Alan",
    "state": "hired",
    "notes_count": 0,
    "last_interview_date": null
  },
  {
    "id": 4,
    "job_name": "RoR Developer",
    "candidate_name": "Mary",
    "state": "rejected",
    "notes_count": 0,
    "last_interview_date": null
  }
]
```

## Future improvements

- Add service to recreate `job` and `application` projections from all events.
- Smarter way to update `job` counters - currently all the time all counters are updated on every application change.
- Move all projection updates and counter calculations to background jobs to not block application.
- Handle errors and retries when something breaks - e.g. if projection creation is out of sync - recreate it.

## About me

- **Name:** Andris Stikans
- **Email:** andris.stikans@gmail.com
- **Phone:** +371 28666366
- **Address:** Sigulda, Latvia
- **LinkedIn:** [linkedin.com/in/andris-stikans](https://www.linkedin.com/in/andris-stikans)
- **Portfolio:** [andris.stikans.taurus.lv](https://andris.stikans.taurus.lv/)