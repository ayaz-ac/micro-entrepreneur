# MicroEntrepreneur

This file provides guidance to AI coding agents working with this repository.

## What is MicroEntrepreneur?

MicroEntrepreneur is an open-source web application built for french IT freelancers with the "micro-entrepreneur" legal status. It's a budget tool to help freelancers maximize their income by regulating their TJM (average daily rate) and off days throughout the year.

## Development Commands

### Setup and Server
```bash
bin/setup # Initial setup (installs gems, creates DB, loads schema)
bin/dev   # Start development server (runs on port 3000)
```

Development URL: http://localhost:3000
Login with: user@example.com (development fixtures), password is `password`

### Testing
```bash
bin/rails test                         # Run unit tests (fast)
bin/rails test test/path/file_test.rb  # Run single test file
bin/rails test:system                  # Run system tests (Capybara + Selenium)
bin/ci                                 # Run full CI suite (style, security, tests)

# For parallel test execution issues, use:
PARALLEL_WORKERS=1 bin/rails test
```

CI pipeline (`bin/ci`) runs:
1. Rubocop (style)
2. Bundler audit (gem security)
3. Importmap audit
4. Brakeman (security scan)
5. Application tests
6. System tests

### Database
```bash
bin/rails db:fixtures:load    # Load fixture data
bin/rails db:migrate          # Run migrations
bin/rails db:reset            # Drop, create, and load schema
```

## Architecture Overview

### Core Domain Models

**Activtity Report** → Records all the significant data for a month
- JSONB details attribute, it holds all the data on the month: daily rate and status

**Revenue** → Holds the annual revenue before tax

**Configured Off Day** → User's global off days
