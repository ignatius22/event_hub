# Event Hub

A modern event management platform built with Ruby on Rails that allows users to create, discover, and register for events.

## Features

- **Event Management**: Create, edit, and manage events with detailed information including location, capacity, and timing
- **User Authentication**: Secure user registration and login powered by Devise
- **Event Registration**: Users can register for events and track their registrations
- **Category System**: Organize events by categories for easy discovery
- **Admin Dashboard**: Administrative interface for managing events and users
- **RESTful API**: JSON API with JWT authentication for third-party integrations
- **Geocoding**: Automatic geocoding of event addresses with map integration
- **Image Uploads**: Support for event cover images using Active Storage
- **Real-time Updates**: Powered by Hotwire and Turbo for a smooth user experience
- **Responsive Design**: Modern UI built with Tailwind CSS
- **Analytics**: Event statistics and charts using Chartkick
- **Authorization**: Role-based access control with Pundit

## Tech Stack

- **Ruby**: 3.1.4
- **Rails**: 7.1.5+
- **Database**: PostgreSQL
- **CSS Framework**: Tailwind CSS
- **JavaScript**: Stimulus Controllers, Hotwire/Turbo
- **Authentication**: Devise
- **Authorization**: Pundit
- **API**: JSON:API with JWT
- **Image Processing**: Active Storage with image_processing gem
- **Geocoding**: Geocoder gem
- **Pagination**: Pagy
- **Charts**: Chartkick & Groupdate

## Prerequisites

- Ruby 3.1.4
- PostgreSQL
- Node.js (for asset compilation)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd event_hub
```

2. Install dependencies:
```bash
bundle install
```

3. Setup environment variables:
```bash
cp .env.example .env
```
Edit `.env` and configure your database credentials and other settings.

4. Setup the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. Install JavaScript dependencies:
```bash
bin/rails assets:precompile
```

## Running the Application

### Development Server

Start the development server:
```bash
bin/dev
```

Or use traditional Rails server:
```bash
rails server
```

The application will be available at `http://localhost:3000`

### Using Docker

Build and run with Docker:
```bash
docker build -t event_hub .
docker run -p 3000:3000 event_hub
```

## Testing

Run the test suite:
```bash
rails test
```

Run system tests:
```bash
rails test:system
```

## Database Schema

### Main Models

- **User**: Handles authentication and user accounts (Devise)
- **Event**: Core event model with title, description, location, capacity, and timing
  - Status: draft, published, cancelled, completed
  - Associations: belongs_to :user, :category; has_many :registrations
- **Registration**: Tracks user event registrations
- **Category**: Organizes events into categories

## API Endpoints

### Authentication
- `POST /api/v1/auth/login` - Authenticate and receive JWT token

### Events
- `GET /api/v1/events` - List all published events
- `GET /api/v1/events/:id` - Show event details
- `POST /api/v1/events/:id/rsvp` - RSVP to an event (requires authentication)

## Configuration

Key configuration files:
- `config/database.yml` - Database configuration
- `config/routes.rb` - Application routes
- `config/initializers/devise.rb` - Authentication settings
- `.env` - Environment variables (create from .env.example)

## Key Features Implementation

### Event States
Events can be in one of four states:
- **Draft**: Event is being prepared
- **Published**: Event is live and accepting registrations
- **Cancelled**: Event has been cancelled
- **Completed**: Event has ended

### Registration System
- Users can register for published events
- Capacity tracking prevents overbooking
- Registration confirmation system
- Users can view their registered events

### Admin Features
- Dashboard with event analytics and charts
- Event management interface
- User management
- Event approval workflow

## Deployment

The application includes:
- `Dockerfile` for containerized deployment
- `Procfile.dev` for Foreman/Heroku deployment
- Health check endpoint at `/up`

For production deployment, ensure:
1. Set `RAILS_ENV=production`
2. Configure production database
3. Set secret key base: `RAILS_MASTER_KEY` or `SECRET_KEY_BASE`
4. Precompile assets: `rails assets:precompile`
5. Run migrations: `rails db:migrate`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available for use under the MIT License.
