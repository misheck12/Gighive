# Use the official Ruby 3.1 image as the base image
FROM ruby:3.1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm
RUN npm install -g yarn

# Install Rails and bundler
RUN gem install rails -v '7.0.0'

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
