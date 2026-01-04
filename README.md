# MicroEntrepreneur

A modern, open-source web application for French IT freelancers with "micro-entrepreneur" legal status. MicroEntrepreneur helps you maximize your income by optimizing your average daily rate (TJM - Taux Journalier Moyen) and managing off days throughout the year while staying compliant with French tax regulations.

## Features

- **Budget Planning**: Track and forecast your annual income before taxes
- **Daily Rate Optimization**: Calculate and adjust your TJM to maximize earnings
- **Activity Reports**: Monitor worked days and revenue on a monthly basis
- **Revenue Tracking**: Stay within the €77,700 annual revenue limit for micro-entrepreneurs
- **Off Days Management**: Plan and configure your non-working days
- **Tax Calculations**: Automatic calculation with 21.3% average tax rate on income
- **Dashboard**: Visual overview of your financial status and projections
- **Responsive Design**: Works seamlessly on desktop and mobile devices

## Tech Stack

- **Ruby**: 3.4.8
- **Rails**: 8.1.1
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo & Stimulus)
- **CSS**: Tailwind CSS
- **JavaScript**: Importmap (no Node.js required)
- **Authentication**: Devise
- **Deployment**: Docker-ready

## Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.4.8 (use [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://asdf-vm.com/))
- PostgreSQL 14+
- Git

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ayaz-ac/micro-entrepreneur.git
cd micro-entrepreneur
```

### 2. Install dependencies

```bash
bin/setup
```

This command will:
- Install Ruby gems
- Create the database
- Load the schema
- Set up initial configuration

### 3. Configure credentials

Generate your Rails credentials file:

```bash
rails credentials:edit
```

See `.env.example` for required environment variables.

### 4. Start the development server

```bash
bin/dev
```

The application will be available at [http://localhost:3000](http://localhost:3000)

### 5. Login

Use the default development credentials:
- **Email**: user@example.com
- **Password**: password

## Development

### Running Tests

```bash
# Run all unit tests
bin/rails test

# Run a specific test file
bin/rails test test/path/to/file_test.rb

# Run system tests (Capybara + Selenium)
bin/rails test:system

# Run the full CI suite (linting, security, tests)
bin/ci
```

For parallel test execution issues:
```bash
PARALLEL_WORKERS=1 bin/rails test
```

### Database Commands

```bash
# Load fixture data
bin/rails db:fixtures:load

# Run migrations
bin/rails db:migrate

# Reset database (drop, create, load schema)
bin/rails db:reset
```

### Code Quality

The project includes several code quality and security tools:

- **RuboCop**: Ruby style guide enforcement
- **Brakeman**: Security vulnerability scanner
- **Bundler Audit**: Checks for vulnerable gem versions
- **Importmap Audit**: JavaScript dependency security

Run all checks:
```bash
bin/ci
```

## Deployment

### Docker

The project includes a multi-stage Dockerfile for production deployment:

```bash
# Build the image
docker build -t micro-entrepreneur .

# Run the container
docker run -p 3000:3000 micro-entrepreneur
```

Make sure to set the required environment variables in your deployment environment.

### Environment Variables

See `.env.example` for all required environment variables. Key variables include:

- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_MASTER_KEY`: Rails credentials encryption key
- `SECRET_KEY_BASE`: Rails secret key

## Project Structure

### Core Domain Models

- **ActivityReport**: Records monthly activity data including daily rates and work status
  - Stores data in JSONB `details` attribute
  - Tracks worked days, estimated income, and monthly revenue

- **Revenue**: Manages annual revenue tracking
  - Enforces the €77,700 annual limit for micro-entrepreneurs
  - Unique per user per year

- **ConfiguredOffDay**: Defines user's global non-working days
  - Used for planning and budget calculations

- **User**: Manages user authentication and profile
  - Devise-based authentication
  - Associated with activity reports and revenue records

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- How to set up your development environment
- Coding standards and guidelines
- How to submit pull requests
- Our code review process

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

If you discover a security vulnerability, please follow our [Security Policy](SECURITY.md). Do not open a public issue.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/ayaz-ac/micro-entrepreneur/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ayaz-ac/micro-entrepreneur/discussions)

## Acknowledgments

Built with Ruby on Rails and modern web technologies. Special thanks to the open-source community for the amazing tools and libraries that make this project possible.

---

Made with ❤️ for French freelancers
