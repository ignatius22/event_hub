# Event Hub

A modern, full-featured event management platform built with Ruby on Rails that allows users to create, discover, and register for events with real-time updates and interactive features.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Database Schema](#database-schema)
- [API Documentation](#api-documentation)
- [User Roles & Permissions](#user-roles--permissions)
- [Key Features](#key-features)
- [Interactive UI Components](#interactive-ui-components)
- [Email Notifications](#email-notifications)
- [Security Features](#security-features)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Features

### Core Features
- **Event Management**: Create, edit, and manage events with detailed information including location, capacity, and timing
- **User Authentication**: Secure user registration and login powered by Devise with password recovery
- **Event Registration & RSVP**: Users can register for events, track their registrations, and manage waitlists
- **Category System**: Organize events by categories for easy discovery and filtering
- **Advanced Search**: Full-text search across event titles and descriptions
- **Event Filtering**: Filter events by category, date range, and status

### Admin & Analytics
- **Admin Dashboard**: Comprehensive administrative interface with real-time analytics
- **Event Analytics**: Track registrations by day, events by category, and user distribution
- **User Management**: Manage users, roles, and permissions
- **Event Moderation**: Approve, publish, or cancel events

### API & Integration
- **RESTful API**: JSON:API compliant endpoints with JWT authentication
- **API Token Management**: Automatic API token generation for each user
- **Third-party Integration**: Easy integration with external services

### Location & Media
- **Geocoding**: Automatic geocoding of event addresses with latitude/longitude
- **Interactive Maps**: Map integration for event locations using Stimulus controllers
- **Image Uploads**: Support for event cover images and user avatars using Active Storage
- **Image Variants**: Automatic image processing and optimization

### Real-time Features
- **Live Updates**: Real-time RSVP count updates powered by Hotwire and Turbo Streams
- **Instant Notifications**: Broadcast updates when registrations are created or cancelled
- **Responsive UI**: SPA-like experience with Turbo Drive

### User Experience
- **Responsive Design**: Modern, mobile-first UI built with Tailwind CSS
- **Interactive Components**: Character counters, image previews, dropdowns, and more
- **Pagination**: Efficient pagination with Pagy for large datasets
- **Loading States**: Smooth transitions and loading indicators

### Email System
- **Registration Confirmations**: Automatic email confirmation when users register
- **Event Reminders**: Scheduled reminders before events start
- **Cancellation Notices**: Notifications when events are cancelled
- **Customizable Templates**: HTML email templates with event details

### Authorization
- **Role-based Access Control**: Fine-grained permissions with Pundit policies
- **Three-tier Role System**: Attendee, Organizer, and Admin roles
- **Policy Enforcement**: Automatic authorization checks on all sensitive actions

## Tech Stack

### Backend
- **Ruby**: 3.1.4
- **Rails**: 7.1.5+
- **Database**: PostgreSQL with optimized indexes
- **Authentication**: Devise
- **Authorization**: Pundit
- **Background Jobs**: Active Job (configurable with Sidekiq/Resque)

### Frontend
- **CSS Framework**: Tailwind CSS
- **JavaScript**: Stimulus Controllers, Hotwire/Turbo
- **UI Components**: Custom Stimulus controllers for interactive features
- **Asset Pipeline**: Sprockets with import maps

### APIs & Services
- **API Framework**: JSON:API with jsonapi-serializer
- **API Authentication**: JWT tokens
- **HTTP Client**: Faraday for third-party API calls
- **Geocoding**: Geocoder gem with configurable providers

### Media & Assets
- **File Storage**: Active Storage (supports local, S3, GCS, Azure)
- **Image Processing**: image_processing gem with ImageMagick/libvips
- **Image Variants**: Automatic thumbnail generation

### Analytics & Charts
- **Charts**: Chartkick
- **Time-series Data**: Groupdate for time-based analytics
- **Dashboards**: Admin analytics with multiple chart types

### Development Tools
- **Environment Variables**: dotenv-rails
- **Debugging**: debug gem
- **Testing**: Minitest with Capybara and Selenium
- **Code Quality**: error_highlight for better error messages

## Prerequisites

- Ruby 3.1.4
- PostgreSQL (11+)
- Node.js (14+) for asset compilation
- ImageMagick or libvips (for image processing)
- Git

## Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd event_hub
```

2. **Install Ruby dependencies:**
```bash
bundle install
```

3. **Setup environment variables:**
```bash
cp .env.example .env
```
Edit `.env` and configure your database credentials, API keys, and other settings.

4. **Setup the database:**
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. **Install JavaScript dependencies:**
```bash
bin/rails assets:precompile
```

6. **Verify installation:**
```bash
rails test
```

## Running the Application

### Development Server

Start the development server with automatic reloading:
```bash
bin/dev
```

Or use traditional Rails server:
```bash
rails server
```

The application will be available at `http://localhost:3000`

### Console Access

Access the Rails console:
```bash
rails console
```

### Database Console

Access the database directly:
```bash
rails dbconsole
```

### Using Docker

Build and run with Docker:
```bash
docker build -t event_hub .
docker run -p 3000:3000 -e DATABASE_URL=<your-db-url> event_hub
```

Using Docker Compose:
```bash
docker-compose up
```

## Testing

### Run all tests:
```bash
rails test
```

### Run specific test files:
```bash
rails test test/models/event_test.rb
```

### Run system tests:
```bash
rails test:system
```

### Run tests with coverage:
```bash
COVERAGE=true rails test
```

## Database Schema

### Tables Overview

#### Users Table
- **Purpose**: User accounts and authentication
- **Key Fields**:
  - `email` (unique, indexed)
  - `first_name`, `last_name`, `bio`
  - `role` (enum: attendee, organizer, admin)
  - `api_token` (auto-generated for API access)
- **Attachments**: Avatar image via Active Storage
- **Indexes**: email, reset_password_token

#### Events Table
- **Purpose**: Event information and management
- **Key Fields**:
  - `title`, `description`, `location`, `address`
  - `latitude`, `longitude` (auto-geocoded)
  - `starts_at`, `ends_at` (datetime fields)
  - `capacity` (max attendees)
  - `status` (enum: draft, published, cancelled, completed)
- **Foreign Keys**: `user_id` (organizer), `category_id`
- **Attachments**: Cover image via Active Storage
- **Indexes**: status, starts_at, latitude/longitude (composite), user_id, category_id

#### Registrations Table
- **Purpose**: Track user event registrations
- **Key Fields**:
  - `status` (enum: pending, confirmed, cancelled, waitlisted)
- **Foreign Keys**: `user_id`, `event_id`
- **Unique Constraint**: user_id + event_id (prevent duplicate registrations)
- **Indexes**: user_id, event_id, composite index on both

#### Categories Table
- **Purpose**: Event categorization
- **Key Fields**: `name`, `description`

### Relationships

```
User
  ├── has_many :events (as organizer)
  ├── has_many :registrations
  ├── has_many :registered_events (through registrations)
  └── has_one_attached :avatar

Event
  ├── belongs_to :user (organizer)
  ├── belongs_to :category
  ├── has_many :registrations
  ├── has_many :attendees (through registrations)
  └── has_one_attached :cover_image

Registration
  ├── belongs_to :user
  └── belongs_to :event

Category
  └── has_many :events
```

## API Documentation

### Authentication

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "attendee"
  }
}
```

### Events

#### List Events
```http
GET /api/v1/events
Authorization: Bearer <token>
```

**Query Parameters:**
- `category_id` - Filter by category
- `search` - Search in title/description
- `page` - Page number for pagination

**Response:**
```json
{
  "data": [
    {
      "id": "1",
      "type": "event",
      "attributes": {
        "title": "Ruby Conference 2025",
        "description": "Annual Ruby conference...",
        "location": "San Francisco",
        "starts_at": "2025-06-15T09:00:00Z",
        "ends_at": "2025-06-15T17:00:00Z",
        "capacity": 500,
        "available_spots": 234,
        "status": "published"
      }
    }
  ]
}
```

#### Show Event
```http
GET /api/v1/events/:id
Authorization: Bearer <token>
```

#### RSVP to Event
```http
POST /api/v1/events/:id/rsvp
Authorization: Bearer <token>
```

**Response:**
```json
{
  "message": "Successfully registered for event",
  "registration": {
    "id": 42,
    "status": "confirmed"
  }
}
```

## User Roles & Permissions

### Role Hierarchy

1. **Attendee** (Default)
   - Register for events
   - View published events
   - Manage own registrations
   - Update own profile

2. **Organizer**
   - All Attendee permissions
   - Create and manage own events
   - Publish/unpublish events
   - View registrations for own events
   - Cancel own events

3. **Admin**
   - All Organizer permissions
   - Access admin dashboard
   - Manage all events (any user)
   - Manage all users
   - View system analytics
   - Approve/reject events
   - Delete users and events

### Permission Examples

- **Creating Events**: Requires Organizer or Admin role
- **Publishing Events**: Event owner or Admin
- **Viewing Draft Events**: Event owner or Admin
- **Cancelling Registrations**: Registration owner or Event owner or Admin
- **Accessing Admin Dashboard**: Admin role only

## Key Features

### Event States & Lifecycle

Events progress through four states:

1. **Draft**
   - Initial state when created
   - Only visible to organizer and admins
   - Can be edited freely
   - Not accepting registrations

2. **Published**
   - Event is live and visible to all users
   - Accepting registrations (if capacity available)
   - Can still be edited by organizer
   - Sends notifications to interested users

3. **Cancelled**
   - Event has been cancelled
   - No longer accepting registrations
   - Sends cancellation emails to all registered users
   - Cannot be un-cancelled (must create new event)

4. **Completed**
   - Automatically set after event end time
   - No longer accepting registrations
   - Used for historical data and analytics

### Registration System

#### Registration Flow
1. User browses published events
2. Clicks "Register" on an available event
3. System checks capacity and eligibility
4. Creates registration with "confirmed" status
5. Sends confirmation email
6. Updates available spots in real-time

#### Capacity Management
- Events have a maximum capacity
- System prevents overbooking
- Shows available spots in real-time
- Automatically adds to waitlist when full

#### Waitlist Feature
- Users added to waitlist when event is full
- Registration status: "waitlisted"
- Automatically promoted when spots open up
- Notification sent when moved from waitlist to confirmed

#### Registration Statuses
- **Pending**: Registration awaiting confirmation (future enhancement)
- **Confirmed**: User is registered and has a spot
- **Cancelled**: User cancelled their registration
- **Waitlisted**: Event is full, user is on waiting list

### Search & Filtering

#### Text Search
- Full-text search across event titles and descriptions
- Case-insensitive matching
- Partial word matching

#### Category Filtering
- Filter events by category
- Multiple categories supported
- Category-based analytics

#### Date Filtering
- **Upcoming Events**: `starts_at > current_time`
- **Past Events**: `ends_at < current_time`
- Custom date range filtering

#### Combined Filters
- Stack multiple filters together
- Filters are chainable and optimized

### Admin Dashboard Features

The admin dashboard provides comprehensive analytics:

#### Overview Statistics
- Total users count
- Total events count
- Total registrations count
- Published events count

#### Charts & Visualizations
- **Events by Category**: Pie/bar chart showing event distribution
- **Registrations by Day**: Line chart showing registration trends (last 30 days)
- **Events by Status**: Distribution of draft/published/cancelled/completed
- **Users by Role**: Distribution of attendees/organizers/admins

#### Recent Activity
- 10 most recent events created
- 10 most recent registrations
- Quick action links for management

## Interactive UI Components

### Stimulus Controllers

#### Map Controller (`map_controller.js`)
- Displays interactive maps for event locations
- Uses geocoded latitude/longitude
- Supports multiple map providers
- Custom markers and info windows

#### Image Preview Controller (`image_preview_controller.js`)
- Real-time image preview when selecting files
- Works for event cover images and user avatars
- Shows file name and size
- Client-side validation

#### Character Counter Controller (`character_counter_controller.js`)
- Live character count for text fields
- Shows remaining characters
- Visual feedback when approaching limit
- Prevents submission when over limit

#### Dropdown Controller (`dropdown_controller.js`)
- Accessible dropdown menus
- Click-outside-to-close functionality
- Keyboard navigation support
- Smooth animations

### Real-time Updates

#### Turbo Streams
- Registration count updates in real-time
- No page refresh needed
- WebSocket-free (uses HTTP streaming)
- Works across multiple browser tabs

#### Broadcast Targets
- Event registration counts
- Available spots
- Waitlist updates

## Email Notifications

### Email Templates

#### Registration Confirmation
- **Trigger**: User successfully registers for an event
- **Content**: Event details, date/time, location, organizer info
- **CTA**: View event, add to calendar

#### Event Reminder
- **Trigger**: Scheduled job (e.g., 24 hours before event)
- **Content**: Reminder with event details and location
- **CTA**: View event details, get directions

#### Event Cancellation
- **Trigger**: Organizer cancels an event
- **Content**: Cancellation notice with apology and event details
- **Recipients**: All registered users

### Email Configuration

Configure SMTP settings in `config/environments/production.rb`:
```ruby
config.action_mailer.smtp_settings = {
  address: ENV['SMTP_ADDRESS'],
  port: ENV['SMTP_PORT'],
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Security Features

### Authentication Security
- **Password Encryption**: Bcrypt with high cost factor
- **Password Requirements**: Minimum length enforced by Devise
- **Password Reset**: Secure token-based password recovery
- **Remember Me**: Secure persistent login sessions

### Authorization
- **Policy-based**: All actions checked through Pundit policies
- **Fail-safe**: Denies by default unless explicitly allowed
- **Context-aware**: Policies consider user role and resource ownership

### API Security
- **JWT Tokens**: Stateless authentication for API
- **Token Expiration**: Configurable expiration time
- **HTTPS Only**: Force SSL in production
- **CORS Configuration**: Restricted cross-origin requests

### Data Protection
- **SQL Injection**: Protected by Active Record parameterization
- **XSS Prevention**: Rails automatic HTML escaping
- **CSRF Protection**: Token-based CSRF protection on all forms
- **Mass Assignment**: Strong parameters on all controllers

### File Upload Security
- **Content Type Validation**: Only allow specific image types
- **File Size Limits**: Prevent large file uploads
- **Virus Scanning**: (Recommended for production)
- **Secure Storage**: Support for encrypted storage backends

## Environment Variables

Create a `.env` file with the following variables:

```bash
# Database
DATABASE_URL=postgresql://username:password@localhost/event_hub_development

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=your-secret-key-here

# Devise
DEVISE_SECRET_KEY=your-devise-secret

# JWT
JWT_SECRET_KEY=your-jwt-secret
JWT_EXPIRATION_HOURS=24

# Email (SMTP)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_DOMAIN=yourdomain.com
DEFAULT_FROM_EMAIL=noreply@yourdomain.com

# Geocoding
GEOCODER_API_KEY=your-api-key-here
GEOCODER_PROVIDER=google # or nominatim, mapbox, etc.

# File Storage (AWS S3)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket-name

# External APIs
FARADAY_TIMEOUT=30
```

## Deployment

### Heroku Deployment

1. **Create Heroku app:**
```bash
heroku create your-app-name
```

2. **Add PostgreSQL addon:**
```bash
heroku addons:create heroku-postgresql:standard-0
```

3. **Set environment variables:**
```bash
heroku config:set RAILS_MASTER_KEY=<your-master-key>
heroku config:set SMTP_ADDRESS=<your-smtp>
# ... other variables
```

4. **Deploy:**
```bash
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

### Docker Deployment

The application includes a `Dockerfile` for containerized deployment:

```bash
docker build -t event_hub:latest .
docker run -d -p 3000:3000 \
  -e DATABASE_URL=<your-db-url> \
  -e SECRET_KEY_BASE=<your-secret> \
  event_hub:latest
```

### Production Checklist

- [ ] Set `RAILS_ENV=production`
- [ ] Configure production database
- [ ] Set `SECRET_KEY_BASE` or `RAILS_MASTER_KEY`
- [ ] Configure SMTP for emails
- [ ] Setup file storage (S3, GCS, etc.)
- [ ] Configure geocoding API
- [ ] Setup SSL/TLS certificates
- [ ] Precompile assets: `rails assets:precompile`
- [ ] Run migrations: `rails db:migrate`
- [ ] Setup background job processor (Sidekiq recommended)
- [ ] Configure monitoring and logging
- [ ] Setup regular database backups
- [ ] Configure CDN for assets

### Performance Optimization

- **Database Indexing**: All foreign keys and frequently queried columns are indexed
- **Eager Loading**: Use `.includes()` to prevent N+1 queries
- **Fragment Caching**: Cache expensive view fragments
- **Asset Pipeline**: Minified and compressed assets
- **CDN**: Serve assets from CDN in production
- **Database Connection Pooling**: Configure pool size based on traffic

## Troubleshooting

### Common Issues

#### Database Connection Errors
```bash
# Check PostgreSQL is running
sudo service postgresql status

# Reset database
rails db:drop db:create db:migrate db:seed
```

#### Asset Compilation Errors
```bash
# Clear asset cache
rails assets:clobber

# Recompile
rails assets:precompile
```

#### Image Processing Errors
```bash
# Install ImageMagick (Ubuntu/Debian)
sudo apt-get install imagemagick

# Or install libvips (faster alternative)
sudo apt-get install libvips
```

#### Geocoding Not Working
- Verify `GEOCODER_API_KEY` is set
- Check API rate limits
- Verify address format is valid
- Check geocoder logs in console

#### Email Not Sending
- Verify SMTP credentials
- Check spam folder
- Review `log/development.log` for errors
- Test with letter_opener gem in development

### Debug Mode

Enable verbose logging:
```ruby
# config/environments/development.rb
config.log_level = :debug
```

View logs:
```bash
tail -f log/development.log
```

## Performance Monitoring

### Recommended Tools
- **Application Monitoring**: New Relic, Scout APM, Skylight
- **Error Tracking**: Sentry, Rollbar, Airbrake
- **Uptime Monitoring**: Pingdom, UptimeRobot
- **Database Monitoring**: PgHero, pganalyze

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`rails test`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style

- Follow Ruby Style Guide
- Use RuboCop for linting
- Write descriptive commit messages
- Add comments for complex logic
- Update documentation for new features

### Testing Guidelines

- Write tests for all new features
- Maintain test coverage above 80%
- Include both unit and integration tests
- Test edge cases and error conditions

## License

This project is available for use under the MIT License.

## Support

For issues and questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review the documentation
- Contact the maintainers

## Roadmap

Future enhancements planned:
- [ ] Social media integration (share events)
- [ ] Calendar integration (iCal, Google Calendar)
- [ ] Payment processing for paid events
- [ ] QR code check-in system
- [ ] Mobile app (React Native)
- [ ] Advanced analytics and reporting
- [ ] Multi-language support (i18n)
- [ ] Event recommendations based on user preferences
- [ ] Recurring events support
- [ ] Email campaign integration

## Acknowledgments

Built with these amazing open-source projects:
- Ruby on Rails
- PostgreSQL
- Tailwind CSS
- Hotwire/Turbo
- Stimulus
- Devise
- Pundit
- And many more...

---

Made with ❤️ by the Event Hub Team
