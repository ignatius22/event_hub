# Clear existing data in development
if Rails.env.development?
  puts "Cleaning database..."
  Registration.destroy_all
  Event.destroy_all
  Category.destroy_all
  User.destroy_all
end

# Create Categories
puts "Creating categories..."
categories = [
  { name: "Concerts", description: "Live music performances and shows" },
  { name: "Workshops", description: "Educational and skill-building sessions" },
  { name: "Sports", description: "Athletic events and competitions" },
  { name: "Networking", description: "Professional meetups and business events" },
  { name: "Arts & Culture", description: "Museums, galleries, and cultural experiences" },
  { name: "Food & Drink", description: "Culinary events, tastings, and food festivals" },
  { name: "Technology", description: "Tech talks, hackathons, and innovation events" },
  { name: "Health & Wellness", description: "Fitness classes, meditation, and wellness events" },
  { name: "Family", description: "Kid-friendly events and family activities" },
  { name: "Outdoors", description: "Nature excursions and outdoor adventures" }
]

categories.each do |cat|
  Category.create!(cat)
end

puts "Created #{Category.count} categories"

# Create Users
puts "Creating users..."

# Admin user
admin = User.create!(
  email: "admin@eventhub.com",
  password: "password123",
  first_name: "Admin",
  last_name: "User",
  bio: "Platform administrator",
  role: :admin
)

# Organizer users
organizers = []
3.times do |i|
  organizers << User.create!(
    email: "organizer#{i + 1}@example.com",
    password: "password123",
    first_name: ["Sarah", "Mike", "Emma"][i],
    last_name: ["Johnson", "Chen", "Williams"][i],
    bio: "Event organizer with #{rand(2..10)} years of experience",
    role: :organizer
  )
end

# Attendee users
attendees = []
10.times do |i|
  attendees << User.create!(
    email: "attendee#{i + 1}@example.com",
    password: "password123",
    first_name: ["Alex", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Drew", "Cameron", "Avery", "Quinn"][i],
    last_name: ["Smith", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson"][i],
    bio: "Event enthusiast who loves attending #{Category.all.sample.name.downcase} events",
    role: :attendee
  )
end

puts "Created #{User.count} users (1 admin, 3 organizers, 10 attendees)"

# Create Events
puts "Creating events..."
event_titles = [
  "Summer Music Festival",
  "Web Development Bootcamp",
  "Morning Yoga in the Park",
  "Tech Startup Networking Night",
  "Italian Cooking Masterclass",
  "Marathon Training Workshop",
  "Modern Art Exhibition Opening",
  "JavaScript Framework Deep Dive",
  "Family Fun Day at the Zoo",
  "Mountain Hiking Adventure",
  "Jazz Night at Downtown Club",
  "Data Science for Beginners",
  "Community Garden Volunteer Day",
  "Wine Tasting Experience",
  "Kids Science Fair"
]

locations = [
  "Central Park Amphitheater",
  "Tech Innovation Hub",
  "Riverside Community Center",
  "Downtown Conference Center",
  "Culinary Institute",
  "Sports Complex",
  "Metropolitan Art Museum",
  "Co-Working Space",
  "City Zoo",
  "Mountain Trail Base Camp"
]

addresses = [
  "123 Main Street, New York, NY 10001",
  "456 Innovation Blvd, San Francisco, CA 94102",
  "789 River Road, Austin, TX 78701",
  "321 Business Ave, Chicago, IL 60601",
  "555 Culinary Way, Boston, MA 02101",
  "888 Sports Drive, Denver, CO 80201",
  "999 Art Boulevard, Los Angeles, CA 90001",
  "222 Tech Lane, Seattle, WA 98101",
  "444 Family Circle, Portland, OR 97201",
  "777 Mountain Path, Boulder, CO 80301"
]

15.times do |i|
  organizer = organizers.sample
  category = Category.all.sample
  starts_at = rand(1..60).days.from_now + rand(9..18).hours

  event = Event.new(
    title: event_titles[i % event_titles.length],
    description: "Join us for an amazing #{category.name.downcase} experience! " * 5 +
                 "This event will feature expert speakers, hands-on activities, and great networking opportunities. " +
                 "Don't miss out on this incredible opportunity to learn, grow, and connect with like-minded individuals.",
    location: locations[i % locations.length],
    address: addresses[i % addresses.length],
    starts_at: starts_at,
    ends_at: starts_at + rand(2..6).hours,
    capacity: [25, 50, 100, 150, 200].sample,
    status: [:draft, :published, :published, :published].sample, # 75% published
    user: organizer,
    category: category
  )

  # Skip geocoding in seeds to avoid API calls
  event.save!(validate: false)
  event.update_columns(latitude: rand(25.0..48.0).round(6), longitude: rand(-122.0..-71.0).round(6))
end

puts "Created #{Event.count} events"

# Create some registrations for published events
puts "Creating registrations..."
Event.published.each do |event|
  # Random number of attendees register
  attendees.sample(rand(3..8)).each do |attendee|
    Registration.create!(
      user: attendee,
      event: event,
      status: :confirmed
    )
  rescue ActiveRecord::RecordInvalid
    # Skip if validation fails (e.g., duplicate registration)
    next
  end
end

puts "Created #{Registration.count} registrations"
puts "Seed data created successfully!"
